//
//  CardApi.h
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardApi : NSObject
/**
 *  查询一卡通类型
 *
 *
 */
+(void)checkYKTType:(NSString *)userid
            success:(void (^)(NSDictionary *))successMethod
            failure:(void (^)(NSError *))errorMethod;

/**
 *  绑定一卡通
 *
 *
 */
+(void)bindYKT:(NSString *)userid
      ykt_type:(NSString *)ykt_type
      stuempno:(NSString *)stuempno
     studentno:(NSString *)studentno
      password:(NSString *)password
     real_name:(NSString *)real_name
       success:(void (^)(NSDictionary *))successMethod
       failure:(void (^)(NSError *))errorMethod;


/**
 *  一卡通——获取学校已充值次数
 *
 *  @param busiType  业务类型
 *
 */
+(void)oneCardGetTradeCountWithType:(NSString *)busiType
                            success:(void (^)(NSDictionary *))successMethod
                            failure:(void (^)(NSError *))errorMethod;

/**
 *  根据用户的userid 获取用户的绑定的银行卡列表
 *
 *  @param userid  用户ID ：从服务端获取
 * 
 */
+(void)CardListWithUser:(NSString *)userid success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/**
 *   根据用户的一卡通号，金额，userid，银行卡号和一卡通密码实现一卡通充值
 *
 *  @param userid        用户id
 *  @param amount        充值到金额
 *  @param stuempno      一卡通号
 *  @param ykt_password  一卡通密码
 *  @param bank_card_no  银行卡号
 */
+(void)yktRechargeWithUerid:(NSString *)userid
                     amount:(NSString *)amount
                   stuempno:(NSString *)stuempno
                   schoolid:(NSString *)schoolid
               bank_card_no:(NSString *)bank_card_no
                  bank_code:(NSString *)bank_code
               ykt_password:(NSString *)ykt_password
             is_no_password:(NSString *)is_no_password
               pay_password:(NSString *)pay_password
                noticePhone:(NSString *)noticePhone
                    success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/**
 *   根据用户的一卡通号，金额，userid和一卡通密码实现一卡通余额充值
 *
 *  @param userid        用户id
 *  @param amount        充值到金额
 *  @param stuempno      一卡通号
 *  @param ykt_password  一卡通密码
 *  @param bank_card_no  银行卡号
 */
+(void)yktRechargeUseBalanceWithUerid:(NSString *)userid
                                amount:(NSString *)amount
                              stuempno:(NSString *)stuempno
                              schoolid:(NSString *)schoolid
                          ykt_password:(NSString *)ykt_password
                          pay_password:(NSString *)pay_password
                           noticePhone:(NSString *)noticePhone
                               success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *  根据用户id、一卡通密码和一卡通号 来校验是否匹配
 *
 *  @param userid        用户id
 *  @param stuempno      一卡通号
 *  @param ykt_password  一卡通密码
 * 
 */
+(void)checkOneCardUserInfoWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolId:(NSString *)schoolID ykt_password:(NSString *)ykt_password success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;



/**
 *  根据用户id、一塌痛密码和一卡通号 来挂失一卡通
 *
 *  @param userid        用户id
 *  @param stuempno      一卡通号
 *  @param ykt_password  一卡通密码
 *
 */
+(void)oneCardReportLossWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid ykt_password:(NSString *)ykt_password success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/**
 *  根据用户id、一卡通号 查询一卡通消费流水
 *
 *  @param userid        用户id
 */
+(void)oneCardConsumes_listWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid  success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

+(void)oneCardConsumes_listWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid password:(NSString *)pwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod;

/**
 *  根据用户id、一卡通号 学校ID查询卡信息
 *
 *  @param userid        用户id
 */
+ (void)oneCardStususWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod;

/**
 *  设置缺省卡
 *
 *  @param userid      用户id
 *  @param bankNo      银行卡号
 */
+(void)setDefaultCardwithUserid:(NSString *)userid bankNo:(NSString *)bankNo success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod;

/**
 *  解绑银行卡
 *
 *  @param userid 用户id
 *  @param bankNo 银行卡号
 *  @param payPwd 支付密码
 */
+(void)unbindCardWithUserid:(NSString *)userid bankNO:(NSString *)bankNo payPwd:(NSString *)payPwd success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod;


/**
 *  根据 userid  来获取 一卡通的充值记录
 *
 *  @param userid       用户id  从服务器获取
 */
+(void)oneCardRecharges_listWithUserid:(NSString *)userid success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;



/**
 *  根据用户的id 来获取 支持的银行卡列表
 *
 *  @param userid        用户id  从服务器获取
 *  
 */
+(void)getAgreement_bank_listWithUserid:(NSString *)userid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod;



/**
 *  请求所有账单
 *
 *  @param userid        用户id
 */
+(void)checkAllConsumesListWithUserID:(NSString *)userid success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

//验证银行卡身份信息
+(void)checkBankCardWithUserId:(NSString *)userid
                    bankCardNo:(NSString *)bankCardNo
                       cert_no:(NSString *)cert_no
                       success:(void(^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *error)) errorMethod;

/**
 *  修改学号
 *
 *  @param studentNumber  新学号
 *  @param userID         用户ID
 *  @param verifyCode     输入的验证码
 *  @param successHandler 请求成功回调
 *  @param errorHandler   请求失败回调
 */
+ (void)modifyStudentNumber:(NSString *)studentNumber
                     userID:(NSString *)userID
                 verifyCode:(NSString *)verifyCode
                    success:(void(^)(NSDictionary *))successHandler
                    failure:(void (^)(NSError *error))errorHandler;



@end




