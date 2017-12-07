//
//  BaiDuPushTool.m
//  Wallet
//
//  Created by mac on 15/3/12.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BaiDuPushTool.h"
#import "LoginApi.h"

@implementation BaiDuPushTool
#define kBaiDuPush_Info         @"kBaiDuPush_Info"
#define kBaiDuPush_Appid        @"kBaiDuPush_Appid"
#define kBaiDuPush_BaiduUserid       @"kBaiDuPush_BaiduUserid"
#define kBaiDuPush_Channelid    @"kBaiDuPush_Channelid"

+(void)saveAppid:(NSString *)appid
     baiduUserid:(NSString *)baiduUserid
       channelid:(NSString *)channelid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *result = [userDefaults objectForKey:kBaiDuPush_Info];

    if (!result || [result allKeys].count <= 0) {
        result = [@{} mutableCopy];
        [result setObject:appid forKey:kBaiDuPush_Appid];
        [result setObject:baiduUserid forKey:kBaiDuPush_BaiduUserid];
        [result setObject:channelid forKey:kBaiDuPush_Channelid];
    }
    
    [userDefaults setObject:result forKey:kBaiDuPush_Info];
    [userDefaults synchronize];
    
    
}

+ (NSDictionary *)getBaiDuPushInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *result = [userDefaults objectForKey:kBaiDuPush_Info];
    return result;
}

+ (void)updateUserId:(NSString *)userId
         baiduUserid:(NSString *)baiduUserid
           channelid:(NSString *)channelid
            schoolId:(NSString *)schoolId
             success:(void (^)(NSDictionary *data))successMethod
             failure:(void (^)(NSError *error))errorMethod
{
    
    [LoginApi bindBaiDuPushWithUserID:userId
                         baidu_userid:baiduUserid
                      baidu_channelid:channelid
                              success:^(NSDictionary *data) {
                                  successMethod(data);
 
   
                              } failure:^(NSError *error) {
                                  errorMethod(error);
                              }];
}


@end
