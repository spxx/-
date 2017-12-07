//
//  BNSetNewPayPwdViewController.h
//  NewWallet
//
//  Created by mac1 on 14-10-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, SetNewPayPwdViewControllerUseStyle) {
    SetNewPayPwdViewControllerUseStyleBindCardSetPwd,//设置密码
    SetNewPayPwdViewControllerUseStyleModifyPwd, //修改密码
    SetNewPayPwdViewControllerUseStyleFindPayPwdBindCard,
    SetNewPayPwdViewControllerUseStyleCollectFees // 费用领取
};

@interface BNSetNewPayPwdViewController : BNBaseViewController

@property (assign, nonatomic) SetNewPayPwdViewControllerUseStyle useStyle;

@property (strong, nonatomic) BNPayModel *payModel;

@property (strong, nonatomic) NSString *oldPayPassword;
@property (strong, nonatomic) NSString *verifyCode;

@end
