//
//  NewPayOrderCenterApi.m
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "NewPayOrderCenterApi.h"
#import "FirstHttpTools_OrderCenter.h"

#define Newpay_Statistics @"/ykt_biz/external/v3/consume_statistics"

#define Newpay_QueryTrans @"/ykt_biz/external/v3/query_trans"

#define Newpay_StartPayTerrace @"/order_center/external/v1/start_pay_terrace"      //获取启动支付平台-支付数据

#define Newpay_QueryOrderList  @"/order_center/external/v1/query_order_list"       //查询订单列表

#define Newpay_QueryOrderInfo  @"/order_center/external/v1/query_order_info"       //获取订单详情

#define Newpay_CancelOrder     @"/order_center/external/v1/close_order"       //取消订单

#define Newpay_GetAvailableCoupons  @"/coupon_server/external/v1/available_coupons"       //获取可用优惠券数量

#define Newpay_GetPayWaysList  @"/pay_way_supervise/external/v1/common_pay_list"    //收银台_获取支付方式列表
#define Newpay_QR_GetPayWaysList  @"/pay_way_supervise/external/v1/personal_qr_pay_list"    //付款码_获取支付方式列表

#define Newpay_QR_SetTopPayWay  @"/pay_way_supervise/external/v1/top_personal_qr_pay" //付款码_置顶选择的支付方式

#define Newpay_QR_GetPersonalSecret  @"/pay_way_supervise/external/v1/get_personal_secret"//付款码_获取个人秘钥

#define Newpay_QR_Check_is_open_qr_pay  @"/pay_way_supervise/external/v1/is_open_qr_pay"   //付款码_检查用户是否开通二维码支付
#define Newpay_QR_Open_qr_pay  @"/pay_way_supervise/external/v1/open_qr_pay" //开通二维码支付

#define newpay_QR_StopUseIt  @"/pay_way_supervise/external/v1/close_qr_pay"   //付款码_暂停使用

#define Newpay_QR_Check_query_qr_pay_result  @"/qr_pay_server/external/v1/query_qr_pay_result" //查询二维码支付结果


#pragma mark - 静脉信息的API
#define VeinInfo_checkIfBindedVein      @"/member_card_server/external/v1/is_bound_vein" //静脉信息_查询是否已绑定静脉
#define VeinInfo_checkIfOpenedVeinPay   @"/pay_way_supervise/external/v1/is_enabled_vein_pay" //静脉信息_查询是否已开通静脉支付
#define VeinInfo_openVeinPay   @"/pay_way_supervise/external/v1/enable_vein_pay"     //静脉信息_开通静脉支付
#define VeinInfo_need_stu_no   @"/member_card_server/external/v1/gym/query_open_vein_pay_need_stu_no"   //静脉信息_查询该学校的静脉业务是否必须绑定学号
#define VeinInfo_getVeinCreditAmout @"/app/cafeteria_consume_server/v1/query_credit_amount"   //静脉信息_查询静脉信用金额度


@implementation NewPayOrderCenterApi

static FirstHttpTools_OrderCenter *tool;

+(void)initialize
{
    tool = [FirstHttpTools_OrderCenter shareInstance];
}

