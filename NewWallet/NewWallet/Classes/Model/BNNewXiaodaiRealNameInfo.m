//
//  BNNewXiaodaiRealNameInfo.m
//  Wallet
//
//  Created by mac1 on 15/10/27.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNNewXiaodaiRealNameInfo.h"
#import <objc/runtime.h>

@implementation BNNewXiaodaiRealNameInfo
singleton_implementation(BNNewXiaodaiRealNameInfo);


- (BOOL)clearRealNameInfo{
    
    BOOL isClearAll = YES;
    unsigned int outCount = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        const char *propertyChar = property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:propertyChar];
        
        [self setValue:nil forKey:propertyName];
        
        NSString *propertyValue = [self valueForKey:propertyName];
        
        if (propertyValue.length > 0) {//属性有值
            isClearAll = NO;
            break;
        }
    }
    return isClearAll;
}

- (BOOL)checkAllPropertyValues
{
        BOOL canSubmit = YES;
    
        unsigned int outCount = 0;
    
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
    
            const char *propertyChar = property_getName(property);
    
            NSString *propertyName = [NSString stringWithUTF8String:propertyChar];
    
            NSString *propertyValue = [self valueForKey:propertyName];
            if ([propertyName isEqualToString:@"realNameInfoOfFrontImgPath"]) {
                continue;
            }
            if (propertyValue.length <= 0) {//属性有值
                canSubmit = NO;
                break;
            }
        }
        
        return canSubmit;
}

@end
