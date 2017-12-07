//
//  Password.h
//  Wallet
//
//  Created by Mac on 14-7-22.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Password : NSObject



/**
 *  在用户的登录状态，验证用户的登录密码是否正确
 *
 *  @param useridAndPwd  key:usreid  用户的密码key:password
 *
 */


+(void)verifyLoginPwd:(NSDictionary *)useridAndPwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;



/**
 *  在用户的登录状态，修改用户的登录密码
 *
 *  @param useridAndPwd_oldNew key:userid old_password new_password
 *
 */

+(void)modifyLoginPwd:(NSDictionary *)useridAndPwd_oldNew success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;


/**
 *  根据用户的id(userid)校验用户的支付密码是否正确
 *
 *  @param userid        从服务器端获取的userid
 *  @param pay_pwd       用户输入的 支付密码
 */

+(void)verifyPayPwdWithUserid:(NSString *)userid pay_pwd:(NSString *)pay_pwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *  根据用户的 userid  旧的支付密码 新的支付密码 来修改用户的 支付密码
 *
 *  @param userid        从服务器端获取的 用户id  userid
 *  @param old_payPwd    用户旧的支付密码
 *  @param new_payPed    用户输入的新的支付密码
 */

+(void)modifyPayPwdWithUserid:(NSString *)userid old_payPwd:(NSString *)old_payPwd new_payPwd:(NSString *)new_payPwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/**
 *  根据用户的 userid 和支付密码设置小额免密
 *
 *  @param userid        从服务器端获取的 用户id  userid
 *  @param old_payPwd    支付密码
 *  @param amount    小额免密金额
 */

+(void)enableSmallPaymentFreePwd:(NSString *)userid payPassword:(NSString *)pwd amount:(int)amount success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;

/**
 *  根据用户的 userid 取消小额免密
 *
 *  @param userid        从服务器端获取的 用户id  userid
 *  @param old_payPwd    支付密码
 *  @param amount        小额免密金额
 */
+(void)disableSmallPaymentFreePwd:(NSString *)userid  success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod;


@end
