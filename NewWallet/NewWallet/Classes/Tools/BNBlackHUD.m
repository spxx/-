//
//  BNBlackHUD.m
//  LCHUD
//
//  Created by mac1 on 15/8/28.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBlackHUD.h"
#define kMessageFont [UIFont systemFontOfSize:15];

/**
 *  消息停留时间
 */
static CGFloat const BNMessageDuration = 1.5;

/**
 * 动画执行时间
 */
static CGFloat const BNAnimationDuration = 0.25;

static UILabel *blackLabel;

@implementation BNBlackHUD

+ (UILabel *)initBlackLabel
{
    blackLabel = [[UILabel alloc] init];
    blackLabel.translatesAutoresizingMaskIntoConstraints = NO;
    blackLabel.numberOfLines = 0;
    blackLabel.backgroundColor = [UIColor blackColor];
    blackLabel.textColor = [UIColor whiteColor];
    blackLabel.textAlignment = NSTextAlignmentCenter;
    blackLabel.lineBreakMode = NSLineBreakByWordWrapping;
    blackLabel.font = kMessageFont;
    return blackLabel;
}


+ (void)showMessage:(NSString *)msg toView:(UIView *)aView
{
    [self initBlackLabel];
    blackLabel.text = msg;
    [aView addSubview:blackLabel];
    [self showOrhideWithLayer:blackLabel.layer show:YES]; //show动画

    NSInteger margin = 0;
    CGFloat theWidth = [Tools getTextWidthWithText:msg font:[UIFont systemFontOfSize:15] height:20];
    if (theWidth < [UIScreen mainScreen].bounds.size.width - 80) {
        margin = ([UIScreen mainScreen].bounds.size.width - theWidth - 10)/2.0;
    }
    else
    {
        margin = 40;
    }
    
    NSDictionary *views = @{@"blackLabel":blackLabel};
    NSDictionary *metrics = @{@"margin":@(margin)};
    NSArray *blackLabelConsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[blackLabel]-margin-|" options:0 metrics:metrics views:views];
    [aView addConstraints:blackLabelConsH];//水平约束
    
    NSLayoutConstraint *blackLabelConsV = [NSLayoutConstraint constraintWithItem:blackLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeBottom multiplier:1 constant:-50];
    [aView addConstraint:blackLabelConsV];//垂直约束
    
        
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(BNMessageDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showOrhideWithLayer:blackLabel.layer show:NO];//hide动画
    });
    
}

+ (void)showOrhideWithLayer:(CALayer *)aLayer show:(BOOL)isShow
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    if (isShow) {
        basicAnimation.fromValue = @(0);
        basicAnimation.toValue = @(1);
    }
    else
    {
        basicAnimation.fromValue = @(1);
        basicAnimation.toValue = @(0);
    }
    basicAnimation.duration = BNAnimationDuration;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [aLayer addAnimation:basicAnimation forKey:@"animation"];
    
}

+ (CGFloat)getStringWithString:(NSString *)string
{
   CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    return size.width;
}



@end
