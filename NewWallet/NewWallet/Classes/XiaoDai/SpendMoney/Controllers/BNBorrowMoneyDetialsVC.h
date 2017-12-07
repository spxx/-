//
//  BNBorrowMoneyDetialsVC.h
//  Wallet
//
//  Created by mac1 on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, BNXiaoDaiReturnStyle){
    BNXiaoDaiReturnStyleAnyTime,
    BNXiaoDaiReturnStyleStages
};
typedef NS_ENUM(NSInteger, BNXiaoDaiLoanStatus){
    BNXiaoDaiLoanStatusChuLiZhong,//处理中
    BNXiaoDaiLoanStatusSucceed,//贷款成功
    BNXiaoDaiLoanStatusField//贷款失败
};

@interface BNBorrowMoneyDetialsVC : BNBaseViewController

@property (assign, nonatomic) BNXiaoDaiReturnStyle returnStyle;
@property (assign, nonatomic) BNXiaoDaiLoanStatus  resultStyle;
@property (nonatomic,strong) NSDictionary *detailDic;
@property (nonatomic,strong) NSMutableArray *detailArray;

@end
