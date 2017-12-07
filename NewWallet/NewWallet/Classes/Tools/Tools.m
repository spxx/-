//
//  Tools.m
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "Tools.h"

#import "FXLabel.h"
#import "CardApi.h"

@implementation Tools

+(void)showMessageWithTitle:(NSString *)title message:(NSString *)message
{
    [Tools showMessageWithTitle:title message:message btnTitle:@"确定"];
}

+(void)showMessageWithTitle:(NSString *)title message:(NSString *)message btnTitle:(NSString *)btnTitle
{
    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil];
    [shareAppDelegateInstance.alertView show];
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
                                              textColor:(UIColor *)color
                                               textFont:(UIFont *)font
                                             colorRange:(NSRange)colorRange
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary * attributes1 = @{NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : color};
    [attributedString addAttributes:attributes1 range:colorRange];

    return attributedString;
}

+(void)showHubMessageWithView:(NSString *)message withView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = message;
}

+(void)hideHubMessageWithView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(void)showHubMessageWithView:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.dimBackground = YES;
    hud.labelText = message;
}
+(void)hideHubMessageWithView
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
+(NSArray *)getIdRecordArrayWithUserId:(NSString *)userId
{
    if (userId == nil) {
        return nil;
    }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:kBoenUserID];
    NSArray *array = nil;
    if ([dict count] > 0) {
        array = [dict valueForKey:userId];
    }
    
    return array;
}
+(void)addIdToRecordArray:(NSString *)addId withUserId:(NSString *)userId
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kBoenUserID] mutableCopy];
    if (!dict) {
        dict = [@{} mutableCopy];
    }
    NSMutableArray *array = [[dict valueForKey:userId] mutableCopy];
    if (!array) {
        array = [@[] mutableCopy];
    }
    if (![array containsObject:addId]) {
        [array insertObject:addId atIndex:0];
    }
    [dict setValue:array forKey:userId];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:kBoenUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)deleteIdFromRecordArray:(NSString *)deleteId withUserId:(NSString *)userId
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kBoenUserID] mutableCopy];
    NSMutableArray *array = [[dict valueForKey:userId] mutableCopy];
    if ([array containsObject:deleteId]) {
        [array removeObject:deleteId];
    }

    [dict setValue:array forKey:userId];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:kBoenUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)insetSpaceToBreakUpString:(NSString *)str
{
    NSMutableString *retString =[[NSMutableString alloc] init];
    NSInteger strLength = str.length;
    if (strLength > 0) {
        NSInteger fourLength = strLength / 4;
        for (int i = 0; i < fourLength; i++) {
            NSString *subString = [str substringWithRange:NSMakeRange(i*4, 4)];
            [retString appendString:subString];
            if (i != fourLength - 1) {
                [retString appendString:@" "];
            }
            
        }
        if (strLength % 4 > 0) {
            [retString appendString:@" "];
            NSString *subString = [str substringWithRange:NSMakeRange(fourLength*4, strLength % 4)];
            [retString appendString:subString];
        }
    }
    return retString;
}

