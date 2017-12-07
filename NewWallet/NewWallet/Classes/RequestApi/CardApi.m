//
//  CardApi.m
//  Wallet
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "CardApi.h"
#import "HttpTools.h"

#define  CARDLIST_URL @"/app/v4/binded_cards_list"
#define  YKT_RECHARGE_URL @"/app/v4/ykt_recharge"
#define  YKT_RECHARGE_BALANCE_URL @"/app/v4/ykt_recharge_balance"
#define  YKT_CHECKUSER_URL @"/app/v4/ykt_check"
#define  YKT_REPORTLOSS_URL @"/app/v4/ykt_reportloss"
#define  YKT_CONSUMESLIST_URL @"/app/v4/ykt_consumes_list"
#define SetDefaultCard @"/app/v4/default_card"
#define UnbindCard @"/app/v4/unbind_card"
#define YKT_RECHARGESLIST_URL @"/app/v4/ykt_recharges_list"
#define AGREEMENT_BANK_LIST @"/app/v4/agreement_bank_list"
#define YKT_CHECK_STATUS @"/app/v4/ykt_status"


#define All_CONSUMES_LIST_URL @"/app/v4/order_list"

#define OneCardGetTradeCount @"/app/v4/trade_count"
#define BIND_YKT_NUMBER @"/app/v4/bind_ykt"
#define CHECK_YKT_TYPE @"/app/v4/ykt_type"

#define CHECK_BANK_CARD @"/app/v4/check_bank_card"

#define MODIFY_STUDENT_NUMBER_URL @"/app/member/v1/change_student_number"

