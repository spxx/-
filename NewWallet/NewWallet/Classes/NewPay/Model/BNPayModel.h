//
//  BNPayModel.h
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNPayBankCardBinModel.h"
#import "BNBindCardInfoModel.h"

@interface BNPayModel : NSObject    /*****支付信息*****/

@property (strong, nonatomic) BNPayBankCardBinModel *bankCardBinModel;   //银行卡信息

@property (strong, nonatomic) BNBindCardInfoModel *bindCardInfoModel;    //绑卡时的填写的身份信息

@property (strong, nonatomic) NSString *userID;        //登录用户id
@property (strong, nonatomic) NSString *userName;      //充值用户名（如：一卡通充值的学生姓名）

@property (strong, nonatomic) NSString *goodsName;     //商品名称 （如：一卡通充值10元-卡号23342）
@property (strong, nonatomic) NSString *goodsNumber;   //商品号码（需充值的号码，如：一卡通号，手机号，电费宿舍号）
@property (strong, nonatomic) NSString *goodsIcon;     //商品图标

@property (strong, nonatomic) NSString *sellerName;    //收款方名称（如：学校名称）
@property (strong, nonatomic) NSString *sellerID;      //收款方id（如：学校id）

@property (strong, nonatomic) NSString *chargePrice;    //充值金额 (如：30元)
@property (strong, nonatomic) NSString *operatorPrice;    //运营商价格 (话费充值 如：29.8元)

@property (strong, nonatomic) NSString *salePrice;      //最终支付金额 (如：29.5元)

@property (strong, nonatomic) NSString *is_no_password; //是否小额免密
@property (strong, nonatomic) NSString *pay_password;   //非小额免密必填

@property (strong, nonatomic) NSString *order_no;  //订单号
@property (strong, nonatomic) NSString *pay_no;    //支付订单号-用于支付接口
@property (strong, nonatomic) NSString *biz_no;    //业务订单号
@property (strong, nonatomic) NSString *biz_type;    //业务类型，就是首页九宫格的biz_id

@property (strong, nonatomic) NSString *pay_type; //支付类型(1-喜付钱包，2-喜付银行卡，3-银联)

@property (strong, nonatomic) NSDictionary *pay_type_list;   //各渠道是否可用状态
@property (strong, nonatomic) NSString *union_trade_no;    //银联支付TN码

@property (strong, nonatomic) NSString *trade_no;  //易极付交易号
@property (nonatomic) BOOL fromHistoryBillCouponDisable;  //如果从历史订单去支付，禁止选择优惠券
@property (strong, nonatomic) NSString *discount_amount;    //优惠券金额
@property (strong, nonatomic) NSString *coupon_name;    //优惠券名称


@end
