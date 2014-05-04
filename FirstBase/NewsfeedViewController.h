//
//  NewsfeedViewController.h
//  FirstBase
//
//  Created by Changping Chen on 4/4/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsfeedViewController : UITableViewController

@property (nonatomic) NSMutableArray *feedItems;
@property (nonatomic) NSMutableArray *friends;

- (IBAction)createClicked:(id)sender;
- (IBAction)editClicked:(id)sender;

@end
