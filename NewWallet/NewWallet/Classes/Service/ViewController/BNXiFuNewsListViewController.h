//
//  BNXiFuNewsListViewController.h
//  NewWallet
//
//  Created by mac on 15-09-22.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
#import "BNNewsListViewController.h"

//typedef NS_ENUM(NSInteger, NewsListViewControllerUseStyle) {
//    NewsListViewControllerUseStyleYKT,//一卡通
//    NewsListViewControllerUseStyleXIFU//喜付
//    
//};

typedef NS_ENUM(NSInteger, EnterMode) {
    EnterModeFromNotificationCenter,//从通知中心进入
    EnterModeFromVC//从服务列表界面进入
};


@interface BNXiFuNewsListViewController : BNBaseViewController

@property (assign, nonatomic) NewsListViewControllerUseStyle useStyle;
@property (assign, nonatomic) EnterMode enterMode;

@end
