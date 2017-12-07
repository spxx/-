//
//  MobileRechargeApi.h
//  Wallet
//
//  Created by Mac on 14-12-31.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileRechargeApi : NSObject
/**
 *   手机充值-银行卡充值
 *
 *  @param userid        用户id
 *  @param amount        充值到金额
 *  @param sale_amount   售价
 *  @param mobile        手机号
 *  @param pay_password  支付密码
 *  @param bank_card_no  银行卡号 
 *  @param bank_code     银行卡类型
 */
+(void)mobileBankCardPayWithUerid:(NSString *)userid
                           mobile:(NSString *)mobile
                           amount:(NSString *)amount
                     bank_card_no:(NSString *)bank_card_no
                        bank_code:(NSString *)bank_code
                   is_no_password:(NSString *)is_no_password
                     pay_password:(NSString *)pay_password
                      sale_amount:(NSString *)sale_amount
                      bndk_amount:(NSString *)bndk_amount
                        sp_amount:(NSString *)sp_amount
                              pid:(NSString *)pid
                          success:(void (^)(NSDictionary *))successMethod
                          failure:(void (^)(NSError *error)) errorMethod;

/**
 *  手机充值-余额充值
 *
 *  @param userid        用户id
 *  @param mobile        手机号
 *  @param amount        充值金额
 *  @param pay_password  支付密码
 *  @param bank_card_no  银行卡号
 *  @param bank_code     银行卡类型
 */
+(void)mobileBalancePayWithUerid:(NSString *)userid
                          mobile:(NSString *)mobile
                          amount:(NSString *)amount
                  is_no_password:(NSString *)is_no_password
                    pay_password:(NSString *)pay_password
                     sale_amount:(NSString *)sale_amount
                     bndk_amount:(NSString *)bndk_amount
                       sp_amount:(NSString *)sp_amount
                             pid:(NSString *)pid
                         success:(void (^)(NSDictionary *))successMethod
                         failure:(void (^)(NSError *error)) errorMethod;

/**
 *  获取充值金额列表
 */
+(void)amountListSuccess:(void (^)(NSDictionary *))successMethod
                 failure:(void (^)(NSError *error)) errorMethod;

/**
 *  获取充值的售价
 *
 *  @param mobile    手机号
 *  @param amount    充值金额
 */
+(void)getSalePriceWithMobile:(NSString *)mobile
                       amount:(NSString *)amount
                      success:(void (^)(NSDictionary *))successMethod
                      failure:(void (^)(NSError *error)) errorMethod;

/**
 *  验证机主姓名
 *
 *  @param mobile    手机号
 */
+(void)getNameWithMobile:(NSString *)mobile
                 success:(void (^)(NSDictionary *))successMethod
                 failure:(void (^)(NSError *error)) errorMethod;
/**
 *  充值记录列表
 */
+(void)rechargeRecordListSuccess:(void (^)(NSDictionary *))successMethod
                         failure:(void (^)(NSError *error)) errorMethod;
/**
 *  获取所有话费充值项目
 *
 *  @param successBlock
 *  @param failureBlock
 */
+ (void)getAllRechargeItems:(void (^)(NSDictionary *))successBlock
                    failure:(void (^)(NSError *error)) failureBlock;
/**
 *  获取所有流量充值项目
 *
 *  @param successBlock
 *  @param failureBlock
 */
+ (void)getAllRechargeFlowItems:(void (^)(NSDictionary *))successBlock
                        failure:(void (^)(NSError *error)) failureBlock;

/**
 *  使用银行卡支付流量订单
 *
 *  @param productid      商品ID
 *  @param mobile         充值手机号码
 *  @param amount         充值金额
 *  @param bank_card_no   银行卡号
 *  @param bank_code      银行代码
 *  @param is_no_password 是否无密支付
 *  @param pay_password   支付密码
 *  @param successMethod  成功回调
 *  @param errorMethod    失败回调
 */
+ (void)mobileFlowBankCardPayWithProductID:(NSString *)productid
                                    mobile:(NSString *)mobile
                                    amount:(NSString *)amount
                              bank_card_no:(NSString *)bank_card_no
                                 bank_code:(NSString *)bank_code
                            is_no_password:(NSString *)is_no_password
                              pay_password:(NSString *)pay_password
                                   success:(void (^)(NSDictionary *))successMethod
                                   failure:(void (^)(NSError *error)) errorMethod;

/**
 *  喜付余额支付流量订单
 *
 *  @param productid      商品ID
 *  @param mobile         充值手机号码
 *  @param amount         充值金额
 *  @param is_no_password 是否无密支付
 *  @param pay_password   支付密码
 *  @param successMethod  成功回调
 *  @param errorMethod    失败回调
 */
+ (void)mobileFlowBalancePayWithProductID:(NSString *)productid
                                   mobile:(NSString *)mobile
                                   amount:(NSString *)amount
                           is_no_password:(NSString *)is_no_password
                             pay_password:(NSString *)pay_password
                                  success:(void (^)(NSDictionary *))successMethod
                                  failure:(void (^)(NSError *error)) errorMethod;

/**
 *  创建话费充值订单
 *
 *  @param productID   商品ID
 *  @param phoneNumber 充值手机号
 *  @param amount      充值金额
 *  @param saleAmount  喜付销售价
 *  @param spAmount    商品金额
 *  @param bndkAmount  商品定价
 */
+ (void)mobileCreateOrder:(NSString *)productID
              phoneNumber:(NSString *)phoneNumber
                   amount:(NSString *)amount
               saleAmount:(NSString *)saleAmount
                 spAmount:(NSString *)spAmount
               bndkAmount:(NSString *)bndkAmount
                  success:(void (^)(NSDictionary *))successBlock
                  failure:(void (^)(NSError *error))errorBlock;

/**
 *  创建流量充值订单
 *
 *  @param productID   商品ID
 *  @param phoneNumber 充值手机号
 *  @param amount      喜付销售价
 */
+ (void)mobileFlowCreateOrder:(NSString *)productID
                  phoneNumber:(NSString *)phoneNumber
                       amount:(NSString *)amount
                      success:(void (^)(NSDictionary *))successBlock
                      failure:(void (^)(NSError *error))errorBlock;

@end




