//
//  BNReturnMoneyListVC.h
//  Wallet
//
//  Created by mac on 15/5/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"
@protocol BNReturnMoneyListVCDelegate <NSObject>

- (void)BNReturnMoneyListVCDelegatePopPush;

@end
@interface BNReturnMoneyListVC : BNBusinessFinishedBaseVC
@property (assign,  nonatomic) CGFloat creditLoanAmount;
@property (assign,  nonatomic) CGFloat loanRemainAmount;
@property (assign,  nonatomic) NSInteger overduedLoanCount;//超期
@property (weak, nonatomic) id <BNReturnMoneyListVCDelegate> delegate;

@end
