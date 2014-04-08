//
//  ProfileViewController.m
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString*)calculateSkillLevel:(float)grade{
    if (grade < 1.0)
        return @"Beginner";
    else if (grade < 2.0)
        return @"Intermediate";
    else
        return @"Advanced";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.user == nil) {
        self.user = [PFUser currentUser];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(avatarClickToEdit)];
        [self.avatarView addGestureRecognizer:singleTap];
        [self.avatarView setUserInteractionEnabled:YES];
        
        
        [self.nameLabel setText:self.user[@"name"]];
        [self.infoLabel setText:@"Age: " ];
        self.infoLabel.text = [self.infoLabel.text stringByAppendingString:self.user[@"Age"]];
        self.infoLabel.text = [self.infoLabel.text stringByAppendingString:@"\nGender: "];
        self.infoLabel.text = [self.infoLabel.text stringByAppendingString:self.user[@"Gender"]];
        
        // print skill level
        [self.basketballSkill setText:[self calculateSkillLevel:[self.user[@"basketballLevel"] floatValue]]];
        [self.soccerSkill setText:[self calculateSkillLevel:[self.user[@"soccerLevel"] floatValue]]];
        [self.tennisSkill setText:[self calculateSkillLevel:[self.user[@"tennisLevel"] floatValue]]];
        [self.frisbeeSkill setText:[self calculateSkillLevel:[self.user[@"frisbeeLevel"] floatValue]]];
        [self.volleyballSkill setText:[self calculateSkillLevel:[self.user[@"volleyballLevel"] floatValue]]];
    }

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear{

    self.user = [PFUser currentUser];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(avatarClickToEdit)];
    [self.avatarView addGestureRecognizer:singleTap];
    [self.avatarView setUserInteractionEnabled:YES];
        
        
    [self.nameLabel setText:self.user[@"name"]];
    [self.infoLabel setText:@"Age: " ];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:self.user[@"Age"]];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:@"\nGender: "];
    self.infoLabel.text = [self.infoLabel.text stringByAppendingString:self.user[@"Gender"]];
    
    // print skill level
    [self.basketballSkill setText:[self calculateSkillLevel:[self.user[@"basketballLevel"] floatValue]]];
    [self.soccerSkill setText:[self calculateSkillLevel:[self.user[@"soccerLevel"] floatValue]]];
    [self.tennisSkill setText:[self calculateSkillLevel:[self.user[@"tennisLevel"] floatValue]]];
    [self.frisbeeSkill setText:[self calculateSkillLevel:[self.user[@"frisbeeLevel"] floatValue]]];
    [self.volleyballSkill setText:[self calculateSkillLevel:[self.user[@"volleyballLevel"] floatValue]]];
}



- (void)logoutClicked:(id)sender
{
    [PFUser logOut];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] popMainController];
}



-(void)editClicked:(id)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    EditProfileViewController *editProfileController = [sb instantiateViewControllerWithIdentifier:@"edit-profile-controller"];

    [self.navigationController pushViewController:editProfileController animated:YES];
}



- (void)avatarClickToEdit
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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
