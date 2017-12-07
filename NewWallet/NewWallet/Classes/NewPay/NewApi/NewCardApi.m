//
//  NewCardApi.m
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "NewCardApi.h"
#import "FirstHttpTools_YKT.h"


#define Newpay_YKT_CheckGoodsInfo  @"/ykt_biz/external/v1/query_goods_info"    //查询一卡通商品信息

#define Newpay_YKT_CreateOrder  @"/ykt_biz/external/v1/create_order"       //创建一卡通充值订单

#define Newpay_YKT_QueryYKTList  @"/ykt_biz/external/v2/query_ykt_list"   //获取一卡通列表（充过值的）

#define Newpay_YKT_Delete_ykt_record  @"/ykt_biz/external/v2/delete_ykt_record"  //删除一条充值历史记录

@implementation NewCardApi

static FirstHttpTools_YKT *tool;

+(void)initialize
{
    tool = [FirstHttpTools_YKT shareInstance];
}


//NewPay-api
//查询一卡通商品信息
+ (void)newPay_oneCardCheckGoodsInfoWithStudent_no:(NSString *)student_no
                                         school_id:(NSString *)school_id
                                           success:(void (^)(NSDictionary *))successMethod
                                           failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *reportLossInfo = @{
                                     @"student_no":student_no,
                                     @"school_id":school_id
                                     };
    [tool JsonPostRequst:Newpay_YKT_CheckGoodsInfo parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//创建一卡通充值订单  Newpay_YKT_CreateOrder
+ (void)newPay_oneCardCreateOrderWithYkt_name:(NSString *)ykt_name
                                       student_no:(NSString *)student_no
                                        school_id:(NSString *)school_id
                                  recharge_amount:(NSString *)recharge_amount
                                       pay_amount:(NSString *)pay_amount
                                           coupon:(NSString *)coupon
                                   receive_mobile:(NSString *)receive_mobile
                                          success:(void (^)(NSDictionary *))successMethod
                                          failure:(void (^)(NSError *))errorMethod
{
//    ykt_name //  被充值的一卡通姓名
//    student_no //充值学号
//    school_id  //学校id
//    recharge_amount //充值金额
//    pay_amount //付款金额
//    notify_url //充值完成通知地址 客户端调用值为空
//    coupon //优惠信息
    NSDictionary *reportLossInfo;
    if (!receive_mobile || receive_mobile.length <= 0) {
        reportLossInfo = @{@"ykt_name":ykt_name,
                           @"student_no":student_no,
                           @"school_id":school_id,
                           @"recharge_amount":recharge_amount,
                           @"pay_amount":pay_amount,
                           @"coupon":coupon,
                           };
    } else {
        reportLossInfo = @{@"ykt_name":ykt_name,
                           @"student_no":student_no,
                           @"school_id":school_id,
                           @"recharge_amount":recharge_amount,
                           @"pay_amount":pay_amount,
                           @"coupon":coupon,
                           @"receive_mobile" : receive_mobile
                           };
    }
    [tool JsonPostRequst:Newpay_YKT_CreateOrder parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取一卡通列表
+ (void)newPay_getYKTListWithSuccess:(void (^)(NSDictionary *))successMethod
                             failure:(void (^)(NSError *))errorMethod
{
    [tool JsonPostRequst:Newpay_YKT_QueryYKTList parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//删除一条充值历史记录
+ (void)newPay_Delete_ykt_recordWithRecharge_stuempno:(NSString *)recharge_stuempno
                                         school_id:(NSString *)school_id
                                           success:(void (^)(NSDictionary *))successMethod
                                           failure:(void (^)(NSError *))errorMethod
{
//    'recharge_stuempno' // 学号
//    'school_id' // 学校id
    NSDictionary *reportLossInfo = @{
                                     @"recharge_stuempno":recharge_stuempno,
                                     @"school_id":school_id
                                     };
    [tool JsonPostRequst:Newpay_YKT_Delete_ykt_record parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
@end
