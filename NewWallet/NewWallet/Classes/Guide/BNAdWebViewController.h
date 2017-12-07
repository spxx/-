//
//  BNAdWebViewController.h
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
typedef void (^H5ReturnBlock)(void);

@interface BNAdWebViewController : BNBaseViewController

@property (copy, nonatomic) H5ReturnBlock returnBlock;

@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *navTitle;

@end
