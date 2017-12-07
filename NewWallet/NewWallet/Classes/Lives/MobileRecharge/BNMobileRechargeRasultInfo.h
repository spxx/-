//
//  BNMobileRechargeRasultInfo.h
//  Wallet
//
//  Created by mac on 15-1-7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMobileRechargeRasultInfo : NSObject

@property (nonatomic) NSString *retcode;
@property (nonatomic) NSString *retmsg;
@property (nonatomic) NSString *displayMoneyStr; //充值金额
@property (nonatomic) NSString *moneyStr;        //实付金额
@property (nonatomic) NSString *mobileNumber;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *bankName;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *productName;

//增加deposit_msg
@property (nonatomic) NSString *depositMsg;
@end