+(NSString *)deleteTheSpaceOfString:(NSString *)str
{
//    NSMutableString *noSpaceStr = [[NSMutableString alloc] init];
//    NSArray *bankCardNoArray = [str componentsSeparatedByString:@" "];
//    for (int i = 0; i < [bankCardNoArray count]; i++) {
//        [noSpaceStr appendString:[bankCardNoArray objectAtIndex:i]];
//    }
    
    NSString *noSpaceStr = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789xX"] invertedSet]] componentsJoinedByString:@""];
    return noSpaceStr;
}
+(NSString *)limiteIDOfString:(NSString *)str
{
    //    NSMutableString *noSpaceStr = [[NSMutableString alloc] init];
    //    NSArray *bankCardNoArray = [str componentsSeparatedByString:@" "];
    //    for (int i = 0; i < [bankCardNoArray count]; i++) {
    //        [noSpaceStr appendString:[bankCardNoArray objectAtIndex:i]];
    //    }
    
    NSString *noSpaceStr = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789xX"] invertedSet]] componentsJoinedByString:@""];

    return noSpaceStr;
}
+(CGFloat)caleNewsCellHeightWithTitle:(NSString *)title font:(UIFont *)titleFont width:(CGFloat)width
{
//    CGSize sizeTitle = [title sizeWithFont:titleFont constrainedToSize:CGSizeMake(width, 10000) lineBreakMode:NSLineBreakByCharWrapping];

    CGSize sizeTitle;
    if (IOS_VERSION >= 7.0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil];
        sizeTitle = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    } else{
         sizeTitle = [title sizeWithFont:titleFont forWidth:width lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return sizeTitle.height;
}

+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)titleFont height:(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil];
    CGSize sizeTitle = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return sizeTitle.width;
}
#pragma mark - kHasShowPaySchoolFeesExplain
+(BOOL)ifHasShowPaySchoolFeesExplain:(NSString *)userId
{
    if (userId == nil) {
        return NO;
    }
    id array = [[NSUserDefaults standardUserDefaults] valueForKey:kHasShowPaySchoolFeesExplain];
    if ([array isKindOfClass:[NSString class]]) {
        return NO;
    }else{
        if ([array containsObject:userId]) {
            return YES;
        } else {
            return NO;
        }

    }
}
+(void)setHasShowPaySchoolFeesExplainWithUserId:(NSString *)userId
{
    id array0 = [[[NSUserDefaults standardUserDefaults] valueForKey:kHasShowPaySchoolFeesExplain] mutableCopy];
    if ([array0 isKindOfClass:[NSString class]] || !array0 ) {
        array0 = [@[] mutableCopy];
    }
    if (![array0 containsObject:userId]) {
        [array0 addObject:userId];
    }
    [[NSUserDefaults standardUserDefaults] setValue:array0 forKey:kHasShowPaySchoolFeesExplain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - kHasSavedLivenessDetectionImages
//已经验证过活体检测，但上传失败，则保存在本地，以便下次跳过活体检测，直接上传。
+(NSArray *)getLivenessDetectionImages:(NSString *)userId
{
    if (userId == nil) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userIdDocPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, userId];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:userIdDocPath isDirectory:&isDir]) {
        NSMutableArray *images = [@[] mutableCopy];
        NSArray *imagePaths = [self allFilesAtPath:userIdDocPath includeFolder:NO];
        if (imagePaths.count == 4) {
            for (NSString *imgPath in imagePaths) {
                NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
                UIImage *image = [UIImage imageWithData:imgData];
                [images addObject:image];
            }
            return images;
        }
    }
    
    return nil;
}

+(void)saveLivenessDetectionImages:(NSArray *)images WithUserId:(NSString *)userId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userIdDocPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, userId];
    //用userId创建一个文件夹
    [fileManager createDirectoryAtPath:userIdDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    for (int i = 0; i < images.count; i++) {
        NSString *filePath = [userIdDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.jpg", (long)i]];   // 保存文件的名称
        
        BOOL result = [UIImageJPEGRepresentation(images[i], 0.5)writeToFile: filePath atomically:YES];
        BNLog(@"result----%d", result);
    }

}
+(void)removeLivenessDetectionImagesWithUserId:(NSString *)userId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userIdDocPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, userId];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:userIdDocPath isDirectory:&isDir]) {
        [fileManager removeItemAtPath:userIdDocPath error:nil];

//        NSMutableArray *images = [@[] mutableCopy];
//        NSArray *imagePaths = [self allFilesAtPath:userIdDocPath includeFolder:NO];
//        for (NSString *path in imagePaths) {
//            [fileManager removeItemAtPath:path error:nil];
//        }
    }

}
//+(NSString *)getBaseUrl
//{
//    NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:kBaseUrl];
//    NSString *baseUrl = @"http://211.149.198.113";
//    if (url && url.length > 0) {
//        baseUrl = url;
//    }
//    
//    return baseUrl;
//}
//+(BOOL)isAppStoreTestUrl
//{
//    if ([[self getBaseUrl] isEqualToString:@"http://211.149.198.113"]) {
//        return YES;
//    }
//    return NO;
//}
//
//+(void)saveBaseUrlWithPhoneNumber:(NSString *)phone
//{
//    NSString *url = @"https://api.bionictech.cn";
//    if ([phone isEqualToString:@"15828556798"]) {
//        url = @"http://211.149.198.113";
//    }
//    [[NSUserDefaults standardUserDefaults] setValue:url forKey:kBaseUrl];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(BOOL)isAppStoreTest
//{
//    NSString *boolStr = [[NSUserDefaults standardUserDefaults] valueForKey:kIsAppStoreTest];
//    BOOL bool2 = NO;
//    if (!boolStr || [boolStr isEqualToString:@"yes"]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:kIsAppStoreTest];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        bool2 = YES;
//    }
////    else if ([boolStr isEqualToString:@"yes"]){
////        bool2 = NO;
////        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:kIsAppStoreTest];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////    }
//    
//    return bool2;
//}
//+(void)saveToFormalUrl
//{
//    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:kIsAppStoreTest];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//+ (NSString *)getSchoolHeadImgUrl:(NSString *)schoolId
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@/static/xifu_logos/school_%@.png", BASE_URL, schoolId];
//    return urlStr;
//}

