//
//  LDTrainFieldViewController.m
//  Wallet
//
//  Created by mac1 on 16/6/1.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDTrainFieldViewController.h"
#import "LDTrainFeildCell.h"
#import "LDMapViewController.h"

@interface LDTrainFieldViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LDTrainFieldViewController

NSString *const TrainFieldCellID = @"TrinFieldCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"训练场地";
    [self setupLoadedView];
}

- (void)setupLoadedView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 250 * NEW_BILI;
    tableView.backgroundColor = BNColorRGB(238, 241, 243);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView registerClass:[LDTrainFeildCell class] forCellReuseIdentifier:TrainFieldCellID];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
}

#pragma mrak - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fields.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDTrainFeildCell *cell = [tableView dequeueReusableCellWithIdentifier:TrainFieldCellID forIndexPath:indexPath];
    cell.areaModel = self.fields[indexPath.row];
    return cell;
}

#pragma mrak - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LDMapViewController *mapVC = [[LDMapViewController alloc] init];
    mapVC.areaModel = self.fields[indexPath.row];
    [self pushViewController:mapVC animated:YES];

}

@end
