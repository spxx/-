//
//  BNTools.m
//  Wallet
//
//  Created by mac on 15-1-5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNTools.h"

@implementation BNTools

+ (CGFloat)sizeFit:(CGFloat)size six:(CGFloat)six sixPlus:(CGFloat)sixPlus
{
    if (SCREEN_HEIGHT == 667 || SCREEN_WIDTH == 375) {
        //6
        return six;
    }else if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        //6plus
        return sixPlus;
    } else {
        //5s以下
        return size;
    }
}

+ (CGFloat)sizeFitfour:(CGFloat)four five:(CGFloat)five six:(CGFloat)six sixPlus:(CGFloat)sixPlus
{
    if (SCREEN_HEIGHT == 667 || SCREEN_WIDTH == 375) {
        //6
        return six;
    }else if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
        //6plus
        return sixPlus;
    } else if (SCREEN_HEIGHT == 480) {
        //3.5寸-4s以下
        return four;
    } else {
        //4.0寸-5/5s
        return five;
    }
}

+ (void)setProfileUserInfo:(NSDictionary *)retData
{
    shareAppDelegateInstance.boenUserInfo.yjf_bind_id = [retData valueNotNullForKey:@"yjf_bind_id"];
    shareAppDelegateInstance.boenUserInfo.name = [retData valueNotNullForKey:@"real_name"];
    shareAppDelegateInstance.boenUserInfo.isCert = [retData valueNotNullForKey:@"is_cert"];
    //    shareAppDelegateInstance.boenUserInfo.is_nopassword = [retData valueNotNullForKey:@"is_nopassword"];
    //    shareAppDelegateInstance.boenUserInfo.nopassword_amount = [NSString stringWithFormat:@"%@",[retData valueNotNullForKey:@"nopassword_amount"]];
    shareAppDelegateInstance.boenUserInfo.stuempno = [retData valueNotNullForKey:@"stuempno"];
    shareAppDelegateInstance.boenUserInfo.schoolId = [NSString stringWithFormat:@"%li", (long)[[retData valueNotNullForKey:@"school_id"]integerValue]];
    shareAppDelegateInstance.boenUserInfo.schoolName = [retData valueNotNullForKey:@"school_name"];
    //    shareAppDelegateInstance.boenUserInfo.ykt_balance = [retData valueNotNullForKey:@"ykt_balance"];//接口修改，getProfile返回数据不再有ykt_balance字段。所以屏蔽。
    shareAppDelegateInstance.boenUserInfo.yjf_balance = [Tools saveto:shareAppDelegateInstance.boenUserInfo.yjf_balance valueNotNegative:[retData valueNotNullForKey:@"yjf_balance"]];//赋值判断，如果为-1或是不正常数据时，则不赋值。
    
    shareAppDelegateInstance.boenUserInfo.cert_no = [retData valueNotNullForKey:@"cert_no"];
    //    shareAppDelegateInstance.boenUserInfo.bankCardNumbers = [Tools saveto:shareAppDelegateInstance.boenUserInfo.bankCardNumbers valueNotNegative:[NSString stringWithFormat:@"%li",(long)[[retData valueNotNullForKey:@"binded_card_num"] integerValue]]];//赋值判断，如果为-1或是不正常数据时，则不赋值。
    shareAppDelegateInstance.boenUserInfo.phoneNumber = [NSString stringWithFormat:@"%@",[retData valueNotNullForKey:@"mobile"]];
    //记录新添加的yktType和studentno字段
    shareAppDelegateInstance.boenUserInfo.yktType = [NSString stringWithFormat:@"%@", [retData valueNotNullForKey:@"ykt_type"]];
    shareAppDelegateInstance.boenUserInfo.studentno = [NSString stringWithFormat:@"%@", [retData valueNotNullForKey:@"studentno"]];
    shareAppDelegateInstance.boenUserInfo.schoolIcon = [NSString stringWithFormat:@"%@", [retData valueNotNullForKey:@"school_logo"]];
    
}
#define kLastLoginCookies         @"kLastLoginCookies"
+ (void)saveLoginCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    //存储归档后的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: cookiesData forKey:kLastLoginCookies];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:kLastLoginCookies]];
    
    if (cookies) {
        for (NSHTTPCookie *cookie in cookies) {
            NSLog(@"有cookie--111--cookies----%@", cookie);
        }
    }
}
+ (void)removeLoginCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: @[]];
    //存储归档后的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: cookiesData forKey:kLastLoginCookies];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:kLastLoginCookies]];
    
    if (cookies) {
        for (NSHTTPCookie *cookie in cookies) {
            NSLog(@"有cookie--111--cookies----%@", cookie);
        }
    }
}
+ (void)setLastLoginCookies
{
    //打印cookie，检测是否成功设置了cookie
    NSArray *cookiesA = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesA) {
        BNLog(@"000-----setCookie: %@", cookie);
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:kLastLoginCookies]];
    
    if (cookies) {
        BNLog(@"有cookie----cookies----%@",cookies);
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
        BNLog(@"无cookie");
    }
    //打印cookie，检测是否成功设置了cookie
    NSArray *cookiesB = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesB) {
        BNLog(@"11111----setCookie: %@", cookie);
    }

}
#define kLastLaunchADid         @"kLastLaunchADid"
+(void)saveLaunchADid:(NSString *)ADid
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kLastLaunchADid] mutableCopy];
    if (!dict) {
        dict = [@{} mutableCopy];
    }
    [dict setObject:ADid forKey:shareAppDelegateInstance.boenUserInfo.userid];
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:kLastLaunchADid];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
//要么只要ADid一样，就不显示启动广告，
//要么就

