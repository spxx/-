//
//  BNFeesWebViewExplainVC.h
//  Wallet
//
//  Created by mac1 on 15/3/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
typedef NS_ENUM(NSInteger, ExpainUseType) {
    ExpainUseTypeSchoolFees,//学校费用缴纳
    ExpainUseTypeDianFei,//电费房间号
    ExpainUseTypeCollectFess,//费用领取
    ExpainUseTypeXiFuTrainee //喜付实习生
};

@interface BNFeesWebViewExplainVC : BNBaseViewController
@property (nonatomic, assign) ExpainUseType useType;

@end
