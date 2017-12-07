//
//  BNBillDetailVC.h
//  Wallet
//
//  Created by mac on 15/12/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"
typedef void (^ReturnRefreshBlock)(void);

@interface BNBillDetailVC : BNBusinessFinishedBaseVC

@property (nonatomic) NSDictionary *dict;
@property (copy, nonatomic) ReturnRefreshBlock returnRefreshBlock;

@end
