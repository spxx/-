//
//  LoginApi.h
//  Wallet
//
//  Created by Lcyu on 14-7-16.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginApi : NSObject

/**
 *  通过用户名（手机号）和密码登陆
 *
 *  @param user  key:username  pwd
 *
 *  @return 是否登陆成功
 */
+(void)loginWithUsernameAndPwd:(NSDictionary *)user
                       success:(void (^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *error)) errorMethod;

/**
 *  登出
 *
 *  @param userID        用户id
 *
 */
+(void)loginOutwithUserID:(NSString *)userID
                  success:(void (^)(NSDictionary * data))successMethod
                  failure:(void (^)(NSError *error)) errorMethod;

/**
 *  获取用户信息
 *
 *  @param userID        用户id
 */
+(void)getProfile:(NSString *)userID
        success:(void (^)(NSDictionary *data))successMetho
          failure:(void (^)(NSError *error)) errorMethod;

/**
 *  绑定百度消息推送baidu_userid和喜付userID
 *
 *  @param userID            喜付userID
 *  @param baidu_userid      百度userID
 *  @param baidu_channelid   百度channeli
 *  @param device_type       设备类型
 */
+(void)bindBaiDuPushWithUserID:(NSString *)userID
                  baidu_userid:(NSString *)baidu_userid
               baidu_channelid:(NSString *)baidu_channelid
                       success:(void (^)(NSDictionary *data))successMethod
                       failure:(void (^)(NSError *error))errorMethod;


/**
 *   检验邀请码
 *
 *  @param ivt_code      邀请码
 */
+ (void)verifyInvitationCodeWithIvt_code:(NSString *)ivt_code
                                 Success:(void (^)(NSDictionary *data))successMethod
                                failure:(void (^)(NSError *error)) errorMethod;

/**
 *  校验邀请码（确认新老关系）
 *
 *  @param user_id       userID
 *  @param ivt_code      邀请码
 */
+ (void)checkInvitationCodeWithUserId:(NSString *)user_id
                             Ivt_code:(NSString *)ivt_code
                                 Success:(void (^)(NSDictionary *data))successMethod
                                 failure:(void (^)(NSError *error)) errorMethod;


//首页九宫格数据-查询学校业务
+ (void)querySchoolBizCodeWithSuccess:(void (^)(NSDictionary *successData))successMethod
                              failure:(void (^)(NSError *error)) errorMethod;


@end
