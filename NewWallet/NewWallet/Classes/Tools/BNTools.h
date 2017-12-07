//
//  BNTools.h
//  Wallet
//
//  Created by mac on 15-1-5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNTools : NSObject

+ (CGFloat)sizeFit:(CGFloat)size six:(CGFloat)six sixPlus:(CGFloat)sixPlus;

+ (CGFloat)sizeFitfour:(CGFloat)four five:(CGFloat)five six:(CGFloat)six sixPlus:(CGFloat)sixPlus;

//更新BNUserInfo
+ (void)setProfileUserInfo:(NSDictionary *)successData;

//上次登录用户的Cookie
+ (void)saveLoginCookies;
+ (void)removeLoginCookies;
+ (void)setLastLoginCookies;

//上次的启动广告id
+(void)saveLaunchADid:(NSString *)ADid;
+ (NSString *)getLastLaunchADid;

//上次的主页浮层广告id
+(void)saveHomeWindowADid:(NSString *)ADid;
+ (NSString *)getLastHomeWindowADid;


/**
 * 转成 Json 字符串
 */
+ (NSString *)dataJsonWithDic:(id)paramObj;


#pragma mark - 时间相关

/**
 *  计算年月日
 *
 *  @param date 计算的日期
 *
 *  @return 日期组成
 */
+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;
+ (NSDateComponents *)dateComponentsFromDateString:(NSString *)dateString;


/**
 *url 中文 escape编码
 */
+(NSString *)escape:(NSString *)str;



@end
