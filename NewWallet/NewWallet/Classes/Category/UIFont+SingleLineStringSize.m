//
//  UIFont+SingleLineStringSize.m
//  Wallet
//
//  Created by mac1 on 15/5/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "UIFont+SingleLineStringSize.h"

@implementation UIFont (SingleLineStringSize)

- (CGSize)useThisFontWithString:(NSString *) string
{
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: self}];
    CGSize strSize = [attributeStr size];
    return strSize;
}
@end
