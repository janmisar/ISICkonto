//
//  BalanceViewController.m
//  ISICbalance
//
//  Created by Jan Mísař on 24.04.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import "BalanceViewController.h"
#import "SettingsViewController.h"

@interface BalanceViewController ()

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    _balanceLabel.adjustsFontSizeToFitWidth = YES;
    _balanceLabel.font = PTSansBold(80);
    
    _infoLabel.font = PTSansRegular(18);
    
    _shouldReloadOnAppear = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    if(![UserDefaults objectForKey:@"username"] || ![UserDefaults objectForKey:@"password"]) {
        
        [self.navigationController pushViewController:[SettingsViewController new] animated:YES];
        
    } else {
        
        if(_shouldReloadOnAppear) {
            [self reloadData];
            _shouldReloadOnAppear = NO;
        }
        
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    //self.navigationController.navigationBarHidden = NO;
}

-(void)reloadData {
    
    [SVProgressHUD showWithStatus:@"Načítání stavu..." maskType:SVProgressHUDMaskTypeGradient];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [HTMLResponseSerializer serializer];
    
    [manager GET:@"https://agata.suz.cvut.cz/secure/index.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSURL *responseURL = operation.response.URL;
        NSString *hostURLString = [self baseStringFromURL:responseURL];
        
        if([hostURLString rangeOfString:@"agata.suz.cvut.cz" options:NSCaseInsensitiveSearch].location != NSNotFound) { // je to námi požadovaný obsah
            
            [self reloadViewWithBalance:[self readBalanceFromDocument:responseObject]];
            [SVProgressHUD dismiss];
            
        } else { // nejsme lognutý
            
            NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:responseURL.query]];
            NSURL *returnURL = [NSURL URLWithString:[[queryParams objectForKey:@"return"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *returnQuery = returnURL.query;
            NSString *returnBase = [self baseNoQueryStringFromURL:((NSURL *)[NSURL URLWithString:[[queryParams objectForKey:@"return"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]])];
            [queryParams setObject:[self parseQueryString:returnQuery] forKey:@"return"];
            
            NSString *samlds = [[queryParams objectForKey:@"return"] objectForKey:@"SAMLDS"];
            NSString *target = [[queryParams objectForKey:@"return"] objectForKey:@"target"];
            NSString *entityID = @"https://idp2.civ.cvut.cz/idp/shibboleth"; // jiné pro všcht!
            NSString *filter = [[queryParams objectForKey:@"filter"] stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
            NSString *lang = [queryParams objectForKey:@"lang"];
            
            NSString *urlString = [NSString stringWithFormat:@"%@?SAMLDS=%@&target=%@&entityID=%@&filter=%@&lang=%@",returnBase,samlds,target,entityID,filter,lang];
            
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *parameters = @{@"j_username": [UserDefaults objectForKey:@"username"], @"j_password":[UserDefaults objectForKey:@"password"]};
                [manager POST:operation.response.URL.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    OGDocument *document = responseObject;
                    
                    // pokud je ve stránce id #eduid_login, je tam pravděpodobně napsáno wrong credentials
                    NSArray *eduidLogin = [document select:@"#eduid_login"];
                    if(eduidLogin.count) {
                        OGText *credentials = (OGText *)[(OGElement *)eduidLogin[0] first:@"font"];
                        if ([credentials.text rangeOfString:@"credentials" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                            [self reloadViewWithBalance:0];
                            [SVProgressHUD showErrorWithStatus:@"Nesprávné přihlašovací údaje"];
                            return;
                        }
                    }
                    
                    
                    NSArray *forms = [document elementsWithTag:GUMBO_TAG_FORM];
                    OGElement *form = forms[0];
                    NSString *action = [form.attributes objectForKey:@"action"];
                    NSArray *inputs = [form elementsWithTag:GUMBO_TAG_INPUT];
                    OGElement *input1 = inputs[0];
                    OGElement *input2 = inputs[1];
                    NSDictionary *parameters = @{[input1.attributes objectForKey:@"name"]: [input1.attributes objectForKey:@"value"],
                                                 [input2.attributes objectForKey:@"name"]: [input2.attributes objectForKey:@"value"]};
                    
                    [manager POST:action parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        [self reloadViewWithBalance:[self readBalanceFromDocument:responseObject]];
                        [SVProgressHUD dismiss];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"Došlo k chybě, zkuste to prosím znovu."];
                    }];
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"Došlo k chybě, zkuste to prosím znovu."];
                }];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"Došlo k chybě, zkuste to prosím znovu."];
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Došlo k chybě, zkuste to prosím znovu."];
    }];
    
}

-(float)readBalanceFromDocument:(OGDocument *)document {
    OGText *balance = (OGText *)[[[document first:@"table"] last:@"tr"] last:@"td"];
    NSString *balanceString = [balance.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    return [balanceString integerValue];
}

-(void)reloadViewWithBalance:(float)balance {
    
    _balanceLabel.text = [NSString stringWithFormat:@"%@ Kč",[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:balance] numberStyle:NSNumberFormatterDecimalStyle]];
    
}

#pragma mark - UI actions

- (IBAction)reloadButtonTapped:(UIButton *)sender {
    [self reloadData];
}

- (IBAction)settingsButtonTapped:(UIButton *)sender {
    
    [self.navigationController pushViewController:[SettingsViewController new] animated:YES];
    
}

#pragma mark - Helpers

-(NSString *)baseStringFromURL:(NSURL *)url {
    return[[NSURL URLWithString:@"/" relativeToURL:url] absoluteURL].absoluteString;
}

-(NSString *)baseNoQueryStringFromURL:(NSURL *)url {
    return [[NSURL alloc] initWithScheme:[url scheme]
                                                    host:[url host]
                                                    path:[url path]].absoluteString;
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
