//
//  BNSelectAmountView.m
//  NewWallet
//
//  Created by mac1 on 14-11-6.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNSelectAmountView.h"

#define kBkTag 20
#define kSquareSideLength 52

@implementation BNSelectAmountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat spaceWidth = (frame.size.width - 52 * 4) / 3;
        
        for (int i = 0; i < 4; i++) {
            UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(kSquareSideLength * i + spaceWidth *i, 20, kSquareSideLength, kSquareSideLength)];
            bkView.layer.cornerRadius = kSquareSideLength / 2;
            bkView.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
            bkView.layer.borderWidth = 1;
            bkView.tag = kBkTag + i + 1;
            
            UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(kSquareSideLength/4, kSquareSideLength/4, kSquareSideLength/2, kSquareSideLength/2)];
            pointView.layer.cornerRadius = kSquareSideLength/4;
            pointView.backgroundColor = [UIColor whiteColor];
            pointView.tag = 50 * (i + 1);
            [bkView addSubview:pointView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(kSquareSideLength * i + spaceWidth *i, 20, kSquareSideLength, kSquareSideLength)];
            [button setBackgroundColor: [UIColor clearColor]];
            [button setTag:(1 + i)];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height + 8, button.frame.size.width, 20)];
            amountLabel.text = [NSString stringWithFormat:@"%i", 50 * (i + 1)];
            amountLabel.textAlignment = NSTextAlignmentCenter;
            amountLabel.font = [UIFont systemFontOfSize:16];
            amountLabel.textColor = [UIColor blackColor];
            amountLabel.backgroundColor = [UIColor clearColor];
            
            [self addSubview:bkView];
            [self addSubview:button];
            [self addSubview:amountLabel];
        }
        
    }
    
    return self;
    
}

- (void)buttonAction:(UIButton *)btn
{
    for (int i = 1; i <= 4; i++) {
        UIView *bkView = [self viewWithTag:kBkTag + i];
        UIView *pointView = [bkView viewWithTag:50 * i];
        if (btn.tag == i) {
            pointView.backgroundColor = UIColor_Blue_BarItemText;
        }else{
            pointView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(freePassWordSelectAmount:)]) {
         [self.delegate freePassWordSelectAmount:(50 * btn.tag)];
    }
   
}

- (void)configFreePayPwdAmount:(NSInteger) amount
{
    if (amount <= 0) {
        for (int i = 1; i <= 4; i++) {
            UIView *bkView = [self viewWithTag:kBkTag + i];
            UIView *pointView = [bkView viewWithTag:50 * i];
            
            pointView.backgroundColor = [UIColor whiteColor];
        }
    }else{
        UIView *bkView = [self viewWithTag:kBkTag + (amount / 50)];
        UIView *pointView = [bkView viewWithTag:amount];
        pointView.backgroundColor = UIColor_Blue_BarItemText;
    }
}
@end
