//
//  SignUpViewController.h
//  FirstBase
//
//  Created by Changping Chen on 3/26/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : GAITrackedViewController

@property (nonatomic, weak) IBOutlet UITextField *txtUsername;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtName;

- (IBAction)cancelClicked:(id)sender;
- (IBAction)signupClicked:(id)sender;

@end
