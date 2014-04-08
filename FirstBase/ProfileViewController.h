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
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *basketballSkill;
@property (weak, nonatomic) IBOutlet UILabel *soccerSkill;
@property (weak, nonatomic) IBOutlet UILabel *tennisSkill;
@property (weak, nonatomic) IBOutlet UILabel *volleyballSkill;
@property (weak, nonatomic) IBOutlet UILabel *frisbeeSkill;

- (IBAction)logoutClicked:(id)sender;
- (void)avatarClickToEdit;

- (IBAction)editClicked:(id)sender;
- (IBAction)showFriendsClicked:(id)sender;
- (NSString*)calculateSkillLevel:(float)grade;
    
@end
