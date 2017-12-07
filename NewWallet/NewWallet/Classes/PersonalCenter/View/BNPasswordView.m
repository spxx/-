//
//  BNPasswordView.m
//  NewWallet
//
//  Created by mac1 on 14-11-5.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNPasswordView.h"

@interface BNPasswordView()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *passwordTextField;

@property (weak, nonatomic) UIView *displayView;
@end


@implementation BNPasswordView

- (id)initWithOrigin:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, kPasswordSideWidth * 6, kPasswordSideWidth)];
    if (self) {
        UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kPasswordSideWidth * 6 - 20, kPasswordSideWidth - 5*2)];
        pwdTextField.borderStyle = UITextBorderStyleNone;
        pwdTextField.delegate = self;
        pwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        pwdTextField.secureTextEntry = YES;
        pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        [pwdTextField addTarget:self action:@selector(passwordFirstChangedAction:) forControlEvents:UIControlEventEditingChanged];
        self.passwordTextField = pwdTextField;
        [self addSubview:pwdTextField];
        
        UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPasswordSideWidth * 6, kPasswordSideWidth)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passwordViewBecomeFirstResponder)];
        [displayView addGestureRecognizer:tap];
        displayView.backgroundColor = UIColor_NavBarBGColor;
        displayView.layer.borderColor = UIColorFromRGB(0xcfcfcf).CGColor;
        displayView.layer.borderWidth = 1;
        
        for (int i = 1; i <= 6; i++) {
            if (i <= 5) {
                CALayer *oneVLineLayer = [[CALayer alloc] init];
                oneVLineLayer.frame = CGRectMake(kPasswordSideWidth * i, 0, 1, kPasswordSideWidth);
                oneVLineLayer.backgroundColor = UIColorFromRGB(0xcfcfcf).CGColor;
                [displayView.layer addSublayer:oneVLineLayer];
            }
            CGFloat pointWidth = 8*BILI_WIDTH;
            UIView *blackPoint = [[UIView alloc] initWithFrame:CGRectMake((kPasswordSideWidth - pointWidth)/2 + kPasswordSideWidth * (i - 1), (kPasswordSideWidth-pointWidth)/2, pointWidth, pointWidth)];
            blackPoint.tag = i;
            blackPoint.layer.cornerRadius = pointWidth/2;
            blackPoint.backgroundColor = [UIColor blackColor];
            blackPoint.hidden = YES;
            [displayView addSubview:blackPoint];
        }
        
        self.displayView = displayView;
        [self addSubview:displayView];
        
        
    }
    return self;
}

- (void)passwordFirstChangedAction:(UITextField *)tf
{
    NSString *pwd = tf.text;
    if (pwd.length > 6) {
        pwd = [pwd substringWithRange:NSMakeRange(0, 6)];
        tf.text = pwd;
    }
    if ([self.delegate respondsToSelector:@selector(textFieldChangedText:passwordView:)]) {
        [self.delegate textFieldChangedText:pwd passwordView:self];
    }
    self.password = [pwd copy];
    NSInteger pwdLength = pwd.length;
    
    if (pwd != nil && pwdLength > 0) {
        for (int i = 1; i <= 6; i++) {
            UIView *blackPoint = [self.displayView viewWithTag:i];
            if (i <= pwdLength) {
                blackPoint.hidden = NO;
            }else{
                blackPoint.hidden = YES;
            }
        }
    }else{
        for (int i = 1; i <= 6; i++) {
            UIView *blackPoint = [self.displayView viewWithTag:i];
            blackPoint.hidden = YES;
        }
    }
    BNLog(@"pass word %@", self.password);
}


//删除输入的密码
- (void)deletePassword
{
    _passwordTextField.text = @"";
    for (UIView *blackPoint in [self.displayView subviews]) {
        [blackPoint setHidden:YES];
    }
   
}

- (void)passwordViewBecomeFirstResponder
{
    [self.passwordTextField becomeFirstResponder];
}

- (void)passwordViewResignFirstResponder
{
    [self.passwordTextField resignFirstResponder];
}
@end
