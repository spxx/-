//
//  BNYKTRechargeViewController.h
//  Wallet
//
//  Created by mac1 on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBusinessFinishedBaseVC.h"

@interface BNYKTRechargeViewController : BNBusinessFinishedBaseVC

@property (strong, nonatomic) NSMutableArray *bindedCardsArray;
@property (strong, nonatomic) NSDictionary *yktInfo;
@property (assign, nonatomic) NSInteger dayLimite;

@property (assign, nonatomic) NSInteger transLimite;
@end
