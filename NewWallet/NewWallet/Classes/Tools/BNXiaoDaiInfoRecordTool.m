//
//  BNXiaoDaiInfoRecordTool.m
//  Wallet
//
//  Created by mac on 15/5/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNXiaoDaiInfoRecordTool.h"

@implementation BNXiaoDaiInfoRecordTool

static NSString *kHasShowXiaoDaiExplain = @"kHasShowXiaoDaiExplain";
static NSString *kXiaoDaiStepNumber = @"kXiaoDaiStepNumber";
static NSString *kXiaoDaiUserName = @"kXiaoDaiUserName";
static NSString *kXiaoDaiUserGrade = @"kXiaoDaiUserGrade";
static NSString *kXiaoDaiUserEmail = @"kXiaoDaiUserEmail";

static NSString *kXiaoDaiCertificateID = @"kXiaoDaiCertificateID";
static NSString *kXiaoDaiCertificateIDOutTime = @"kXiaoDaiCertificateIDOutTime";
static NSString *kAgreeTheXiaoDaiProtocal = @"kAgreeTheXiaoDaiProtocal";

static NSString *kXiaoDaiPhotoPath_Front = @"kXiaoDaiPhotoPath_Front";
static NSString *kXiaoDaiPhotoPath_Back = @"kXiaoDaiPhotoPath_Back";
static NSString *kXiaoDaiPhotoPath_Hold = @"kXiaoDaiPhotoPath_Hold";
static NSString *kXiaoDaiVedioPath = @"kXiaoDaiVedioPath";

static NSString *kXiaoDaiPhotoPath_Front_URL = @"kXiaoDaiPhotoPath_Front_URL";
static NSString *kXiaoDaiPhotoPath_Back_URL = @"kXiaoDaiPhotoPath_Back_URL";
static NSString *kXiaoDaiPhotoPath_Hold_URL = @"kXiaoDaiPhotoPath_Hold_URL";
static NSString *kXiaoDaiVedioPath_URL = @"kXiaoDaiVedioPath_URL";

+ (NSString *)getUserIdKey
{
    return shareAppDelegateInstance.boenUserInfo.userid ? shareAppDelegateInstance.boenUserInfo.userid : @"0";
}
//清除小额贷款
+(void)clearXiaoDaiInfo
{
    NSMutableDictionary *xiaoDaiDict = [[[NSUserDefaults standardUserDefaults] valueForKey:[self getUserIdKey]] mutableCopy];
    if (!xiaoDaiDict) {
        return;
    }
    [self removePhotosAndVedioWithPath:[xiaoDaiDict valueNotNullForKey:kXiaoDaiPhotoPath_Front]];
    [self removePhotosAndVedioWithPath:[xiaoDaiDict valueNotNullForKey:kXiaoDaiPhotoPath_Back]];
    [self removePhotosAndVedioWithPath:[xiaoDaiDict valueNotNullForKey:kXiaoDaiPhotoPath_Hold]];
    [self removePhotosAndVedioWithPath:[xiaoDaiDict valueNotNullForKey:kXiaoDaiVedioPath]];

    [shareAppDelegateInstance.xiaoDaiInfoDict removeAllObjects];
    
    [xiaoDaiDict removeObjectForKey:kXiaoDaiPhotoPath_Front];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiPhotoPath_Back];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiPhotoPath_Hold];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiVedioPath];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiPhotoPath_Front_URL];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiPhotoPath_Back_URL];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiPhotoPath_Hold_URL];
    [xiaoDaiDict removeObjectForKey:kXiaoDaiVedioPath_URL];
    
    [[NSUserDefaults standardUserDefaults] setValue:xiaoDaiDict forKey:[self getUserIdKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+ (void)removePhotosAndVedioWithPath:(NSString *)path
{
    NSError *eror;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&eror];
    }
    
}
//是否已阅读小额贷款须知
+(BOOL)ifHasShowXiaoDaiExplain
{
    if ([self getUserIdKey].length <= 0) {
        return NO;
    }
    id array = [[NSUserDefaults standardUserDefaults] valueForKey:kHasShowXiaoDaiExplain];
    if ([array isKindOfClass:[NSString class]]) {
        return NO;
    }else{
        if ([array containsObject:[self getUserIdKey]]) {
            return YES;
        } else {
            return NO;
        }
    }
}
+(void)setHasShowXiaoDaiExplain
{
    id array0 = [[[NSUserDefaults standardUserDefaults] valueForKey:kHasShowXiaoDaiExplain] mutableCopy];
    if ([array0 isKindOfClass:[NSString class]] || !array0 ) {
        array0 = [@[] mutableCopy];
    }
    if (![array0 containsObject:[self getUserIdKey]]) {
        [array0 addObject:[self getUserIdKey]];
    }
    [[NSUserDefaults standardUserDefaults] setValue:array0 forKey:kHasShowXiaoDaiExplain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//实名认证步骤
+(NSInteger)getRealNameVeriryStepNumber
{
    NSString *str = [self getMethodforKey:kXiaoDaiStepNumber];
    
    NSInteger stepNumber = 0;
    if (str && str.length > 0) {
        stepNumber = [str integerValue];
    }
    return stepNumber;
}
+(void)setRealNameVeriryStepNumber:(NSInteger)stepNumber
{
    NSString *stepStr = [NSString stringWithFormat:@"%ld",(long)stepNumber];

    [self setMethodValue:stepStr forKey:kXiaoDaiStepNumber];
    
}

//实名认证信息-姓名
+(NSString *)getXiaoDaiUserName
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        return @"";
    }
    
    NSString *str = [xiaoDaiInfoDict valueNotNullForKey:kXiaoDaiUserName];
    if (!str || [str isEqualToString:@"null"]) {
        return @"";
    }
    return str;
}
+(void)setXiaoDaiUserName:(NSString *)userName
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        xiaoDaiInfoDict = [@{} mutableCopy];
    }
    [xiaoDaiInfoDict setValue:userName forKey:kXiaoDaiUserName];
    shareAppDelegateInstance.xiaoDaiInfoDict = xiaoDaiInfoDict;
}
//实名认证信息-年级
+(NSString *)getXiaoDaiUserGrade
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        return @"";
    }
    NSString *str = [xiaoDaiInfoDict valueNotNullForKey:kXiaoDaiUserGrade];
    if (!str || [str isEqualToString:@"null"]) {
        return @"";
    }
    return str;
}

