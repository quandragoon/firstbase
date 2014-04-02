//
//  ViewController.h
//  FirstBase
//
//  Created by Quan Nguyen on 2/19/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

// Migrate to use https://parse.com/tutorials/login-and-signup-views

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (void)pushMainController;

@end