//判断serIDArray是否包含此userID
+(BOOL)userIDArrayContain:(NSString *)userId
{
    if (userId == nil) {
        return NO;
    }
    id array = [[NSUserDefaults standardUserDefaults] valueForKey:kUserIDArrayContain];
    if ([array isKindOfClass:[NSString class]]) {
        return NO;
    }else{
        if ([array containsObject:userId]) {
            return YES;
        } else {
            return NO;
        }
        
    }
}
+(void)userIDArrayAddWithUserId:(NSString *)userId
{
    id array0 = [[[NSUserDefaults standardUserDefaults] valueForKey:kUserIDArrayContain] mutableCopy];
    if ([array0 isKindOfClass:[NSString class]] || !array0 ) {
        array0 = [@[] mutableCopy];
    }
    if (![array0 containsObject:userId]) {
        [array0 addObject:userId];
    }
    [[NSUserDefaults standardUserDefaults] setValue:array0 forKey:kUserIDArrayContain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

+(CGFloat)getReturnMoneyListCellHeight:(NSDictionary *)dict
{

    CGFloat whiteViewOriginY = 8*BILI_WIDTH;
    UIView *whiteView =[[UIView alloc]initWithFrame:CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, 122*BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];

    CGRect _titleLblframe = CGRectMake(10*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH-(110+2*10)*BILI_WIDTH, 14*BILI_WIDTH);
    
    whiteViewOriginY += _titleLblframe.size.height + 14*BILI_WIDTH;
    
        //111---->>>>>
//    CGRect _redYuQiBGViewframe;
//    float overduedAmount = [[dict valueNotNullForKey:@"overdued_amount"] floatValue];
//    
//    //    NSString *yuqiStr = @"本期还款已逾期3天，罚息12元!若逾期30天未还款将记入征信系统，影响个人信用记录！请尽快还款！";
//    NSString *yuqiStr = [NSString stringWithFormat:@"本期还款已逾期，逾期会产生罚息，你总共需要还款%f元，若逾期30天未还款将记入征信系统，影响个人信用记录。",overduedAmount];
//    if (overduedAmount > 0) {
//        CGFloat redTitleHeight = [Tools caleNewsCellHeightWithTitle:yuqiStr font:[UIFont systemFontOfSize:13*BILI_WIDTH] width:SCREEN_WIDTH-2*10*BILI_WIDTH];
//        
//         _redYuQiBGViewframe = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 2*7*BILI_WIDTH+redTitleHeight);
//        
//        whiteViewOriginY += _redYuQiBGViewframe.size.height;
//        whiteViewOriginY += 2*14*BILI_WIDTH;
//
//    } else {
//        _redYuQiBGViewframe = CGRectMake(0, whiteViewOriginY, 0, 0);
//        whiteViewOriginY += 14*BILI_WIDTH;
//    }
    //<<<-----111
    
    //---->>>>222  //222是临时不显示红色逾期内容，要显示就打开111，不要222
    whiteViewOriginY += 14*BILI_WIDTH;
    //<<<<----222
    CGRect _moneyTitleLblframe = CGRectMake(10*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 13*BILI_WIDTH);
    
    whiteViewOriginY += _moneyTitleLblframe.size.height + 10*BILI_WIDTH;
    
    CGRect _moneyLblframe = CGRectMake(10*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 22*BILI_WIDTH);
    
    whiteViewOriginY += _moneyLblframe.size.height + 22*BILI_WIDTH;
    CGRect _shouldReturnLblframe;
//    随时还=SCHEDULED, 分期=INSTALLMENT.

    if ([[dict valueNotNullForKey:@"repayment_type"] isEqualToString:@"INSTALLMENT"]) {
        _shouldReturnLblframe = CGRectMake(10*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH-2*BILI_WIDTH, 35*BILI_WIDTH);
    } else {
        _shouldReturnLblframe = CGRectMake(10*BILI_WIDTH, whiteViewOriginY, 0, 0);
    }
    
    whiteViewOriginY += _shouldReturnLblframe.size.height;
    
    //还款时间
    CGRect _remainTimeBtnframe = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH-110*BILI_WIDTH, 40*BILI_WIDTH);
    
    whiteViewOriginY += _remainTimeBtnframe.size.height;
    whiteView.frame = CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, whiteViewOriginY);
    
    return whiteView.frame.size.height + 8*BILI_WIDTH;

}


