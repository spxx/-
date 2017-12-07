//
//  PartApi.h
//  Wallet
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartApi : NSObject

//+(void)getPartProfileInfo:(NSString *)userid success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error))errorMethod;



+ (void)payPartFeeWithAmount:(NSString *)fee_id userid:(NSString *)userid bankCardNo:(NSString *)bankCardNo password:(NSString *)password bank_code:(NSString *)bankCode success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error))errorMethod;;




+ (void)getPartFeesListWithUserid:(NSString *)userid stuempno:(NSString *)stuempno is_finish:(NSString *)is_finish  success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error))errorMethod;


@end
