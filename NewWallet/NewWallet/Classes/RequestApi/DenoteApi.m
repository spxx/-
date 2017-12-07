//
//  DenoteApi.m
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "DenoteApi.h"
#import "HttpTools.h"

#define  Denote_BaseUrl @""
#define  Denote_Pay_URL [Denote_BaseUrl stringByAppendingString:@"/app/denote/v1/denote_pay"]  //捐赠支付
#define  Denote_Pay_Balance_URL [Denote_BaseUrl stringByAppendingString:@"/app/denote/v1/denote_pay_balance"]  //余额捐赠支付
#define  Denote_Prj_WebViewInfo_URL [Denote_BaseUrl stringByAppendingString:@"/app/denote/v1/denote_prj_info"] //获取具体捐赠信息web view接口
#define  Denote_Prj_amt_URL [Denote_BaseUrl stringByAppendingString:@"/app/denote/v1/denote_prj_amt"]          //单个捐赠项目概况
#define  Denote_Focus_URL [Denote_BaseUrl stringByAppendingString:@"/app/denote/v1/denote_focus"]              //获取图片焦点
#define  Denote_ProjectList_URL [Denote_BaseUrl stringByAppendingString:@"/app/denote/v1/denote_projects"]     //查询学校捐赠项目

@implementation DenoteApi

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+(void)denotePayWithUerid:(NSString *)userid
                   amount:(NSString *)amount
               project_id:(NSString *)project_id
             bank_card_no:(NSString *)bank_card_no
                bank_code:(NSString *)bank_code
           is_no_password:(NSString *)is_no_password
             pay_password:(NSString *)pay_password
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData;
    if (pay_password) {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"project_id": project_id,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password
                       };
    }else {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"project_id": project_id,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"is_no_password":@"yes",
                       };
    }
    [tool JsonPostRequst:Denote_Pay_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)denoteBalancePayWithUerid:(NSString *)userid
                          amount:(NSString *)amount
                      project_id:(NSString *)project_id
                  is_no_password:(NSString *)is_no_password
                    pay_password:(NSString *)pay_password
                         success:(void (^)(NSDictionary *))successMethod
                         failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData;
    if (pay_password) {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"project_id": project_id,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password
                       };
    }else {
        requstData = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"project_id": project_id,
                       @"is_no_password":@"yes",
                       };
    }
    [tool JsonPostRequst:Denote_Pay_Balance_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)denoteWebViewInfoWithProjectid:(NSString *)project_id
                              success:(void (^)(NSDictionary *))successMethod
                              failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"prj_id": project_id,
                                 };
    [tool JsonPostRequst:Denote_Prj_WebViewInfo_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)denoteProjectInfoWithProjectid:(NSString *)project_id
                              success:(void (^)(NSDictionary *))successMethod
                              failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"prj_id": project_id,
                                 };
    [tool JsonPostRequst:Denote_Prj_amt_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)denoteFocusWithSchoolid:(NSString *)school_id
                       success:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"school_id": school_id,
                                 };
    [tool JsonPostRequst:Denote_Focus_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)denoteProjectListsWithSchoolid:(NSString *)school_id
                              success:(void (^)(NSDictionary *))successMethod
                              failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"school_id": school_id,
                                 };
    [tool JsonPostRequst:Denote_ProjectList_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
@end
