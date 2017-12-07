//
//  BNReturnAndBorrowMoneyResultVC.h
//  Wallet
//
//  Created by mac on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNReturnAndBorrowMoneyResultVC : BNBaseViewController

@property (nonatomic) XiaoDaiPayResultStatus resultStatus;

@property (nonatomic) NSString *message;
@property (nonatomic) NSString *moneyStr;

@end
