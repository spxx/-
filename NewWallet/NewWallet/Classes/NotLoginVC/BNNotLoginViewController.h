//
//  BNNotLoginViewController.h
//  Wallet
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
typedef NS_ENUM(NSInteger, BNNotLoginViewBUttonType) {
    BNNotLoginViewBUttonTypeSignIn, //注册
    BNNotLoginViewBUttonTypeLogin,  //登录
};

@protocol BNNotLoginViewDelegate <NSObject>

@optional
- (void)BNNotLoginViewbuttonAction:(BNNotLoginViewBUttonType)buttonType;

@end
@interface BNNotLoginViewController : BNBaseViewController

@property (weak, nonatomic) id<BNNotLoginViewDelegate> delegate;
@property (nonatomic) BOOL forGesturePswWrongToPush;   //手势密码错误5次后,成为rootControler.

@end
