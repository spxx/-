//
//  BNCCBISWebViewController.h
//  Wallet
//
//  Created by liuchun on 2017/8/12.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNBaseUIViewController.h"



@interface BNCCBISWebViewController : BNBaseUIViewController

typedef void (^AsReaultVCBackBtnBlock)(PayVCJumpType jumpType);

@property (copy, nonatomic) AsReaultVCBackBtnBlock backBtnBlock; //作为支付结果H5页面，点击返回按钮时。


@property(nonatomic, strong) NSString *htmlUrl;

@end
