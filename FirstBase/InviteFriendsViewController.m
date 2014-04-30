//
//  InviteFriendsViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "ObjectNameConstants.h"

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

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
    
    self.tableView.allowsMultipleSelection = YES;
    self.friends = [NSArray array];
    [[[[PFUser currentUser] relationForKey:@"friends"] query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.friends = objects;
        [self.tableView reloadData];
    }];

    
    self.selectedFriends = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneClicked:(id)sender
{
    [self.game saveInBackground];
    
    for (PFUser *f in self.selectedFriends) {
        PFObject *invitation = [PFObject objectWithClassName:kGameInvitationObject];
        [invitation setObject:[PFUser currentUser] forKey:@"from"];
        [invitation setObject:f forKey:@"to"];
        [invitation setObject:self.game forKey:@"game"];
        [invitation saveInBackground];
        
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" equalTo:f];
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        [push setMessage:[NSString stringWithFormat:@"%@ invited you to play %@!",
                          [[PFUser currentUser] objectForKey:@"name"], [self.game objectForKey:@"sport"]]];
        [push sendPushInBackground];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"InviteFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    PFUser *friend = [self.friends objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [[self.friends objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if ([self.selectedFriends containsObject:friend])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *friend = [self.friends objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectedFriends containsObject:friend]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFriends removeObject:friend];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFriends addObject:friend];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *friend = [self.friends objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectedFriends containsObject:friend]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFriends removeObject:friend];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFriends addObject:friend];
    }
}

@end
