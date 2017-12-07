//
//  TiXianApi.m
//  Wallet
//
//  Created by cyjjkz1 on 15/6/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "TiXianApi.h"
#import "HttpTools.h"

@implementation TiXianApi


//文件上传接口
NSString *const fileUpload = @"/withdraw/app/v3/file_upload";

//实名认证申请
NSString *const tiXianRealnameCertifyApply = @"/withdraw/app/v3/realname_certify/apply";

//实名认证状态查询
NSString *const tixianRealnameCertifyQuery = @"/withdraw/app/v3/realname_certify/query";

//提现接口
NSString *const tiXian = @"/withdraw/app/v3/apply";

//收支明细查询
NSString *const qureyTiXian = @"/withdraw/app/v3/wallet_balance/query";



//修改手机号_通过身份验证
NSString *const modifyPswVerifyCertInfo = @"/withdraw/app/v3/verify_cert_info";

static  HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}
//文件上传接口
+ (void)fileUpLoadWithService:(NSString *)service
                     fileName:(NSString *)fileName
                     fileType:(NSString *)fileType
                       upFile:(NSString *)up_file
                      success:(void(^)(NSDictionary *returnData))successMethod
                      failure:(void(^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"service":service,
                                   @"file_name":fileName,
                                   @"file_type":fileType,
                                   @"up_file":up_file
                                   };
    [tool JsonPostRequst:fileUpload parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//实名认证申请
+ (void)realnameCertifyApplyWithRealName:(NSString *)realName
                                certType:(NSString *)cetType
                              certNumber:(NSString *)certNumber
                           certValidTime:(NSString *)time
                            cerFrontPath:(NSString *)frontPath
                            certBackPath:(NSString *)backPath
                              occupation:(NSString *)occupation
                                  mobile:(NSString *)mobile
                                 address:(NSString *)address
                             attribution:(NSString *)attribution
                                 success:(void(^)(NSDictionary *returnData))successMethod
                                 failure:(void(^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{@"real_name":realName,
                                   @"cert_no":certNumber,
                                   @"cert_valid_time":time,
                                   @"cert_front_path":frontPath,
                                   @"cert_back_path":backPath,
                                   };
    [tool JsonPostRequst:tiXianRealnameCertifyApply parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//实名认证状态查询
+ (void)realnameCertifyQuerySuccess:(void (^)(NSDictionary *returnData))successMethod
                            failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:tixianRealnameCertifyQuery parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

// 提现接口(暂时没有要验证码)
+ (void)tiXianWithCardNumber:(NSString *)cardNumber
                 applyAmount:(NSString *)amount
                 payPassword:(NSString *)psw
                  VerifyCode:(NSString *)code
                     success:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"card_no":cardNumber,
                                   @"apply_amount":amount,
                                   @"pay_passwd":psw
                                   };
    [tool JsonPostRequst:tiXian parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//收支明细查询
+ (void)tixianQueryWithOrderNumber:(NSString *)orderNumber
                           Success:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                //  @"order_no":orderNumber
                                   };
    [tool JsonPostRequst:qureyTiXian parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}







//修改手机号_通过身份验证
+ (void)modifyPswVerifyCertInfoWIthRealName:(NSString *)real_name
                                   stuempno:(NSString *)stuempno
                                     certNo:(NSString *)cert_no
                                    Success:(void (^)(NSDictionary *returnData))successMethod
                                    failure:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"real_name":real_name,
                                   @"stuempno":stuempno,
                                   @"cert_no":cert_no,
                                   };
    [tool JsonPostRequst:modifyPswVerifyCertInfo parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}



@end
