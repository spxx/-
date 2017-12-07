//
//  BNVerifySMSCodeViewController.h
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

#define kVerifyTipsString @"温馨提示:\n如果原手机无法收到验证码， 请拨打客服热线：400-998-0880进行人工申诉更换新手机号。"
@interface BNVerifySMSCodeViewController : BNBaseViewController

@property (copy, nonatomic) NSString *phoneNumber;

@property (assign, nonatomic) ViewControllerUseStyle useStyle;

@property (nonatomic) BNPayModel *payModel;

@property (copy, nonatomic) NSString *studentNumber;

@end
