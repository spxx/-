//
//  BNAnimitionBlockDelegate.m
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNAnimitionBlockDelegate.h"

@interface BNAnimitionBlockDelegate ()

@property (copy) void(^start)(void);
@property (copy) void(^stop)(BOOL);

+(instancetype)animationDelegateWithBeginning:(void(^)(void))beginning
                                   completion:(void(^)(BOOL finished))completion;

@end

@implementation BNAnimitionBlockDelegate


+ (instancetype)animationDelegateWithBeginning:(void (^)(void))beginning
                                    completion:(void (^)(BOOL))completion
{
    BNAnimitionBlockDelegate *result = [[BNAnimitionBlockDelegate alloc] init];
    result.start = beginning;
    result.stop  = completion;
    return result;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.start) {
        self.start();
    }
    self.start = nil;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.stop) {
        self.stop(flag);
    }
    self.stop = nil;
}
@end
