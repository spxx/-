//
//  PartApi.m
//  Wallet
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "PartApi.h"
#import "HttpTools.h"
//#define PART_PROFILR @"app/part_profile"
#define PART_FEE @"/app/v2/part_fee"
#define PART_FEES_LIST @"/app/v2/part_fees_list"

@implementation PartApi

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

//+(void)getPartProfileInfo:(NSString *)userid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
//    NSDictionary *parameters = @{@"userid": userid};
//
//    [tool JsonPostRequst:PART_PROFILR parameters:parameters success:^(id responseObject) {
//        successMethod(responseObject);
//    } failure:^(NSError *error) {
//        errorMethod(error);
//    }];
//
//}


+(void)payPartFeeWithAmount:(NSString *)fee_id userid:(NSString *)userid bankCardNo:(NSString *)bankCardNo password:(NSString *)password bank_code:(NSString *)bankCode success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error))errorMethod{


    NSDictionary *parameters = @{
                                 @"fee_id": fee_id,
                                 @"userid": userid,
                                 @"bank_card_no": bankCardNo,
                                 @"pay_password": password,
                                 @"bank_code": bankCode
                                 };
    
    [tool JsonPostRequst:PART_FEE parameters:parameters success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

+(void)getPartFeesListWithUserid:(NSString *)userid stuempno:(NSString *)stuempno is_finish:(NSString *)is_finish success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    
    NSDictionary *parameters = @{
                                 @"userid": userid,
                                 @"stuempno": stuempno,
                                 @"is_finish": is_finish
                                 
                                 };
    
    [tool JsonPostRequst:PART_FEES_LIST parameters:parameters success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


@end
