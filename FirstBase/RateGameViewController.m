//
//  RateGameViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/8/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "RateGameViewController.h"
#import "Resources.h"
#import "ObjectNameConstants.h"
#import "ProfileViewController.h"

@interface RateGameViewController ()

@end

@implementation RateGameViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView setAllowsSelection:NO];
    self.ratings = [NSMutableDictionary dictionary];
    PFQuery *query = [[self.game relationForKey:@"players"] query];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.players = objects;
        for (PFUser *player in objects) {
            NSMutableDictionary *rating = [NSMutableDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:4],
                                                                                       [NSNumber numberWithInt:4],
                                                                                       [NSNumber numberWithInt:4]] forKeys:
                                           @[@"sportsmenship", @"likability", @"experience"]];
            [self.ratings setObject:rating forKey:[player objectId]];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitClicked:(id)sender
{
    for (PFUser *player in self.players) {
        NSDictionary *rating = [self.ratings objectForKey:[player objectId]];
        
        PFObject *obj = [PFObject objectWithClassName:kPlayerRatingObject];
        for (NSString *key in @[@"sportsmenship", @"likability", @"experience"]) {
            [obj setObject:[rating objectForKey:key] forKey:key];
        }
        
        [obj setObject:player forKey:@"player"];
        [obj setObject:self.game forKey:@"game"];
        [obj setObject:[PFUser currentUser] forKey:@"rater"];
        [obj saveInBackground];
    }
    NSMutableArray *ratedGames = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"RatedGames"]];
    [ratedGames addObject:[self.game objectId]];
    [[NSUserDefaults standardUserDefaults] setObject:ratedGames forKey:@"RatedGames"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playerNameClicked:(id)sender
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
    
    PFUser *player = [self.players objectAtIndex:indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ProfileViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"profile-controller"];
    [viewController setUser:player];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)sliderChanged:(UISlider*)sender
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
    
    PFUser *player = [self.players objectAtIndex:indexPath.row];
    
    NSString *key = nil;
    switch ([sender tag]) {
        case 3:
            key = @"sportsmenship";
            break;
        case 4:
            key = @"likability";
            break;
        case 5:
            key = @"experience";
            break;
        default:
            break;
    }
    
    [[self.ratings objectForKey:[player objectId]] setObject:[NSNumber numberWithFloat:[sender value]] forKey:key];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.players count];
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 136;
            break;
        case 1:
            return 211;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"rate-intro-cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rate-intro-cell"];
        }
    }
    else {
        PFUser *player = [self.players objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"person-rate-cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"person-rate-cell"];
        }
        PFImageView *avatarView = (PFImageView*)[cell viewWithTag:1];
        [avatarView setFile:[player objectForKey:@"avatar"]];
        [avatarView loadInBackground];
        
        UIButton *nameButton = (UIButton*)[cell viewWithTag:2];
        [nameButton setTitle:[player objectForKey:@"name"] forState:UIControlStateNormal];
    }

    return cell;
}

@end
