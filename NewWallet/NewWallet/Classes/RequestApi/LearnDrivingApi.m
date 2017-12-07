//
//  LearnDrivingApi.m
//  Wallet
//
//  Created by 陈荣雄 on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LearnDrivingApi.h"
#import "TempTool.h"

@implementation LearnDrivingApi

#define GET_DRIVING_CLASS_DETAIL @"/external/driving_server/v1/get_driving_class_detail"
#define SUBMIT_DRIVING_CLASS @"/external/driving_server/v1/confirm_driving_class"
#define GET_DRIVING_RECORD @"/external/driving_server/v1/get_driving_record"
#define CONTINUE_PAY @"/external/driving_server/v1/continue_pay"

NSString *const get_driving_school_list = @"/external/driving_server/v1/get_driving_school_list";
NSString *const get_train_field_list = @"/external/driving_server/v1/get_train_field_list";
NSString *const get_driving_class_list = @"/external/driving_server/v1/get_driving_class_list";
NSString *const get_banner_list = @"/external/driving_server/v1/get_banner_list";


//static TempTool *tool;
//
//+(void)initialize
//{
//    tool = [TempTool shareInstance];
//}


static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

//获取培训班详情
+ (void)getDrivingClassDetail:(NSString *)classKey
                      succeed:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error)) errorMethod {
    
    [tool JsonPostRequst:GET_DRIVING_CLASS_DETAIL parameters:@{@"class_key": classKey} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//确认报名
+ (void)submit:(NSString *)classKey
       payType:(NSNumber *)type
     payAmount:(NSNumber *)amount
      realName:(NSString *)name
 contactMobile:(NSString *)mobile
   redeem_code:(NSString *)redeem
       succeed:(void (^)(NSDictionary *returnData))successMethod
       failure:(void (^)(NSError *error))errorMethod {
    NSDictionary *params;
//    if (redeem.length > 0) {
        params = @{@"class_key": classKey, @"pay_type": type, @"pay_amount": amount, @"real_name": name, @"contact_mobile": mobile, @"redeem_code": redeem};
//    } else {
//        params = @{@"class_key": classKey, @"pay_type": type, @"pay_amount": amount, @"real_name": name, @"contact_mobile": mobile};
//    }
    [tool JsonPostRequst:SUBMIT_DRIVING_CLASS parameters:params success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//学车记录
+ (void)getDrivingRecord:(void (^)(NSDictionary *returnData))successMethod
                 failure:(void (^)(NSError *error))errorMethod {
    
    [tool JsonPostRequst:GET_DRIVING_RECORD parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//从学车记录继续缴费
+ (void)continuePay:(NSString *)recordKey
  installmentSerial:(NSString *)installmentSerial
     installmentFee:(NSString *)installmentFee
       succeed:(void (^)(NSDictionary *returnData))successMethod
       failure:(void (^)(NSError *error))errorMethod {
    
    [tool JsonPostRequst:CONTINUE_PAY parameters:@{@"record_key": recordKey, @"installment_serial": installmentSerial, @"installment_fee": installmentFee} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取推荐驾校列表
+ (void)get_driving_school_list:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:get_driving_school_list parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取训练场地列表
+ (void)get_train_field_list:(NSString *)driving_key
                     succeed:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:get_train_field_list parameters:@{@"driving_key":driving_key} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取培训班列表
+ (void)get_driving_class_list:(NSString *)driving_key
                       succeed:(void (^)(NSDictionary *returnData))successMethod
                       failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:get_driving_class_list parameters:@{@"driving_key":driving_key} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//获取首页banner信息
+ (void)getBanner:(void (^)(NSDictionary *returnData))successMethod
          failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:get_banner_list parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
