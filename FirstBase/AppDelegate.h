//
//  AppDelegate.h
//  FirstBase
//
//  Created by Quan Nguyen on 2/19/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

// https://www.dropbox.com/sh/uyr8avbitie1w5t/7VKgRHk1In

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *loginController;

- (void)pushMainController;
- (void)popMainController;
- (void)loadTestData;

@end
