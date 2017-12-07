//
//  BNPayResultVC.h
//  Wallet
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

//支付结果页面跳转类型
typedef NS_ENUM(NSInteger, PayResultVCBackType) {
    PayResultVCBackType_BackHomeVC,           //返回主页
    
};
typedef void (^BackBolck)(PayResultVCBackType payResultVCBackType);

@interface BNPayResultVC : BNBaseViewController

@property (nonatomic) BNPayModel *payModel;
@property (nonatomic) NSDictionary  *dict;
@property (nonatomic, copy) BackBolck backBolck;

@end
