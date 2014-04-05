//
//  CreateGameViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "CreateGameViewController.h"
#import "ObjectNameConstants.h"

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationOptions = [NSArray arrayWithObjects:@"Z Center", @"Bubble", @"Du Pont", nil];
    self.sportOptions = [NSArray arrayWithObjects:kGameTypeFrisbee, kGameTypeBasketball, kGameTypeVolleyball, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
