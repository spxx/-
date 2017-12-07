//
//  XiaoDaiTools.m
//  Wallet
//
//  Created by cyjjkz1 on 15/5/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "XiaoDaiTools.h"

@implementation XiaoDaiTools

NSString *const hasApply = @"hasApply";


//+ (void)saveUserInfo2SandBox:(NSString *)userName cardId:(NSString *)cardId expirsTime:(NSString *)expirsTimeStr cardFrontUrl:(NSString *)frontUrlStr cardBackgroundUrl:(NSString *)backUrlStr IDCardUrl:(NSString *)cardUrl readingStep:(NSInteger)step andUserId:(NSString *)userId
//{
////    if (userName) {
////        
////    }
//    NSDictionary *dic = @{
//                          @"name":userName,
//                          @"cardId":cardId,
//                          @"expirsTime":expirsTimeStr,
//                          @"frontUrlStr":frontUrlStr,
//                          @"backUrlStr":backUrlStr,
//                          @"cardUrl":cardUrl,
//                          @"step":[NSNumber numberWithInteger:step],
//                          };
//    [kUserDefaluts setObject:dic forKey:userId];
//    [kUserDefaluts synchronize];
//}
//------------------------------------------------------------------------------

//姓名
+ (void)saveUserName2SandBox:(NSString *)userName userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:userName forKey:@"userName"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:userName forKey:@"userName"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }
}
+ (NSString *)getUserNameFromSandBoxWithUserId:(NSString *)userId
{
   return [kUserDefaluts objectForKey:userId][@"userName"];
}
//身份证号码
+ (void)saveCardId2SandBox:(NSString *)cardId userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:cardId forKey:@"cardId"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:cardId forKey:@"cardId"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }
}
+ (NSString *)getCardIdFromSandBoxWithUserId:(NSString *)userId
{
    return [kUserDefaluts objectForKey:userId][@"cardId"];
}

//过期时间
+ (void)saveExpirsTime2SandBox:(NSString *)time userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:time forKey:@"time"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:time forKey:@"time"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }

}
+ (NSString *)getExpirsTimeFromSandBoxWithUserId:(NSString *)userId
{
    return [kUserDefaluts objectForKey:userId][@"time"];
}

//正面
+ (void)savecardFrontUrl2SandBox:(NSString *)cardFrontUrl userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:cardFrontUrl forKey:@"cardFrontUrl"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:cardFrontUrl forKey:@"cardFrontUrl"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }
}
+ (NSString *)getcardFrontUrlFromSandBoxWithUserId:(NSString *)userId
{
    return [kUserDefaluts objectForKey:userId][@"cardFrontUrl"];
}
//背面
+ (void)saveBackgroundUrl2SandBox:(NSString *)backgroundUrl userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:backgroundUrl forKey:@"backgroundUrl"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:backgroundUrl forKey:@"backgroundUrl"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }
}
+ (NSString *)getBackgroundUrlFromSandBoxWithUserId:(NSString *)userId
{
    return [kUserDefaluts objectForKey:userId][@"backgroundUrl"];
}

//手持身份证
+ (void)saveIDCardUrl2SandBox:(NSString *)IDCardUrl userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:IDCardUrl forKey:@"IDCardUrl"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:IDCardUrl forKey:@"IDCardUrl"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }
}
+ (NSString *)getIDCardUrlFromSandBoxWithUserId:(NSString *)userId
{
    return [kUserDefaluts objectForKey:userId][@"IDCardUrl"];
}

//实名认证到哪一步
+ (void)saveStep2SandBox:(NSInteger)step userId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:[NSNumber numberWithInteger:step] forKey:@"step"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:[NSNumber numberWithInteger:step] forKey:@"step"];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }

}
+ (NSInteger)getStepFromSandBoxWithUserId:(NSString *)userId
{
    return [[kUserDefaluts objectForKey:userId][@"step"] integerValue];
}

//判断是否是第一次
+ (BOOL)isFirstApplyWithUserId:(NSString *)userId
{
    if ([kUserDefaluts objectForKey:userId][hasApply]) {
        return NO;//不是第一次申请
    }
    return YES;
}
+ (void)setHasApplyedWithUserId:(NSString *)userId
{
    NSMutableDictionary *userInfoDic = [kUserDefaluts objectForKey:userId];
    if (userInfoDic)
    {
        [userInfoDic setObject:hasApply forKey:hasApply];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }else{
        userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:hasApply forKey:hasApply];
        [kUserDefaluts setObject:userInfoDic forKey:userId];
        [kUserDefaluts synchronize];
    }
}

//删除个人信息
+ (void)removeApplyRecord:(NSString *)userId
{
    NSMutableDictionary *dic = [kUserDefaluts objectForKey:userId];
    [dic removeObjectsForKeys:@[@"userName",@"cardId",@"time",@"cardFrontUrl",@"backgroundUrl",@"IDCardUrl"]];
    [kUserDefaluts setObject:dic forKey:userId];
    [kUserDefaluts synchronize];
}

@end
