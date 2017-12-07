//
//  BaiDuPushTool.h
//  Wallet
//
//  Created by mac on 15/3/12.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiDuPushTool : NSObject

//本地保存百度推送返回的配置信息。
+ (void)saveAppid:(NSString *)appid
      baiduUserid:(NSString *)baiduUserid
        channelid:(NSString *)channelid;


//获取保存的百度推送配置信息。
+ (NSDictionary *)getBaiDuPushInfo;


//更新喜付账户绑定的百度推送信息。
+ (void)updateUserId:(NSString *)userId
         baiduUserid:(NSString *)baiduUserid
           channelid:(NSString *)channelid
            schoolId:(NSString *)schoolId
             success:(void (^)(NSDictionary *data))successMethod
             failure:(void (^)(NSError *error))errorMethod;

@end
