//
//  RegexModel.m
//  Wallet
//
//  Created by mac1 on 15/12/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "RegexModel.h"

@implementation RegexModel


- (NSString *)description
{
    return [NSString stringWithFormat:@"range :%@  ismatch: %d",NSStringFromRange(self.resultRange),self.isMatch];
}
@end