+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


+ (void)deleteAllUploadImg
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Img"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            BNLog(@"Delete upload img %@", error.localizedDescription);
        }
    });
    
}

+ (UIImage *)createUploadDefaultBackGroundImage
{
    UIGraphicsBeginImageContext(CGSizeMake(90, 90));   //开始画线
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    CGContextSetLineCap(currentContext, kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[2] = {8,4};
    CGContextSetLineDash(currentContext, 0, lengths, 2);
    CGContextSetLineWidth(currentContext, 1);
    [UIColorFromRGB(0xc5c5c5) setStroke];
    [UIColorFromRGB(0xe7e7e7) setFill];
    CGContextAddRect(currentContext, CGRectMake(1, 1, 90-2, 90-2));
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGContextRestoreGState(currentContext);
    
    CGContextSaveGState(currentContext);
    CGContextAddRect(currentContext, CGRectMake((90 - 6)/2.0, 20, 6, 90 - 20 * 2));
    CGContextAddRect(currentContext, CGRectMake(20, (90 - 6)/2.0, 90 - 20 * 2, 6));
    [[UIColor whiteColor] setFill];
    CGContextFillPath(currentContext);
    
    CGContextRestoreGState(currentContext);
    
    UIImage *uploadBKImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return uploadBKImg;
}

//用于钱包余额yjf_balance赋值判断，如果为-1或是不正常数据时，则不赋值。
+ (NSString *)saveto:(NSString *)savetoStr valueNotNegative:(NSString *)value
{
    if (!value || [value floatValue] < 0.0 || [value isEqualToString:@"null"]) {
        return savetoStr;
    }
    return value;
}

//获取文件目录下的文件名，可选则是否包含文件夹
+ (NSArray*)allFilesAtPath:(NSString*)dirString includeFolder:(BOOL)includeFolder{
    
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    if (includeFolder == YES) {
        //返回所有文件及文件夹名称
        return tempArray;
    }
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                
                [array addObject:fullPath];
                
            }
            
        }
        
    }
    //只返回所有文件名称，不包含文件夹
    return array;
    
}


