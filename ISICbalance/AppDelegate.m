//
//  AppDelegate.m
//  ISICbalance
//
//  Created by Jan Mísař on 24.02.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"https://agata.suz.cvut.cz/secure/index.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\nfailing URL: %@", operation.response.URL);
        
        NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:operation.response.URL.query]];
        NSString *returnQuery = ((NSURL *)[NSURL URLWithString:[[queryParams objectForKey:@"return"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]).query;
        [queryParams setObject:[self parseQueryString:returnQuery] forKey:@"return"];
        
        NSLog(@"params: %@",queryParams);
        
        NSString *samlds = [[queryParams objectForKey:@"return"] objectForKey:@"SAMLDS"];
        NSString *target = [[queryParams objectForKey:@"return"] objectForKey:@"target"];
        NSString *entityID = [queryParams objectForKey:@"entityID"];
        entityID = @"https://idp2.civ.cvut.cz/idp/shibboleth";
        NSString *filter = [[queryParams objectForKey:@"filter"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        filter = @"eyJhbGxvd0ZlZWRzIjogWyJlZHVJRC5jeiJdLCAiYWxsb3dJZFBzIjogWyJodHRwczovL3dzc28udnNjaHQuY3ovaWRwL3NoaWJib2xldGgiLCJodHRwczovL2lkcDIuY2l2LmN2dXQuY3ovaWRwL3NoaWJib2xldGgiXSwgImFsbG93SG9zdGVsIjogZmFsc2UsICJhbGxvd0hvc3RlbFJlZyI6IGZhbHNlfQ%3D%3D";
        NSString *lang = [queryParams objectForKey:@"lang"];
        
        NSString *urlString = [NSString stringWithFormat:@"https://agata.suz.cvut.cz/Shibboleth.sso/Login?SAMLDS=%@&target=%@&entityID=%@&filter=%@&lang=%@",samlds,target,entityID,filter,lang];
        
        NSLog(@"\nnew URL: %@",urlString);
        
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"\nfail: %@", operation.response.URL);
            
            NSDictionary *parameters = @{@"j_username": @"misarja1", @"j_password":@"15AD1dd294"};
            [manager POST:operation.response.URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"\nError: %@", error);
            }];
            
        }];
        
        
    }];
    
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
