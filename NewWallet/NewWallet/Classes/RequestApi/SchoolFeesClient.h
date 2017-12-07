//
//  SchoolFeesClient.h
//  Wallet
//
//  Created by mac1 on 15/3/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SchoolFeesClient : NSObject


/***
   *
   *请求缴费项目列表
   *
 ***/
+ (void)checkFeesPrijectListWithUserid:(NSString *)userid
                               success:(void (^)(NSDictionary *returnData))successMethod
                               failure:(void (^)(NSError *error)) errorMethod;



/***
 *
 *银行卡支付支付接口
 *
 ***/

+ (void)paySchoolFeesWithUserid:(NSString *)userid
                        prj_key:(NSString *)prj_key
                      bank_code:(NSString *)bank_code
                   bank_card_no:(NSString *)bank_card_no
                         amount:(NSString *)amount
                   pay_password:(NSString *)pay_password
              is_no_paypassword:(NSString *)is_no_paypassword
                        success:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error)) errorMethod;


/***
 *
 *余额支付接口
 *
 ***/
+ (void)paySchoolFeesUseBalanceWithUserid:(NSString *)userid
                                  prj_key:(NSString *)prj_key
                                   amount:(NSString *)amount
                             pay_password:(NSString *)pay_password
                        is_no_paypassword:(NSString *)is_no_paypassword
                                  success:(void (^)(NSDictionary *returnData))successMethod
                                  failure:(void (^)(NSError *error)) errorMethod;

@end
