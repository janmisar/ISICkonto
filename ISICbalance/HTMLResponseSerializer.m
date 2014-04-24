//
//  HTMLResponseSerializer.m
//  ISICbalance
//
//  Created by Jan Mísař on 24.04.14.
//  Copyright (c) 2014 Jan Mísař. All rights reserved.
//

#import "HTMLResponseSerializer.h"

@implementation HTMLResponseSerializer

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    return [ObjectiveGumbo parseDocumentWithData:data];
}

@end
