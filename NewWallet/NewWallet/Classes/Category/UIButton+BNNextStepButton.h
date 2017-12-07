//
//  UIButton+BNNextStepButton.h
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BNNextStepButton)

-(void)setupTitle:(NSString *)title enable:(BOOL)enable; //蓝色按钮

-(void)setupRedBtnTitle:(NSString *)title enable:(BOOL)enable;  //红色按钮

-(void)setupLightBlueBtnTitle:(NSString *)title enable:(BOOL)enable;

-(void)setupBlueBorderLineBtnTitle:(NSString *)title enable:(BOOL)enable;//空心线框按钮

@end
