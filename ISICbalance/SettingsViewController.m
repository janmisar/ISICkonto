//
//  SettingsViewController.m
//  ISICbalance
//
//  Created by Jan Mísař on 24.04.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import "SettingsViewController.h"
#import "BalanceViewController.h"

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
    self.navigationItem.title = @"Uživatel";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _nameLabel.font = PTSansRegular(16);
    _passwordLabel.font = PTSansRegular(16);
    
    _usernameField.text = [UserDefaults objectForKey:@"username"];
    _usernameField.font = PTSansRegular(16);
    _usernameField.tintColor = [UIColor whiteColor];
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _usernameField.leftView = usernamePaddingView;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.layer.cornerRadius = 2;
    _usernameField.layer.masksToBounds = YES;
    
    _passwordField.text = [UserDefaults objectForKey:@"password"];
    _passwordField.font = PTSansRegular(16);
    _passwordField.tintColor = [UIColor whiteColor];
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _passwordField.leftView = passwordPaddingView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.layer.cornerRadius = 2;
    _passwordField.layer.masksToBounds = YES;
    
    _loginButton.titleLabel.font = PTSansRegular(16);
    _loginButton.layer.cornerRadius = 2;
    _loginButton.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;

    CGSize aSize = _mainScrollView.frame.size;
    aSize.height -= self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    _mainScrollView.contentSize = aSize;
}

-(void)keyboardDidShow {
    _mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0);
    _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 216, 0);
}

-(void)keyboardWillHide {
    _mainScrollView.contentInset = UIEdgeInsetsZero;
    _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)handleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField==_usernameField) {
        [_passwordField becomeFirstResponder];
    } else {
        [self saveButtonTapped:nil];
    }
    
    return YES;
}

- (IBAction)saveButtonTapped:(UIButton *)sender {
    
    NSString *username = [UserDefaults objectForKey:@"username"];
    NSString *password = [UserDefaults objectForKey:@"password"];
    
    if(![username isEqualToString:_usernameField.text] || ![password isEqualToString:_passwordField.text]) {
        
        [UserDefaults setObject:_usernameField.text forKey:@"username"];
        [UserDefaults setObject:_passwordField.text forKey:@"password"];
        [UserDefaults synchronize];
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        
        BalanceViewController *parent = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        parent.shouldReloadOnAppear = YES;
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mightyTapped:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.creations.cz"]];
}

- (IBAction)janmisarTapped:(UIButton *)sender {
    
    NSString *message = @"Pokud máte jakýkoliv nápad, připomínku, bug report nebo třeba zájem se spolupodílet (např. udělat Android nebo WP aplikaci...) budu rád, když se ozvete na misar.jan@gmail.com ;-)";
    
    [[[UIAlertView alloc] initWithTitle:@"Baf!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
}


@end
