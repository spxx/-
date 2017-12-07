//
//  BNPayBankCardBinModel.h
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNPayBankCardBinModel : NSObject      /*****银行卡信息*****/

@property (strong, nonatomic) NSString *bankNumber;           //所选银行卡号

@property (strong, nonatomic) NSString *agreement_bank;
@property (strong, nonatomic) NSString *bankCardName;
@property (strong, nonatomic) NSString *bankCardTypeCode;     //所选银行类型
@property (strong, nonatomic) NSString *bankCardTypeName;
@property (strong, nonatomic) NSString *bankId;               //所选银行ID
@property (strong, nonatomic) NSString *bankName;             //所选银行名称
@property (strong, nonatomic) NSString *maintain_bank;
@property (strong, nonatomic) NSString *ok;
@property (strong, nonatomic) NSString *orderNo;
@property (strong, nonatomic) NSString *partnerId;
@property (strong, nonatomic) NSString *protocol;
@property (strong, nonatomic) NSString *resultCode;
@property (strong, nonatomic) NSString *resultMessage;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) NSString *sign;
@property (strong, nonatomic) NSString *signType;
@property (strong, nonatomic) NSString *success;
@property (strong, nonatomic) NSString *version;


- (instancetype)initWithDict:(NSDictionary *)dict;


/*For Example
{
    "agreement_bank" = no;
    bankCardName = "\U592a\U5e73\U6d0b\U4eba\U6c11\U5e01\U8d37\U8bb0\U5361";
    bankCardTypeCode = CREDIT;
    bankCardTypeName = "\U8d37\U8bb0\U5361";
    bankId = COMM;
    bankName = "\U4ea4\U901a\U94f6\U884c";
    "maintain_bank" = no;
    ok = 1;
    orderNo = 2015121715803911;
    partnerId = 20140730020001144381;
    protocol = httpPost;
    resultCode = "EXECUTE_SUCCESS";
    resultMessage = "\U6210\U529f";
    service = bankCardBinQuery;
    sign = 0c80ef253fe1f5fd268915a33f5ef74b;
    signType = MD5;
    success = 1;
    version = "1.0";
};
*/
@end
