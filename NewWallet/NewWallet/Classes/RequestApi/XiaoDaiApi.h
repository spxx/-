//
//  XiaoDaiApi.h
//  Wallet
//
//  Created by cyjjkz1 on 15/5/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 *小贷实名认证的状态
 *
 **/

#define    kBNXiaoDaiRealNameCertifyStatus_NOA    @"NOA" //未认证
#define    kBNXiaoDaiRealNameCertifyStatus_AUT    @"AUT" //认证中
#define    kBNXiaoDaiRealNameCertifyStatus_ATP    @"ATP" //认证通过
#define    kBNXiaoDaiRealNameCertifyStatus_ATN    @"ATN" //认证失败
#define    kBNXiaoDaiRealNameCertifyStatus_UPF    @"UPF" //升级失败




@interface XiaoDaiApi : NSObject

/**
 *
 *查询审核状态
 *
 **/

+ (void)checkRealNameReviewStatusWithSuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;


/**
 *
 *实名认证申请接口
 *
 **/

+ (void)realnameCertifyApplyWithRealname:(NSString *)realname certType:(NSString *)certType certNumber:(NSString *)certNumber certValidTime:(NSString *)certValidTime certFrontPath:(NSString *)certFrontPath certBackPath:(NSString *)certBackPath holdCertPicPath:(NSString *)holdCertPicPath occupation:(NSString *)occupation mobileNumber:(NSString *)mobileNumber address:(NSString *)address andAttribution:(NSString *)attribution grade:(NSString *)grade email:(NSString *)email success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *
 *实名认证状态查询接口
 *
 **/
+ (void)realnameCertifyQuerySuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error))errorMethod;

/**
 *
 *信用额度申请接口  ---已废弃。改为从实名认证申请接口 /loan/app/v3/realname_certify/apply一起顺便额度申请，只用一个接口。

 *
 **/
+ (void)creditAmountApplyWithRealname:(NSString *)realname gender:(NSString *)gender certNumber:(NSString *)certNumber certFrontPath:(NSString *)certFrontPath certBackPath:(NSString *)certBackPath schoolName:(NSString *)schoolName studentNumber:(NSString *)studentNumber grade:(NSString *)grade mobileNumber:(NSString *)mobileNumer email:(NSString *)email monthlyAvgConsume:(NSString *)monthlyAvgConsume monthlyAvgRecharge:(NSString *)monthlyAvgRecharge applyAmount:(NSString *)applyAmount success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *
 *查询电子协议接口
 *
 **/
+ (void)queryEcontractSuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error))errorMethod;
/**
 *
 *视频上传后通知
 *
 **/
+ (void)videoUploadedWithOrderNumber:(NSString *)orderNumber videoPath:(NSString *)videoPath success:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error)) errorMethod;
/**
 *
 *信用额度查询接口
 *
 **/
+ (void)creditamountQuerySuccess:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;
/**
 *
 *申请贷款接口
 *
 **/
+ (void)loanApplyWithcertNumber:(NSString *)certNumber cardNumber:(NSString *)cardNumber applyAmount:(NSString *)applyAmount repaymentType:(NSString *)repaymentType installments:(NSString *)installments mobileNumber:(NSString *)mobileNumber psw:(NSString *)psw verifycode:(NSString *)verifycode success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;
/**
 *
 *查询电子借据
 *
 **/
+ (void)queryReceiptWithOrderNumber:(NSString *)orderNumber success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;
/**
 *
 *确认电子借据
 *
 **/
+ (void)confirmReceiptWithOrderNumber:(NSString *)orderNumber agree:(NSString *)agree success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;
/**
 *
 *贷款信息查询接口
 *
 **/
+ (void)loanQuerySuccess:(void (^)(NSDictionary *returnData))successMethod failure:(void (^)(NSError *error))errorMethod;
/**
 *
 *还款计划试算接口
 *
 **/
+ (void)simulateRepaymentPlanWithGrade:(NSString *)grade applyAmount:(NSString *)applyAmount repaymentType:(NSString *)repaymentType installments:(NSString *)installments success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;
/**
 *
 *还款接口
 *
 **/
+ (void)repayWithOrderNumber:(NSString *)orderNumber bankCardNumber:(NSString *)bankCardNumber psw:(NSString *)psw repayAmount:(NSString *)repayAmount repayRestInstallments:(NSString *)repayRestInstallments success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;
/**
 *
 *还款信息查询接口
 *
 **/

+ (void)repayQueryWithOrderNumber:(NSString *)orderNumber success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;

/**
 *
 *支付密码验证接口
 *
 **/
+ (void)verifyPayPasswd:(NSString *)payPasswd success:(void(^)(NSDictionary *returnData))successMethod failure:(void(^)(NSError *error))errorMethod;

/**
 *  请求验证码
 *
 *  @param moblieNumber 发送到手机号
 */
+(void)requestXiaoDaiVerifyCode:(NSString *)moblieNumber success:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

/**
 *  检验验证码
 *
 *  @param username   注册手机号
 *  @param verifyCode 验证码
 */
+(void)checkXiaoDaiVerifyCode:(NSString *)username verifyCode:(NSString *)verifyCode success:(void(^)(NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

/*--------------------------------------------------------------10月27日--------------------------------------------------------------------*/

//新额度申请接口
+ (void)newCreditAmountApplyWithRealName:(NSString *)realName certNumber:(NSString *)cerNumber certFrontPath:(NSString *)frontPath mobile:(NSString *)mobile grade:(NSString *)grade degree:(NSString *)degree andEnrollYear:(NSString *)enrollYear success:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

//新额度查询接口
+ (void)newAmoutQuerySuccess:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;


// 新电子协议查询接口
+ (void)newCreditAmountQueryEcontractSuccess:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

// 确认电子协议接口
+ (void)newConfirmEcontractWithAgree:(NSString *)agree success:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

//认证进度查询接口
+ (void)newCertifyStatusQuerySuccess:(void(^) (NSDictionary *successData)) successMethod failure:(void(^) (NSError *error)) errorMethod;

//获取入学年份
+ (void)getEnrollYearList:(void(^)(NSDictionary *successData))successBlock failure:(void(^)(NSError *error))failureBlock;

//还款创单接口
+(void)loanCreatOrderWithProjectOrder_no:(NSString *)order_no
                            repay_amount:(NSString *)repay_amount
                 repay_rest_installments:(NSString *)repay_rest_installments
                                 success:(void (^)(NSDictionary *))successMethod
                                 failure:(void (^)(NSError *error)) errorMethod;
@end
