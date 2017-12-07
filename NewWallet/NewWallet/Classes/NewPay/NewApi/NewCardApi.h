//
//  NewCardApi.h
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCardApi : NSObject

//NewPay-api

//查询一卡通商品信息
+ (void)newPay_oneCardCheckGoodsInfoWithStudent_no:(NSString *)student_no
                                         school_id:(NSString *)school_id
                                           success:(void (^)(NSDictionary *))successMethod
                                           failure:(void (^)(NSError *))errorMethod;


//创建一卡通充值订单  Newpay_YKT_CreateOrder
+ (void)newPay_oneCardCreateOrderWithYkt_name:(NSString *)ykt_name
                                   student_no:(NSString *)student_no
                                    school_id:(NSString *)school_id
                              recharge_amount:(NSString *)recharge_amount
                                   pay_amount:(NSString *)pay_amount
                                       coupon:(NSString *)coupon
                               receive_mobile:(NSString *)receive_mobile
                                      success:(void (^)(NSDictionary *))successMethod
                                      failure:(void (^)(NSError *))errorMethod;

//获取一卡通列表
+ (void)newPay_getYKTListWithSuccess:(void (^)(NSDictionary *))successMethod
                             failure:(void (^)(NSError *))errorMethod;

//删除一条充值历史记录
+ (void)newPay_Delete_ykt_recordWithRecharge_stuempno:(NSString *)recharge_stuempno
                                            school_id:(NSString *)school_id
                                              success:(void (^)(NSDictionary *))successMethod
                                              failure:(void (^)(NSError *))errorMethod;

@end




