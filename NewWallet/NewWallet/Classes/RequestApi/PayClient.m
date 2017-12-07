//
//  PayClient.m
//  Wallet
//
//  Created by Lcyu on 14-7-23.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "PayClient.h"
#import "HttpTools.h"


#define kSelectCardNo @"/app/v4/card_bin"
#define kBindCard @"/app/v4/bind_card"

#define kPreBindCard  @"/app/v4/pre_bind_card"
#define kRequestVerifyCodeBankMobile @"/app/v4/verifycode_bank_mobile"

#define kForgetPayPassword @"/app/v4/forget_pay_password"

@implementation PayClient

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}


+(void)getVerifycodeForAddCard:(NSString *)bankMobile success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": bankMobile
                                 };
    [tool JsonPostRequst:kRequestVerifyCodeBankMobile parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)fetchCardInfoWithUserID:(NSString *)userid bankCardNo:(NSString *)bankCardNo success:(void(^)(NSDictionary *data)) successMethod failure:
    (void(^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:kSelectCardNo parameters:@{
                                                    @"userid":userid,
                                                    @"bank_card_no":bankCardNo
                                                    } success:^(id responseObject) {
                                                        successMethod(responseObject);
                                                    } failure:^(NSError *error) {
                                                        errorMethod(error);
                                                    }];
}

+(void)preBindCardWithUserid:(NSString *)userid bankType:(NSString *)bankType bankCardNo:(NSString *)bankCardNo is_cert:(NSString *)isCert is_credit:(NSString *)isCredit realName:(NSString *)realName certNo:(NSString*)certNo  bankMobile:(NSString *) bankMobile  cardValidate:(NSString *)cardValidate safeCode:(NSString *)safeCode success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod
{
    NSDictionary *parmData = nil;
    if ([isCert isEqualToString:@"yes"]) {
        if ([isCredit isEqualToString:@"yes"]) {
            parmData = @{ @"userid":userid,
                          @"bank_type":bankType,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":isCredit,
                          @"bank_mobile":bankMobile,
                          @"name":realName,
                          @"cert_no":certNo,
                          @"cert_valid_date":cardValidate,
                          @"ccv2":safeCode
                          };
        }else{
            parmData = @{ @"userid":userid,
                          @"bank_type":bankType,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":isCredit,
                          @"bank_mobile":bankMobile,
                          @"name":realName,
                          @"cert_no":certNo
                
                          };
        }
       
    }else{
        if ([isCredit isEqualToString:@"yes"]) {
            parmData = @{ @"userid":userid,
                          @"bank_type":bankType,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":isCredit,
                          @"bank_mobile":bankMobile,
                          @"cert_valid_date":cardValidate,
                          @"ccv2":safeCode
                          };
        }else{
            parmData = @{ @"userid":userid,
                          @"bank_type":bankType,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":isCredit,
                          @"bank_mobile":bankMobile,

                          };
        }

    }
    
    [tool JsonPostRequst:kPreBindCard parameters:parmData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)bindCard:(NSString *)bankId bankCardNo:(NSString *)bankCardNo is_cert:(NSString *)isCert isCredit:(NSString *)isCredit userid:(NSString *)userid payPassWord:(NSString *) payPassWord mobile:(NSString*) bankMobile  realName:(NSString *)realName  certNo:(NSString*)certNo safeCode:(NSString *)safeCode certValidate:(NSString *)certValidate verifyCode:(NSString *)verifycode success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod
{
    NSDictionary *parmData = nil;
    if ([isCert isEqualToString:@"yes"]) {
        if ([isCredit isEqualToString:@"yes"] ) {//首次绑信用卡
            parmData = @{ @"userid":userid,
                          @"bank_type":bankId,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":@"yes",
                          @"bank_mobile":bankMobile,
                          @"pay_password":payPassWord,
                          @"name":realName,
                          @"cert_no":certNo,
                          @"ccv2":safeCode,
                          @"cert_valid_date":certValidate,
                          @"verifycode" : verifycode
                          };
            
        }else{//首次绑非信用卡
            
            parmData = @{ @"userid":userid,
                          @"bank_type":bankId,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":@"no",
                          @"bank_mobile":bankMobile,
                          @"pay_password":payPassWord,
                          @"name":realName,
                          @"cert_no":certNo,
                          @"verifycode" : verifycode
                          };
            
        }

    }else{
        if ([isCredit isEqualToString:@"yes"] ) {//非首次绑信用卡
            parmData = @{ @"userid":userid,
                          @"bank_type":bankId,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":@"yes",
                          @"bank_mobile":bankMobile,
                          @"ccv2":safeCode,
                          @"cert_valid_date":certValidate,
                          @"verifycode" : verifycode
                          };
            
        }else{//非首次绑非信用卡
            
            parmData = @{ @"userid":userid,
                          @"bank_type":bankId,
                          @"bank_card_no":bankCardNo,
                          @"is_cert":isCert,
                          @"is_credit":@"no",
                          @"bank_mobile":bankMobile,
                          @"verifycode" : verifycode
                          };
            
        }

    }
    
    [tool JsonPostRequst:kBindCard parameters:parmData success:^(id responseObject) {
                                                        successMethod(responseObject);
                                                    } failure:^(NSError *error) {
                                                        errorMethod(error);
                                                    }];
}
//非首次绑卡
//+(void)noOneBindCard:(NSString *)bankType bankCardNo:(NSString *)bankCardNo is_cert:(NSString *)isCert userid:(NSString *)userid payPassWord:(NSString *) payPassWord mobile:(NSString*) mobile certNo:(NSString*)certNo certValidate:(NSString *)certValidate  realName:(NSString *)realname  success:(void(^)(NSDictionary *data)) successMethod failure:
//(void(^)(NSError *error)) errorMethod
//{
//    [tool JsonPostRequst:kBindCard parameters:@{
//                                                @"bank_type":bankType,
//                                                @"bank_card_no":bankCardNo,
//                                                @"is_cert":@"no",
//                                                @"userid":userid,
//                                                @"pay_password":@" ",
//                                                @"mobile":mobile,
//                                                @"cert_no":@" ",
//                                                @"cert_valid_date":@" ",
//                                                @"name":@" "
//                                                } success:^(id responseObject) {
//                                                    successMethod(responseObject);
//                                                } failure:^(NSError *error) {
//                                                    errorMethod(error);
//                                                }];
//}

//忘记支付密码
+(void)forgetPayPasswordWithUserID:(NSString *)userid
                        bankCardNo:(NSString *)bankCardNo
                           cert_no:(NSString *)cert_no
                      pay_password:(NSString *)pay_password
                           success:(void(^)(NSDictionary *data))successMethod
                           failure:(void(^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:kForgetPayPassword parameters:@{
                                                    @"userid":userid,
                                                    @"bank_card_no":bankCardNo,
                                                    @"cert_no":cert_no,
                                                    @"pay_password":pay_password
                                                    } success:^(id responseObject) {
                                                        successMethod(responseObject);
                                                    } failure:^(NSError *error) {
                                                        errorMethod(error);
                                                    }];
}
@end
