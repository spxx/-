//
//  BNBindCardInfoModel.h
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNBindCardInfoModel : NSObject   /*****绑卡时填写的银行卡信息及户主身份信息*****/

@property (strong, nonatomic) NSString *personalName;             //户主名
@property (strong, nonatomic) NSString *personalIDNum;            //身份证号
@property (strong, nonatomic) NSString *personalBankPhone;        //绑定手机号
@property (strong, nonatomic) NSString *personalVanlidate;        //有效期
@property (strong, nonatomic) NSString *personalSafeCode;         //安全码
@property (strong, nonatomic) NSString *personalIsFristBindCard;  //是否首次绑卡
@property (strong, nonatomic) NSString *personalIsCredit;         //是信用卡



@end
