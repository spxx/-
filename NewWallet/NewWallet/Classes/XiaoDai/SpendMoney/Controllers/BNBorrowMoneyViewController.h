//
//  BNBorrowMoneyViewController.h
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
@protocol BNBorrowMoneyViewControllerDelegate <NSObject>

- (void)BNBorrowMoneyViewControllerDelegatePopPush;

@end

@interface BNBorrowMoneyViewController : BNBaseViewController

@property (assign,  nonatomic) CGFloat creditLoanAmount;

@property (assign,  nonatomic) CGFloat loanRemainAmount;

@property (assign,  nonatomic) NSInteger overduedLoanCount;//超期

@property (weak, nonatomic) id <BNBorrowMoneyViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *bankListArray;

@end
