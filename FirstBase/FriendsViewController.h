//
//  FriendsViewController.h
//  FirstBase
//
//  Created by Changping Chen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController
@property (nonatomic) PFUser *user;
@property (nonatomic) NSArray *friends;
@property (nonatomic) NSArray *others;

- (IBAction)friendButtonClicked:(id)sender;
- (IBAction)reloadFriends;

@end
