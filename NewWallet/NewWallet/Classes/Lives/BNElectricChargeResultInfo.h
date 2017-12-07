//
//  BNElectricChargeResultInfo.h
//  Wallet
//
//  Created by mac1 on 15/8/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface BNElectricChargeResultInfo : NSObject

singleton_interface(BNElectricChargeResultInfo);

@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *roomStr;
@property (copy, nonatomic) NSString *bankName;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *moneyStr; //充值金额
@property (copy, nonatomic) NSString *ActrulMoney; //实际支付金额

@property (copy, nonatomic) NSString *retMsg;//错误信息

@end
