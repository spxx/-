//
//  UIButton+BNNextStepButton.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "UIButton+BNNextStepButton.h"

@implementation UIButton (BNNextStepButton)

-(void)setupTitle:(NSString *)title enable:(BOOL)enable
{
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    [self.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self setEnabled:enable];
    
    UIImage *image1 = [Tools imageWithColor:UIColor_Button_Normal andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    UIImage *image3 = [Tools imageWithColor:UIColor_Button_HighLight andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    
    [self setBackgroundImage:image1 forState:UIControlStateNormal];
    [self setBackgroundImage:image2 forState:UIControlStateDisabled];
    [self setBackgroundImage:image3 forState:UIControlStateHighlighted];
}

-(void)setupRedBtnTitle:(NSString *)title enable:(BOOL)enable
{
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    [self.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self setEnabled:enable];
    
    UIImage *image1 = [Tools imageWithColor:UIColor_RedButtonBGNormal andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    UIImage *image3 = [Tools imageWithColor:UIColor_RedButtonBGHighLight andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    
    [self setBackgroundImage:image1 forState:UIControlStateNormal];
    [self setBackgroundImage:image2 forState:UIControlStateDisabled];
    [self setBackgroundImage:image3 forState:UIControlStateHighlighted];
}


-(void)setupLightBlueBtnTitle:(NSString *)title enable:(BOOL)enable
{
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    [self.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self setEnabled:enable];
    
    UIImage *image1 = [Tools imageWithColor:UIColor_LightBlueButtonBGNormal andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    UIImage *image3 = [Tools imageWithColor:UIColor_LightBlueButtonBGHighLight andSize:CGSizeMake(SCREEN_WIDTH, 50*BILI_WIDTH)];
    
    [self setBackgroundImage:image1 forState:UIControlStateNormal];
    [self setBackgroundImage:image2 forState:UIControlStateDisabled];
    [self setBackgroundImage:image3 forState:UIControlStateHighlighted];
}
-(void)setupBlueBorderLineBtnTitle:(NSString *)title enable:(BOOL)enable
{
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = UIColor_BlueBorderBtn_Normal.CGColor;
    self.layer.borderWidth = 0.5;

    [self.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]]];
    [self setTitle:title forState:UIControlStateNormal];
    [self setEnabled:enable];
    
    [self setTitleColor:UIColor_BlueBorderBtn_Normal forState:UIControlStateNormal];
    [self setTitleColor:UIColor_BlueBorderBtn_HighLight forState:UIControlStateHighlighted];
    
}

@end
