//
//  BNLoginViewController.h
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
//typedef NS_ENUM(NSInteger, FromChangeUserOrReset) {
//    FromChangeUserOrReset1 = 1,
//    FromChangeUserOrReset2 = 2,
//};
@interface BNLoginViewController : BNBaseViewController

@property (nonatomic) BOOL isFromChangeUser;
@property (nonatomic) BOOL isFromForget;

@property (nonatomic) BOOL hideBackBtn;

@end
