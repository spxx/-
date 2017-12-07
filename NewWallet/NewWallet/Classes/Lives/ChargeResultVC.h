//
//  ChargeResultVC.h
//  Wallet
//
//  Created by mac1 on 15/8/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
typedef NS_ENUM(NSInteger, chargeResultUseType) {
    chargeResultUseTypeCharge,
    chargeResultUseTypeBillCenter
};

@interface ChargeResultVC : BNBaseViewController

@property (nonatomic, assign) ElectricChargeStatus status;

@property (nonatomic, assign) chargeResultUseType type;

@property (copy, nonatomic) NSString *roomStr;
@property (copy, nonatomic) NSString *timeStr;
@property (copy, nonatomic) NSString *channelStr;
@property (copy, nonatomic) NSString *moneyStr;

@end
