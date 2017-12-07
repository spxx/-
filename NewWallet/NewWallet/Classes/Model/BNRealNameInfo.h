//
//  BNRealNameInfo.h
//  Wallet
//
//  Created by mac1 on 15/5/20.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRealNameInfo : NSObject

@property (strong, nonatomic) NSString *realNameInfoOfName;
@property (strong, nonatomic) NSString *realNameInfoOfGrade;//记录的是年纪编号
@property (strong, nonatomic) NSString *realNameInfoOfEmail;
@property (strong, nonatomic) NSString *realNameInfoOfIdentity;
@property (strong, nonatomic) NSString *realNameInfoOfValidate;//@"yyyy.MM.dd";
@property (strong, nonatomic) NSString *realNameInfoOfFrontImgPath;
@property (strong, nonatomic) NSString *realNameInfoOfBackImgPath;
@property (strong, nonatomic) NSString *realNameInfoOfHoldImgPath;


@property (copy, nonatomic) NSString *tiXianFrontImgPath;
@property (copy, nonatomic) NSString *tiXianBackImgPath;


+ (BNRealNameInfo *)shareInstance;


/***
 ***
 *** 小贷实名认证需要 8 要素, 检查8要素是否具备, 具备后就可以提交实名认证。
 ***
 ***/
- (BOOL)checkXiaoDaiRealNameInfoCanSubmit;


/***
 ***
 *** 提现实名认证 具备后就可以提交实名认证。
 ***
 ***/
- (BOOL)checkTiXianRealNameInfoCanSubmit;

/***
 ***
 ***清除所有实名认证信息
 ***
 ***/

- (BOOL)clearRealNameInfo;


/***
 ***
 ***返回年级  大三  和   3 两种格式
 ***
 ***/
- (NSString *)getRealNameInfoOfGradeWithChineseString;

- (NSString *)getRealNameInfoOfGradeWithNOString;

- (NSArray  *)getGradesList;

/***
 ***
 ***获取 2015.12.01 和 20151201 两种格式
 ***
 ***/
- (NSString *)getRealNameInfoOfValidateHasPoint;

- (NSString *)getRealNameInfoOfValidateHasNotPoint;
@end
