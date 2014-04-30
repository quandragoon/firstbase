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
#import "RateGameViewController.h"

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
//    PFQuery *publicQuery = [PFQuery queryWithClassName:kGameObject];
//    [publicQuery whereKey:@"friendsOnly" equalTo:[NSNumber numberWithBool:NO]];
//    
//    PFQuery *privateQuery = [PFQuery queryWithClassName:kGameObject];
//    [privateQuery whereKey:@"friendsOnly" equalTo:[NSNumber numberWithBool:YES]];
//    [privateQuery whereKey:@"friends" equalTo:[PFUser currentUser]];
//    
//    PFQuery *myEventsQuery = [PFQuery queryWithClassName:kGameObject];
//    [myEventsQuery whereKey:@"creator" equalTo:[PFUser currentUser]];

//    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:publicQuery, privateQuery, myEventsQuery, nil]];
    PFQuery *query = [PFQuery queryWithClassName:kGameObject];
    [query orderByAscending:@"time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.feedItems = [[NSMutableArray alloc] init];
        for (PFObject *game in objects) {
//            if ([[game objectForKey:@"friendsOnly"] boolValue] == YES) {
//                [[[[game objectForKey:@"creator"] relationForKey:@"friends"] query] whereKey:@"id" equalTo:[PFUser currentUser] objec]
//            }
            [self.feedItems addObject:game];
        }
        // [self.feedItems addObject:game];
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
    
    NSNumber *fo = [game objectForKey:@"friendsOnly"];
    if ([fo boolValue]){
        // [(UIImageView*)[cell viewWithTag:6] setImage:[UIImage imageNamed:@"friends_only.png"]];
        [(UILabel*)[cell viewWithTag:6] setText:@"PRIVATE"];
    } else {
        // [(UIImageView*)[cell viewWithTag:6] setImage:[UIImage imageNamed:@"public.png"]];
        [(UILabel*)[cell viewWithTag:6] setText:@"PUBLIC"];
    }
    
    [(UILabel*)[cell viewWithTag:7] setText:[game objectForKey:@"description"]];
    return cell;
}

- (void)createClicked:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *mainController = [sb instantiateViewControllerWithIdentifier:@"create-game-controller"];
    [self presentViewController:mainController animated:YES completion:nil];
}

- (void)editClicked:(id)sender
{
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked:)];
    }
    else {
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editClicked:)];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *game = [self.feedItems objectAtIndex:indexPath.row];
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    id vc = nil;
    if ([(NSDate*)[game objectForKey:@"time"] compare:[NSDate date]] == NSOrderedAscending) {
        vc = [sb instantiateViewControllerWithIdentifier:@"rate-view-controller"];
    }
    else {
        vc = [sb instantiateViewControllerWithIdentifier:@"game-detail-controller"];
    }
    [vc setGame:game];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *game = [self.feedItems objectAtIndex:indexPath.row];

    if ([[[game objectForKey:@"creator"] objectId] isEqual:[[PFUser currentUser] objectId]]) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *game = [self.feedItems objectAtIndex:indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [game deleteInBackground];
        [self.feedItems removeObject:game];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
