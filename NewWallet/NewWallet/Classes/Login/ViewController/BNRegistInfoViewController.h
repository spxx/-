//
//  BNRegistInfoViewController.h
//  NewWallet
//
//  Created by mac1 on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNRegistInfoViewController : BNBaseViewController

@property (strong, nonatomic) NSArray *schoolListArray;
@property (copy, nonatomic)   NSString *verifycode;
@property (copy, nonatomic)   NSString *registPhone;

@end
