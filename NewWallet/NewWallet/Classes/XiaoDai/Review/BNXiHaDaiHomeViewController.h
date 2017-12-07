//
//  BNXiHaDaiHomeViewController.h
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNYJPayBankCardManageBaseVC.h"

@interface BNXiHaDaiHomeViewController : BNYJPayBankCardManageBaseVC

@property (assign,  nonatomic) CGFloat creditLoanAmount;//总额
@property (assign,  nonatomic) CGFloat loanRemainAmount; //可贷金额
@property (assign,  nonatomic) NSInteger overduedLoanCount;//超期
@property (assign,  nonatomic) NSInteger closeReturnCount; //快要到期


@property (assign, nonatomic) BOOL isPop;

@end
