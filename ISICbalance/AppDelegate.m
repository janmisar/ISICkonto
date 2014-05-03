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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
