//
//  Password.m
//  Wallet
//
//  Created by Mac on 14-7-22.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#define CHECK_LOGINPWD_URL @"/app/v4/check_login_password"
#define MODIFY_LOGINPWD_URL @"/app/v4/change_login_password"
#define VERIFY_PAYPWD_URL @"/app/v4/verify_paypassword"
#define CHANGE_PAYPWD_URL @"/app/v4/change_pay_password"

#define ENABLE_NO_PASSWORD @"/app/v4/enable_no_password"
#define DISABLE_NO_PASSWORD @"/app/v4/disable_no_password"

#import "Password.h"
#import "HttpTools.h"
@implementation Password

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}


+(void)verifyLoginPwd:(NSDictionary *)useridAndPwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    
    [tool JsonPostRequst:CHECK_LOGINPWD_URL parameters:useridAndPwd success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)modifyLoginPwd:(NSDictionary *)useridAndPwd_oldNew success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    
    [tool JsonPostRequst:MODIFY_LOGINPWD_URL parameters:useridAndPwd_oldNew success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)verifyPayPwdWithUserid:(NSString *)userid pay_pwd:(NSString *)pay_pwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod{
    
    NSDictionary *parameterData = @{@"userid": userid,
                                    @"pay_password": pay_pwd};
    [tool JsonPostRequst:VERIFY_PAYPWD_URL parameters:parameterData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}


+(void)modifyPayPwdWithUserid:(NSString *)userid old_payPwd:(NSString *)old_payPwd new_payPwd:(NSString *)new_payPwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod{
    NSDictionary *parameterData = @{@"userid": userid,
                                    @"old_password": old_payPwd,
                                    @"new_password": new_payPwd};
    [tool JsonPostRequst:CHANGE_PAYPWD_URL parameters:parameterData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)enableSmallPaymentFreePwd:(NSString *)userid payPassword:(NSString *)pwd amount:(int)amount success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod{
    
    NSDictionary *parameterData = @{@"userid":userid,
                                    @"pay_password":pwd,
                                    @"amount":[NSNumber numberWithInt:amount]};
    [tool JsonPostRequst:ENABLE_NO_PASSWORD parameters:parameterData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}
+(void)disableSmallPaymentFreePwd:(NSString *)userid  success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod{
    NSDictionary *parameterData = @{@"userid":userid};
    [tool JsonPostRequst:DISABLE_NO_PASSWORD parameters:parameterData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}
@end
