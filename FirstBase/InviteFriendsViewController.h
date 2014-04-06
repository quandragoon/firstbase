//
//  InviteFriendsViewController.h
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InviteFriendsViewController : UITableViewController

@property (nonatomic) PFObject *game;
@property (nonatomic) NSArray *friends;
@property (nonatomic) NSMutableArray *selectedFriends;

- (IBAction)doneClicked:(id)sender;

@end
