//
//  BNUserInfo.m
//  NewWallet
//
//  Created by mac on 14-10-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNUserInfo.h"

@implementation BNUserInfo

@synthesize name;
@synthesize userid;
@synthesize stuempno;
@synthesize ykt_balance; //接口修改，getProfile返回数据不再有ykt_balance字段。
@synthesize yjf_balance;
@synthesize schoolId;
@synthesize schoolName;
@synthesize isCert;
@synthesize is_nopassword;
@synthesize nopassword_amount;
@synthesize bankCardNumbers;
@synthesize cert_no;

@synthesize phoneNumber;

@synthesize yktType;//1则表示学号和一卡通号相同
@synthesize studentno;//学号
@synthesize yjf_bind_id; //易极付id
@synthesize schoolIcon;
@synthesize avatar;

@synthesize user_type;
@synthesize user_type_name;


-(instancetype)init
{
    self = [super init];
    if (self) {
        name = @"";
        userid = @"";
        stuempno = @"";
        ykt_balance = @""; //接口修改，getP
        yjf_balance = @"";
        schoolId = @"";
        schoolName = @"";
        isCert = @"";
        is_nopassword = @"";
        nopassword_amount = @"";
        bankCardNumbers = @"";
        cert_no = @"";
        phoneNumber = @"";
        yktType = @"";
        studentno = @"";//学号
        yjf_bind_id = @"";
        schoolIcon = @"";
        avatar = @"";
        avatar = user_type;
        avatar = user_type_name;

    }
    return self;
}
@end
