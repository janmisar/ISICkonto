//
//  AppDelegate.m
//  ISICbalance
//
//  Created by Jan Mísař on 24.02.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import "AppDelegate.h"
#import "BalanceViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x4b96b3]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    NSDictionary *textAttributes = @{NSFontAttributeName: PTSansBold(18),
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    textAttributes = @{NSFontAttributeName: PTSansRegular(18),
                       NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [SVProgressHUD setFont:PTSansRegular(15)];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xffffff]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHex:0x3783a0]];
    
    
    BalanceViewController *controller = [BalanceViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self.window setRootViewController:navController];
    self.window.backgroundColor = [UIColor colorWithHex:0x4b96b3];
    [self.window makeKeyAndVisible];
    
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    return YES;
}

-(NSDictionary *)parseQueryString:(NSString *)queryString {
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = @"";
        for (int i=1; i<pairComponents.count; i++) {
            if(i!=1)
                value = [value stringByAppendingString:@"="];
            value = [value stringByAppendingString:pairComponents[i]];
        }
        
        [queryStringDictionary setObject:value forKey:key];
    }
    
    return queryStringDictionary;
}

@end