+(void)setXiaoDaiUserGrade:(NSString *)grade
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        xiaoDaiInfoDict = [@{} mutableCopy];
    }
    [xiaoDaiInfoDict setValue:grade forKey:kXiaoDaiUserGrade];
    shareAppDelegateInstance.xiaoDaiInfoDict = xiaoDaiInfoDict;
}

//实名认证信息-邮箱
+(NSString *)getXiaoDaiUserEmail
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        return @"";
    }
    
    NSString *str = [xiaoDaiInfoDict valueNotNullForKey:kXiaoDaiUserEmail];
    if (!str || [str isEqualToString:@"null"]) {
        return @"";
    }
    return str;
}

+(void)setXiaoDaiUserEmail:(NSString *)email
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        xiaoDaiInfoDict = [@{} mutableCopy];
    }
    [xiaoDaiInfoDict setValue:email forKey:kXiaoDaiUserEmail];
    shareAppDelegateInstance.xiaoDaiInfoDict = xiaoDaiInfoDict;
}

//实名认证信息-身份证号
+(NSString *)getXiaoDaiCertificateID
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        return @"";
    }
    
    NSString *str = [xiaoDaiInfoDict valueNotNullForKey:kXiaoDaiCertificateID];
    if (!str || [str isEqualToString:@"null"]) {
        return @"";
    }
    return str;

}
+(void)setXiaoDaiCertificateID:(NSString *)certificateID
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        xiaoDaiInfoDict = [@{} mutableCopy];
    }
    [xiaoDaiInfoDict setValue:certificateID forKey:kXiaoDaiCertificateID];
    shareAppDelegateInstance.xiaoDaiInfoDict = xiaoDaiInfoDict;
}

//实名认证信息-身份证有效期
+(NSString *)getXiaoDaiCertificateIDOutTime;
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        return @"";
    }
    
    NSString *str = [xiaoDaiInfoDict valueNotNullForKey:kXiaoDaiCertificateIDOutTime];
    if (!str || [str isEqualToString:@"null"]) {
        return @"";
    }
    return str;

}
+(void)setXiaoDaiCertificateIDOutTime:(NSString *)outTime;
{
    NSMutableDictionary *xiaoDaiInfoDict = shareAppDelegateInstance.xiaoDaiInfoDict;
    if (!xiaoDaiInfoDict) {
        xiaoDaiInfoDict = [@{} mutableCopy];
    }
    [xiaoDaiInfoDict setValue:outTime forKey:kXiaoDaiCertificateIDOutTime];
    shareAppDelegateInstance.xiaoDaiInfoDict = xiaoDaiInfoDict;
}

//实名认证信息-是否已阅读小贷协议
+(BOOL)agreeTheXiaoDaiProtocal
{
    NSString *str = [self getMethodforKey:kAgreeTheXiaoDaiProtocal];
    if (str && [str isEqualToString:@"yes"]) {
        return YES;
    }
    return NO;
}
+(void)setHaveAgreeTheXiaoDaiProtocal
{
    [self setMethodValue:@"yes" forKey:kAgreeTheXiaoDaiProtocal];
}