+(BOOL)getIfXifuNewsUpdatedBefore500
{
    //从版本大于5.0.0开始，NSUserDefault存储一个字段“XifuNewsUpdateBefore500”，查询是否以保存此key
    NSString *boolString = [[NSUserDefaults standardUserDefaults] valueForKey:KXifuNewsUpdateBefore500];
    if (boolString && [boolString isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
+(void)saveXifuNewsUpdatedBefore500
{
    //从版本大于5.0.0开始，NSUserDefault存储一个字段“XifuNewsUpdateBefore500”，保存此key
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:KXifuNewsUpdateBefore500];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)checkUserBindCardArrayWithResult:(void (^)(NSArray *bindCardArray))bindBlock
                                 notBind:(void (^)(void))notBindBlock
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CardApi CardListWithUser:shareAppDelegateInstance.boenUserInfo.userid success:^(NSDictionary *returnData) {
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            NSDictionary *dataDic = [returnData valueForKey:kRequestReturnData];
            NSArray *bandCardsArray = [dataDic valueForKey:@"binded_cards"];
            [SVProgressHUD dismiss];
    
            if (bandCardsArray != nil && [bandCardsArray count] > 0) { //绑定过银行卡
                bindBlock(bandCardsArray);
                
            }else{//没绑定银行卡
                notBindBlock();
            }
        }else{
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}
//NSDate转换成NSString
+ (NSString *)changeNSDateToNSString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    return nowDate;
}
//计算两个日期间隔多少天
+ (NSInteger)intervalFromLastDate:(NSString *)dateString1  toTheDate:(NSString *)dateString2
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[date dateFromString:dateString1];
    NSDate *date2=[date dateFromString:dateString2];
    
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
    
    int days=((int)time)/(3600*24);
    //    int hours=((int)time)%(3600*24)/3600;
    
    return days;
}
//计算两个时间间隔多少秒
+ (CGFloat)intervalSecondsFromLastDate1:(NSDate *)date1  toTheDate2:(NSDate *)date2
{
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
    
//    int days=((int)time)/(3600*24);
//    int hours=((int)time)%(3600*24)/3600;
//    int minutes = ((int)time)%(3600*24)%3600/60;
//    int seconds = ((int)time)%(3600*24)%3600%60;
//    NSString *dateContent = [[NSString alloc] initWithFormat:@"仅剩%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    float second = time;

    return second;
}
#define kHomeItemArray         @"kHomeItemArray"
//首页九宫格数组记录
+(NSArray *)getHomeItemRecordArray
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:kHomeItemArray];
    NSArray *arrayDefault = [[NSArray alloc]init];
    if (array && [array isKindOfClass:[NSArray class]]) {
        arrayDefault = array;
    } else {
        arrayDefault = @[@{
                             @"biz_id" : @"1",
                             @"biz_name" : @"一卡通",
                             @"image" : @"home_onecard_icon"
                             },
                         @{
                             @"biz_id" : @"3",
                             @"biz_name" : @"手机充值",
                             @"image" : @"home_mobile_charge_icon"
                             },
                         @{
                             @"biz_id" : @"5",
                             @"biz_name" : @"电费充值",
                             @"image" : @"home_electric_charge_icon"
                             },
                         @{
                             @"biz_id" : @"102",
                             @"biz_name" : @"嘻哈贷",
                             @"image" : @"home_loan_icon"
                             },
                         @{
                             @"biz_id" : @"101",
                             @"biz_name" : @"费用领取",
                             @"image" : @"home_collect_fees_icon"
                             },
                         @{
                             @"biz_id" : @"7",
                             @"biz_name" : @"教育缴费",
                             @"image" : @"home_school_fees_icon"
                             },
                         @{
                             @"biz_id" : @"8",
                             @"biz_name" : @"网费充值",
                             @"image" : @"home_net_fees_icon"
                             },
                          @{
                             @"biz_id" : @"9",
                             @"biz_name" : @"扫码支付",
                             @"image" : @"home_qrcode_pay_icon"
                             },
                         @{
                             @"biz_id" : @"10",
                             @"biz_name" : @"喜付学车",
                             @"image" : @"home_study_car_icon"
                             }
                         ];
    }
    
    return arrayDefault;

}
+(void)saveHomeItemRecordArray:(NSArray *)array
{
    if (array && [array isKindOfClass:[NSArray class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:array forKey:kHomeItemArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}
#define kSchoolProjectItemRecordArray         @"kSchoolProjectItemRecordArray"
//校园应用列表数组记录
+(NSArray *)getSchoolProjectItemRecordArray
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:kSchoolProjectItemRecordArray];
    NSArray *arrayDefault = [[NSArray alloc]init];
    if (array && [array isKindOfClass:[NSArray class]]) {
        arrayDefault = array;
    } else {
        arrayDefault = @[];
    }
    
    return arrayDefault;
}

+(void)saveSchoolProjectItemRecordArray:(NSArray *)array
{
    if (array && [array isKindOfClass:[NSArray class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:array forKey:kSchoolProjectItemRecordArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
#define kHomeItemUpdateDate         @"kHomeItemUpdateDate"
//首页获取九宫格数组的日期记录，每次启动判断，超过一天就刷新一次
+(NSString *)getHomeItemLastDate
{
    NSString *dateStr = [[NSUserDefaults standardUserDefaults] valueForKey:kHomeItemUpdateDate];
    if (!dateStr || dateStr.length <= 0) {
        dateStr = @"1970-01-01";
    }
    return dateStr;

}
+(void)saveHomeItemUpdateDate:(NSString *)dateStr
{
    if (dateStr && dateStr.length > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:dateStr forKey:kHomeItemUpdateDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

//dictionaryToJson
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
//jsonToDictionary
+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    if (!jsonString) {
        return nil;
    }
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];

    return result;
}

// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}

#pragma mark - kHasShowHomeFirstGuidView
+(BOOL)ifHasShowHomeFirstGuidView
{
    NSString *boolStr = [[NSUserDefaults standardUserDefaults] valueForKey:kHasShowHomeFirstGuidView];
    BOOL bool2 = NO;
    if (boolStr && [boolStr isEqualToString:@"yes"]) {
        bool2 = YES;
    }

    return bool2;
}
+(void)saveHasShowHomeFirstGuidView
{
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:kHasShowHomeFirstGuidView];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//#pragma mark - KHasShowScanedByShopFirstIntroduce
//+(BOOL)ifHasShowScanedByShopFirstIntroduce:(NSString *)userId
//{
//    if (userId == nil) {
//        return NO;
//    }
//    id array = [[NSUserDefaults standardUserDefaults] valueForKey:KHasShowScanedByShopFirstIntroduce];
//    if ([array isKindOfClass:[NSString class]]) {
//        return NO;
//    }else{
//        if ([array containsObject:userId]) {
//            return YES;
//        } else {
//            return NO;
//        }
//        
//    }
//}
//+(void)setHasShowScanedByShopFirstIntroduceWithUserId:(NSString *)userId
//{
//    id array0 = [[[NSUserDefaults standardUserDefaults] valueForKey:KHasShowScanedByShopFirstIntroduce] mutableCopy];
//    if ([array0 isKindOfClass:[NSString class]] || !array0 ) {
//        array0 = [@[] mutableCopy];
//    }
//    if (![array0 containsObject:userId]) {
//        [array0 addObject:userId];
//    }
//    [[NSUserDefaults standardUserDefaults] setValue:array0 forKey:KHasShowScanedByShopFirstIntroduce];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//}

#define kGetLocalPersonalSecret @"kGetLocalPersonalSecret"
//付款码页面-获取个人秘钥
+ (NSString *)getLocalPersonalSecret
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kGetLocalPersonalSecret] mutableCopy];
    NSString *secretStr = @"";
    if ([[dict allKeys] containsObject:shareAppDelegateInstance.boenUserInfo.userid]) {
        secretStr = [dict valueForKey:shareAppDelegateInstance.boenUserInfo.userid];
    }
    
    return secretStr;
}
//付款码页面-保存个人秘钥到本地
+(void)savePersonalSecretToLocal:(NSString *)secretStr
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kGetLocalPersonalSecret] mutableCopy];
    if (!dict) {
        dict = [@{} mutableCopy];
    }
    [dict setObject:secretStr forKey:shareAppDelegateInstance.boenUserInfo.userid];
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:kGetLocalPersonalSecret];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
