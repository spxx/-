//
//  XiaoDaiApi.m
//  Wallet
//
//  Created by cyjjkz1 on 15/5/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "XiaoDaiApi.h"
#import "HttpTools.h"

//实名认证申请
static NSString *const realnameCertifyApply = @"/loan/app/v3/realname_certify/apply";
//实名认证状态查询
static NSString *const realnameCertifyQuery = @"/loan/app/v3/realname_certify/query";
//信用额度申请
static NSString *const creditAmountApply = @"/loan/app/v3/credit_amount/apply";
//查询电子协议
static NSString *const creditAmountQueryEcontract = @"/loan/app/v3/credit_amount/query_econtract";
//视频上传后通知
static NSString *const videoUploaded = @"/loan/app/v3/credit_amount/video_uploaded";
//信用额度查询
static NSString *const creditAmountQuery = @"/loan/app/v3/credit_amount/query";
//申请贷款
static NSString *const Apply = @"/loan/app/v5/apply";
//查询电子借据
static NSString *const queryReceipt = @"/loan/app/v3/query_receipt";
//确认电子借据
static NSString *const confirmReceipt = @"/loan/app/v3/confirm_receipt";
//贷款信息查询
static NSString *const loanInfoQuery = @"/loan/app/v3/query";
//还款计划试算
static NSString *const repaymentPlan = @"/loan/app/v3/simulate_repayment_plan";
//还款
static NSString *const repay = @"/loan/app/v3/repay";
//还款信息查询
static NSString *const repayQuery = @"/loan/app/v3/repay/query";

//审核状态查询
static NSString *const checkCertifyStatus = @"/loan/app/v3/certify_status/query";
//支付密码验证接口
static NSString *const verifyPayPsw = @"/loan/app/v3/verify_pay_passwd";

//请求验证码接口
static NSString *const requestXiaoDaiVerifyCode = @"/loan/app/v3/create_verifycode";
//检验验证码接口
static NSString *const checkXiaoDaiVerifyCode = @"/loan/app/v3/check_verifycode";

/*--------------------------------------------------------------10月27日--------------------------------------------------------------------*/
//新额度申请
static NSString *const new_creditAmoutApply = @"/loan/app/v4/credit_amount/apply";
// 新额度查询接口
static NSString *const new_creditAmoutQuery = @"/loan/app/v4/credit_amount/query";
//新电子协议查询
static NSString *const new_creditAmoutQueryEcontract = @"/loan/app/v4/credit_amount/query_econtract";
//确认电子协议接口
static NSString *const new_creditConfirmEcontract = @"/loan/app/v4/credit_amount/confirm_econtract";
//认证进度查询接口
static NSString *const new_certifyStatusQuery = @"/loan/app/v4/certify_status/query";
//入学年份列表接口
static NSString *const enroll_year_list = @"/loan/app/v4/credit_amount/enroll_year_list";

//还款创单接口
static NSString *const loanCreatOrder = @"/loan/app/v5/repay";

@implementation XiaoDaiApi

static HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}



//查询审核状态
+ (void)checkRealNameReviewStatusWithSuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    [tool JsonPostRequst:checkCertifyStatus parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}




//实名认证申请

