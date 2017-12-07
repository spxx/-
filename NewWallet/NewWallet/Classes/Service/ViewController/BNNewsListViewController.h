//
//  BNNewsListViewController.h
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

typedef NS_ENUM(NSInteger, NewsListViewControllerUseStyle) {
    NewsListViewControllerUseStyleYKT,//一卡通
    NewsListViewControllerUseStyleXIFU//喜付
    
};

@interface BNNewsListViewController : BNBaseViewController

@property (assign, nonatomic) NewsListViewControllerUseStyle useStyle;

@end
