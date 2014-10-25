//
//  AKMapViewController.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

@import CoreLocation;
@import MapKit;

#import "KZAsserts.h"

#import "AKDeparturesViewController.h"
#import "AKBusStop.h"
#import "AKBusStopsImporter.h"
#import "AKMapViewController.h"

static NSString *const AKMapViewAnnotationIdentifier = @"AKMapViewAnnotationIdentifier";

@interface AKMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *busStops;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKAnnotationView *activeAnnotationView;

@end

@implementation AKMapViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // General
    self.title = @"Keolocation";
    
    // Map View
    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    
    // Asking for location usage.
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    // Constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_mapView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:nil views:views]];
}

#pragma mark - <MKMapViewDelegate>

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.activeAnnotationView = view;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    // Skip user location.
    if ([annotation isEqual:mapView.userLocation]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AKMapViewAnnotationIdentifier];
    
    if (!annotationView) {
        annotationView  = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AKMapViewAnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = NO;
        
        // Information Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        [button addTarget:self action:@selector(didTapAnnotation:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;
    }
    
    return annotationView;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    // Import annotations if not already done.
    if (!self.mapView.annotations.count) {
        [self importMapData];
    }
}

#pragma mark - Map Population

- (void)importMapData {
    
    // Bus Stops Data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error;
        NSArray *rowButStops = [AKBusStopsImporter busStopsWithError:&error];
        
        if (rowButStops && !error) {
            self.busStops = [AKBusStop busStopsWithArray:rowButStops];
        }
        
        // Updating the list of annotation on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:self.busStops];
        });
        
    });
}

#pragma mark - Annotation Interaction

- (void)didTapAnnotation:(id)sender {
    AssertTrueOrReturn([self.activeAnnotationView isKindOfClass:MKAnnotationView.class]);
    
    AKBusStop *busStop = self.activeAnnotationView.annotation;
    if ([busStop isKindOfClass:AKBusStop.class]) {
        AKDeparturesViewController *departuresController = [[AKDeparturesViewController alloc] initWithBusStop:busStop];
        UINavigationController *departureNavigationController = [[UINavigationController alloc] initWithRootViewController:departuresController];
        [self.navigationController presentViewController:departureNavigationController animated:YES completion:nil];
    }
}

@end
