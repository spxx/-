//
//  BNIDValidateSelectView.m
//  Wallet
//
//  Created by mac1 on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNIDValidateSelectView.h"

#define kIDValidateBarHeight [BNTools sizeFit:30 six:32 sixPlus:36]

@interface BNIDValidateSelectView ()

@property (assign, nonatomic) CGFloat boardHeight;

@property (weak,   nonatomic) UIDatePicker *datePickView;
@end

@implementation BNIDValidateSelectView
- (id)initWithDelegate:(id)theDelegate
{
    _boardHeight = 216;
    if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        _boardHeight = 226;
    }
    
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kIDValidateBarHeight)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
        cancelBtn.frame = CGRectMake(10, 3, 60, kIDValidateBarHeight);
        [cancelBtn setTitleColor:UIColorFromRGB(0x31d1fe) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelSelectDate:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
        finishBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 60, 3, 60, kIDValidateBarHeight);
        [finishBtn setTitleColor:UIColorFromRGB(0x31d1fe) forState:UIControlStateNormal];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishSelectDate:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kIDValidateBarHeight, SCREEN_WIDTH, _boardHeight)];
        _datePickView = picker;
        [picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"]];
        [picker setDatePickerMode:UIDatePickerModeDate];
        [self addSubview:picker];
        
        [self addSubview:line];
        [self addSubview:cancelBtn];
        [self addSubview:finishBtn];
        
        
        _delegate = theDelegate;
        _pickIsShow = NO;
    }
    return self;
}


- (void)cancelSelectDate:(UIButton *)btn
{
    [self dismiss];
}

- (void)finishSelectDate:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(selectedIDValidate:)]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
        [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"]];
        NSDate *selectedDate = [_datePickView date];

        [self.delegate selectedIDValidate:[dateFormatter stringFromDate:selectedDate]];
        
    }
    [self dismiss];
}

- (void)show
{
    if (_pickIsShow == NO) {
        __weak typeof(self) weakSelf = self;
        UIWindow *keyWindow = shareAppDelegateInstance.window;
        [keyWindow addSubview:self];
        _pickIsShow = YES;
        
        [UIView animateWithDuration:.5 animations:^{
            weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT - (_boardHeight + kIDValidateBarHeight), SCREEN_WIDTH, _boardHeight + kIDValidateBarHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}

- (void)dismiss
{
    _pickIsShow = NO;
    UIWindow *keyWindow = shareAppDelegateInstance.window;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _boardHeight + kIDValidateBarHeight);
    } completion:^(BOOL finished) {
        [keyWindow removeFromSuperview];
    }];
    
    
}

@end
