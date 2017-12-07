//
//  TiXianApi.h
//  Wallet
//
//  Created by cyjjkz1 on 15/6/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiXianApi : NSObject
/**
 *
 *文件上传接口(service  要用到该文件的服务. file_name 该文件的字段名. file_type  拓展名. up_file 文件内容.)
 *
 **/
+ (void)fileUpLoadWithService:(NSString *)service
                     fileName:(NSString *)fileName
                     fileType:(NSString *)fileType
                       upFile:(NSString *)up_file
                      success:(void(^)(NSDictionary *returnData))successMethod
                      failure:(void(^)(NSError *error))errorMethod;



/**
 *
 *实名认证申请接口(5要素)
 *
 **/
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
                                 failure:(void(^)(NSError *error))errorMethod;

/**
 *
 *实名认证状态查询接口
 *
 **/
+ (void)realnameCertifyQuerySuccess:(void (^)(NSDictionary *returnData))successMethod
                            failure:(void (^)(NSError *error))errorMethod;

/**
 *
 *提现接口
 *
 **/
+ (void)tiXianWithCardNumber:(NSString *)cardNumber
                 applyAmount:(NSString *)amount
                 payPassword:(NSString *)psw
                  VerifyCode:(NSString *)code
                     success:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error))errorMethod;
/**
 *
 *收支明细查询接口
 *
 **/
+ (void)tixianQueryWithOrderNumber:(NSString *)orderNumber
                           Success:(void (^)(NSDictionary *returnData))successMethod
                           failure:(void (^)(NSError *error))errorMethod;













//**************************************************************************************


//**************************************************************************************


//修改手机号_通过身份验证
+ (void)modifyPswVerifyCertInfoWIthRealName:(NSString *)real_name
                                   stuempno:(NSString *)stuempno
                                     certNo:(NSString *)cert_no
                                    Success:(void (^)(NSDictionary *returnData))successMethod
                                    failure:(void (^)(NSError *error))errorMethod;

@end
