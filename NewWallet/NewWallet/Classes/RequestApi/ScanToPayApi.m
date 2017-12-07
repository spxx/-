//
//  ScanToPayApi.m
//  Wallet
//
//  Created by 陈荣雄 on 16/5/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "ScanToPayApi.h"

@implementation ScanToPayApi

#define CREATE_ORDER @"/external/shop_pay_biz/v1/create_order"
#define CHECK_URL_INTERNAL @"/external/config_center/v1/query_url_attribution"

#define QR_Test_CompareQRCode @"/qr_pay_server/external/vq/qr_pay_checkup"

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+ (void)getPayInfo:(NSString *)url succeed:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod {
    [tool JsonGetRequst:url parameters:nil headers:@{@"User-Agent": @"XifuApp"} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (void)createOrder:(id)amount
         shopKey:(id)shopKey
         cashierKey:(id)cashierKey
          qrCodeKey:(id)qrCodeKey
            succeed:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod {
    [tool JsonPostRequst:CREATE_ORDER parameters:@{@"amount": amount, @"shop_key": shopKey, @"cashier_key": cashierKey, @"qr_code_key": qrCodeKey} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (void)checkURLIsInternal:(NSString *)url succeed:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod {
	[tool JsonPostRequst:CHECK_URL_INTERNAL parameters:@{@"url": url} success:^(id responseObject) {
		successMethod(responseObject);
	} failure:^(NSError *error) {
		errorMethod(error);
	}];
}

//付款码页面，test二维码验证接口。
+ (void)testTOTPCodeInfo:(NSString *)codeNumber
                 succeed:(void (^)(NSDictionary *returnData))successMethod
                 failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:@"/verify_qr" parameters:@{@"qr_code" : codeNumber} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
@end
