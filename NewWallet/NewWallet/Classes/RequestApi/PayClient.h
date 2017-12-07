//
//  PayClient.h
//  Wallet
//
//  Created by Lcyu on 14-7-23.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayClient : NSObject
/**
 *  添加银行卡时——请求验证码
 *
 *  @param bankMobile     手机号

 */
+(void)getVerifycodeForAddCard:(NSString *)bankMobile success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *  验证卡信息
 *
 *  @param userid     用户id
 *  @param bankCardNo 银行卡号
 */
+(void)preBindCardWithUserid:(NSString *)userid bankType:(NSString *)bankType bankCardNo:(NSString *)bankCardNo is_cert:(NSString *)isCert is_credit:(NSString *)isCredit realName:(NSString *)realName certNo:(NSString*)certNo  bankMobile:(NSString *) bankMobile  cardValidate:(NSString *)cardValidate safeCode:(NSString *)safeCode success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod;

/**
 *  查询银行卡名字
 *
 *  @param userid     用户id
 *  @param bankCardNo 银行卡号
 */
+(void)fetchCardInfoWithUserID:(NSString *)userid bankCardNo:(NSString *)bankCardNo success:(void(^)(NSDictionary *data)) successMethod failure:
(void(^)(NSError *error)) errorMethod;

/**
 *  绑卡
 *
 *  @param userid       用户id
 *  @param bankCardNo   银行卡号
 *  @param bankType     银行卡类型
 *  @param realName     真实姓名
 *  @param certNo       身份证号
 *  @param certValidate 身份证有效期
 */
+(void)bindCard:(NSString *)bankId bankCardNo:(NSString *)bankCardNo is_cert:(NSString *)isCert isCredit:(NSString *)isCredit userid:(NSString *)userid payPassWord:(NSString *) payPassWord mobile:(NSString*) bankMobile  realName:(NSString *)realName  certNo:(NSString*)certNo safeCode:(NSString *)safeCode certValidate:(NSString *)certValidate verifyCode:(NSString *)verifycode success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod;

/**
 *  非首次绑卡
 *
 *  @param userid     <#userid description#>
 *  @param bankCardNo <#bankCardNo description#>
 *  @param bankType   <#bankType description#>
 *  @param mobile     <#mobile description#>
 */
//+(void)noOneBindCard:(NSString *)bankType bankCardNo:(NSString *)bankCardNo is_cert:(NSString *)isCert userid:(NSString *)userid payPassWord:(NSString *) payPassWord mobile:(NSString*) mobile certNo:(NSString*)certNo certValidate:(NSString *)certValidate  realName:(NSString *)realname  success:(void(^)(NSDictionary *data)) successMethod failure:
//(void(^)(NSError *error)) errorMethod;

//忘记支付密码
+(void)forgetPayPasswordWithUserID:(NSString *)userid
                        bankCardNo:(NSString *)bankCardNo
                           cert_no:(NSString *)cert_no
                      pay_password:(NSString *)pay_password
                           success:(void(^)(NSDictionary *data))successMethod
                           failure:(void(^)(NSError *error)) errorMethod;
@end
