//
//  AppDelegate.m
//  Alpha_v0.1
//
//  Created by Lucas Pena on 2/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    [Parse setApplicationId:@"MXEJFIQBjg8YQqCVQ20IfhYY3LH2JZd0XEcGltYF"
                  clientKey:@"MFAbOms5D1KZwqClDoFvz1a9U7z5J8w0eWVU8qEx"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [FBLoginView class];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [GMSServices provideAPIKey:@"AIzaSyAYtxyOcLNHr8GNSu6nvSArqsa88fNwNHU"];
    
    
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    [[PFUser currentUser] refresh];
    bool isLoggedIn =  [PFUser currentUser];
    if  (isLoggedIn)
    {
        dispatch_queue_t myQueue = dispatch_queue_create("fetchMyAds",NULL);
        dispatch_async(myQueue, ^{
            [[UserSingleton singleUser] fetchConfirmedAds];
            [[UserSingleton singleUser] fetchConnects:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        });
    
    }
    NSString *storyboardId = isLoggedIn ? @"Main" : @"Login";
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    //WHIPE AL USER DEFFAULTS
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSArray *allkeys = [notificationPayload allKeys];
    if( (allkeys) && (isLoggedIn)) //if logged in AND have notifications waiting
    {
        NSMutableArray *notificationList = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"notifications"]];
        for (int i = 0; i < notificationList.count; ++i)
        {
            if ([ [notificationList[i]objectForKey:@"withString"] isEqualToString:[notificationPayload objectForKey:@"withString"] ])
            {
                [notificationList removeObjectAtIndex:i];
                --i;
            }
        }
        [notificationList insertObject:notificationPayload atIndex:0];

        [[NSUserDefaults standardUserDefaults] setObject:notificationList forKey:@"notifications"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NotificationFeedView *nFV = (NotificationFeedView *)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Notifications"];
        [nFV notifPayLoadHandler:notificationPayload forTime:YES];
        SideBarTable *sBT = (SideBarTable *)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SideBarTable"];
        [sBT loadForNotifications];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:nFV];
        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:sBT frontViewController:frontNavigationController];
        self.window.rootViewController = mainRevealController;
    }
    else if( (!allkeys) && (isLoggedIn)) //else there are no notifications waiting
    {
        FitnessFeedView *fFV = (FitnessFeedView *)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"FitnessFeed"];
        SideBarTable *sBT = (SideBarTable *)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SideBarTable"];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:fFV];
        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:sBT frontViewController:frontNavigationController];
        self.window.rootViewController = mainRevealController;
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // store the device token in the current installation and save it to Parse.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *compare = [defaults stringForKey:@"Notifications"];
    if (!compare)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"Allow" forKey:@"Notification"];
        [defaults synchronize];
    }
    if ([compare isEqualToString:@"block"])
        return;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
    
    if  (![PFUser currentUser])
        return;
    PFInstallation *installation= [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for push, %@", error);
}


-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *compare = [defaults stringForKey:@"Notifications"];
    if ([compare isEqualToString:@"block"])
        return;
    NSMutableArray *notificationList = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"notifications"]];
    for (int i = 0; i < notificationList.count; ++i)
    {
        if ([ [notificationList[i]objectForKey:@"withString"] isEqualToString:[userInfo objectForKey:@"withString"] ])
        {
            [notificationList removeObjectAtIndex:i];
            --i;
        }
    }
    [notificationList insertObject:userInfo atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:notificationList forKey:@"notifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserSingleton singleUser].pendinfNotification = YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
}

@end
