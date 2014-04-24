//
//  SettingsViewController.h
//  ISICbalance
//
//  Created by Jan Mísař on 24.04.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

- (IBAction)doneButtonTapped:(UIButton *)sender;
- (IBAction)saveButtonTapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
