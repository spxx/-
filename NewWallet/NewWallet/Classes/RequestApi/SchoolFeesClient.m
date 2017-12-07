//
//  SchoolFeesClient.m
//  Wallet
//
//  Created by mac1 on 15/3/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "SchoolFeesClient.h"

#import "HttpTools.h"

#import "NSString+MD5.h"

#define CHECK_SCHOOL_FEES_LIST @"/open-platform"

#define APP_KEY @"c7fb6cce-0a27-4c99-92b7-79ebbb337713"

#define CATEGORY_ID @"0000000000000001"

#define SERVICE_CHECK_LIST @"op_user_query_payment"

#define SERVICE_PAY        @"op_user_payment"

#define SERVICE_BALANCE_PAY    @"op_user_balance_payment"

#define SECRET_KEY @"5B300719DAD987A0BF2DFDDAC479C823"

#define APP_ID @"1"

@implementation SchoolFeesClient

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}


+ (void)checkFeesPrijectListWithUserid:(NSString *)userid
                     success:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error)) errorMethod
{
    NSString *baseUrlStr = BASE_URL;
    
    NSString *headPOSTStr = [NSString stringWithFormat:@"POST%@/open-platformappkey=%@", baseUrlStr, APP_KEY];
    NSString *middleStr =[NSString stringWithFormat:@"category_id=%@service=%@", CATEGORY_ID, SERVICE_CHECK_LIST];
    NSString *tailStr = [NSString stringWithFormat:@"userid=%@%@", userid, SECRET_KEY];
    
    headPOSTStr = [[headPOSTStr stringByAppendingString:middleStr] stringByAppendingString:tailStr];
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)headPOSTStr, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8));
    
    NSString *sign = [result MD5Digest];
    
    NSDictionary *requstData = @{@"service":SERVICE_CHECK_LIST,
                                 @"appkey":APP_KEY,
                                 @"category_id":CATEGORY_ID,
                                 @"userid":userid,
                                 @"sign":sign
                                 };
    
    [tool JsonPostRequst:CHECK_SCHOOL_FEES_LIST parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (void)paySchoolFeesWithUserid:(NSString *)userid
                        prj_key:(NSString *)prj_key
                      bank_code:(NSString *)bank_code
                   bank_card_no:(NSString *)bank_card_no
                         amount:(NSString *)amount
                   pay_password:(NSString *)pay_password
              is_no_paypassword:(NSString *)is_no_paypassword
                        success:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error)) errorMethod
{
    NSString *baseUrlStr = BASE_URL;

    NSString *headPOSTStr = [NSString stringWithFormat:@"POST%@/open-platformamount=%@appkey=%@bank_card_no=%@bank_code=%@",baseUrlStr,amount, APP_KEY, bank_card_no, bank_code];
    NSString *middleStr =[NSString stringWithFormat:@"category_id=%@prj_key=%@service=%@", CATEGORY_ID, prj_key, SERVICE_PAY];
    NSString *tailStr = [NSString stringWithFormat:@"userid=%@%@",userid, SECRET_KEY];
    
    headPOSTStr = [[headPOSTStr stringByAppendingString:middleStr] stringByAppendingString:tailStr];
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)headPOSTStr, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8));
    
    NSString *sign = [result MD5Digest];
    
    NSDictionary *requstData = nil;
    
    if (pay_password.length > 0) {
        requstData= @{  @"service":SERVICE_PAY,
                        @"appkey":APP_KEY,
                        @"category_id":CATEGORY_ID,
                        @"userid":userid,
                        @"prj_key":prj_key,
                        @"bank_code":bank_code,
                        @"bank_card_no":bank_card_no,
                        @"amount":amount,
                        @"appid":APP_ID,
                        @"pay_password":pay_password,
                        @"is_no_paypassword":@"no",
                        @"sign":sign
                        };
    }else{
        requstData= @{  @"service":SERVICE_PAY,
                        @"appkey":APP_KEY,
                        @"category_id":CATEGORY_ID,
                        @"userid":userid,
                        @"prj_key":prj_key,
                        @"bank_code":bank_code,
                        @"bank_card_no":bank_card_no,
                        @"amount":amount,
                        @"appid":APP_ID,
                        @"pay_password":@"111111",
                        @"is_no_paypassword":@"yes",
                        @"sign":sign
                    };

    }
    
    BNLog(@"parameters--->>>%@",requstData);
    [tool JsonPostRequst:CHECK_SCHOOL_FEES_LIST parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}



+ (void)paySchoolFeesUseBalanceWithUserid:(NSString *)userid
                                 prj_key:(NSString *)prj_key
                                  amount:(NSString *)amount
                            pay_password:(NSString *)pay_password
                       is_no_paypassword:(NSString *)is_no_paypassword
                                 success:(void (^)(NSDictionary *returnData))successMethod
                                 failure:(void (^)(NSError *error)) errorMethod
{
    NSString *baseUrlStr = BASE_URL;
    
    NSString *headPOSTStr = [NSString stringWithFormat:@"POST%@/open-platformamount=%@appkey=%@",baseUrlStr,amount, APP_KEY];
    NSString *middleStr =[NSString stringWithFormat:@"category_id=%@prj_key=%@service=%@", CATEGORY_ID, prj_key, SERVICE_BALANCE_PAY];
    NSString *tailStr = [NSString stringWithFormat:@"userid=%@%@",userid, SECRET_KEY];
    
    headPOSTStr = [[headPOSTStr stringByAppendingString:middleStr] stringByAppendingString:tailStr];
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)headPOSTStr, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8));
    
    NSString *sign = [result MD5Digest];
    NSDictionary *requstData = nil;
    
    if (pay_password.length > 0) {
        requstData = @{  @"service":SERVICE_BALANCE_PAY,
                         @"appkey":APP_KEY,
                         @"category_id":CATEGORY_ID,
                         @"userid":userid,
                         @"prj_key":prj_key,
                         @"amount":amount,
                         @"appid":APP_ID,
                         @"pay_password":pay_password,
                         @"is_no_paypassword":@"no",
                         @"sign":sign
                         };

    }else{
        requstData = @{  @"service":SERVICE_BALANCE_PAY,
                         @"appkey":APP_KEY,
                         @"category_id":CATEGORY_ID,
                         @"userid":userid,
                         @"prj_key":prj_key,
                         @"amount":amount,
                         @"appid":APP_ID,
                         @"pay_password":@"111111",
                         @"is_no_paypassword":@"yes",
                         @"sign":sign
                         };
    }
    
    
    [tool JsonPostRequst:CHECK_SCHOOL_FEES_LIST parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

@end
