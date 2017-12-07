//
//  BNResultView.m
//  Wallet
//
//  Created by mac1 on 15/9/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNResultView.h"
@interface BNResultView ()

@property(strong, nonatomic) UIButton *finishButton;
@end

@implementation BNResultView



- (void)reloadData
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT-44)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollView.frame.size.height + 1);
    [self addSubview:scrollView];
    
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90 * BILI_WIDTH);
    headButton.userInteractionEnabled = NO;
    [headButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headButton setBackgroundImage:[Tools imageWithColor:UIColor_Gray_BG andSize:headButton.frame.size] forState:UIControlStateNormal];
    [headButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [headButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [headButton setTitle:self.headBtnStr forState:UIControlStateNormal];
    [scrollView addSubview:headButton];
    
    CGFloat topMargin = CGRectGetMaxY(headButton.frame);
    
    if (self.tipsLabelMsg.length > 0) {
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headButton.frame), scrollView.frame.size.width, 80 * BILI_WIDTH)];
        middleView.tag = 666;
        middleView.layer.borderColor = UIColor_GrayLine.CGColor;
        middleView.layer.borderWidth = 0.5;
        [scrollView addSubview:middleView];
        
        UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * BILI_WIDTH, 0, middleView.frame.size.width - 2 * 20 *BILI_WIDTH, middleView.frame.size.height)];
        middleLabel.textColor = [UIColor colorWithRed:144/ 255.0 green:144 / 255.0 blue:144 / 255.0 alpha:1.f];
        middleLabel.text = self.tipsLabelMsg;
        middleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:17]];
        middleLabel.numberOfLines = 0;
        [middleView addSubview:middleLabel];
        topMargin = CGRectGetMaxY(middleView.frame);
    }
    
    switch (self.status) {
        case ResultStatusSuccesed:
        {
            topMargin += 26*BILI_WIDTH;
            [headButton setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
            NSInteger count = [self.dataSource numberOfmembersInResultView:self];
            
            NSArray *titleArray = [self.dataSource titleForView:self];
            NSArray *contentArray = [self.dataSource contentForView:self];
            for (int i = 0; i < count ; i ++)
            {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19 * BILI_WIDTH,topMargin + (13 + 20) * i * BILI_WIDTH, 70 * BILI_WIDTH, 13 * BILI_WIDTH)];
                titleLabel.text = titleArray[i];
                titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                titleLabel.textColor = [UIColor colorWithRed:144/ 255.0 green:144 / 255.0 blue:144 / 255.0 alpha:1.f];
                [scrollView addSubview:titleLabel];
                
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 3 * BILI_WIDTH, titleLabel.frame.origin.y, 200 * BILI_WIDTH, CGRectGetHeight(titleLabel.frame))];
                contentLabel.text = contentArray[i];
                contentLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                contentLabel.textColor = [UIColor blackColor];
                [scrollView addSubview:contentLabel];
                
                if (i == count - 1) {
                    topMargin = CGRectGetMaxY(titleLabel.frame);
                }
            }
            
            self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _finishButton.frame = CGRectMake(10, topMargin + 50 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
            [_finishButton setupTitle:@"完成" enable:YES];
            [_finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:_finishButton];
            _finishButton.hidden = self.isHiddenFinshButton;
            
            break;
        }
        case ResultStatusUnderWay:
        {
            [headButton setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
            break;
        }
        case ResultStatusFailure:
        {
            [headButton setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
            self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _finishButton.frame = CGRectMake(10, topMargin + 50 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
            [_finishButton setupTitle:@"完成" enable:YES];
            [_finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:_finishButton];
            _finishButton.hidden = self.isHiddenFinshButton;
            break;
        }
            
        default:
            break;
    }
    
}

- (void)finishButtonAction
{
    if ([self.delegate respondsToSelector:@selector(resultViewFinshButtonAcion:)]) {
        [self.delegate resultViewFinshButtonAcion:self];
    }
}

@end