+ (void)realnameCertifyApplyWithRealname:(NSString *)realname certType:(NSString *)certType certNumber:(NSString *)certNumber certValidTime:(NSString *)certValidTime certFrontPath:(NSString *)certFrontPath certBackPath:(NSString *)certBackPath holdCertPicPath:(NSString *)holdCertPicPath occupation:(NSString *)occupation mobileNumber:(NSString *)mobileNumber address:(NSString *)address andAttribution:(NSString *)attribution grade:(NSString *)grade email:(NSString *)email success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod
{

    NSDictionary *parameterDic = @{@"real_name":realname,
                                   @"cert_type":certType,
                                   @"cert_no":certNumber,
                                   @"cert_valid_time":certValidTime,
                                   @"cert_front_path":certFrontPath,
                                   @"cert_back_path":certBackPath,
                                   @"hold_cert_pic_path":holdCertPicPath,
                                   @"email":email,
                                   @"grade":grade
//                                   @"occupation":@"111111",
//                                   @"mobile":@"111111",
//                                   @"address":@"111111",
//                                   @"attribution":@"111111"
                                   };
    [tool JsonPostRequst:realnameCertifyApply parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//实名认证状态查询
+ (void)realnameCertifyQuerySuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:realnameCertifyQuery parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//信用额度申请  ---已废弃。改为从实名认证申请接口 /loan/app/v3/realname_certify/apply一起顺便额度申请，只用一个接口。
+ (void)creditAmountApplyWithRealname:(NSString *)realname gender:(NSString *)gender certNumber:(NSString *)certNumber certFrontPath:(NSString *)certFrontPath certBackPath:(NSString *)certBackPath schoolName:(NSString *)schoolName studentNumber:(NSString *)studentNumber grade:(NSString *)grade mobileNumber:(NSString *)mobileNumer email:(NSString *)email monthlyAvgConsume:(NSString *)monthlyAvgConsume monthlyAvgRecharge:(NSString *)monthlyAvgRecharge applyAmount:(NSString *)applyAmount success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod
{
//    NSDictionary *parameterDic = @{
//                                   @"real_name":realname,
//                                   @"gender":gender,
//                                   @"cert_no":certNumber,
//                                   @"cert_front_path":certFrontPath,
//                                   @"cert_back_path":certBackPath,
//                                   @"school_name":schoolName,
//                                   @"student_no":studentNumber,
//                                   @"grade":grade,
//                                   @"email":email,
//                                   @"monthly_avg_consume_amount":monthlyAvgConsume,
//                                   @"monthly_avg_recharge_amount":monthlyAvgRecharge,
//                                   @"apply_amount":applyAmount,
//                                   };
    NSDictionary *parameterDic = @{
                                   @"grade":grade,
                                   @"email":email
                                   };
    [tool JsonPostRequst:creditAmountApply parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//查询电子协议
+ (void)queryEcontractSuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:creditAmountQueryEcontract parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//视频上传后通知
+ (void)videoUploadedWithOrderNumber:(NSString *)orderNumber videoPath:(NSString *)videoPath success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"order_no":orderNumber,
                                   @"video_path":videoPath,
                                   };
    [tool JsonPostRequst:videoUploaded parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

//信用额度查询
+ (void)creditamountQuerySuccess:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:creditAmountQuery parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

//申请贷款
+ (void)loanApplyWithcertNumber:(NSString *)certNumber cardNumber:(NSString *)cardNumber applyAmount:(NSString *)applyAmount repaymentType:(NSString *)repaymentType installments:(NSString *)installments mobileNumber:(NSString *)mobileNumber psw:(NSString *)psw verifycode:(NSString *)verifycode success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    if (installments == nil || [installments isEqualToString:@""] ) {
        installments = @"3";
    }
    NSDictionary *parameterDic = @{
//                                   @"cert_no":certNumber,
                                   @"card_no":cardNumber,
                                   @"apply_amount":applyAmount,
                                   @"repayment_type":repaymentType,
                                   @"installments":installments,
//                                   @"mobile":mobileNumber,
//                                   @"pay_passwd":psw,
                                   @"verifycode":verifycode
                                   };
    BNLog(@"申请贷款接口参数----->>>>> %@",parameterDic);
    [tool JsonPostRequst:Apply parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//查询电子借据
+ (void)queryReceiptWithOrderNumber:(NSString *)orderNumber success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"order_no":orderNumber
                                   };
    [tool JsonPostRequst:queryReceipt parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//确认电子借据
+ (void)confirmReceiptWithOrderNumber:(NSString *)orderNumber agree:(NSString *)agree success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"order_no":orderNumber,
                                   @"agree":agree
                                   };
    [tool JsonPostRequst:confirmReceipt parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//贷款信息查询
+ (void)loanQuerySuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:loanInfoQuery parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//还款计划试算
+ (void)simulateRepaymentPlanWithGrade:(NSString *)grade applyAmount:(NSString *)applyAmount repaymentType:(NSString *)repaymentType installments:(NSString *)installments success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"grade":grade,
                                   @"apply_amount":applyAmount,
                                   @"repayment_type":repaymentType
                                  // @"installments":installments
                                   };
    [tool JsonPostRequst:repaymentPlan parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//还款
+ (void)repayWithOrderNumber:(NSString *)orderNumber bankCardNumber:(NSString *)bankCardNumber psw:(NSString *)psw repayAmount:(NSString *)repayAmount repayRestInstallments:(NSString *)repayRestInstallments success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"order_no":orderNumber,
                                   @"card_no" : bankCardNumber,
                                   @"pay_passwd" : psw,
                                   @"repay_amount":repayAmount,
                                   @"repay_rest_installments":repayRestInstallments
                                   };
    [tool JsonPostRequst:repay parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//还款信息查询
+ (void)repayQueryWithOrderNumber:(NSString *)orderNumber success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    if (orderNumber && orderNumber.length > 0) {
        NSDictionary *parameterDic = @{
                                       @"order_no":orderNumber
                                       };
        [tool JsonPostRequst:repayQuery parameters:parameterDic success:^(id responseObject) {
            successMethod(responseObject);
        } failure:^(NSError *error) {
            errorMethod(error);
        }];
    } else{
        [tool JsonPostRequst:repayQuery parameters:nil success:^(id responseObject) {
            successMethod(responseObject);
        } failure:^(NSError *error) {
            errorMethod(error);
        }];
    }

}

//支付密码验证接口
+ (void)verifyPayPasswd:(NSString *)payPasswd success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod
{
    NSDictionary *parameterDic = @{
                                   @"pay_passwd":payPasswd
                                   };
    [tool JsonPostRequst:verifyPayPsw parameters:parameterDic success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];

}

+(void)requestXiaoDaiVerifyCode:(NSString *)moblieNumber success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": moblieNumber
                                 };
    [tool JsonPostRequst:requestXiaoDaiVerifyCode parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+(void)checkXiaoDaiVerifyCode:(NSString *)phone verifyCode:(NSString *)verifyCode success:(void (^)(NSDictionary *))successMethod failure:(void (^)(NSError *error)) errorMethod
{
    NSDictionary *requstData = @{
                                 @"mobile": phone,
                                 @"verifycode": verifyCode
                                 };
    [tool JsonPostRequst:checkXiaoDaiVerifyCode parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

/*--------------------------------------------------------------10月27日--------------------------------------------------------------------*/

//新额度申请接口
+ (void)newCreditAmountApplyWithRealName:(NSString *)realName certNumber:(NSString *)cerNumber certFrontPath:(NSString *)frontPath mobile:(NSString *)mobile grade:(NSString *)grade degree:(NSString *)degree andEnrollYear:(NSString *)enrollYear success:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;
{
    NSMutableDictionary *dict = @{
                                  @"real_name":realName,
                                  @"cert_no":cerNumber,
                                  @"cert_front_path":frontPath,
                                  @"grade":grade,
                                  @"enroll_year":enrollYear,
                                  }.mutableCopy;
    if (mobile.length > 0) {
        [dict setObject:mobile forKey:@"mobile"];
    }
    BNLog(@"parameters-->>>%@",dict);
    [tool JsonPostRequst:new_creditAmoutApply parameters:dict success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

// 新额度查询接口
+ (void)newAmoutQuerySuccess:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod
{
    [tool JsonPostRequst:new_creditAmoutQuery parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

// 新电子协议查询接口
+ (void)newCreditAmountQueryEcontractSuccess:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod
{
    [tool JsonPostRequst:new_creditAmoutQueryEcontract parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

// 确认电子协议接口
+ (void)newConfirmEcontractWithAgree:(NSString *)agree success:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod
{
    [tool JsonPostRequst:new_creditConfirmEcontract parameters:@{@"agree":agree} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

//认证进度查询接口
+ (void)newCertifyStatusQuerySuccess:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod
{
    [tool JsonPostRequst:new_certifyStatusQuery parameters:nil success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (void)getEnrollYearList:(void(^)(NSDictionary *successData))successBlock failure:(void(^)(NSError *error))failureBlock
{
    [tool JsonPostRequst:enroll_year_list parameters:nil success:^(id responseObject) {
        successBlock(responseObject);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

//还款创单接口
+(void)loanCreatOrderWithProjectOrder_no:(NSString *)order_no
                            repay_amount:(NSString *)repay_amount
                 repay_rest_installments:(NSString *)repay_rest_installments
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *error)) errorMethod
{
//    order_no 还款订单号(和之前调用接口保持一致)
//    repay_amount 还款金额(和之前调用接口保持一致)
//    repay_rest_installments 剩余分期(和之前调用接口保持一致)
    NSDictionary *requstData = @{
                                 @"order_no": order_no,
                                 @"repay_amount": repay_amount,
                                 @"repay_rest_installments": repay_rest_installments
                                 };
    [tool JsonPostRequst:loanCreatOrder parameters:requstData success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
@end
