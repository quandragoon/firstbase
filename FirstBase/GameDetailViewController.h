//
//  GameDetailViewController.h
//  FirstBase
//
//  Created by Quan Nguyen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GameDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
}

@property (nonatomic) PFObject *game;
@property (nonatomic) IBOutlet UITableViewCell *infoCell;
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *host;
@property (nonatomic) NSMutableArray *participants;

- (IBAction)joinClicked:(id)sender;
- (IBAction)hostClicked:(id)sender;

@end
