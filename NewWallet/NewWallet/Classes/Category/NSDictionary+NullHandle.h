//
//  NSDictionary+NullHandle.h
//  NewWallet
//
//  Created by mac on 14-10-29.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullHandle)

- (id)valueNotNullForKey:(NSString *)aKey;
- (id)valueWithNoDataForKey:(NSString *)aKey;

@end
