#import "MSAppDelegate.h"
#import "checkConnection.h"
#import "MSiOSVersionControlHeader.h"

@implementation MSAppDelegate

//check conection and send request
- (void)connectionVerification
{
    if (checkConnection.hasConnectivity)
    {
        NSURL *url = [NSURL URLWithString:@"www.apple.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(!connection)
        {
            UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"URL Connection" message:@"Not seccess URL Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [failmessage show];
        }
    }
    else
    {
        UIAlertView *failmessage = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"Not seccess Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [failmessage show];
    }
    
}

- (void)customizeInterface
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
        [[UIBarButtonItem appearance] setTintColor:[UIColor orangeColor]];
        
        [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
//        [[UITabBar appearance] setSelectedImageTintColor:[UIColor orangeColor]];
        [[UITabBar appearance] setTintColor:[UIColor orangeColor]];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        [[UIBarButtonItem appearance] setTintColor:[UIColor orangeColor]];
        
        [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor orangeColor]];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeInterface];
    
    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:@"currentLanguage"];
  
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        UIStoryboard *iPhoneStoryboard_iOS7 = [UIStoryboard storyboardWithName:@"iPhoneStoryboard_iOS7" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhoneStoryboard_iOS7 instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
    }
    
	[self.window makeKeyAndVisible];
    
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self connectionVerification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
