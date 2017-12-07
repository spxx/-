//
//  BNPasswordView.h
//  NewWallet
//
//  Created by mac1 on 14-11-5.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPasswordSideWidth 45*BILI_WIDTH
@protocol BNPasswordViewDelegate <NSObject>

- (void)textFieldChangedText:(NSString *)text passwordView:(UIView *) pwdView;

@end

@interface BNPasswordView : UIView

@property (strong, nonatomic) NSString *password;
@property (weak, nonatomic) id <BNPasswordViewDelegate> delegate;

- (id)initWithOrigin:(CGPoint)point;//父视图中的坐标

- (void)passwordViewBecomeFirstResponder;

- (void)passwordViewResignFirstResponder;

- (void)deletePassword;//删除输入的密码


@end
