//
//  Tools.h
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface Tools : NSObject

+(void)showMessageWithTitle:(NSString *)title message:(NSString *)message;

+(void)showMessageWithTitle:(NSString *)title message:(NSString *)message btnTitle:(NSString *)btnTitle;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
                                              textColor:(UIColor *)color
                                               textFont:(UIFont *)font
                                             colorRange:(NSRange)colorRange;

+(void)showHubMessageWithView:(NSString *)message withView:(UIView *)view;

+(void)hideHubMessageWithView:(UIView *)view;

+(void)showHubMessageWithView:(NSString *)message;

+(void)hideHubMessageWithView;

//一卡通号记录
+(NSArray *)getIdRecordArrayWithUserId:(NSString *)userId;
+(void)addIdToRecordArray:(NSString *)addId withUserId:(NSString *)userId;
+(void)deleteIdFromRecordArray:(NSString *)deleteId withUserId:(NSString *)userId;

//是否已阅读学校缴费须知
+(BOOL)ifHasShowPaySchoolFeesExplain:(NSString *)userId;
+(void)setHasShowPaySchoolFeesExplainWithUserId:(NSString *)userId;



//已经验证过活体检测，但上传失败，则保存在本地，以便下次跳过活体检测，直接上传。
+(NSArray *)getLivenessDetectionImages:(NSString *)userId;
+(void)saveLivenessDetectionImages:(NSArray *)images WithUserId:(NSString *)userId;
+(void)removeLivenessDetectionImagesWithUserId:(NSString *)userId;

+(NSString *)insetSpaceToBreakUpString:(NSString *)str;
+(NSString *)deleteTheSpaceOfString:(NSString *)str;
+(NSString *)limiteIDOfString:(NSString *)str; //身份证输入限制为0-9和xX
+(CGFloat)caleNewsCellHeightWithTitle:(NSString *)title font:(UIFont *)titleFont width:(CGFloat)width;

//获取文本宽度
+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)titleFont height:(CGFloat)height;

////获取BaseUrl
//+(NSString *)getBaseUrl;
//+(BOOL)isAppStoreTestUrl;
//+(void)saveBaseUrlWithPhoneNumber:(NSString *)phone;
//
////保存是否是testUrl
//+(BOOL)isAppStoreTest;
//+(void)saveToFormalUrl;
//+ (NSString *)getSchoolHeadImgUrl:(NSString *)schoolId;

//判断serIDArray是否包含此userID
+(BOOL)userIDArrayContain:(NSString *)userId;
+(void)userIDArrayAddWithUserId:(NSString *)userId;

+(CGFloat)getReturnMoneyListCellHeight:(NSDictionary *)dict;


//删除保存在Documents/Img下面所有要上传的图片
+ (void)deleteAllUploadImg;

//用于钱包余额yjf_balance赋值判断，如果为-1或是不正常数据时，则不赋值。
+ (NSString *)saveto:(NSString *)savetoStr valueNotNegative:(NSString *)value;



//NSFileManager
//获取文件目录下的文件名，可选则是否包含文件夹
+ (NSArray*)allFilesAtPath:(NSString*)dirString includeFolder:(BOOL)includeFolder;

+(BOOL)getIfXifuNewsUpdatedBefore500;  //查询NSUserDefault是否包含XifuNewsUpdateBefore500字段
+(void)saveXifuNewsUpdatedBefore500;   //NSUserDefault保存XifuNewsUpdateBefore500字段

//获取用户的银行卡列表
+ (void)checkUserBindCardArrayWithResult:(void (^)(NSArray *bindCardArray))bindBlock
                              notBind:(void (^)(void))notBindBlock;

//NSDate转换成NSString
+ (NSString *)changeNSDateToNSString:(NSDate *)date;

//计算两个日期间隔多少天
+ (NSInteger)intervalFromLastDate:(NSString *)dateString1  toTheDate:(NSString *)dateString2;
//计算两个时间间隔多少秒
+ (CGFloat)intervalSecondsFromLastDate1:(NSDate *)date1  toTheDate2:(NSDate *)date2;

//首页九宫格数组记录
+(NSArray *)getHomeItemRecordArray;
+(void)saveHomeItemRecordArray:(NSArray *)array;

//首页获取九宫格数组的日期记录，每次启动判断，超过一天就刷新一次
+(NSString *)getHomeItemLastDate;
+(void)saveHomeItemUpdateDate:(NSString *)date;

//校园应用列表数组记录
+(NSArray *)getSchoolProjectItemRecordArray;
+(void)saveSchoolProjectItemRecordArray:(NSArray *)array;


//dictionaryToJson
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
//jsonToDictionary
+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString;

// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController;

//是否已显示过首次加载的引导蒙版
+(BOOL)ifHasShowHomeFirstGuidView;
+(void)saveHasShowHomeFirstGuidView;

////是否已阅读二维码付款须知
//+(BOOL)ifHasShowScanedByShopFirstIntroduce:(NSString *)userId;
//+(void)setHasShowScanedByShopFirstIntroduceWithUserId:(NSString *)userId;

//付款码页面-获取个人秘钥
+ (NSString *)getLocalPersonalSecret;
//付款码页面-保存个人秘钥到本地
+(void)savePersonalSecretToLocal:(NSString *)secretStr;

@end
