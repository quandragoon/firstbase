//
//  GameDetailViewController.h
//  FirstBase
//
//  Created by Quan Nguyen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GameDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *participantTable;
    NSMutableArray *participants;
}

@property (nonatomic) PFObject *game;
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UIButton *joinGame;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *host;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
