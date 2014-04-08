//
//  NewsfeedViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/4/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <Parse/Parse.h>
#import "NSDate+Utilities.h"
#import "NewsfeedViewController.h"
#import "GameDetailViewController.h"
#import "ObjectNameConstants.h"
#import "Resources.h"

@interface NewsfeedViewController ()

@end

@implementation NewsfeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) viewWillAppear:(BOOL)animated {
    PFQuery *publicQuery = [PFQuery queryWithClassName:kGameObject];
    [publicQuery whereKey:@"friendsOnly" equalTo:[NSNumber numberWithBool:NO]];
    
    PFQuery *privateQuery = [PFQuery queryWithClassName:kGameObject];
    [privateQuery whereKey:@"friendsOnly" equalTo:[NSNumber numberWithBool:YES]];
    [privateQuery whereKey:@"friends" equalTo:[PFUser currentUser]];
    
    PFQuery *myEventsQuery = [PFQuery queryWithClassName:kGameObject];
    [myEventsQuery whereKey:@"creater" equalTo:[PFUser currentUser]];

//    PFQuery *query = publicQuery;
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:publicQuery, privateQuery, myEventsQuery, nil]];
    [query orderByAscending:@"time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.feedItems = [[NSMutableArray alloc] initWithArray:objects];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"newsfeed-cell";
    PFObject *game = [self.feedItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    
    PFRelation *players = [game relationForKey:@"players"];
    PFQuery *playersQuery = [players query];
    [playersQuery setLimit:8];
    [playersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        UITableViewCell *c = [self.tableView cellForRowAtIndexPath:indexPath];
        if (c) {
            NSMutableArray *playerNames = [NSMutableArray arrayWithCapacity:8];
//            [playerNames addObject:[game objectForKey:@"host"]];
            for (PFUser *player in objects) {
                [playerNames addObject:[player objectForKey:@"name"]];
            }
            [(UILabel*)[c viewWithTag:3] setText:[playerNames componentsJoinedByString:@", "]];
        }
    }];
    
    PFQuery *invitationQuery = [PFQuery queryWithClassName:kGameInvitationObject];
    [invitationQuery whereKey:@"game" equalTo:game];
    [invitationQuery whereKey:@"to" equalTo:[PFUser currentUser]];
    [invitationQuery includeKey:@"from"];
    [invitationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        UITableViewCell *c = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([objects count]) {
            PFObject *invitation = [objects objectAtIndex:0];
            [(UILabel*)[c viewWithTag:5] setHidden:NO];
            [(UILabel*)[c viewWithTag:5] setText:[NSString stringWithFormat:@"You are invited by %@!", [[invitation objectForKey:@"from"] objectForKey:@"name"]]];
        }
        else
            [(UILabel*)[c viewWithTag:5] setHidden:YES];
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd MMMM yyyy"]; // use one d for 7 October instead of 07 October

    [(UILabel*)[cell viewWithTag:1] setText:[dateFormatter stringFromDate:[game objectForKey:@"time"]]];
    UIImage *i = [Resources iconForSportType:[game objectForKey:@"sport"]];
    [(UIImageView*)[cell viewWithTag:2] setImage:i];
    [(UILabel*)[cell viewWithTag:3] setText:@"Loading..."];
    [(UILabel*)[cell viewWithTag:4] setText:[game objectForKey:@"location"]];
    [(UILabel*)[cell viewWithTag:5] setHidden:YES];

    return cell;
}

- (void)createClicked:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *mainController = [sb instantiateViewControllerWithIdentifier:@"create-game-controller"];
    [self presentViewController:mainController animated:YES completion:nil];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *game = [self.feedItems objectAtIndex:indexPath.row];
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    GameDetailViewController *gameDetailViewController = [sb instantiateViewControllerWithIdentifier:@"game-detail-controller"];

    gameDetailViewController.game = game;
    [self.navigationController pushViewController:gameDetailViewController animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
