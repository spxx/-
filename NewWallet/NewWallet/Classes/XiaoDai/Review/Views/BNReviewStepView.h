//
//  BNReviewStepView.h
//  Wallet
//
//  Created by cyjjkz1 on 15/4/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNReviewBKView.h"

@protocol BNReviewStepDelegate <NSObject>

- (void)reviewStepSelectedWithIndex:(NSInteger) index;

@end

@interface BNReviewStepView : UIView


@property (weak, nonatomic) id<BNReviewStepDelegate> delegate;

- (id)initWithFrame:(CGRect)frame stepNames:(NSArray *)stepNames reviewStep:(BNReviewStepType)step;

- (void)stepButtonActiveAnimitionWithViewTag:(NSInteger)tag;

- (void)stepButtonNormalAnimitionWithViewTag:(NSInteger)tag;

- (void)changeColorAndEnableWithTag:(NSInteger) tag;

- (void)changeReviewFinishButton;
@end
