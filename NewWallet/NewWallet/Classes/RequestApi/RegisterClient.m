//
//  RegisterClient.m
//  Wallet
//
//  Created by Lcyu on 14-7-17.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "RegisterClient.h"
#import "HttpTools.h"

//#define LOGIN_BASE_URL @"http://192.168.1.113:9090"

#define LOGIN_PWD @"/app/v4/login_password"


#define LOGIN_PWD_SIMPLE @"/app/v4/login_password_simple"

#define VERIFY_CODE @"/app/v4/verifycode"
#define CHECK_VC @"/app/v4/check_verifycode"
#define CHECK_AddCard_VC @"/app/v4/check_verifycode_bank_mobile"

#define FindLoginPwd_URL  @"/app/v4/verifycode_forget"
#define Check_Verifycode_Forget @"/app/v4/check_verifycode_forget"
#define Login_Password_Forget  @"/app/v4/login_password_forget"
#define VERIFY_CODE_FORGET @"/app/v4/verifycode_forget"

#define FETCH_SCHOOL_LIST @"/app/v6/bac/school_list"
///app/v4/school_list 喜付获取学校列表


#define VERIFY_SUTNO_AND_SCID @"/app/v4/check_stuempno"


////////////////////////////

#define CHANGE_MOBILE @"/app/v4/change_mobile"

@implementation RegisterClient

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}


+(void)changeMobileWithUserID:(NSString *)userid
                    moblie:(NSString *)moblieNumber
                    verifyCode:(NSString *)verifyCode
                 success:(void (^)(NSDictionary *))successMethod
                      failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{@"userid": userid,
                                 @"mobile": moblieNumber,
                                 @"verifycode": verifyCode
                                 };
    [tool JsonPostRequst:CHANGE_MOBILE parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


+(void)requestVerifyCode:(NSString *)moblieNumber success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": moblieNumber
                                };
    [tool JsonPostRequst:VERIFY_CODE parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)checkVerifyCode:(NSString *)username verifyCode:(NSString *)verifyCode success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": username,
                                 @"verifycode": verifyCode
                                };
    [tool JsonPostRequst:CHECK_VC parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)checkVerifyCodeForAddCard:(NSString *)username verifyCode:(NSString *)verifyCode success:(void (^)(NSDictionary *successData))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": username,
                                 @"verifycode": verifyCode
                                 };
    [tool JsonPostRequst:CHECK_AddCard_VC parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
/******
    ***
    ***注册接口修改V3.0
    ***
 ******/
+(void)setLoginPhoneNum:(NSString *)mobile
                   pwd:(NSString *)pwd
            verifyCode:(NSString *)verifyCode
              schoolId:(NSString *)schoolId
               success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{@"mobile":mobile,
                                 @"verifycode":verifyCode,
                                 @"school_id":schoolId,
                                 @"password":pwd
                                 };
    [tool JsonPostRequst:LOGIN_PWD_SIMPLE parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)findLoginPwdWithUserPhone:(NSString *)phone  success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod{
    NSDictionary *requstData = @{
                                  @"mobile": phone
                                 };
    [tool JsonPostRequst:FindLoginPwd_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


+(void)findLoginPwdWithCheckVerifyCode:(NSString *)mobile verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod{
    NSDictionary *requstData = @{
                                 @"mobile": mobile,
                                 @"verifycode": verifyCode
                                 };
    [tool JsonPostRequst:Check_Verifycode_Forget parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)setNewLoginPwdWithUserPhone:(NSString *)mobile verifycode:(NSString *)verifycode password:(NSString *)password  success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod{
    NSDictionary *requstData = @{
                                 @"mobile": mobile,
                                 @"verifycode":verifycode,
                                 @"password": password
                                 };
    [tool JsonPostRequst:Login_Password_Forget parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}



+(void)findLoginPwdWithRequestVerifyCode:(NSString *)moblieNumber success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": moblieNumber
                                 };
    [tool JsonPostRequst:VERIFY_CODE_FORGET parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)fetchSchoolListSuccess:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{

    [tool JsonPostRequst:FETCH_SCHOOL_LIST parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


+(void)verifySchoolID:(NSString *)schoolID studentNumber:(NSString *)stuNo success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{@"stuempno":stuNo,
                                 @"school_id": schoolID
                                 };
    [tool JsonPostRequst:VERIFY_SUTNO_AND_SCID parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