//NewPay-api
//消费统计
+(void)newPay_StatisticsWithSchool_id:(NSString *)School_id student_no:(NSString *)student_no year_month:(NSString *)year_month success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"school_id":School_id,@"student_no":student_no,@"year_month":year_month};
    BNLog(@"%@",dict);
    [tool JsonPostRequst:Newpay_Statistics parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//账单查询
+(void)newPay_queryTransWithyear:(NSString *)year month:(NSString *)month card_no:(NSString *)card_no success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"year":year,@"month":month,@"card_no":card_no};
    BNLog(@"%@",dict);
    [tool JsonPostRequst:Newpay_QueryTrans parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取启动支付平台-支付数据
+ (void)newPay_StartPayTerraceWithOrder_no:(NSString *)order_no
                                  pay_type:(NSString *)pay_type
                                  coupon_no:(NSString *)coupon_no
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *))errorMethod
{
//    order_no //支付订单号
//    pay_type //支付类型(1-喜付钱包，2-喜付银行卡，3-银联 6-易极付)
    NSDictionary *reportLossInfo = @{
                                     @"order_no":order_no,
                                     @"pay_type":pay_type,
                                     @"coupon_no":coupon_no
                                     };
    if ([coupon_no floatValue] <=0) {
        reportLossInfo = @{
                           @"order_no":order_no,
                           @"pay_type":pay_type,
                           };
    }
    [tool JsonPostRequst:Newpay_StartPayTerrace parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//查询订单列表
+ (void)newPay_QueryOrderListWithSuccess:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod
{
    [tool JsonPostRequst:Newpay_QueryOrderList parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//取消订单
+ (void)newPay_CancelOrderWithOrder_no:(NSString *)order_no
                                biz_no:(NSString *)biz_no
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{
                           @"order_no":order_no,
                           @"biz_no":biz_no
                           };
    
    [tool JsonPostRequst:Newpay_CancelOrder parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取订单详情
+ (void)newPay_QueryOrderInfoWithOrder_no:(NSString *)order_no
                                 biz_no:(NSString *)biz_no
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{
                           @"order_no":order_no,
                           @"biz_no":biz_no
                           };

    [tool JsonPostRequst:Newpay_QueryOrderInfo parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//获取可用优惠券数量
+ (void)newpay_GetAvailableCouponsWithCount_only:(NSString *)count_only
                                        biz_type:(NSString *)biz_type
                                      pay_amount:(NSString *)pay_amount
                                         success:(void (^)(NSDictionary *))successMethod
                                         failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"count_only":count_only,
                           @"biz_type":biz_type,
                           @"pay_amount":pay_amount
                           };
    
    [tool JsonPostRequst:Newpay_GetAvailableCoupons parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//收银台_获取支付方式列表
+ (void)newpay_GetPayWaysListWithSchoolID:(NSString *)schoolID
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"school_id" : schoolID ? schoolID : @"",
                           @"app_version" : [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey],
                           @"os" : @"ios",
                           };
    
    [tool JsonPostRequst:Newpay_GetPayWaysList parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//付款码_获取支付方式列表
+ (void)newpay_QR_GetPayWaysListWithUserID:(NSString *)userID
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"user_id" : userID ? userID : @"",
                           };
    
    [tool JsonPostRequst:Newpay_QR_GetPayWaysList parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//付款码_置顶选择的支付方式
+ (void)newpay_QR_SetTopPayWayWithUserID:(NSString *)userID
                            top_pay_type:(NSString *)top_pay_type
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"user_id" : userID ? userID : @"",
                           @"top_pay_type" : top_pay_type ? top_pay_type : @"",
                           };
    
    [tool JsonPostRequst:Newpay_QR_SetTopPayWay parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//付款码_获取个人秘钥
+ (void)newpay_QR_GetPersonalSecretWithUserID:(NSString *)userID
                                      success:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"user_id" : userID ? userID : @"",
                           };
    
    [tool JsonPostRequst:Newpay_QR_GetPersonalSecret parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//付款码_检查用户是否开通二维码支付
+ (void)newpay_QR_Check_is_open_qr_payWithUserID:(NSString *)userID
                                         success:(void (^)(NSDictionary *))successMethod
                                         failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"user_id" : userID ? userID : @"",
                           };
    
    [tool JsonPostRequst:Newpay_QR_Check_is_open_qr_pay parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//开通二维码支付
+ (void)newpay_QR_Open_qr_pay_WithUserID:(NSString *)userID
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"user_id" : userID ? userID : @"",};
    [tool JsonPostRequst:Newpay_QR_Open_qr_pay parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//查询二维码支付结果
+ (void)newpay_QR_Check_query_qr_pay_resultWithUserID:(NSString *)userID
                                              success:(void (^)(NSDictionary *))successMethod
                                              failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"user_id" : userID ? userID : @"",};
    [tool JsonPostRequst:Newpay_QR_Check_query_qr_pay_result parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//付款码_暂停使用
+ (void)newpay_QR_stopUseItWithSuccess:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod
{
    
    [tool JsonPostRequst:newpay_QR_StopUseIt parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

#pragma mark - 静脉信息的API
//静脉信息_查询是否已绑定静脉
+ (void)veinInfo_checkIfBindedVeinWithSuccess:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod
{
    /*返回值："is_bound": 0 // 0-未绑定 1-已绑定*/
    [tool JsonPostRequst:VeinInfo_checkIfBindedVein parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//静脉信息_查询是否已开通静脉支付
+ (void)veinInfo_checkIfOpenedVeinPayWithSuccess:(void (^)(NSDictionary *))successMethod
                                         failure:(void (^)(NSError *))errorMethod
{
    /*返回值："is_enabled_vein_pay": 0 // 0-未开通 1-已开通*/
    [tool JsonPostRequst:VeinInfo_checkIfOpenedVeinPay parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//静脉信息_开通静脉支付
+ (void)veinInfo_openVeinPayWithStatus:(NSString *)status
                               success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod
{
    //传值："status": 1 //1-开启 ,0-关闭
    NSDictionary *dict = @{@"status" : status,
                           };

    [tool JsonPostRequst:VeinInfo_openVeinPay parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//静脉信息_查询该学校的静脉业务是否必须绑定学号
+ (void)veinInfo_need_stu_noWithSchoolID:(NSString *)school_id
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod
{
    //返回值："need_bind": 1 //1-必须绑定 ,0-不须绑定
    NSDictionary *dict = @{@"school_id" : school_id ? school_id : @"",
                           };
    [tool JsonPostRequst:VeinInfo_need_stu_no parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
//静脉信息_查询静脉信用金额度
+ (void)veinInfo_getVeinCreditAmoutWithXifuID:(NSString *)xifu_id
                                      success:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *dict = @{@"xifu_id" : xifu_id ? xifu_id : @"",
                           };
    [tool JsonPostRequst:VeinInfo_getVeinCreditAmout parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
