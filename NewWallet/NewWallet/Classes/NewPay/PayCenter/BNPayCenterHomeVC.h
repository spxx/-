//
//  BNPayCenterHomeVC.h
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

//支付类型
typedef NS_ENUM(NSInteger, PayProjectType) {
    PayProjectTypeOneCard,           //一卡通支付
    PayProjectTypeLoveDenote,        //爱心捐助支付
    PayProjectTypeMobileRecharge,    //手机话费充值
    PayProjectTypeMobileFlowRecharge,    //手机流量充值
    PayProjectTypeSchoolPay,         //校园缴费
    PayProjectTypeXiaoDaiReturnMoney,    //小额贷款-还钱
    PayProjectTypeDianFei,            //电费充值
    
    PayProjectTypeOrderDetail,            //订单详情页面发起支付
    PayProjectTypeNetFees,
    PayProjectTypeScanToPay,
    PayProjectTypeOther,                //其他第三方的业务


};
//支付页面跳转类型
typedef NS_ENUM(NSInteger, PayVCJumpType) {
    PayVCJumpType_PayCompletedBackHomeVC,           //支付成功，返回主页面
    PayVCJumpType_PayCompletedGoToResultVC,           //支付成功，返回主页面
    PayVCJumpType_PayCompletedGoToLastVC,           //支付成功，返回上一个页面
    PayVCJumpType_PayCancle,                        //支付取消 专用于建行和翼支付
};

typedef void (^ReturnBlock)(PayVCJumpType jumpType, id params);


#import "BNBaseViewController.h"
#import "BNPayModel.h"



@interface BNPayCenterHomeVC : BNBaseViewController

@property (copy, nonatomic) ReturnBlock returnBlock;

@property (assign, nonatomic) PayProjectType payProjectType;
@property (nonatomic, strong) BNPayModel *payModel;


//手机充值
//@property (strong, nonatomic) NSString *bndk_amount;
@property (strong, nonatomic) NSString *sp_amount;
@property (strong, nonatomic) NSString *pid;

//小额贷款
@property (strong, nonatomic) NSString *orderNumber;
@property (strong, nonatomic) NSString *repayRestInstallments;

//学校费用缴纳缴纳
@property (strong, nonatomic) NSDictionary *schoolFeesPrjInfo;

//电费充值
@property (copy, nonatomic) NSString *roomStr;

@end
