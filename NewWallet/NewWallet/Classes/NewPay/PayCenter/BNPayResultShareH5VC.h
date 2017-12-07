//
//  BNPayResultShareH5VC.h
//  Wallet
//
//  Created by mac on 2017/03/06.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"
#import "CustomButton.h"

typedef void (^H5BackBlock)(NSDictionary *dict);
typedef void (^AsReaultVCBackBtnBlock)(PayVCJumpType jumpType);

@interface BNPayResultShareH5VC : BNBusinessFinishedBaseVC

@property (copy, nonatomic) H5BackBlock backBlock;
@property (copy, nonatomic) AsReaultVCBackBtnBlock backBtnBlock; //作为支付结果H5页面，点击返回按钮时。

@property (nonatomic) NSDictionary *params;
@property (nonatomic) CustomButton *bindStumpData;


@property (copy, nonatomic) NSString *url;


@end
