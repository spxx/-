//
//  BNNetRemainFeesViewController.m
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNNetRemainFeesViewController.h"

@interface BNNetRemainFeesViewController ()

@end

@implementation BNNetRemainFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"余额查询";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 1);
    scrollView.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:scrollView];
    
    UIView *topBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 9 * NEW_BILI, SCREEN_WIDTH, 100.5 * NEW_BILI)];
    topBGView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:topBGView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16 * NEW_BILI, 50 * NEW_BILI, SCREEN_WIDTH - 16 * NEW_BILI, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [topBGView addSubview:line];
    
    UILabel *school = [[UILabel alloc] initWithFrame:CGRectMake(16 * NEW_BILI, 15 * NEW_BILI, SCREEN_WIDTH - 32 * NEW_BILI, 20 * NEW_BILI)];
    school.font = [UIFont systemFontOfSize:16 * NEW_BILI];
    school.text = [self.datas valueNotNullForKey:@"school_info"];
    [topBGView addSubview:school];
    
    UILabel *accout = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(school.frame), CGRectGetMaxY(line.frame) + 15 * NEW_BILI, CGRectGetWidth(school.frame), 20 * NEW_BILI)];
    accout.text = [self.datas valueNotNullForKey:@"account_info"];
    accout.font = [UIFont systemFontOfSize:16 * NEW_BILI];
    [topBGView addSubview:accout];
    

    UIView *downBGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topBGView.frame) + 9 * NEW_BILI, SCREEN_WIDTH, 50 * NEW_BILI)];
    downBGView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:downBGView];
    
    UILabel *remainMoney = [[UILabel alloc] initWithFrame:CGRectMake(16 * NEW_BILI, 15 * NEW_BILI, CGRectGetWidth(school.frame), 20 * NEW_BILI)];
    remainMoney.font = [UIFont systemFontOfSize:16 * NEW_BILI];
    remainMoney.text = [self.datas valueNotNullForKey:@"net_info"];
    [downBGView addSubview:remainMoney];
    
    
    
}

@end
