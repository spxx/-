//
//  BNAnimitionBlockDelegate.h
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNAnimitionBlockDelegate : NSObject

+(instancetype)animationDelegateWithBeginning:(void(^)(void))beginning
                                   completion:(void(^)(BOOL finished))completion;
@end
