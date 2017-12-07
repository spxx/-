//
//  LearnDrivingApi.h
//  Wallet
//
//  Created by 陈荣雄 on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LearnDrivingApi : NSObject



//获取培训班详情
+ (void)getDrivingClassDetail:(NSString *)classKey succeed:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;

//确认报名
+ (void)submit:(NSString *)classKey
       payType:(NSNumber *)type
     payAmount:(NSNumber *)amount
      realName:(NSString *)name
 contactMobile:(NSString *)mobile
   redeem_code:(NSString *)redeem
       succeed:(void (^)(NSDictionary *returnData))successMethod
       failure:(void (^)(NSError *error))errorMethod;


//学车记录
+ (void)getDrivingRecord:(void (^)(NSDictionary *returnData))successMethod
                 failure:(void (^)(NSError *error)) errorMethod;

//从学车记录继续缴费
+ (void)continuePay:(NSString *)recordKey
  installmentSerial:(NSString *)installmentSerial
     installmentFee:(NSString *)installmentFee
            succeed:(void (^)(NSDictionary *returnData))successMethod
            failure:(void (^)(NSError *error))errorMethod;

//获取推荐驾校列表
+ (void)get_driving_school_list:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error)) errorMethod;

//获取训练场地列表
+ (void)get_train_field_list:(NSString *)driving_key
                     succeed:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error)) errorMethod;
//获取培训班列表
+ (void)get_driving_class_list:(NSString *)driving_key
                     succeed:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error)) errorMethod;
//首页获取banner
+ (void)getBanner:(void (^)(NSDictionary *returnData))successMethod
                 failure:(void (^)(NSError *error)) errorMethod;

@end
