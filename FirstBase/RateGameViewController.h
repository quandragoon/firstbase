//
//  RateGameViewController.h
//  FirstBase
//
//  Created by Changping Chen on 4/8/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RateGameViewController : UITableViewController

@property (nonatomic) PFObject *game;
@property (nonatomic) NSArray *players;

@end
