#import <Parse/Parse.h>
#import "ParseStarterProjectAppDelegate.h"
#import "RootViewController.h"

#import "LoginViewController.h"
#import "RootViewController.h"
#import "Circle.h"

#import "GlobalData.h"

#import "TestFlightSDK/TestFlight.h"


@implementation ParseStarterProjectAppDelegate

@synthesize window;
@synthesize navigationController;

@synthesize rootViewController;

@synthesize locationManager;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    NSLog(@"%@", launchOptions);

#ifndef RELEASE
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [TestFlight takeOff:@"f8d7037b262277589cd287681817220a_MTUyNzAwMjAxMi0xMS0wNyAyMToxMDo0Ni43OTY5OTc"];
    
    [TestFlight passCheckpoint:@"Initialization started"];
    
    [Parse setApplicationId:@"VMhSG8IQ9xibufk8lAPpclIwdXVfYD44OpKmsHdn"
                  clientKey:@"u2kJ1jWBjN9qY3ARlJuEyNkvUA9EjOMv1R4w5sDX"];
    
    [PFFacebookUtils initializeWithApplicationId:@"157314481074430"];
    
    //[PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Override point for customization after application launch.
     
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
	
	// Create the navigation and view controllers
//	RootViewController *rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
    
    rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.navigationController = aNavigationController;
    
    if (! PFFacebookUtils.session.isOpen) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
        [aNavigationController pushViewController:loginViewController animated:YES];
        [aNavigationController setNavigationBarHidden:true animated:false];
    }
    else
        [[PFUser currentUser] refresh];
    
    // Location data
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = [[NSNumber numberWithDouble:kCLLocationAccuracyHundredMeters] doubleValue];
    locationManager.distanceFilter = [[NSNumber numberWithDouble:100.0] doubleValue];
    [locationManager startUpdatingLocation];
    
    // Retrieving initial data
    
    
	//rootViewController.displayList = [self displayList];
	//rootViewController.calendar = [self calendar];
	

	
	// Configure and show the window
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];

    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
                                                    UIRemoteNotificationTypeAlert|
                                                    UIRemoteNotificationTypeSound];
    
    [TestFlight passCheckpoint:@"Initialization ended"];
    
    return YES;
}




#pragma mark -
#pragma mark Setting up the display list

/*- (NSArray *)displayList {

	NSArray *knownTimeZoneNames = [NSTimeZone knownTimeZoneNames];
	
	NSMutableArray *regions = [NSMutableArray array];
	
	for (NSString *timeZoneName in knownTimeZoneNames)
    {
		
		NSArray *components = [timeZoneName componentsSeparatedByString:@"/"];
		NSString *circleName = [components objectAtIndex:0];
		
		Circle* circle = [Circle circleNamed:circleName];
		if (circle == nil) {
			circle = [Circle newCircleWithName:regionName];
			[circles addObject:circle];
//			[region release];
		}
		
		[circle addPersonWithComponents:components];
//		[timeZone release];
	}
	
	//NSDate *date = [NSDate date];
	// Now sort the time zones by name
	for (Region *region in regions) {
		[region sortZones];
//		[region setDate:date];
	}
	// Sort the regions
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[regions sortUsingDescriptors:sortDescriptors];
//	[sortDescriptor release];
	
	return regions;
}*/


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
//	[navigationController release];
//    [window release];
//    [calendar release];
//    [super dealloc];
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSLog(@"%@", userInfo);
    [rootViewController reloadData];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark - ()







- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation.horizontalAccuracy < 0) return;
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0)
    {
        
    }
    
    CLLocationCoordinate2D coord = newLocation.coordinate;
    
    //NSNumber* latitude = [[NSNumber alloc] initWithDouble:coord.latitude];
    //NSNumber* longitude = [[NSNumber alloc] initWithDouble:coord.longitude];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coord.latitude
                                                  longitude:coord.longitude];
    [[PFUser currentUser] setObject:geoPoint forKey:@"location"];
    //[[PFUser currentUser] setObject:latitude forKey:@"loclat"];
    //[[PFUser currentUser] setObject:longitude forKey:@"loclon"];
    
    [locationManager stopUpdatingLocation];
}





@end
