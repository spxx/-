//
//  NewPayOrderCenterApi.h
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewPayOrderCenterApi : NSObject

//NewPay-api

//获取消费统计
+ (void)newPay_StatisticsWithSchool_id:(NSString *)School_id
                                  student_no:(NSString *)student_no
                                 year_month:(NSString *)year_month
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *))errorMethod;
//账单接口查询
+ (void)newPay_queryTransWithyear:(NSString *)year
                                  month:(NSString *)month
                                 card_no:(NSString *)card_no
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *))errorMethod;

//获取启动支付平台-支付数据
+ (void)newPay_StartPayTerraceWithOrder_no:(NSString *)order_no
                                  pay_type:(NSString *)pay_type
                                 coupon_no:(NSString *)coupon_no
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *))errorMethod;

//查询订单列表
+ (void)newPay_QueryOrderListWithSuccess:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod;
//取消订单
+ (void)newPay_CancelOrderWithOrder_no:(NSString *)order_no
                                biz_no:(NSString *)biz_no
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod;

//获取订单详情
+ (void)newPay_QueryOrderInfoWithOrder_no:(NSString *)order_no
                                 biz_no:(NSString *)biz_no
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod;

//获取可用优惠券数量
+ (void)newpay_GetAvailableCouponsWithCount_only:(NSString *)count_only
                                        biz_type:(NSString *)biz_type
                                      pay_amount:(NSString *)pay_amount
                                         success:(void (^)(NSDictionary *))successMethod
                                         failure:(void (^)(NSError *))errorMethod;

//收银台_获取支付方式列表
+ (void)newpay_GetPayWaysListWithSchoolID:(NSString *)schoolID
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod;

//付款码_获取支付方式列表
+ (void)newpay_QR_GetPayWaysListWithUserID:(NSString *)userID
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *))errorMethod;

//付款码_置顶选择的支付方式
+ (void)newpay_QR_SetTopPayWayWithUserID:(NSString *)userID
                            top_pay_type:(NSString *)top_pay_type
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod;

//付款码_获取个人秘钥
+ (void)newpay_QR_GetPersonalSecretWithUserID:(NSString *)userID
                                      success:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod;

//付款码_检查用户是否开通二维码支付
+ (void)newpay_QR_Check_is_open_qr_payWithUserID:(NSString *)userID
                                         success:(void (^)(NSDictionary *))successMethod
                                         failure:(void (^)(NSError *))errorMethod;
//开通二维码支付
+ (void)newpay_QR_Open_qr_pay_WithUserID:(NSString *)userID
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod;

//查询二维码支付结果
+ (void)newpay_QR_Check_query_qr_pay_resultWithUserID:(NSString *)userID
                                              success:(void (^)(NSDictionary *))successMethod
                                              failure:(void (^)(NSError *))errorMethod;

//付款码_暂停使用
+ (void)newpay_QR_stopUseItWithSuccess:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod;





#pragma mark - 静脉信息的API
//静脉信息_查询是否已绑定静脉
+ (void)veinInfo_checkIfBindedVeinWithSuccess:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod;

//静脉信息_查询是否已开通静脉支付
+ (void)veinInfo_checkIfOpenedVeinPayWithSuccess:(void (^)(NSDictionary *))successMethod
                                         failure:(void (^)(NSError *))errorMethod;

//静脉信息_开通静脉支付
+ (void)veinInfo_openVeinPayWithStatus:(NSString *)status
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod;

//静脉信息_查询该学校的静脉业务是否必须绑定学号
+ (void)veinInfo_need_stu_noWithSchoolID:(NSString *)school_id
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *))errorMethod;
//静脉信息_查询静脉信用金额度
+ (void)veinInfo_getVeinCreditAmoutWithXifuID:(NSString *)xifu_id
                                      success:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod;

@end




