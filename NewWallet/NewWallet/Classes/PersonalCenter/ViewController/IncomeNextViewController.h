//
//  IncomeNextViewController.h
//  Wallet
//
//  Created by cyjjkz1 on 15/6/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@interface IncomeNextViewController : BNBaseViewController

@property(nonatomic, assign) IncomeSpendStatus incomeSpendstatus;

@property (nonatomic,copy) NSString *navigationTitleString;

@property (nonatomic) NSDictionary *dataDic;

@end
