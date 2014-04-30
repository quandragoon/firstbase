//
//  EditProfileViewController.h
//  FirstBase
//
//  Created by Quan Nguyen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditProfileViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet UISlider *basketballLevel;
@property (weak, nonatomic) IBOutlet UISlider *soccerLevel;
@property (weak, nonatomic) IBOutlet UISlider *tennisLevel;
@property (weak, nonatomic) IBOutlet UISlider *volleyballLevel;
@property (weak, nonatomic) IBOutlet UISlider *frisbeeLevel;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *age;

@property (nonatomic) PFUser *user;

- (IBAction)saveClicked:(id)sender;

@end
