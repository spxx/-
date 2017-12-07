//
//  XiaoDaiTools.h
//  Wallet
//
//  Created by cyjjkz1 on 15/5/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoDaiTools : NSObject


//存入本地
//+ (void)saveUserInfo2SandBox:(NSString *)userName cardId:(NSString *)cardId expirsTime:(NSString *)expirsTimeStr cardFrontUrl:(NSString *)frontUrlStr cardBackgroundUrl:(NSString *)backUrlStr IDCardUrl:(NSString *)cardUrl readingStep:(NSInteger)step andUserId:(NSString *)userId;

//-------------------------------------

//姓名
+ (void)saveUserName2SandBox:(NSString *)userName userId:(NSString *)userId;
+ (NSString *)getUserNameFromSandBoxWithUserId:(NSString *)userId;

//身份证号码
+ (void)saveCardId2SandBox:(NSString *)cardId userId:(NSString *)userId;
+ (NSString *)getCardIdFromSandBoxWithUserId:(NSString *)userId;

//过期时间
+ (void)saveExpirsTime2SandBox:(NSString *)userName userId:(NSString *)userId;
+ (NSString *)getExpirsTimeFromSandBoxWithUserId:(NSString *)userId;

//正面
+ (void)savecardFrontUrl2SandBox:(NSString *)cardFrontUrl userId:(NSString *)userId;
+ (NSString *)getcardFrontUrlFromSandBoxWithUserId:(NSString *)userId;

//背面
+ (void)saveBackgroundUrl2SandBox:(NSString *)backgroundUrl userId:(NSString *)userId;
+ (NSString *)getBackgroundUrlFromSandBoxWithUserId:(NSString *)userId;

//手持身份证
+ (void)saveIDCardUrl2SandBox:(NSString *)IDCardUrl userId:(NSString *)userId;
+ (NSString *)getIDCardUrlFromSandBoxWithUserId:(NSString *)userId;

//实名认证到哪一步
+ (void)saveStep2SandBox:(NSInteger)step userId:(NSString *)userId;
+ (NSInteger)getStepFromSandBoxWithUserId:(NSString *)userId;

//判断是否是第一次申请贷款
+ (BOOL)isFirstApplyWithUserId:(NSString *)userId;
+ (void)setHasApplyedWithUserId:(NSString *)userId;

//删除信息保留实名认证步骤 是否是第一次
+ (void)removeApplyRecord:(NSString *)userId;

@end
