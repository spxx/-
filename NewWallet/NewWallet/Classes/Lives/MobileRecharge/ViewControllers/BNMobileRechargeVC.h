//
//  BNMobileRechargeVC.h
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"

#define kMobileRechargeTipsString @"温馨提示\n1、支持全国移动/联通/电信;\n2、默认为本次登录账号充值，也可为他人充值。"

@interface BNMobileRechargeVC : BNBusinessFinishedBaseVC
@property (strong, nonatomic) NSMutableArray *bindedCardsArray;
@property (nonatomic) NSString *biz_id;

@end
