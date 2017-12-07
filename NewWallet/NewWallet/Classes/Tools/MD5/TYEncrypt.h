//
//  TYEncrypt.h
//  Wallet
//
//  Created by liuchun on 2017/8/28.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYEncrypt : NSObject

+ (NSString *)MD5:(NSString *)string;

+ (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;



@end
