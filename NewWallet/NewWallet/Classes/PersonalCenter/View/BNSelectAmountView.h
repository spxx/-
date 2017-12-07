//
//  BNSelectAmountView.h
//  NewWallet
//
//  Created by mac1 on 14-11-6.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNSelectAmountViewDelegate <NSObject>

- (void)freePassWordSelectAmount:(NSInteger) amount;

@end
@interface BNSelectAmountView : UIView

@property (weak, nonatomic) id<BNSelectAmountViewDelegate> delegate;

- (void)configFreePayPwdAmount:(NSInteger) amount;
@end
