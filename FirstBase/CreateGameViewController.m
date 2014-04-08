//
//  CreateGameViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "CreateGameViewController.h"
#import "ObjectNameConstants.h"
#import "InviteFriendsViewController.h"

@interface CreateGameViewController ()

@end

@implementation CreateGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)cancelClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteClicked:(id)sender
{
    // self.game setObject:self.timePicker  forKey:<#(NSString *)#>
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    InviteFriendsViewController *inviteController = [sb instantiateViewControllerWithIdentifier:@"invite-friends-controller"];
    
    // save information to self.game
    self.game[@"sport"] = [self.sportOptions objectAtIndex:[self.sportPicker selectedRowInComponent:0]];
    self.game[@"Location"] = [self.locationOptions objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
    self.game[@"creator"] = [PFUser currentUser];
    self.game[@"host"] = [[PFUser currentUser] objectForKey:@"name"];
    NSDate *selected = [self.timePicker date];
    // NSLog(@"%f",[selected timeIntervalSince1970]);
    self.game[@"time"] = selected;
    
    [self.game save];
    inviteController.game = self.game;
    // NSLog(@"Object id %@", [self.game objectId]);
    [self.navigationController pushViewController:inviteController animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.locationPicker) {
        return [self.locationOptions count];
    }
    if (pickerView == self.sportPicker) {
        return [self.sportOptions count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.locationPicker) {
        return [self.locationOptions objectAtIndex:row];
    }
    if (pickerView == self.sportPicker) {
        return [self.sportOptions objectAtIndex:row];
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)viewDidLoad
{
    self.locationOptions = [NSArray arrayWithObjects:@"Z Center", @"Bubble", @"Du Pont", @"MAC Court", @"Rockwell", @"Briggs Field", @"Johnson",  nil];
    self.sportOptions = [NSArray arrayWithObjects:kGameTypeFrisbee, kGameTypeBasketball, kGameTypeVolleyball, kGameTypeSoccer, kGameTypeTennis, nil];
    self.game = [PFObject objectWithClassName:kGameObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

@end