@implementation CardApi

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+(void)checkYKTType:(NSString *)userid
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *))errorMethod{
    
    NSDictionary *requstData = @{
                                 @"userid": userid,
                                };
    [tool JsonPostRequst:CHECK_YKT_TYPE parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

+(void)bindYKT:(NSString *)userid
      ykt_type:(NSString *)ykt_type
      stuempno:(NSString *)stuempno
      studentno:(NSString *)studentno
      password:(NSString *)password
    real_name:(NSString *)real_name
                  success:(void (^)(NSDictionary *))successMethod
                  failure:(void (^)(NSError *))errorMethod{
    
    NSDictionary *requstData = nil;
    if(studentno)
    {
        requstData = @{
                       @"userid": userid,
                       @"ykt_type": ykt_type,
                       @"studentno": stuempno,
                       @"real_name": real_name
                       };
    } else if([ykt_type isEqualToString:@"1"] ==  YES)
    {
        requstData = @{
                        @"userid": userid,
                        @"ykt_type": ykt_type,
                        @"stuempno": stuempno,
                        @"real_name": real_name
                     };
    }else{
        requstData = @{
                        @"userid": userid,
                        @"ykt_type": ykt_type,
                        @"stuempno": stuempno,
                        @"password": password,
                        @"real_name": real_name
                       };
    }
    
    [tool JsonPostRequst:BIND_YKT_NUMBER parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}



+(void)oneCardGetTradeCountWithType:(NSString *)busiType
                            success:(void (^)(NSDictionary *))successMethod
                            failure:(void (^)(NSError *))errorMethod
{
    
//    busiType = 1     # to一卡通
//    busiType = 2     # to捐赠
//    busiType = 3     # to手机充值
    NSDictionary *requstData = @{@"busi_type": busiType,
                                 };
    [tool JsonPostRequst:OneCardGetTradeCount parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}



+(void)CardListWithUser:(NSString *)userid success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod{
    
    
    NSDictionary *requstData = @{
                                 @"userid": userid
                                 };
    
    [tool JsonPostRequst:CARDLIST_URL parameters:requstData success:^(id responseObject) {
        
        
        successMethod(responseObject);
        
        
        
    } failure:^(NSError *error) {
 
        errorMethod(error);
        
    }];
}

+(void)yktRechargeWithUerid:(NSString *)userid
                     amount:(NSString *)amount
                   stuempno:(NSString *)stuempno
                   schoolid:(NSString *)schoolid
               bank_card_no:(NSString *)bank_card_no
                  bank_code:(NSString *)bank_code
               ykt_password:(NSString *)ykt_password
             is_no_password:(NSString *)is_no_password
               pay_password:(NSString *)pay_password
                noticePhone:(NSString *)noticePhone
                    success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSMutableDictionary *requstData = [[NSMutableDictionary alloc] init];
    if (pay_password) {
        NSDictionary *info = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"stuempno": stuempno,
                       @"school_id":schoolid,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"ykt_password": ykt_password,
                       @"is_no_password":@"no",
                       @"pay_password":pay_password
                       
                       };
        [requstData setValuesForKeysWithDictionary:info];
    }else {
        NSDictionary *info = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"stuempno": stuempno,
                       @"school_id":schoolid,
                       @"bank_card_no":bank_card_no,
                       @"bank_code":bank_code,
                       @"ykt_password": ykt_password,
                       @"is_no_password":@"yes",
                       };
        [requstData setValuesForKeysWithDictionary:info];
    }
    if (noticePhone.length == 11) {
        [requstData setObject:noticePhone forKey:@"mobile"];
    }

    [tool JsonPostRequst:YKT_RECHARGE_URL parameters:requstData success:^(id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];     //刷新主页充值次数

        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+(void)yktRechargeUseBalanceWithUerid:(NSString *)userid
                                amount:(NSString *)amount
                              stuempno:(NSString *)stuempno
                              schoolid:(NSString *)schoolid
                          ykt_password:(NSString *)ykt_password
                          pay_password:(NSString *)pay_password
                           noticePhone:(NSString *)noticePhone
                               success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSMutableDictionary *requstData = [[NSMutableDictionary alloc] init];
    if (pay_password) {
        NSDictionary *info = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"stuempno": stuempno,
                       @"school_id":schoolid,
                       @"ykt_password": ykt_password,
                       @"is_no_password": @"no",
                       @"pay_password":pay_password
                      };
        [requstData setValuesForKeysWithDictionary:info];
    }else {
        NSDictionary *info = @{
                       @"userid": userid,
                       @"amount": amount,
                       @"stuempno": stuempno,
                       @"school_id":schoolid,
                       @"is_no_password": @"yes",
                       @"ykt_password": ykt_password,
                       };
        [requstData setValuesForKeysWithDictionary:info];
    }
    if (noticePhone.length == 11) {
        [requstData setObject:noticePhone forKey:@"mobile"];
    }
    [tool JsonPostRequst:YKT_RECHARGE_BALANCE_URL parameters:requstData success:^(id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];     //刷新主页充值次数

        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


+(void)checkOneCardUserInfoWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolId:(NSString *)schoolID ykt_password:(NSString *)ykt_password success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    NSDictionary *requstData = @{
                                 @"userid": userid,
                                 @"stuempno": stuempno,
                                 @"school_id": schoolID,
                                 @"ykt_password": ykt_password
                                 };
    [tool JsonPostRequst:YKT_CHECKUSER_URL parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

+(void)oneCardReportLossWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid ykt_password:(NSString *)ykt_password success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    
    NSDictionary *reportLossInfo = @{
                                     @"userid":userid,
                                     @"stuempno":stuempno,
                                     @"ykt_password":ykt_password,
                                     @"school_id":schoolid
                                     };
    [tool JsonPostRequst:YKT_REPORTLOSS_URL parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}


+(void)oneCardConsumes_listWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    NSDictionary *reportLossInfo = @{
                                     @"userid":userid,
                                     @"stuempno":stuempno,
                                     @"school_id":schoolid
                                     };
    [tool JsonPostRequst:YKT_CONSUMESLIST_URL parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)oneCardConsumes_listWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid password:(NSString *)pwd success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    NSDictionary *reportLossInfo = @{
                                     @"userid":userid,
                                     @"stuempno":stuempno,
                                     @"school_id":schoolid,
                                     @"ykt_password":pwd
                                     };
    [tool JsonPostRequst:YKT_CONSUMESLIST_URL parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+ (void)oneCardStususWithUserid:(NSString *)userid stuempno:(NSString *)stuempno schoolID:(NSString *)schoolid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    NSDictionary *reportLossInfo = @{
                                     @"userid":userid,
                                     @"stuempno":stuempno,
                                     @"school_id":schoolid
                                     };
    [tool JsonPostRequst:YKT_CHECK_STATUS parameters:reportLossInfo success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)setDefaultCardwithUserid:(NSString *)userid bankNo:(NSString *)bankNo success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod
{
    NSDictionary *request = @{
                                     @"userid":userid,
                                     @"bank_card_no":bankNo
                                     };
    [tool JsonPostRequst:SetDefaultCard parameters:request success:^(id responseObject) {
        successMethod(responseObject);

    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)unbindCardWithUserid:(NSString *)userid bankNO:(NSString *)bankNo payPwd:(NSString *)payPwd success:(void(^)(NSDictionary *data)) successMethod failure:(void(^)(NSError *error)) errorMethod
{
    NSDictionary *request = @{
                              @"userid":userid,
                              @"bank_card_no":bankNo,
                              @"pay_password":payPwd
                              };
    [tool JsonPostRequst:UnbindCard parameters:request success:^(id responseObject) {
        successMethod(responseObject);

    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}




//.ykt_recharges_list一卡通充值记录
//input: 'userid'
//output:
//{
//    "retcode":'0000',
//    "msg":"成功",
//    "data":{'recharges':[{"status":1,"school_name":"keda","amount":"1.01","create_time":"2014-07-23 16:28:27","stuempno":"1",]}
//                         }
//                         备注：status值说明
//                         1.STATE_CREATE: '创建',
//                         2.STATE_TRANS: '资金充值到一卡通',
//                         3.STATE_PAY: '资金已从银行卡扣除'
//


+(void)oneCardRecharges_listWithUserid:(NSString *)userid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    
    
    NSDictionary *request = @{
                              @"userid":userid,
                              };
    [tool JsonPostRequst:YKT_RECHARGESLIST_URL parameters:request success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}


//agreement_bank_list
//8. agreement_bank_list支持的银行列表
//input: userid
//output:list[]
+(void)getAgreement_bank_listWithUserid:(NSString *)userid success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *))errorMethod{
    
    
    NSDictionary *request = @{
                              @"userid":userid,
                              
                              };
    [tool JsonPostRequst:AGREEMENT_BANK_LIST parameters:request success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}





+(void)checkAllConsumesListWithUserID:(NSString *)userid success:(void(^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *request = @{
                              @"userid":userid,
                              
                              };
    [tool JsonPostRequst:All_CONSUMES_LIST_URL parameters:request success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

//验证银行卡身份信息
+(void)checkBankCardWithUserId:(NSString *)userid
                    bankCardNo:(NSString *)bankCardNo
                       cert_no:(NSString *)cert_no
                       success:(void(^)(NSDictionary *))successMethod
                       failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *request = @{
                              @"userid":userid,
                              @"bank_card_no":bankCardNo,
                              @"cert_no":cert_no,
                              };
    [tool JsonPostRequst:CHECK_BANK_CARD parameters:request success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
    
}

+ (void)modifyStudentNumber:(NSString *)studentNumber
                     userID:(NSString *)userID
                 verifyCode:(NSString *)verifyCode
                    success:(void(^)(NSDictionary *))successHandler
                    failure:(void (^)(NSError *error))errorHandler
{
    NSDictionary *parameters = @{@"newstudentno": studentNumber,
                                 @"userid": userID,
                                 @"verifycode": verifyCode};
    [tool JsonPostRequst:MODIFY_STUDENT_NUMBER_URL parameters:parameters success:^(id responseObject) {
        successHandler(responseObject);
    } failure:^(NSError *error) {
        errorHandler(error);
    }];
}

@end
