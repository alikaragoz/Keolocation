//
//  AKDeparturesViewController.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "AKDeparture.h"
#import "AKDeparturesViewController.h"
#import "AKStopLine.h"
#import "KeoAPIClient.h"

static NSString *const AKDeparturesIdentifier = @"AKDeparturesIdentifier";

@interface AKDeparturesViewController ()

@property (nonatomic, strong) AKBusStop *bustStop;
@property (nonatomic, strong) NSArray *stopLines;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AKDeparturesViewController

#pragma mark - Init

- (instancetype)initWithBusStop:(AKBusStop *)busStop {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _bustStop = busStop;
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // General
    self.title = self.bustStop.name;
    self.navigationItem.backBarButtonItem.title = @"Map";
    self.tableView.rowHeight = 30.0;
    
    // Acivity Indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
    self.activityIndicator.hidesWhenStopped = YES;
    
    // Navigation bar button
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapDoneButton:)];
    self.navigationItem.leftBarButtonItem = doneBarButtonItem;
    
    UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = spinnerButton;
    
    // Cell Registering
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:AKDeparturesIdentifier];
    
    [self fetchDepartureTimes];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.stopLines.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < self.stopLines.count) {
        AKStopLine *stopLine = self.stopLines[section];
        return stopLine.departures.count;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section < self.stopLines.count) {
        AKStopLine *stopLine = self.stopLines[section];
        return [NSString stringWithFormat:@"%@ : %lu", NSLocalizedString(@"_ROUTE_", nil), (unsigned long)stopLine.route];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AKDeparturesIdentifier forIndexPath:indexPath];
    
    AKDeparture *departure;
    
    if (indexPath.section < self.stopLines.count) {
        AKStopLine *stopLine = self.stopLines[indexPath.section];
        
        if (indexPath.row < stopLine.departures.count) {
            departure = stopLine.departures[indexPath.row];
        }
    }
    
    if ([departure isKindOfClass:AKDeparture.class]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:14.0];
        cell.textLabel.text = [self.dateFormatter stringFromDate:departure.time];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Departure Time

- (void)fetchDepartureTimes {
    
    [self activityIndicatorShouldSpin:YES];
    
    // Getting the departure times.
    __weak typeof(self) weakSelf = self;
    [KeoAPIClient getDeparturesWithBusStopIdentifier:self.bustStop.identifier completion:^(NSDictionary *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
        [strongSelf activityIndicatorShouldSpin:NO];
        
        // Showing an alert in case of error.
        if (error || ![response isKindOfClass:NSDictionary.class]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"_ERROR_", nil)
                                                                         message:NSLocalizedString(@"_REQUEST_ERROR_", nil)
                                                                        delegate:strongSelf
                                                               cancelButtonTitle:NSLocalizedString(@"_OK_", nil)
                                                               otherButtonTitles:nil];
                [errorAlertView show];
            });
        }
        
        // Extracting stop lines.
        id rawStopLines = [response valueForKeyPath:@"opendata.answer.data.stopline"];
        strongSelf.stopLines = [AKStopLine stopLinesWithAttributes:rawStopLines];
        
        // Updating the table view if necessary.
        if (strongSelf.stopLines.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - User Interfaction

- (void)didTapDoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Activity Indicator

- (void)activityIndicatorShouldSpin:(BOOL)shouldSpin {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (shouldSpin) {
            [self.activityIndicator startAnimating];
        } else {
            [self.activityIndicator stopAnimating];
        }
        
    });
    
}

#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return _dateFormatter;
    
}

@end
