//
//  BNAllPayBillViewController.h
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, BillShowType) {
    BillShowTypeAll,//显示所有
    BillShowTypeOneCardSolution,//一卡通
    BillShowTypeMobileRecharge,//手机充值
    BillShowTypeContribution,//捐助
    BillShowTypeTiXian,//提现
    BillShowTypeDianFei,//电费
    BillShowTypeSchoolFees, //学校费用缴纳
    BillShowTypeCollectFees, //费用领取
    BillShowTypeXiaoDai, //嘻哈贷
    BillShowTypeNetFees, //网费
    BillShowTypeScanToPay, //到店付
    BillShowTypeLearnDriving, //学车
    BillShowTypeVeinPay, //静脉支付
    BillShowTypeQRPay, //二维码支付

};
typedef void (^ReturnsBlock)(void);

@interface BNAllPayBillViewController : BNBaseViewController

@property (copy, nonatomic) ReturnsBlock returnsBlock;

@end
