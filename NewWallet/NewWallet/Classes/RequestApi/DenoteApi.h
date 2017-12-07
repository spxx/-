//
//  DenoteApi.h
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DenoteApi : NSObject
/**
 *   爱心捐助-充值
 *
 *  @param userid        用户id
 *  @param amount        充值到金额
 *  @param project_id    捐赠项目id
 *  @param pay_password  支付密码
 *  @param bank_card_no  银行卡号 
 *  @param bank_code     银行卡类型
 */
+(void)denotePayWithUerid:(NSString *)userid
                   amount:(NSString *)amount
               project_id:(NSString *)project_id
             bank_card_no:(NSString *)bank_card_no
                bank_code:(NSString *)bank_code
           is_no_password:(NSString *)is_no_password
             pay_password:(NSString *)pay_password
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *error)) errorMethod;

/**
 *  爱心捐助-余额充值
 *
 *  @param userid        用户id
 *  @param amount        充值到金额
 *  @param project_id    捐赠项目id
 *  @param pay_password  支付密码
 *  @param bank_card_no  银行卡号
 *  @param bank_code     银行卡类型
 */
+(void)denoteBalancePayWithUerid:(NSString *)userid
                          amount:(NSString *)amount
                      project_id:(NSString *)project_id
                  is_no_password:(NSString *)is_no_password
                    pay_password:(NSString *)pay_password
                         success:(void (^)(NSDictionary *))successMethod
                         failure:(void (^)(NSError *error)) errorMethod;

/**
 *  获取具体捐赠信息web view接口
 *
 *  @param project_id    捐赠项目id
 */
+(void)denoteWebViewInfoWithProjectid:(NSString *)project_id
                              success:(void (^)(NSDictionary *))successMethod
                              failure:(void (^)(NSError *error)) errorMethod;

/**
 *  单个捐赠项目概况
 *
 *  @param project_id    捐赠项目id
 */
+(void)denoteProjectInfoWithProjectid:(NSString *)project_id
                              success:(void (^)(NSDictionary *))successMethod
                              failure:(void (^)(NSError *error)) errorMethod;

/**
 *  获取图片焦点
 *
 *  @param school_id    学校id
 */
+(void)denoteFocusWithSchoolid:(NSString *)school_id
                       success:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *error)) errorMethod;

/**
 *  查询学校捐赠项目
 *
 *  @param school_id    学校id
 */
+(void)denoteProjectListsWithSchoolid:(NSString *)school_id
                              success:(void (^)(NSDictionary *))successMethod
                              failure:(void (^)(NSError *error)) errorMethod;


@end




