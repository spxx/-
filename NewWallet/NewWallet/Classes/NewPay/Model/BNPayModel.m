//
//  BNPayModel.m
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPayModel.h"

@implementation BNPayModel

@synthesize bankCardBinModel;   //银行卡信息
@synthesize bindCardInfoModel;  //绑卡时的填的身份信息

@synthesize userID;        //登录用户id
@synthesize userName;      //充值用户名（如：一卡通充值的学生姓名）
@synthesize goodsName;     //商品名称 （如：一卡通充值）
@synthesize goodsNumber;       //商品号码（需充值的号码，如：一卡通号，手机号）
@synthesize goodsIcon;     //商品图标
@synthesize sellerName;    //收款方名称（如：学校名称）
@synthesize sellerID;      //收款方id（如：学校id）
@synthesize chargePrice;   //充值金额 (如：30元)
@synthesize operatorPrice;     //运营商价格 (话费充值 如：29.5元)


@synthesize salePrice;      //最终支付金额 (如：29.0元)
@synthesize is_no_password; //是否小额免密
@synthesize pay_password; //非小额免密必填
@synthesize order_no;  //订单号
@synthesize biz_no;    // 业务订单号
@synthesize biz_type;  //业务类型，就是首页九宫格的biz_id

@synthesize pay_no;  //支付订单号
@synthesize pay_type; //支付类型

@synthesize pay_type_list;   //各渠道是否可用状态

@synthesize union_trade_no;    //银联支付TN码

@synthesize trade_no;  //易极付交易号
@synthesize fromHistoryBillCouponDisable;  //如果从历史订单去支付，禁止选择优惠券
@synthesize discount_amount;    //优惠券金额
@synthesize coupon_name;    //优惠券名称

-(instancetype)init
{
    self = [super init];
    if (self) {
        bankCardBinModel = [[BNPayBankCardBinModel alloc] init];
        bindCardInfoModel = [[BNBindCardInfoModel alloc] init];
        
        userID = @"";
        userName = @"";
        goodsName = @"";
        goodsNumber = @"";
        goodsIcon = @"";
        sellerName = @"";
        sellerID = @"";
        chargePrice = @"";
        operatorPrice = @"";
        salePrice = @"";
        is_no_password = @"";
        pay_password = @"";
        order_no = @"";
        biz_no = @"";
        biz_type = @"";
        pay_no = @"";
        pay_type = @"";
        
        pay_type_list = @{};
        
        union_trade_no = @"";
        trade_no = @"";
        fromHistoryBillCouponDisable = NO;
        discount_amount = @"";
        coupon_name= @"";
    }
    return self;
}
@end
