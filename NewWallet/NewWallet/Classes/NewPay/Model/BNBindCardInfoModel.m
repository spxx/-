//
//  BNBindCardInfoModel.m
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBindCardInfoModel.h"

@implementation BNBindCardInfoModel

@synthesize personalName;             //户主名
@synthesize personalIDNum;            //身份证号
@synthesize personalBankPhone;        //绑定手机号
@synthesize personalVanlidate;        //有效期
@synthesize personalSafeCode;         //安全码
@synthesize personalIsFristBindCard;  //是否首次绑卡
@synthesize personalIsCredit;         //是信用卡

-(instancetype)init
{
    self = [super init];
    if (self) {
        personalName = @"";             //户主名
        personalIDNum = @"";            //身份证号
        personalBankPhone = @"";        //绑定手机号
        personalVanlidate = @"";        //有效期
        personalSafeCode = @"";         //安全码
        personalIsFristBindCard = @"";  //是否首次绑卡
        personalIsCredit = @"";         //是信用卡

    }
    return self;
}
@end
