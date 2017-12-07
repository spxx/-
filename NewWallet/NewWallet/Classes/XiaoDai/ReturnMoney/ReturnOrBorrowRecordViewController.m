//
//  ReturnOrBorrowRecordViewController.m
//  Wallet
//
//  Created by cyjjkz1 on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ReturnOrBorrowRecordViewController.h"
#import "ReturnOrBorrowRecordTableViewCell.h"
#import "XiaoDaiApi.h"
#import "BNReturnMoneyDetailVC.h"
#import "BNBorrowMoneyDetialsVC.h"

@interface ReturnOrBorrowRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic) UIView *noRecordView;

@end

@implementation ReturnOrBorrowRecordViewController


- (id)initWithReturnOrBorrow:(BOOL)returnOrBorrow
{
    self = [super init];
    if (self)
    {
        self.returnOrBorrow = returnOrBorrow;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = self.returnOrBorrow == YES ? @"还款记录":@"借款记录";
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self createTableView];
    [self setupNoRecordViews];
    [self initDataArray];
}

//初始化数据源
- (void)initDataArray
{
    __weak typeof(self) weakSelf = self;
    if (_returnOrBorrow == YES)
    {
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [XiaoDaiApi  repayQueryWithOrderNumber:@"" success:^(NSDictionary *returnData) {
            
            if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
            {
                [SVProgressHUD dismiss];
                NSArray *array = returnData[@"data"];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.dataArray addObjectsFromArray:array];
                if(self.dataArray.count ==0)
                {
                    [_noRecordView setHidden:NO];
                }
                [weakSelf.tableView reloadData];
            }else{
                NSString *retMsg = [returnData valueForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
    }
    else
    {
        //借钱信息查询
       [SVProgressHUD showWithStatus:@"请稍候..."];
       [XiaoDaiApi loanQuerySuccess:^(NSDictionary *returnData) {

           BNLog(@"loan list %@", returnData);
           if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
           {
               [SVProgressHUD dismiss];
               NSArray *array = returnData[@"data"][@"loan_infos"];
               [weakSelf.dataArray removeAllObjects];
               [weakSelf.dataArray addObjectsFromArray:array];
               if(self.dataArray.count ==0)
               {
                   [_noRecordView setHidden:NO];
               }
               [weakSelf.tableView reloadData];
           }else{
               NSString *retMsg = [returnData valueForKey:kRequestRetMessage];
               [SVProgressHUD showErrorWithStatus:retMsg];
           }
       
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];

    }
    
}

//创建表
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _tableView.rowHeight = 72 * BILI_WIDTH;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

//没有还款or借款记录
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
    noRecordLabel.bounds = CGRectMake(0, 0, 100 * BILI_WIDTH, 30*BILI_WIDTH);
    noRecordLabel.center = roundView.center;
    noRecordLabel.textAlignment = NSTextAlignmentCenter;
    noRecordLabel.text = self.returnOrBorrow ? @"暂无还钱记录":@"暂无借款记录";
    noRecordLabel.font = [UIFont boldSystemFontOfSize:14.0*BILI_WIDTH];
    noRecordLabel.textColor = [UIColor grayColor];
    [_noRecordView addSubview:noRecordLabel];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    ReturnOrBorrowRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[ReturnOrBorrowRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier viewController:self];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell drawDataWithDict:dic returnOrBorrow:_returnOrBorrow];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];

    NSString *statusString = self.dataArray[indexPath.row][@"status"];
    if(self.returnOrBorrow)
    {
        BNReturnMoneyDetailVC *detailVC = [[BNReturnMoneyDetailVC alloc] initWithBorrowInfo:dict];
        [self pushViewController:detailVC animated:YES];
    }
    else
    {
        BNBorrowMoneyDetialsVC *bDetailVC = [[BNBorrowMoneyDetialsVC alloc] init];
        bDetailVC.detailDic = self.dataArray[indexPath.row];
        if([statusString isEqualToString:@"FALSE"])
        {
            bDetailVC.resultStyle = BNXiaoDaiLoanStatusField;
        }
        else if ([statusString isEqualToString:@"INIT"]||[statusString isEqualToString:@"AUDING"])
        {
            bDetailVC.resultStyle = BNXiaoDaiLoanStatusChuLiZhong;
        }
        else
        {
            bDetailVC.resultStyle = BNXiaoDaiLoanStatusSucceed;
        }
        [self pushViewController:bDetailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
