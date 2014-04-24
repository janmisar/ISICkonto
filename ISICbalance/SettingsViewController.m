//
//  SettingsViewController.m
//  ISICbalance
//
//  Created by Jan Mísař on 24.04.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _usernameField.text = [UserDefaults objectForKey:@"username"];
    _passwordField.text = [UserDefaults objectForKey:@"password"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(UIButton *)sender {
    
    [UserDefaults setObject:_usernameField.text forKey:@"username"];
    [UserDefaults setObject:_passwordField.text forKey:@"password"];
    [UserDefaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
