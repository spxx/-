//
//  BNSetLoginPwdViewController.h
//  NewWallet
//
//  Created by mac1 on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNSetLoginPwdViewController : BNBaseViewController

@property (strong, nonatomic) NSDictionary *registInfoDictionary;

@property (assign, nonatomic) ViewControllerUseStyle useStyle;

@property (strong, nonatomic) NSString *oldLoginPassword;

@end
