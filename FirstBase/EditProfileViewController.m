//
//  EditProfileViewController.m
//  FirstBase
//
//  Created by Quan Nguyen on 4/7/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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
    
    self.basketballLevel.minimumValue = 0;
    self.basketballLevel.maximumValue = 3;
    self.soccerLevel.minimumValue = 0;
    self.soccerLevel.maximumValue = 3;
    self.tennisLevel.minimumValue = 0;
    self.tennisLevel.maximumValue = 3;
    self.frisbeeLevel.minimumValue = 0;
    self.frisbeeLevel.maximumValue = 3;
    self.volleyballLevel.minimumValue = 0;
    self.volleyballLevel.maximumValue = 3;
    
    self.user = [PFUser currentUser];
    
    self.basketballLevel.value = [[self.user objectForKey:@"basketballLevel"] floatValue];
    self.soccerLevel.value = [[self.user objectForKey:@"soccerLevel"] floatValue];
    self.tennisLevel.value = [[self.user objectForKey:@"tennisLevel"] floatValue];
    self.frisbeeLevel.value = [[self.user objectForKey:@"frisbeeLevel"] floatValue];
    self.volleyballLevel.value = [[self.user objectForKey:@"volleyballLevel"] floatValue];

    self.name.text = self.user[@"name"];
    self.gender.text = self.user[@"Gender"];
    self.age.text = self.user[@"Age"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view.
}



-(void)dismissKeyboard {
    [self.name resignFirstResponder];
    [self.gender resignFirstResponder];
    [self.age resignFirstResponder];
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

- (IBAction)saveClicked:(id)sender {
    self.user[@"basketballLevel"] = [[NSNumber alloc]initWithFloat:[self.basketballLevel value]];
    self.user[@"soccerLevel"] = [[NSNumber alloc]initWithFloat:[self.soccerLevel value]];
    self.user[@"tennisLevel"] = [[NSNumber alloc]initWithFloat:[self.tennisLevel value]];
    self.user[@"frisbeeLevel"] = [[NSNumber alloc]initWithFloat:[self.frisbeeLevel value]];
    self.user[@"volleyballLevel"] = [[NSNumber alloc]initWithFloat:[self.volleyballLevel value]];
    self.user[@"name"] = self.name.text;
    self.user[@"Gender"] = self.gender.text;
    self.user[@"Age"] = self.age.text;
    [self.user save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
