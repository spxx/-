//
//  NewYJFPayApi.h
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewYJFPayApi : NSObject

//NewPay-api
//支付接口（客户端调用）
+ (void)newPay_PayTradeWithIs_no_password:(NSString *)is_no_password
                               goods_name:(NSString *)goods_name
                              seller_name:(NSString *)seller_name
                               pay_amount:(NSString *)pay_amount
                                   pay_no:(NSString *)pay_no
                                 order_no:(NSString *)order_no
                             pay_password:(NSString *)pay_password
                            buyer_card_no:(NSString *)buyer_card_no
                        buyer_card_bindid:(NSString *)buyer_card_bindid
                                 pay_type:(NSString *)pay_type
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *))errorMethod;


//获取易极付支付方式列表(客户端调用)
+ (void)newPay_GetYJFPayWaysWithSuccess:(void (^)(NSDictionary *))successMethod
                                failure:(void (^)(NSError *))errorMethod;


//获取易极付关联ID - 调起易极付SDK银行卡管理模块之前，调用此接口。
+ (void)getYJFBindidWithSuccess:(void (^)(NSDictionary *))successMethod
                        failure:(void (^)(NSError *))errorMethod;

//支付完成后，向喜付后台上传支付返回码
+ (void)unloadYJFPayStatusWithOrder_no:(NSString *)order_no
                              pay_type:(NSString *)pay_type
                        sdk_pay_status:(NSString *)sdk_pay_status
                               success:(void (^)(NSDictionary *))successMethod
                               failure:(void (^)(NSError *))errorMethod;
@end




