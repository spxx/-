//
//  BNPayFeesExplainViewController.h
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
#import "CustomButton.h"

#define kFuncationIntroduce @"功能介绍\n\n喜付将与学校积极合作，今后可以在喜付上面\n缴纳各种费用了！包含：学杂费、考试费、培\n训费等。"

@interface BNPayFeesExplainViewController : BNBaseViewController
@property (nonatomic) NSString *h5Url;
@property (nonatomic) CustomButton *bindStumpData;


@end
