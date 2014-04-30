//
//  ProfileViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "ObjectNameConstants.h"
#import "FriendsViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (NSString*)calculateSkillLevel:(float)grade{
    if (grade < 1.0)
        return @"Beginner";
    else if (grade < 2.0)
        return @"Intermediate";
    else
        return @"Advanced";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.user == nil || [self.user isEqual:[PFUser currentUser]]) {
        self.user = [PFUser currentUser];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(avatarClickToEdit)];
        [self.avatarView addGestureRecognizer:singleTap];
        [self.avatarView setUserInteractionEnabled:YES];
    }
    else {
        // hide Edit button
        [self.clickToEditLabel setHidden:YES];
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if ( self != [self.navigationController.viewControllers objectAtIndex:0] ) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.avatarView setFile:[self.user objectForKey:@"avatar"]];
    [self.avatarView loadInBackground];
    
    [self.nameLabel setText:self.user[@"name"]];
    [self.infoLabel setText:@"Age: " ];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:self.user[@"age"] ?: @""];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:@"\nGender: "];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:self.user[@"gender"] ?: @""];
    
    // print skill level
    [self.basketballSkill setText:[[self class] calculateSkillLevel:[self.user[@"basketballLevel"] floatValue]]];
    [self.soccerSkill setText:[[self class] calculateSkillLevel:[self.user[@"soccerLevel"] floatValue]]];
    [self.tennisSkill setText:[[self class] calculateSkillLevel:[self.user[@"tennisLevel"] floatValue]]];
    [self.frisbeeSkill setText:[[self class] calculateSkillLevel:[self.user[@"frisbeeLevel"] floatValue]]];
    [self.volleyballSkill setText:[[self class] calculateSkillLevel:[self.user[@"volleyballLevel"] floatValue]]];
    
    PFQuery *ratingsQuery = [PFQuery queryWithClassName:kPlayerRatingObject];
    [ratingsQuery whereKey:@"player" equalTo:self.user];
    [ratingsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            [self.sportsmenshipLabel setText:@"No data"];
            [self.likabilityLabel setText:@"No data"];
            [self.experienceLabel setText:@"No data"];
        }
        else {
            float sportsmenship = 0.0, experience = 0.0, likability = 0.0;
            for (PFObject *rating in objects) {
                sportsmenship += [[rating objectForKey:@"sportsmenship"] floatValue];
                likability += [[rating objectForKey:@"likability"] floatValue];
                experience += [[rating objectForKey:@"experience"] floatValue];
            }
            sportsmenship = sportsmenship / [objects count];
            likability = likability / [objects count];
            experience = experience / [objects count];
            [self.sportsmenshipLabel setText:[NSString stringWithFormat:@"%.2f", sportsmenship]];
            [self.experienceLabel setText:[NSString stringWithFormat:@"%.2f", experience]];
            [self.likabilityLabel setText:[NSString stringWithFormat:@"%.2f", likability]];
        }
    }];
}


- (void)logoutClicked:(id)sender
{
    [PFUser logOut];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] popMainController];
}


- (void)editClicked:(id)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    EditProfileViewController *editProfileController = [sb instantiateViewControllerWithIdentifier:@"edit-profile-controller"];

    [self.navigationController pushViewController:editProfileController animated:YES];
}

- (void)showFriendsClicked:(id)sender
{
    
}


- (void)avatarClickToEdit
{
    self.picker = [[GKImagePicker alloc] init];
    self.picker.delegate = self;
    self.picker.cropper.cropSize = CGSizeMake(300., 300.);
    self.picker.cropper.rescaleImage = YES;
    self.picker.cropper.rescaleFactor = 1.0;
    self.picker.cropper.dismissAnimated = NO;
    [self.picker presentPicker];
}


- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
    self.picker = nil;
    NSData* data = UIImagePNGRepresentation(image);
    NSString *name = [NSString stringWithFormat:@"%@_pic.png", [[PFUser currentUser] username]];
    PFFile *avatar = [PFFile fileWithName:name data:data];
    [[PFUser currentUser] setObject:avatar forKey:@"avatar"];
    [[PFUser currentUser] saveInBackground];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show-friends"]) {
        FriendsViewController* vc = [segue destinationViewController];
        [vc setUser:self.user];
        
    }
}


@end
