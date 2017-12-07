//
//  NewModifyPhoneVerifyVC.h
//  Wallet
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
typedef NS_ENUM(NSInteger, ModifyPhoneVerifyType)
{
    ModifyPhoneVerifyTypeIdentity,    //验证身份信息
    ModifyPhoneVerifyTypeLoginPsw,    //验证登录密码
};
@interface NewModifyPhoneVerifyVC : BNBaseViewController

@property (nonatomic) ModifyPhoneVerifyType verifyType;

@end
