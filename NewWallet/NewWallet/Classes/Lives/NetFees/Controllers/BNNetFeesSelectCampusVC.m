//
//  BNNetFeesSelectCampusVC.m
//  Wallet
//
//  Created by mac1 on 16/2/16.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNNetFeesSelectCampusVC.h"
#import "BNNetFeesCampusTableViewCell.h"

@interface BNNetFeesSelectCampusVC ()<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) UITableView *tableView;

@end

@implementation BNNetFeesSelectCampusVC

static NSString *const reuseIdentifer = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"选择校区";
    [self setupLoadedView];
    
}

- (void)setupLoadedView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[BNNetFeesCampusTableViewCell class] forCellReuseIdentifier:reuseIdentifer];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView = tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.campuses.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNNetFeesCampusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer forIndexPath:indexPath];
    [cell setupCellSubViewsWithDictionary:self.campuses[indexPath.row] index:indexPath.row selectIndex:_selectedIndex];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 11)];
    sectionFooterView.backgroundColor = UIColor_GrayLine;
    return sectionFooterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 11)];
    sectionFooterView.backgroundColor = UIColor_GrayLine;
    return sectionFooterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        weakSelf.selectedCampusFinished(self.campuses[indexPath.row], indexPath.row);
    });
}
@end
