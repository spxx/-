//
//  BNDiscoverMainVC.m
//  Wallet
//
//  Created by mac1 on 16/7/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNDiscoverMainVC.h"
#import "DiscoverMainCell.h"
#import "DiscoverApi.h"
#import "BNCommonWebViewController.h"

@interface BNDiscoverMainVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BNDiscoverMainVC

static NSString *const discoverMainCellID = @"discoverMainCellID";

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"发现";
    [self setupLoadedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserPrivilegeList];
}

- (void)setupLoadedView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = 154;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 13)];
    footerView.backgroundColor = UIColor_Gray_BG;
    tableView.tableFooterView = footerView;

    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNavigationBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge - 49);
    }];
    
    
    [tableView registerClass:[DiscoverMainCell class] forCellReuseIdentifier:discoverMainCellID];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverMainCell *cell = [tableView dequeueReusableCellWithIdentifier:discoverMainCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.datas[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.datas[indexPath.row];
    NSString *urlStr = [dic valueNotNullForKey:@"privilege_url"];
    BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
    [webViewController setUrlString:urlStr];
    [self pushViewController:webViewController animated:YES];
    //友盟事件点击
    [MobClick event:@"discover_cellClicked" label:urlStr];
}


#pragma mark - Request

- (void)getUserPrivilegeList
{
    [DiscoverApi get_user_privilege_list:^(NSDictionary *returnData) {
        BNLog(@"获取特权列表---->>>>%@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:[datas valueNotNullForKey:@"privileges_detail_list"]];
            [self.tableView reloadData];
            
        }else{
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
