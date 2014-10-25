//
//  AppDelegate.m
//  Keolocation
//
//  Created by Ali Karagoz on 25/10/14.
//
//

#import "AppDelegate.h"
#import "AKMapViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) AKMapViewController *mapViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Map View Controller
    self.mapViewController = [[AKMapViewController alloc] init];
    
    // Navigation Controller
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
    
    // Customization
    [self customizeApp];
    
    // Window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)customizeApp {
    
    UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
    UIColor *color = [UIColor whiteColor];
    
    NSDictionary *titleAttributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: color };
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:23.0/255.0 green:155.0/255.0 blue:141.0/255.0 alpha:1.0]];
    
    NSDictionary *barButtonAttributes = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
}

@end
