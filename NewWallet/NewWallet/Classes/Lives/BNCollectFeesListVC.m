//
//  BNCollectFeesListVC.m
//  Wallet
//
//  Created by mac1 on 15/8/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNCollectFeesListVC.h"
#import "ColletFeesTableViewCell.h"
#import "CollectFeesApi.h"
#import "BNFeesWebViewExplainVC.h"
#import "BNFeeDetailViewController.h"

#define kReuseIdentifier @"reuseIdentifier"

@interface BNCollectFeesListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIView *noCollectView;

@end

@implementation BNCollectFeesListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isPop) {
        [self loadData];
        self.isPop = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"领取列表";
    [self setupSubViews];
    [self loadData];
}

- (void)setupSubViews
{
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 44);
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info_HeighLight"] forState:UIControlStateHighlighted];
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightItemButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.rowHeight = 85 * BILI_WIDTH;
    _tableView.backgroundColor = UIColor_Gray_BG;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.bounds), 1)];
    _tableView.tableFooterView = footView;
    
    self.noCollectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    _noCollectView.backgroundColor = UIColor_Gray_BG;
    _noCollectView.hidden = YES;
    [self.view addSubview:_noCollectView];
    
    UIImageView *noCollectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 213 * BILI_WIDTH, 188 * BILI_WIDTH)];
    noCollectImgView.center = CGPointMake(_noCollectView.frame.size.width/2.0, _noCollectView.frame.size.height/2.0 - 30 * BILI_WIDTH);
    noCollectImgView.image = [UIImage imageNamed:@"FeesNoRecord"];
    [_noCollectView addSubview:noCollectImgView];

}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CollectFeesApi queryPayeeWithPrj_key:@"" Success:^(NSDictionary *returnData) {
        [SVProgressHUD dismiss];
        BNLog(@"费用领取查询--->>>%@",returnData);
        if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *dataDic = returnData[kRequestReturnData];
            weakSelf.dataArray = [[NSArray alloc] initWithArray:dataDic[@"prj_infos"]];
            if(_dataArray.count > 0){
                [_tableView reloadData];
            }else{
                _noCollectView.hidden = NO;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:kRequestRetMessage];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColletFeesTableViewCell *cell = (ColletFeesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (cell == nil) {
        cell = [[ColletFeesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell drawCellWithData:_dataArray[indexPath.row]];
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowDic = _dataArray[indexPath.row];
    NSString *prj_key = rowDic[@"prj_key"];
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CollectFeesApi queryPayeeWithPrj_key:prj_key Success:^(NSDictionary *returnData) {
        [SVProgressHUD dismiss];
        if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *dataDic = returnData[kRequestReturnData];
            NSArray *nextDataArray = [[NSArray alloc] initWithArray:dataDic[@"prj_infos"]];
            if(nextDataArray)
            {
                BNFeeDetailViewController *feeDetailViewController = [[BNFeeDetailViewController alloc] init];
                feeDetailViewController.dataDic = nextDataArray[0];
                [self pushViewController:feeDetailViewController animated:YES];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:kRequestRetMessage];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
    }

- (void)rightItemButtonAction
{
    BNFeesWebViewExplainVC *explainVC = [[BNFeesWebViewExplainVC alloc] init];
    explainVC.useType = ExpainUseTypeCollectFess;
    [self pushViewController:explainVC animated:YES];
}


- (void)backButtonClicked:(UIButton *)sender
{
    for (UIViewController *navVc in self.navigationController.viewControllers) {
        if ([navVc isKindOfClass:NSClassFromString(@"BNHomeViewController")]) {
            [self.navigationController popToViewController:navVc animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
