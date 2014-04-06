//
//  ProfileViewController.h
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UITableViewController

@property (nonatomic) PFUser *user;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UIImageView *avatarView;

- (IBAction)logoutClicked:(id)sender;
- (void)avatarClickToEdit;

@end
