//
//  BNBaseTextField.m
//  Wallet
//
//  Created by mac on 15/1/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseTextField.h"

@implementation BNBaseTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
//        line1.backgroundColor = UIColor_GrayLine;
//        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(30, frame.size.height-1, frame.size.width-30*2, 1)];
        line2.backgroundColor = UIColor_GrayLine;
        [self addSubview:line2];
        
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.borderStyle = UITextBorderStyleNone;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//控制placeHolder的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width-80, bounds.size.height);
    return rect;
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width-80, bounds.size.height);
    return rect;
}

//控制清除按钮位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectOffset([super clearButtonRectForBounds:bounds], -30, 0);
}
@end
