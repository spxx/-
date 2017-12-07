//
//  NSDictionary+NullHandle.m
//  NewWallet
//
//  Created by mac on 14-10-29.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "NSDictionary+NullHandle.h"

@implementation NSDictionary (NullHandle)

- (id)valueNotNullForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] class] ==  [NSNull class] || ![self.allKeys containsObject:aKey]) {
        return @"null";
    } else {
        return [self objectForKey:aKey];
    }
}
- (id)valueWithNoDataForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] class] ==  [NSNull class] || ![self.allKeys containsObject:aKey]) {
        return @"";
    } else {
        return [self objectForKey:aKey];
    }
}
@end

