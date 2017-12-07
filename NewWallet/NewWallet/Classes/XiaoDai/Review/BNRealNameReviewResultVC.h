//
//  BNRealNameReviewResultVC.h
//  Wallet
//
//  Created by mac1 on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"


@interface BNRealNameReviewResultVC : BNBaseViewController

@property (assign, nonatomic) RealNameReviewResult reviewResult;//实名认证状态，包括实名信息和上传视频的状态

@property (copy,   nonatomic) NSString *errorInfo;//认证出现了错误信息


@end
