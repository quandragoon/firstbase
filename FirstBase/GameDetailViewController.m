//
//  GameDetailViewController.m
//  FirstBase
//
//  Created by Quan Nguyen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "GameDetailViewController.h"
#import "Resources.h"
#import "ProfileViewController.h"

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
    [self.host setTitle:self.game[@"host"] forState:UIControlStateNormal];
    self.time.text = [dateFormatter stringFromDate:self.game[@"time"]];
    
    UIImage *i = [Resources iconForSportType:self.game[@"sport"]];
    [self.gameImage setImage:i];
    
    self.participants = [NSMutableArray array];
    PFRelation *relation = [self.game relationForKey:@"players"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.participants = [NSMutableArray arrayWithArray:objects];
        NSMutableArray *playerIds = [NSMutableArray arrayWithCapacity:[self.participants count]];
        for (PFUser *u in self.participants) {
            [playerIds addObject:[u objectId]];
        }
        if ([playerIds containsObject:[[PFUser currentUser] objectId]]) {
            [self.joinButton setTitle:@"Unjoin!" forState:UIControlStateNormal];
        }
        else {
            [self.joinButton setTitle:@"Join!" forState:UIControlStateNormal];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
//    NSMutableArray *playerIds = [NSMutableArray arrayWithCapacity:[self.game[@"players"] count]];
//    for (PFUser *p in self.game[@"players"]) {
//        [playerIds addObject:[p objectId]];
//    }
//    self.participants = [NSMutableArray array];
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"objectId" containedIn:playerIds];
//    [query orderByAscending:@"name"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        for (PFUser *u in objects) {
//            [self.participants addObject:u];
//        }
//        if ([self.participants containsObject:[PFUser currentUser]]) {
//            [self.joinButton setTitle:@"Join!" forState:UIControlStateNormal];
//        }
//        else {
//            [self.joinButton setTitle:@"Unjoin!" forState:UIControlStateNormal];
//        }
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    }];
}
    
- (void)joinClicked:(UIButton*)sender
{
    NSMutableArray *playerIds = [NSMutableArray arrayWithCapacity:[self.participants count]];
    for (PFUser *u in self.participants) {
        [playerIds addObject:[u objectId]];
    }
    if ([playerIds containsObject:[[PFUser currentUser] objectId]]) {
        NSInteger row = [playerIds indexOfObject:[[PFUser currentUser] objectId]];
        [[self.game relationForKey:@"players"] removeObject:[PFUser currentUser]];
        [self.participants removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [sender setTitle:@"Join!" forState:UIControlStateNormal];
    }
    else {
        [self.participants addObject:[PFUser currentUser]];
        [[self.game relationForKey:@"players"] addObject:[PFUser currentUser]];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.participants count] - 1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [sender setTitle:@"Unjoin!" forState:UIControlStateNormal];
    }

    [self.game saveInBackground];
}

- (void)hostClicked:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ProfileViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"profile-controller"];
    PFUser *creator = [self.game objectForKey:@"creator"];
    [creator refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [viewController setUser:(PFUser*)object];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Info";
            break;
        case 1:
            return [NSString stringWithFormat:@"%i players.", [self.participants count]];
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.participants count];
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 140.0;
            break;
        case 1:
            return 99;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return self.infoCell;

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"participant-cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"participant-cell"];
    }
    
    PFUser *player = [self.participants objectAtIndex:indexPath.row];
    PFImageView* avatarView = (PFImageView*)[cell viewWithTag:1];
    PFFile *avatar = [player objectForKey:@"avatar"];
    [avatarView setFile:avatar];
    [avatarView loadInBackground];
    
    [(UILabel*)[cell viewWithTag:2] setText:[player objectForKey:@"name"]];
    
    
    NSString * sport = self.game[@"sport"];
    if ([sport isEqualToString:kGameTypeBasketball]){
        [(UILabel*)[cell viewWithTag:3] setText:[ProfileViewController calculateSkillLevel:[player[@"basketballLevel"] floatValue]]];
    } else if ([sport isEqualToString:kGameTypeSoccer]) {
        [(UILabel*)[cell viewWithTag:3] setText:[ProfileViewController calculateSkillLevel:[player[@"soccerLevel"] floatValue]]];
    } else if ([sport isEqualToString:kGameTypeVolleyball]){
        [(UILabel*)[cell viewWithTag:3] setText:[ProfileViewController calculateSkillLevel:[player[@"volleyballLevel"] floatValue]]];
    } else if ([sport isEqualToString:kGameTypeTennis]){
        [(UILabel*)[cell viewWithTag:3] setText:[ProfileViewController calculateSkillLevel:[player[@"tennisLevel"] floatValue]]];
    } else if ([sport isEqualToString:kGameTypeFrisbee]){
        [(UILabel*)[cell viewWithTag:3] setText:[ProfileViewController calculateSkillLevel:[player[@"frisbeeLevel"] floatValue]]];
    }
    
    
    PFQuery *ratingsQuery = [PFQuery queryWithClassName:kPlayerRatingObject];
    [ratingsQuery whereKey:@"player" equalTo:player];
    [ratingsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            [(UILabel*)[cell viewWithTag:4] setText:@"Not enough data"];
        }
        else {
            float sportsmenship = 0.0, experience = 0.0, likability = 0.0;
            for (PFObject *rating in objects) {
                sportsmenship += [[rating objectForKey:@"sportsmenship"] floatValue];
                likability += [[rating objectForKey:@"likability"] floatValue];
                experience += [[rating objectForKey:@"experience"] floatValue];
            }
            sportsmenship = sportsmenship / [objects count];
            likability = likability / [objects count];
            experience = experience / [objects count];
            [(UILabel*)[cell viewWithTag:4] setText:[NSString stringWithFormat:@"%.2f", (sportsmenship + experience + likability)/3.0]];
        }
    }];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ProfileViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"profile-controller"];
    [viewController setUser:[self.participants objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:viewController animated:YES];
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
