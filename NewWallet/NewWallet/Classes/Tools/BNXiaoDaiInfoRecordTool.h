//
//  BNXiaoDaiInfoRecordTool.h
//  Wallet
//
//  Created by mac on 15/5/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNXiaoDaiInfoRecordTool : NSObject

//删除用户的小额贷款记录信息
+(void)clearXiaoDaiInfo;

//是否已阅读小额贷款须知
+(BOOL)ifHasShowXiaoDaiExplain;
+(void)setHasShowXiaoDaiExplain;

//实名认证步骤
+(NSInteger)getRealNameVeriryStepNumber;
+(void)setRealNameVeriryStepNumber:(NSInteger)stepNumber;

//实名认证信息-姓名
+(NSString *)getXiaoDaiUserName;
+(void)setXiaoDaiUserName:(NSString *)userName;

//实名认证信息-年级
+(NSString *)getXiaoDaiUserGrade;
+(void)setXiaoDaiUserGrade:(NSString *)grade;

//实名认证信息-邮箱
+(NSString *)getXiaoDaiUserEmail;
+(void)setXiaoDaiUserEmail:(NSString *)email;

//实名认证信息-身份证号
+(NSString *)getXiaoDaiCertificateID;
+(void)setXiaoDaiCertificateID:(NSString *)certificateID;

//实名认证信息-身份证有效期
+(NSString *)getXiaoDaiCertificateIDOutTime;
+(void)setXiaoDaiCertificateIDOutTime:(NSString *)outTime;

//实名认证信息-是否已阅读小贷协议
+(BOOL)agreeTheXiaoDaiProtocal;
+(void)setHaveAgreeTheXiaoDaiProtocal;

//实名认证信息-照片路径—正面
+(NSString *)getXiaoDaiPhotoPath_Front;
+(void)setXiaoDaiPhotoPath_Front:(NSString *)photoPath_Front;

//实名认证信息-照片路径—背面
+(NSString *)getXiaoDaiPhotoPath_Back;
+(void)setXiaoDaiPhotoPath_Back:(NSString *)photoPath_Back;

//实名认证信息-照片路径—手持
+(NSString *)getXiaoDaiPhotoPath_Hold;
+(void)setXiaoDaiPhotoPath_Hold:(NSString *)photoPath_Hold;

//实名认证信息-视频路径
+(NSString *)getXiaoDaiVedioPath;
+(void)setXiaoDaiVedioPath:(NSString *)vedioPath;

//*******上传成功返回的URL
//实名认证信息-照片成功返回url—正面
+(NSString *)getXiaoDaiPhotoPath_Front_URL;
+(void)setXiaoDaiPhotoPath_Front_URL:(NSString *)photoPath_Front;

//实名认证信息-照片成功返回url—背面
+(NSString *)getXiaoDaiPhotoPath_BackURL_URL;
+(void)setXiaoDaiPhotoPath_Back_URL:(NSString *)photoPath_Back;

//实名认证信息-照片成功返回url—手持
+(NSString *)getXiaoDaiPhotoPath_Hold_URL;
+(void)setXiaoDaiPhotoPath_Hold_URL:(NSString *)photoPath_Hold;

//实名认证信息-视频成功返回url
+(NSString *)getXiaoDaiVedioPath_URL;
+(void)setXiaoDaiVedioPath_URL:(NSString *)vedioPath;
@end
