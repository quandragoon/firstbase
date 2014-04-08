//
//  FriendsViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    [self reloadFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)reloadFriends
{
    PFQuery *query = [[self.user relationForKey:@"friends"] query];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friends = objects;
        [self.tableView reloadData];
        
        if ([self.user isEqual:[PFUser currentUser]]) {
            PFQuery *query = [PFUser query];
            [query orderByAscending:@"name"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *allUsers, NSError *error) {
                NSMutableArray *users = [NSMutableArray arrayWithArray:allUsers];
                for (PFUser *friend in self.friends) {
                    if ([users containsObject:friend]) {
                        [users removeObject:friend];
                    }
                }
                self.others = users;
                [self.tableView reloadData];
            }];
        }
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Friends";
    else
        return @"Everyone else";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    if (self.others)
        count += 1;
    if (self.friends)
        count += 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.friends count];
    }
    else if (section == 1) {
        return [self.others count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"show-friend-cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"show-friend-cell"];
    }
    
    NSArray *group = indexPath.section == 0 ? self.friends : self.others;
    PFUser *user = [group objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [user objectForKey:@"name"];
    UIButton *button = (UIButton*)[cell accessoryView];
    
    if (![user isEqual:[PFUser currentUser]] && [self.user isEqual:[PFUser currentUser]]) {
        [button setHidden:NO];
        if (indexPath.section == 0)
            [button setTitle:@"Remove" forState:UIControlStateNormal];
        else
            [button setTitle:@"Add" forState:UIControlStateNormal];
    }
    else {
        [button setHidden:YES];
    }
    return cell;
}

- (void)friendButtonClicked:(id)sender
{
    UIView *superView = [sender superview];
    UIView *foundSuperView = nil;
    
    while (nil != superView && nil == foundSuperView) {
        if ([superView isKindOfClass:[UITableViewCell class]]) {
            foundSuperView = superView;
        } else {
            superView = superView.superview;
        }
    }
    
    UITableViewCell* cell = (UITableViewCell*)superView;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    PFRelation *relation = [self.user relationForKey:@"friends"];

    if (indexPath.section == 0) {
        PFUser *u = [self.friends objectAtIndex:indexPath.row];
        [relation removeObject:u];
    }
    else {
        PFUser *u = [self.others objectAtIndex:indexPath.row];
        [relation addObject:u];
    }
    [[PFUser currentUser] save];

    [self reloadFriends];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
