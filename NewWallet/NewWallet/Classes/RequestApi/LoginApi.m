//
//  LoginApi.m
//  Wallet
//
//  Created by Lcyu on 14-7-16.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "LoginApi.h"
#import "HttpTools.h"
#define loginURL @"/app/v4/login"
#define kLoginOut @"/app/v4/logout"
#define profile @"/app/v5/profile"
#define kBindBaiDuPush @"/app/v4/bind_pushmsg"

@implementation LoginApi

static NSString *const verify_ivt_code = @"/app/invite/v1/verify_ivt_code";
static NSString *const check_ivt_code = @"/app/invite/v1/check_ivt_code";
static NSString *const query_school_biz_code = @"/external/config_center/v1/query_school_biz";

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+(void)loginWithUsernameAndPwd:(NSDictionary *)user
                       success:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *))errorMethod
{
    [[BNRealNameInfo shareInstance] clearRealNameInfo];
    
    [Tools deleteAllUploadImg];
    
    
    [tool JsonPostRequst: loginURL
              parameters:user
                 success:^(id responseObject) {
                     NSDictionary *returnData = responseObject;
                     NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
//                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshHomeActivityList object:nil];
                     }

        successMethod(responseObject);
                     
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
    
}

+(void)loginOutwithUserID:(NSString *)userID
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *))errorMethod
{
    
    [tool JsonPostRequst: kLoginOut
              parameters:@{
                           @"userid":userID
                           } success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

+(void)getProfile:(NSString *)userID
          success:(void (^)(NSDictionary *))successMethod
          failure:(void (^)(NSError *))errorMethod
{
    [tool JsonPostRequst: profile
              parameters:@{
                           @"userid":userID,
                           @"no_ykt_balance" : @"yes",//no_ykt_balance=yes则不需要返回一卡通余额，自己在账单列表实时获取,在3.0.2版本以上添加了此字段，不返回余额，接口返回速度会有很大提升。
                           }
                 success:^(id responseObject) {
                     //获取新闻列表
//                     [shareAppDelegateInstance getAndRefreshNewsData];
                     successMethod(responseObject);
                 } failure:^(NSError *error) {
                     errorMethod(error);
                 }];
    
}

//绑定百度消息推送baidu_userid和喜付userID
+(void)bindBaiDuPushWithUserID:(NSString *)userID
                  baidu_userid:(NSString *)baidu_userid
               baidu_channelid:(NSString *)baidu_channelid
                       success:(void (^)(NSDictionary *data))successMethod
                       failure:(void (^)(NSError *error))errorMethod
{
    if (!userID || !baidu_userid || !baidu_channelid) {
        successMethod(nil);
        return ;
    }
    [tool JsonPostRequst:kBindBaiDuPush
              parameters:@{
                          @"userid":userID,
                          @"baidu_userid":baidu_userid,
                          @"baidu_channelid":baidu_channelid,
                          @"device_type":@"4",    //device_type    3：Andriod设备；4：iOS设备；
                          }
                 success:^(id responseObject) {
                     successMethod(responseObject);
                 }
                 failure:^(NSError *error) {
                     errorMethod(error);
                 }];
    
}

// 检验邀请码
+ (void)verifyInvitationCodeWithIvt_code:(NSString *)ivt_code
                                 Success:(void (^)(NSDictionary *data))successMethod
                                 failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *dic = @{
                          @"ivt_code":ivt_code
                          };
    [tool JsonPostRequst:verify_ivt_code
              parameters:dic
                 success:^(id responseObject) {
                     successMethod(responseObject);
                 }
                 failure:^(NSError *error) {
                     errorMethod(error);
                 }];
}


//校验邀请码（确认新老关系）
+ (void)checkInvitationCodeWithUserId:(NSString *)user_id
                             Ivt_code:(NSString *)ivt_code
                              Success:(void (^)(NSDictionary *data))successMethod
                              failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *dic = @{
                          @"user_id":user_id,
                          @"ivt_code":ivt_code
                          };
    [tool JsonPostRequst:check_ivt_code
              parameters:dic
                 success:^(id responseObject) {
                     successMethod(responseObject);
                 }
                 failure:^(NSError *error) {
                     errorMethod(error);
                 }];
    
}

//首页九宫格数据-查询学校业务
+ (void)querySchoolBizCodeWithSuccess:(void (^)(NSDictionary *successData))successMethod
                              failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:query_school_biz_code
              parameters:nil
                 success:^(id responseObject) {
                     successMethod(responseObject);
                 }
                 failure:^(NSError *error) {
                     errorMethod(error);
                 }];
    
}
@end
