//
//  RegisterClient.h
//  Wallet
//
//  Created by Lcyu on 14-7-17.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterClient : NSObject

/**
 *  更换绑定的手机号
 *
 *  @param moblieNumber 发送到手机号
 */
+(void)changeMobileWithUserID:(NSString *)userid
                       moblie:(NSString *)moblieNumber
                   verifyCode:(NSString *)verifyCode
                      success:(void (^)(NSDictionary *))successMethod
                      failure:(void (^)(NSError *error)) errorMethod;
/**
 *  请求验证码
 *
 *  @param moblieNumber 发送到手机号
 */
+(void)requestVerifyCode:(NSString *)moblieNumber success:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

/**
 *  检验验证码
 *
 *  @param username   注册手机号
 *  @param verifyCode 验证码
 */
+(void)checkVerifyCode:(NSString *)username verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;
/**
 *  检验验证码-添加银行卡时使用
 *
 *  @param username   注册手机号
 *  @param verifyCode 验证码
 */
+(void)checkVerifyCodeForAddCard:(NSString *)username verifyCode:(NSString *)verifyCode success:(void (^)(NSDictionary *successData))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *  设置登陆密码
 *
 *  @param username 注册手机号
 *  @param pwd      登录密码
 */
+(void)setLoginPhoneNum:(NSString *)phone
               pwd:(NSString *)pwd
        verifyCode:(NSString *)verifyCode
          schoolId:(NSString *)schoolId
           success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/**
 *  根据已注册的电话号码来找回登录密码
 *
 *  @param phone 已注册的用户电话号码
 */
+(void)findLoginPwdWithUserPhone:(NSString *)phone  success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;


/**
 *  在找回验证码时，校验短信验证码
 *
 *  @param mobile     已经注册的电话号码
 *  @param verifyCode 发送到手机的验证码
 */
+(void)findLoginPwdWithCheckVerifyCode:(NSString *)mobile verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;
/**
 *  找回登录密码：重新设置用户的登录密码（根据新的登录密码和用户id）
 *
 *  @param loginPwd 用户输入的 登录密码
 *  @param userid   从服务器得到到 用户id  userid
 */
+(void)setNewLoginPwdWithUserPhone:(NSString *)mobile verifycode:(NSString *)verifycode password:(NSString *)password  success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;




/*
 *  忘记登录密码找回登录密码时，请求短信验证码
 *  @param moblieNumber  用户已注册的手机号码
 */

+(void)findLoginPwdWithRequestVerifyCode:(NSString *)moblieNumber success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/*
 *  获取所有学校列表
 *
 */
+(void)fetchSchoolListSuccess:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;
/*
 *  验证一卡通号和学校
 *
 */
+(void)verifySchoolID:(NSString *)schoolID studentNumber:(NSString *)stuNo success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;
@end
