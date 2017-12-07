//
//  BNXiaoDaiBorrowMoneyInfo.h
//  Wallet
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNXiaoDaiBorrowMoneyInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (copy,nonatomic) NSString *amount;//借款金额
@property (copy,nonatomic) NSString *cardId;//银行卡号
@property (copy,nonatomic) NSString *psw;//支付密码
@property (copy,nonatomic) NSString *mobileNumber; //手机号
@property (copy,nonatomic) NSString *repaymentType;//还款类型
@property (copy,nonatomic) NSString *installments;//分期数

@property (copy,nonatomic) NSString *status;//借款状态

@end
