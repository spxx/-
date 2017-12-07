//
//  BNXiaoDaiExplainViewController.h
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

#define kDiscripIntroduce @"产品介绍\n\n嘻哈贷，大学生的零钱袋，是喜付联合哈尔滨银行为全国在校大学生量身打造的一款便捷贴心的互联网贷款产品，也是国内率先纳入央行征信的大学生个人贷款产品。"
#define kExplainFuncationIntroduce @"信用额度\n\n嘻哈贷针对各个大学生不同的信用等级有着不同的信用额度，具体会以实际放贷审核结果为准，满足你的生活费借贷，资金周转等需求。"

@protocol BNXiaoDaiExplainViewControllerDelegate <NSObject>

- (void)BNXiaoDaiExplainViewControllerDelegatePopPush;

@end
@interface BNXiaoDaiExplainViewController : BNBaseViewController

@property (weak, nonatomic) id <BNXiaoDaiExplainViewControllerDelegate> delegate;

@end
