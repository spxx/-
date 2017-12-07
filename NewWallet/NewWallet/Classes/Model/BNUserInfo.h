//
//  BNUserInfo.h
//  NewWallet
//
//  Created by mac on 14-10-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNUserInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *stuempno;//一卡通号
@property (strong, nonatomic) NSString *ykt_balance;
@property (strong, nonatomic) NSString *yjf_balance;
@property (strong, nonatomic) NSString *schoolId;
@property (strong, nonatomic) NSString *schoolName;
@property (strong, nonatomic) NSString *is_nopassword;
@property (strong, nonatomic) NSString *nopassword_amount;
@property (strong, nonatomic) NSString *isCert;
@property (strong, nonatomic) NSString *bankCardNumbers;
@property (strong, nonatomic) NSString *cert_no;

@property (strong, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *invitedCode;//邀请码
@property (copy, nonatomic) NSString *yjf_bind_id; //易极付id

//增加一卡通type和学号
@property (strong, nonatomic) NSString *yktType;
@property (strong, nonatomic) NSString *studentno;//学号

@property (copy, nonatomic) NSString *schoolIcon;
@property (copy, nonatomic) NSString *avatar;

@property (copy, nonatomic) NSString *user_type;
@property (copy, nonatomic) NSString *user_type_name;

@end
