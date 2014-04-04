//
//  ViewController.m
//  FirstBase
//
//  Created by Quan Nguyen on 2/19/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClicked:(id)sender {
    [PFUser logInWithUsernameInBackground:_txtUsername.text password:_txtPassword.text block:^(PFUser *user, NSError *error) {
         if (user) {
             [(AppDelegate*)([[UIApplication sharedApplication] delegate]) pushMainController];
         }
         else {
             [[[UIAlertView alloc] initWithTitle:@"Cannot Login" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
         }
    }];
}


- (IBAction)backgroundClick:(id)sender {
    [_txtPassword resignFirstResponder];
    [_txtUsername resignFirstResponder];
}
@end
