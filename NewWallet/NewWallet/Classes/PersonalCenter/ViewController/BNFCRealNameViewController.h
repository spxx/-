//
//  BNFCRealNameViewController.h
//  Wallet
//
//  Created by cyjjkz1 on 15/6/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef void (^RealNameReturnBlock)(void);

@interface BNFCRealNameViewController : BNBaseViewController

@property (copy, nonatomic) RealNameReturnBlock RealNameSubmitedBlock;

@end
