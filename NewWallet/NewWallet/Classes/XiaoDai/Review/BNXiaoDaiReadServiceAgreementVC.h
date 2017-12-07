//
//  BNXiaoDaiReadServiceAgreementVC.h
//  Wallet
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
//协议类型
typedef NS_ENUM(NSInteger, XiaoDaiProtocalType) {
    XiaoDaiProtocalTypeService,            //嘻哈贷服务协议
    XiaoDaiProtocalTypeServiceOnlyRead,     //嘻哈贷服务协议_阅读而已——从关于嘻哈贷进入
    XiaoDaiProtocalTypeElectronTicket,      //嘻哈贷电子借据
    XiaoDaiProtocalTypeElectronTicketOnlyRead,     //嘻哈贷电子借据_阅读而已
};
@interface BNXiaoDaiReadServiceAgreementVC : BNBaseViewController

@property (nonatomic) XiaoDaiProtocalType protocalType;

@property (strong, nonatomic) NSString *orderNO;
@property (strong, nonatomic) NSString *econtractProtocol;

@end
