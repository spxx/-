//
//  BNLivesViewController.h
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, LivesType) {
    LivesTypeMobileRecharge,      //手机充值
    LivesTypeContribute,           //爱心捐助
    LivesTypePaySchoolFees,        //缴纳学杂费
    LivesTypeXiaoDai,              //小额贷款
    LivesTypeDianFei,               //电费充值
    LivesTypeCollectFees           //费用领取
};



@interface BNLivesViewController : BNBaseViewController

@property (assign, nonatomic) LivesType livesType;

@end
