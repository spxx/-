//
//  BNMobileRechargeResaultVC.h
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
#import "BNMobileRechargeRasultInfo.h"

@class BNMobileRechargeRasultInfo;

//支付结果返回状态
typedef NS_ENUM(NSInteger, PayResaultType) {
    PayResaultTypeSuccess,                  //充值成功 #3、支付成功 #4
    PayResaultTypeDepositingButSuccess,     //充值中，预计10分钟到账 #5（手机充值返回）
    
    PayResaultTypeDepositSuccessButFailed,  //银行扣款成功，但充值失败///////银行扣款成功 #2
    PayResaultTypeDepositingButFailed,      //银行扣款处理中，但充值失败///////银行扣款处理中 #7

    PayResaultTypeDepositFailed,             //银行扣款失败，充值失败 #1
    PayResaultTypeFailed,                   //其他充值失败 #1  (status = 0,或者余额支付失败)
};

//支付方式
typedef NS_ENUM(NSInteger, PayWayType) {
    PayWayTypeBankCard,                  //银行卡
    PayWayTypeBalance,                   //钱包余额
};

//页面类型
typedef NS_ENUM(NSInteger, ResultControllerType) {
    ResultControllerTypeResultVC,                  //结果页
    ResultControllerTypeDetailVC,                  //详情页
};

@interface BNMobileRechargeResaultVC : BNBaseViewController

@property (assign, nonatomic) PayResaultType payResaultType;
@property (assign, nonatomic) PayProjectType payProjectType;
@property (assign, nonatomic) PayWayType payWayType;
@property (assign, nonatomic) ResultControllerType resultControllerType;

@property (nonatomic) BNMobileRechargeRasultInfo *resultInfo;  //作为充值完成页面

@property (strong, nonatomic) NSDictionary *orderDetials;      //从订单中心进入

//此controller如果是从订单中心进入，则给orderDetials赋值即可；
//如果是作为充值完成页面，则只需给resultInfo、PayProjectType、PayWayType赋值,不需赋值PayResaultType,但要给resultInfo的status赋值

@end