//只要ADid一样，就不显示
//+ (BOOL)ifHaveLaunchedADid:(NSString *)ADid
//{
//    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kLastLaunchADid] mutableCopy];
//    if ([[dict allValues] containsObject:ADid]) {
//        return YES;
//    }
//    
//    return NO;
//}
//未登录，判断不了，切换之前的用户还要再显示启动广告
+ (NSString *)getLastLaunchADid
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kLastLaunchADid] mutableCopy];
    NSString *ADidStr = @"";
    if ([[dict allKeys] containsObject:shareAppDelegateInstance.boenUserInfo.userid]) {
        ADidStr = [dict valueForKey:shareAppDelegateInstance.boenUserInfo.userid];
    }
    
    return ADidStr;
}
#define kHomeWindowADid         @"kHomeWindowADid"
+(void)saveHomeWindowADid:(NSString *)ADid
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kHomeWindowADid] mutableCopy];
    if (!dict) {
        dict = [@{} mutableCopy];
    }
    [dict setObject:ADid forKey:shareAppDelegateInstance.boenUserInfo.userid];
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:kHomeWindowADid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getLastHomeWindowADid
{
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:kHomeWindowADid] mutableCopy];
    NSString *ADidStr = @"";
    if ([[dict allKeys] containsObject:shareAppDelegateInstance.boenUserInfo.userid]) {
        ADidStr = [dict valueForKey:shareAppDelegateInstance.boenUserInfo.userid];
    }

    return ADidStr;
}

/**
 * 转成 Json 参数
 */
