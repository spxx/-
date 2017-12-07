//
//  BNLivesTableViewCell.h
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNLivesViewController.h"

@interface BNLivesTableViewCell : UITableViewCell

//最后一行需要描边
- (void)drawDataWithType:(LivesType)livesType isLastLine:(BOOL)isLast;

//费用领取使用
- (void)drawDataWithType:(LivesType)livesType isLastLine:(BOOL)isLast isHasNotCollectFees:(BOOL)hasNotCollectFees;
@end
