//
//  CreateGameViewController.h
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateGameViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *descInput;
@property (nonatomic) IBOutlet UIPickerView *sportPicker;
@property (nonatomic) IBOutlet UIDatePicker *timePicker;
@property (nonatomic) IBOutlet UITextField *nameInput;
@property (nonatomic) IBOutlet UIPickerView *locationPicker;
@property (nonatomic) IBOutlet UISwitch *privacySwitch;
@property (nonatomic) NSArray *locationOptions;
@property (nonatomic) NSArray *sportOptions;
@property (nonatomic) PFObject *game;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)inviteClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;

@end
