//
//  TYEncrypt.m
//  Wallet
//
//  Created by liuchun on 2017/8/28.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "TYEncrypt.h"

@implementation TYEncrypt

+ (NSString *)MD5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i] ];
    
    return [result uppercaseString];
}

+ (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString {
    return [signString isEqualToString:[self MD5:string]];
}

@end
