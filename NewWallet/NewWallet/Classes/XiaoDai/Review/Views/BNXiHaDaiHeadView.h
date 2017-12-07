//
//  BNXiHaDaiHeadView.h
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KViewBiLi     0.48

#define kInfoBiLi     0.584

@protocol BNXiHaDaiHeadDelegate <NSObject>

- (void)xiHaDaiHeadAnimitionStoped;

@end

@interface BNXiHaDaiHeadView : UIView

@property (assign, nonatomic) CGFloat amount;
@property (assign, nonatomic) CGFloat spend;
@property (assign, nonatomic) CGFloat left;

@property (weak, nonatomic) id<BNXiHaDaiHeadDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame amount:(CGFloat) amount hasSpend:(CGFloat)spend leftAmount:(CGFloat) left;

- (void)startAnimition;


@end