//实名认证信息-照片路径—正面
+(NSString *)getXiaoDaiPhotoPath_Front
{
    NSString *str = [self getMethodforKey:kXiaoDaiPhotoPath_Front];
    return str;
}

+(void)setXiaoDaiPhotoPath_Front:(NSString *)photoPath_Front
{
    [self setMethodValue:photoPath_Front forKey:kXiaoDaiPhotoPath_Front];
}

//实名认证信息-照片路径—背面
+(NSString *)getXiaoDaiPhotoPath_Back
{
    NSString *str = [self getMethodforKey:kXiaoDaiPhotoPath_Back];
    return str;
}

+(void)setXiaoDaiPhotoPath_Back:(NSString *)photoPath_Back
{
    [self setMethodValue:photoPath_Back forKey:kXiaoDaiPhotoPath_Back];
}

//实名认证信息-照片路径—手持
+(NSString *)getXiaoDaiPhotoPath_Hold
{
    NSString *str = [self getMethodforKey:kXiaoDaiPhotoPath_Hold];
    return str;
}
+(void)setXiaoDaiPhotoPath_Hold:(NSString *)photoPath_Hold
{
    [self setMethodValue:photoPath_Hold forKey:kXiaoDaiPhotoPath_Hold];
}

//实名认证信息-视频路径
+(NSString *)getXiaoDaiVedioPath
{
    NSString *str = [self getMethodforKey:kXiaoDaiVedioPath];
    return str;
}
+(void)setXiaoDaiVedioPath:(NSString *)vedioPath
{
    [self setMethodValue:vedioPath forKey:kXiaoDaiVedioPath];
}

//*******上传成功返回的URL
//实名认证信息-照片成功返回url—正面
+(NSString *)getXiaoDaiPhotoPath_Front_URL
{
    NSString *str = [self getMethodforKey:kXiaoDaiPhotoPath_Front_URL];
    return str;
}
+(void)setXiaoDaiPhotoPath_Front_URL:(NSString *)photoPath_Front
{
    [self setMethodValue:photoPath_Front forKey:kXiaoDaiPhotoPath_Front_URL];
}

//实名认证信息-照片成功返回url—背面
+(NSString *)getXiaoDaiPhotoPath_BackURL_URL
{
    NSString *str = [self getMethodforKey:kXiaoDaiPhotoPath_Back_URL];
    return str;
}
+(void)setXiaoDaiPhotoPath_Back_URL:(NSString *)photoPath_Back
{
    [self setMethodValue:photoPath_Back forKey:kXiaoDaiPhotoPath_Back_URL];
}

//实名认证信息-照片成功返回url—手持
+(NSString *)getXiaoDaiPhotoPath_Hold_URL
{
    NSString *str = [self getMethodforKey:kXiaoDaiPhotoPath_Hold_URL];
    return str;
}
+(void)setXiaoDaiPhotoPath_Hold_URL:(NSString *)photoPath_Hold
{
    [self setMethodValue:photoPath_Hold forKey:kXiaoDaiPhotoPath_Hold_URL];
}

//实名认证信息-视频成功返回url
+(NSString *)getXiaoDaiVedioPath_URL
{
    NSString *str = [self getMethodforKey:kXiaoDaiVedioPath_URL];
    return str;
}
+(void)setXiaoDaiVedioPath_URL:(NSString *)vedioPath
{
    [self setMethodValue:vedioPath forKey:kXiaoDaiVedioPath_URL];
}

#pragma mark -  public method
+ (NSString *)getMethodforKey:(NSString *)keyStr
{
    NSMutableDictionary *xiaoDaiDict = [[[NSUserDefaults standardUserDefaults] valueForKey:[self getUserIdKey]] mutableCopy];
    if (!xiaoDaiDict) {
        return @"";
    }
    NSString *str = [xiaoDaiDict valueForKey:keyStr];
    if (str && str.length > 0) {
        return str;
    }
    return @"";
}
+ (void)setMethodValue:(NSString *)valueStr forKey:(NSString *)keyStr
{
    NSMutableDictionary *xiaoDaiDict = [[[NSUserDefaults standardUserDefaults] valueForKey:[self getUserIdKey]] mutableCopy];
    if (!xiaoDaiDict) {
        xiaoDaiDict = [@{} mutableCopy];
    }
    [xiaoDaiDict setValue:valueStr forKey:keyStr];
    
    [[NSUserDefaults standardUserDefaults] setValue:xiaoDaiDict forKey:[self getUserIdKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
