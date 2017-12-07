//
//  BNVeinCreditOrderDetailVC.h
//  Wallet
//
//  Created by xjy on 17/6/21.
//  Copyright (c) 2017年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"
typedef void (^ReturnRefreshBlock)(void);

@interface BNVeinCreditOrderDetailVC : BNBusinessFinishedBaseVC

@property (nonatomic) NSDictionary *dict;
@property (copy, nonatomic) ReturnRefreshBlock returnRefreshBlock;

@end
