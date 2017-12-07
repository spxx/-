//
//  BNReturnMoneyDetailVC.h
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNReturnMoneyDetailVC : BNBaseViewController

@property (nonatomic) ReturnMoneyStatus returnMoneyStatus;

- (id)initWithBorrowInfo:(NSDictionary *)aDic;
@end
