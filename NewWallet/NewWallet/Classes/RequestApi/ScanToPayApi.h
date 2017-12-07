//
//  ScanToPayApi.h
//  Wallet
//
//  Created by 陈荣雄 on 16/5/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanToPayApi : NSObject

+ (void)getPayInfo:(NSString *)url succeed:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;
+ (void)createOrder:(id)amount
            shopKey:(id)shopKey
         cashierKey:(id)cashierKey
          qrCodeKey:(id)qrCodeKey
            succeed:(void (^)(NSDictionary *returnData))successMethod
            failure:(void (^)(NSError *error)) errorMethod;

+ (void)checkURLIsInternal:(NSString *)url
                   succeed:(void (^)(NSDictionary *returnData))successMethod
                   failure:(void (^)(NSError *error)) errorMethod;

//付款码页面，test二维码验证接口。
+ (void)testTOTPCodeInfo:(NSString *)codeNumber
                 succeed:(void (^)(NSDictionary *returnData))successMethod
                 failure:(void (^)(NSError *error)) errorMethod;

@end
