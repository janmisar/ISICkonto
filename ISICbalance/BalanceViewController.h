//
//  BalanceViewController.h
//  ISICbalance
//
//  Created by Jan Mísař on 24.04.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (nonatomic,assign) BOOL shouldReloadOnAppear;

- (IBAction)reloadButtonTapped:(UIButton *)sender;
- (IBAction)settingsButtonTapped:(UIButton *)sender;

@end