+ (NSString *)dataJsonWithDic:(id)paramObj
{
    NSData * data = [NSJSONSerialization dataWithJSONObject:paramObj options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *paramStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return paramStr;
    
}

#pragma mark - 时间相关

+ (NSDateComponents *)dateComponentsFromDateString:(NSString *)dateString {
    
    dateString = [self dateStringFormatter:dateString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; //设定日期时区
    
    return [self dateComponentsFromDate:[dateFormatter dateFromString:dateString]];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 日期对比项
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    return [calendar components:unitFlags fromDate:date];
}

/**
*  日期字符串格式化方法
*
*  @param dateString 日期字符串
*
*  @return 格式化后的字符串
*/
+ (NSString *)dateStringFormatter:(NSString *)dateString {
    
    // 去日期字符串的符号
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 时间字符串长度超出，截取14位
    if ([dateString length] > 14) {
        dateString = [dateString substringToIndex:13];
    }
    
    // 时间字符串长度不够，补0
    while ([dateString length] < 14) {
        dateString = [dateString stringByAppendingString:@"0"];
    }
    
    return dateString;
}

+(NSString *)escape:(NSString *)str{
    {
        NSArray *hex = [NSArray arrayWithObjects:
                        @"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"0A",@"0B",@"0C",@"0D",@"0E",@"0F",
                        @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"1A",@"1B",@"1C",@"1D",@"1E",@"1F",
                        @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"2A",@"2B",@"2C",@"2D",@"2E",@"2F",
                        @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"3A",@"3B",@"3C",@"3D",@"3E",@"3F",
                        @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"4A",@"4B",@"4C",@"4D",@"4E",@"4F",
                        @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"5A",@"5B",@"5C",@"5D",@"5E",@"5F",
                        @"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"6A",@"6B",@"6C",@"6D",@"6E",@"6F",
                        @"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"7A",@"7B",@"7C",@"7D",@"7E",@"7F",
                        @"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"8A",@"8B",@"8C",@"8D",@"8E",@"8F",
                        @"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"9A",@"9B",@"9C",@"9D",@"9E",@"9F",
                        @"A0",@"A1",@"A2",@"A3",@"A4",@"A5",@"A6",@"A7",@"A8",@"A9",@"AA",@"AB",@"AC",@"AD",@"AE",@"AF",
                        @"B0",@"B1",@"B2",@"B3",@"B4",@"B5",@"B6",@"B7",@"B8",@"B9",@"BA",@"BB",@"BC",@"BD",@"BE",@"BF",
                        @"C0",@"C1",@"C2",@"C3",@"C4",@"C5",@"C6",@"C7",@"C8",@"C9",@"CA",@"CB",@"CC",@"CD",@"CE",@"CF",
                        @"D0",@"D1",@"D2",@"D3",@"D4",@"D5",@"D6",@"D7",@"D8",@"D9",@"DA",@"DB",@"DC",@"DD",@"DE",@"DF",
                        @"E0",@"E1",@"E2",@"E3",@"E4",@"E5",@"E6",@"E7",@"E8",@"E9",@"EA",@"EB",@"EC",@"ED",@"EE",@"EF",
                        @"F0",@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8",@"F9",@"FA",@"FB",@"FC",@"FD",@"FE",@"FF", nil];
        
        NSMutableString *result = [NSMutableString stringWithString:@""];
        int strLength = str.length;
        for (int i=0; i<strLength; i++) {
            int ch = [str characterAtIndex:i];
            if (ch == ' ')
            {
                [result appendFormat:@"%c",'+'];
            }
            else if ('A' <= ch && ch <= 'Z')
            {
                [result appendFormat:@"%c",(char)ch];
                
            }
            else if ('a' <= ch && ch <= 'z')
            {
                [result appendFormat:@"%c",(char)ch];
            }
            else if ('0' <= ch && ch<='9')
            {
                [result appendFormat:@"%c",(char)ch];
            }
            else if (ch == '-' || ch == '_'
                     || ch == '.' || ch == '!'
                     || ch == '~' || ch == '*'
                     || ch == '\'' || ch == '('
                     || ch == ')')
            {
                [result appendFormat:@"%c",(char)ch];
            }
            else if (ch <= 0x007F)
            {
                [result appendFormat:@"%%",'%'];
                [result appendString:[hex objectAtIndex:ch]];
            }
            else
            {
                [result appendFormat:@"%%",'%'];
                [result appendFormat:@"%c",'u'];
                [result appendString:[hex objectAtIndex:ch>>8]];
                [result appendString:[hex objectAtIndex:0x00FF & ch]];
            }
        }
        return result;
    }
}






@end

