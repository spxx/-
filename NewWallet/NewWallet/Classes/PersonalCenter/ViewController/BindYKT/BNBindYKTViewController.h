//
//  BNBindYKTViewController.h
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
//支付类型
typedef NS_ENUM(NSInteger, BindType) {
    BindTypeOneCard = 0,           //绑定一卡通
    BindTypeXueHao = 1,            //绑定学号
};
typedef NS_ENUM(NSInteger, UseType) {
    BNBindYKTUseTypeOthers = 0, //其他默认
    BNBindYKTUseTypePaySchoolFees = 1, //学校费用缴纳
    BNBindYKTUseTypeCollectFees = 2, //费用领取绑定学号
    BNBindYKTUseTypeXiaodai = 3,//小额贷绑定学号
    BNBindYKTUseTypeMobileRecharge = 4//手机充值绑定学号
};

extern NSString *const kBindXueHaoUseTypeKey;

@interface BNBindYKTViewController : BNBaseViewController

@property (strong, nonatomic) NSString *yktType;
@property (nonatomic) BindType bindType;
@property (nonatomic, assign) UseType useType;



@end
