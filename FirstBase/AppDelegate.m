//
//  AppDelegate.m
//  FirstBase
//
//  Created by Quan Nguyen on 2/19/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ObjectNameConstants.h"
#import "GoogleAnalytics/Library/GAI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"R7Eu7Sc6m1QMnx8lkJqZYHiHAu587ar1iW0fHJ01"
           clientKey:@"c0JyaYoZFWISGHHmIbOLrgHYRpZ2iAspfizDlT8F"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert |
                                                    UIRemoteNotificationTypeBadge |
                                                    UIRemoteNotificationTypeSound];
    [PFImageView class];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-50518404-1"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"RatedGames"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:@"RatedGames"];
    }

//
//    if (application.applicationState != UIApplicationStateBackground) {
//        // Track an app open here if we launch with a push, unless
//        // "content_available" was used to trigger a background push (introduced
//        // in iOS 7). In that case, we skip tracking here to avoid double
//        // counting the app-open.
//        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
//        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
//        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//        }
//    }

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    installation[@"user"] = [PFUser currentUser];
    [installation addUniqueObject:@"AllUsers" forKey:@"channels"];
    [installation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)pushMainController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *mainController = [sb instantiateViewControllerWithIdentifier:@"main-controller"];
    [self.window.rootViewController presentViewController:mainController animated:YES completion:nil];
}


- (void)popMainController {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadTestData {
    PFObject *game = [PFObject objectWithClassName:kGameObject];
    game[@"name"] = @"Theta Xi Ultimate";
    game[@"type"] = kGameTypeFrisbee;
    game[@"creator"] = [PFUser currentUser];
    PFRelation *players = [game relationforKey:@"players"];
    [players addObject: [PFUser currentUser]];
    game[@"location"] = @"Kresge Field";
    // game[@"time"] = [NSDate dateWithTimeIntervalSinceNow:3600 * 24];
    [game saveInBackground];
}




@end
