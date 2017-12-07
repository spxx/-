//
//  BNReviewStepView.m
//  Wallet
//
//  Created by cyjjkz1 on 15/4/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReviewStepView.h"



@interface BNReviewStepView ()
@property (weak, nonatomic) UIImageView *rightRedArrow;

@end

@implementation BNReviewStepView

- (id)initWithFrame:(CGRect)frame stepNames:(NSArray *)stepNames reviewStep:(BNReviewStepType)step
{
    self = [super initWithFrame:frame];
    
    if (self) {
        for (int i = 1; i < 6; i++) {
            UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTimeLineOriginX/2.0 - 12, kReviewHeadHeight + kReviewRowHeight * i - 12, 24, 24)];
            stepLabel.tag = kReviewBtnBaseTag - i;
            stepLabel.layer.cornerRadius = 12;
            stepLabel.layer.borderWidth = 1.0;
            stepLabel.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
            stepLabel.layer.masksToBounds = YES;
            stepLabel.text = [NSString stringWithFormat:@"%i", i];
            stepLabel.textColor = UIColorFromRGB(0xe8e8e8);
            stepLabel.font = [UIFont systemFontOfSize:[BNTools sizeFitfour:14 five:15 six:16 sixPlus:16]];
            stepLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:stepLabel];
        }
        
        CGSize titleSize = [[UIFont systemFontOfSize:[BNTools sizeFitfour:15 five:16 six:17 sixPlus:18]] useThisFontWithString:[stepNames objectAtIndex: 0]];
        for (int i = 1; i < 6; i++) {
            UIButton *stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            stepBtn.tag = kReviewBtnBaseTag + i;
            stepBtn.backgroundColor = [UIColor clearColor];
            stepBtn.enabled = NO;
            stepBtn.frame = CGRectMake(kTimeLineOriginX + kTimeLineOriginX/2.0, kReviewHeadHeight + kReviewRowHeight * i - 20, SCREEN_WIDTH - (kTimeLineOriginX + kTimeLineOriginX/2.0) - 50, 40);
            [stepBtn setTitleColor:UIColorFromRGB(0xacacac) forState:UIControlStateNormal];
            stepBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFitfour:15 five:16 six:17 sixPlus:18]];
            [stepBtn setTitle:[stepNames objectAtIndex:i - 1] forState:UIControlStateNormal];
            
            [stepBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(stepBtn.frame) - titleSize.width)];
            
            [stepBtn addTarget:self action:@selector(reviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:stepBtn];
        }
        
        UIButton *btn1 = (UIButton *)[self viewWithTag:kReviewBtnBaseTag + 1];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMinY(btn1.frame) + 10, 20, 20)];
        [arrow setImage:[UIImage imageNamed:@"XiaoDai_redRightArrow"]];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        arrow.alpha = .0;
        _rightRedArrow = arrow;
        [self addSubview:arrow];
        
        [self changeColorAndEnableWithTag:step];
        
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.tag = kReviewBtnBaseTag + 6;
        finishButton.backgroundColor = UIColorFromRGB(0xE8E8E8);
        finishButton.frame = CGRectMake(0, CGRectGetHeight(frame) - kReviewFootHeight, SCREEN_WIDTH, kReviewFootHeight);
        [finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        finishButton.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFitfour:16 five:16 six:20 sixPlus:24]];
        [finishButton setTitle:@"认证完成" forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(reviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishButton];
        
    }
    return self;
    
}

#pragma mark - step button
- (void)reviewButtonAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(reviewStepSelectedWithIndex:)]) {
        [self.delegate reviewStepSelectedWithIndex:(btn.tag - kReviewBtnBaseTag)];
        BNLog(@"btn.tag %li", (long)btn.tag);
    }
}

- (void)changeReviewFinishButton
{
    UIButton *finishButton = (UIButton *)[self viewWithTag:kReviewBtnBaseTag + 6];
    finishButton.backgroundColor = UIColorFromRGB(0xE8E8E8);
    [finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    finishButton.enabled = YES;
}

- (void)changeColorAndEnableWithTag:(NSInteger) tag
{
    for (int i = 1; i <= tag; i++) {
        if (i == 6) {
            break;
        }
        UILabel *lab = (UILabel *)[self viewWithTag:kReviewBtnBaseTag - i];
        lab.layer.borderColor = UIColorFromRGB(0xe25258).CGColor;
        lab.textColor = UIColorFromRGB(0xe25258);
    }
    
    for (int i = 1; i <= tag; i++) {
        if (i != 6) {
            UIButton * btn = (UIButton *)[self viewWithTag:kReviewBtnBaseTag + i];
            [btn setTitleColor:UIColorFromRGB(0xe25258) forState:UIControlStateNormal];
            if (i <= tag - 1) {
                btn.enabled = NO;
            }
        }
        
    }
}


- (void)stepButtonActiveAnimitionWithViewTag:(NSInteger)tag
{
    UIButton * btn = (UIButton *)[self viewWithTag:tag];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (btn.enabled == NO) {
        btn.enabled = YES;
        CGRect arrowRect = _rightRedArrow.frame;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.rightRedArrow.alpha = 1.0;
            self.rightRedArrow.frame = CGRectMake(CGRectGetMinX(arrowRect), CGRectGetMinY(btn.frame) + 10, CGRectGetWidth(arrowRect), CGRectGetWidth(arrowRect));
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            btn.frame = CGRectMake(CGRectGetMinX(btn.frame) + (CGRectGetWidth(btn.frame) * 1.2 - CGRectGetWidth(btn.frame))/2.0, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        }];
        
        CABasicAnimation *animt2 = [CABasicAnimation animationWithKeyPath:@"transform"];
        [animt2 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)]];
        animt2.duration = 0.5;
        animt2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animt2.fillMode = kCAFillModeBackwards;
        animt2.removedOnCompletion = YES;
        [btn.layer addAnimation:animt2 forKey:nil];
        btn.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
    }
    
}

- (void)stepButtonNormalAnimitionWithViewTag:(NSInteger)tag
{
    UIButton * btn = (UIButton *)[self viewWithTag:tag];
    
    [btn setTitleColor:UIColorFromRGB(0xe25258) forState:UIControlStateNormal];
    
    
    CABasicAnimation *animt2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animt2 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    animt2.duration = 0.5;
    animt2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animt2.fillMode = kCAFillModeBackwards;
    animt2.removedOnCompletion = YES;
    [btn.layer addAnimation:animt2 forKey:nil];
    btn.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    [UIView animateWithDuration:0.5 animations:^{
        btn.frame = CGRectMake(kTimeLineOriginX + kTimeLineOriginX/2.0, kReviewHeadHeight + kReviewRowHeight * (btn.tag - kReviewBtnBaseTag) - 20, SCREEN_WIDTH - (kTimeLineOriginX + kTimeLineOriginX/2.0) - 50, 40);
        
    }];
    
}


@end
