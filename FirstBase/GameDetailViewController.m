//
//  GameDetailViewController.m
//  FirstBase
//
//  Created by Quan Nguyen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "GameDetailViewController.h"
#import "Resources.h"

@interface GameDetailViewController ()

@end

@implementation GameDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd MMMM yyyy"];
    
    self.location.text = self.game[@"location"];
    self.host.text = self.game[@"host"];
    self.time.text = [dateFormatter stringFromDate:self.game[@"time"]];
    
    UIImage *i = [Resources iconForSportType:self.game[@"sport"]];
    [self.gameImage setImage:i];

    
    participants = self.game[@"players"];
    // [participants addObject:self.game[@"creator"]];
    participants  = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    // Do any additional setup after loading the view.
    
}


- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [participants count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    // PFObject *player = [participants objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [participantTable dequeueReusableCellWithIdentifier:@"participant-cell" forIndexPath:indexPath];
    
    
    // cell.textLabel.text = [participants objectAtIndex:indexPath.row];
    
    return cell;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
