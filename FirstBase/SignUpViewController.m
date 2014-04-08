//
//  SignUpViewController.m
//  FirstBase
//
//  Created by Changping Chen on 3/26/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)signupClicked:(id)sender {
    PFUser *user = [PFUser user];
    user.email = [self.txtEmail text];
    user.password = [self.txtPassword text];
    user.username = [self.txtUsername text];
    [user setObject:[self.txtName text] forKey:@"name"];
    NSNumber *def = [[NSNumber alloc] initWithFloat:0.0];
    user[@"basketballLevel"] = def;
    user[@"soccerLevel"] = def;
    user[@"tennisLevel"] = def;
    user[@"frisbeeLevel"] = def;
    user[@"volleyballLevel"] = def;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Signup succeeded.");
            [[[PFUser currentUser] relationForKey:@"friends"] addObject:[PFUser currentUser]];
            [[PFUser currentUser] saveInBackground];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [(AppDelegate*)([[UIApplication sharedApplication] delegate]) pushMainController];
            }];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        }
    }];
}

- (void)cancelClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
