//
//  BNPayBankCardBinModel.m
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPayBankCardBinModel.h"

@implementation BNPayBankCardBinModel

@synthesize bankNumber;           //所选银行卡号
@synthesize agreement_bank;
@synthesize bankCardName;
@synthesize bankCardTypeCode;     //所选银行类型
@synthesize bankCardTypeName;
@synthesize bankId;               //所选银行ID
@synthesize bankName;             //所选银行名称
@synthesize maintain_bank;
@synthesize ok;
@synthesize orderNo;
@synthesize partnerId;
@synthesize protocol;
@synthesize resultCode;
@synthesize resultMessage;
@synthesize service;
@synthesize sign;
@synthesize signType;
@synthesize success;
@synthesize version;

-(instancetype)init
{
    self = [super init];
    if (self) {
        bankNumber = @"";           //所选银行卡号
        agreement_bank = @"";
        bankCardName = @"";
        bankCardTypeCode = @"";     //所选银行类型
        bankCardTypeName = @"";
        bankId = @"";               //所选银行ID
        bankName = @"";             //所选银行名称
        maintain_bank = @"";
        ok = @"";
        orderNo = @"";
        partnerId = @"";
        protocol = @"";
        resultCode = @"";
        resultMessage = @"";
        service = @"";
        sign = @"";
        signType = @"";
        success = @"";
        version = @"";
    }
    return self;
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        bankNumber = [dict valueNotNullForKey:@"bankNumber"];           //所选银行卡号
        agreement_bank = [dict valueNotNullForKey:@"agreement_bank"];
        bankCardName = [dict valueNotNullForKey:@"bankCardName"];
        bankCardTypeCode = [dict valueNotNullForKey:@"bankCardTypeCode"];     //所选银行类型
        bankCardTypeName = [dict valueNotNullForKey:@"bankCardTypeName"];
        bankId = [dict valueNotNullForKey:@"bankId"];               //所选银行ID
        bankName = [dict valueNotNullForKey:@"bankName"];             //所选银行名称
        maintain_bank = [dict valueNotNullForKey:@"maintain_bank"];
        ok = [dict valueNotNullForKey:@"ok"];
        orderNo = [dict valueNotNullForKey:@"orderNo"];
        partnerId = [dict valueNotNullForKey:@"partnerId"];
        protocol = [dict valueNotNullForKey:@"protocol"];
        resultCode = [dict valueNotNullForKey:@"resultCode"];
        resultMessage = [dict valueNotNullForKey:@"resultMessage"];
        service = [dict valueNotNullForKey:@"service"];
        sign = [dict valueNotNullForKey:@"sign"];
        signType = [dict valueNotNullForKey:@"signType"];
        success = [dict valueNotNullForKey:@"success"];
        version = [dict valueNotNullForKey:@"version"];
    }
    return self;

}
@end
