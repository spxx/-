//
//  IncomeSpendDetailViewController.m
//  Wallet
//
//  Created by cyjjkz1 on 15/6/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "IncomeSpendDetailViewController.h"
#import "IncomeSpendDetailTableViewCell.h"
#import "IncomeNextViewController.h"
#import "TiXianApi.h"

@interface IncomeSpendDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UIView *noRecordView;

@end

@implementation IncomeSpendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"收支明细";
    [self setupLoadedView];
    [self setupNoRecordViews];
    [self loadResponseData];
    
}
- (void)loadResponseData
{
    //收支明细查询接口
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [TiXianApi tixianQueryWithOrderNumber:nil
                                  Success:^(NSDictionary *returnData)
     {
         BNLog(@"收支明细查询___%@",returnData);
         if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode])
         {
             [SVProgressHUD dismiss];
             NSDictionary *dataDic = returnData[@"data"];
             weakSelf.dataArray = [NSMutableArray arrayWithArray:dataDic[@"balance_infos"]];
             if (_dataArray.count == 0)
             {
                 _noRecordView.hidden = NO;
                 return;
             }
             [_tableView reloadData];
         }
         else
         {
             NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
             [SVProgressHUD showErrorWithStatus:retMsg];
         }
         
     }
      failure:^(NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
     }];
                                  
}

- (void)setupLoadedView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70 * BILI_WIDTH;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

//没有收支明细记录
- (void)setupNoRecordViews
{
    _noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, 320*BILI_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    _noRecordView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    _noRecordView.hidden = YES;
    [self.view addSubview:_noRecordView];
    
    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(81*BILI_WIDTH, 100*BILI_WIDTH, 161*BILI_WIDTH, 161*BILI_WIDTH)];
    roundView.backgroundColor = [UIColor whiteColor];
    roundView.layer.cornerRadius = roundView.frame.size.width/2;
    roundView.layer.masksToBounds = YES;
    [_noRecordView addSubview:roundView];
    
    UILabel *noRecordLabel = [[UILabel alloc] init];
    noRecordLabel.bounds = CGRectMake(0, 0, 150 * BILI_WIDTH, 30*BILI_WIDTH);
    noRecordLabel.center = roundView.center;
    noRecordLabel.textAlignment = NSTextAlignmentCenter;
    noRecordLabel.text = @"暂无收支明细记录";
    noRecordLabel.font = [UIFont boldSystemFontOfSize:14.0*BILI_WIDTH];
    noRecordLabel.textColor = [UIColor grayColor];
    [_noRecordView addSubview:noRecordLabel];
}
#pragma mark -UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = _dataArray[section];
    NSArray *array = [[dic allValues] firstObject];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifer = @"Cell";
    IncomeSpendDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (!cell)
    {
        cell = [[IncomeSpendDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
    }
    //刷新UI区
    NSDictionary *dataDic = [[_dataArray[indexPath.section] allValues] firstObject][indexPath.row];
    [cell drawCellWithDictionary:dataDic];
    
    return cell;
}


#pragma mark -UITableViewDelegate
//用户选择了某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IncomeNextViewController *nextVC = [[IncomeNextViewController alloc] init];
   NSDictionary *dataDic = [[_dataArray[indexPath.section] allValues] firstObject][indexPath.row];
    nextVC.dataDic = dataDic;
    nextVC.navigationTitleString = @"收支详情";
    [self pushViewController:nextVC animated:YES];
}

//区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 23.0f * BILI_WIDTH)];
    view.backgroundColor = UIColor_Gray_BG;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 0, view.frame.size.width - 15 * BILI_WIDTH, 23.f * BILI_WIDTH)];
    label.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.f];
    NSString *sectionStr = [[_dataArray[section] allKeys] firstObject];
    
    NSString *yearStr = nil;
    NSString *monthStr = nil;
    if (sectionStr.length >= 4) {
        yearStr = [sectionStr substringWithRange:NSMakeRange(0, 4)];
    }
    if (sectionStr.length >= 6) {
        monthStr = [sectionStr substringWithRange:NSMakeRange(4, 2)];
    }
    label.text = [NSString stringWithFormat:@"%@年%@月", yearStr, monthStr];
    label.textColor = [UIColor colorWithRed:156/255.0 green:144/255.0 blue:144/255.0 alpha:1.f];
    label.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23.0f * BILI_WIDTH;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
