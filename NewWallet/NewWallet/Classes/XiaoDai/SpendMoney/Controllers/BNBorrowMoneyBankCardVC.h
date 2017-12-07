//
//  BNBorrowMoneyBankCardVC.h
//  Wallet
//
//  Created by mac1 on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

//12月1日 需求更改，必须绑卡才能借钱
typedef NS_ENUM(NSInteger, BankCardViewControllerUseStyle) {
    bankCardViewControllerUseStyleXiaoDai = 0, //
    bankCardViewControllerUseStylTixian = 1    //
};


@protocol BNBorrowMoneyBankCardVCDelegate <NSObject>

@optional
- (void)selectPayBankBorrowMoneyBankCardVCWithBankInfo:(NSDictionary *)dict;

@end
@interface BNBorrowMoneyBankCardVC : BNBaseViewController
@property (weak, nonatomic) id <BNBorrowMoneyBankCardVCDelegate> delegate;
@property (nonatomic) NSArray *bankCardsListArray;
@property (nonatomic) NSString *selectCardNoStr;

@property (assign, nonatomic) BankCardViewControllerUseStyle useStyle;

@property (nonatomic,copy) NSString *popControllerName;

@end
