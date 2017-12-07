//
//  BNPageControl.h
//  Wallet
//
//  Created by mac1 on 2017/1/5.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNPageControl : UIControl





@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

- (instancetype)initWithYValue:(CGFloat)yValue;

@end
