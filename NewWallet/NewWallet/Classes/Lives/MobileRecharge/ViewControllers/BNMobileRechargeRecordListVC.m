//
//  BNMobileRechargeRecordListVC.m
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNMobileRechargeRecordListVC.h"

#import "MobileRechargeApi.h"

#import "BNMobileRechargeListCell.h"

@interface BNMobileRechargeRecordListVC ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *dataSource;

@property(weak, nonatomic) UITableView *historyTableView;

@property(assign, nonatomic) LoadDataStatusStyle loadDataStatus;

@property (weak, nonatomic) UIView *nothingBKView;

@property (weak, nonatomic) UILabel *errorLabel;

@property (weak, nonatomic) UIButton *updateButton;
@end

@implementation BNMobileRechargeRecordListVC

@synthesize loadDataStatus = _loadDataStatus;

#pragma mark -set and get
- (void)setLoadDataStatus:(LoadDataStatusStyle) status
{
    _loadDataStatus = status;
    
    switch (status) {
        case LoadDataStatusStyleSuccess:
            _historyTableView.hidden = NO;
            [_historyTableView reloadData];
            break;
        case LoadDataStatusStyleSuccessButNothing:
            _nothingBKView.hidden = NO;
            break;
            
        case LoadDataStatusStyleReturnFailed:
            _errorLabel.hidden = NO;
            _updateButton.hidden = NO;
            break;
            
        case LoadDataStatusStyleNetworkError:
            _errorLabel.hidden = NO;
            _errorLabel.text = @"[网络错误]";
            _updateButton.hidden = NO;
            break;
        default:
            break;
    }

}

#pragma mark - load view
- (void)setupLoadView
{
    self.navigationTitle = @"充值记录";
    
    self.view.backgroundColor = UIColor_Gray_BG;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH - 10 * 2, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 80.0;
    tableView.hidden = YES;
    tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.frame];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    footView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPathLB = [UIBezierPath bezierPathWithRoundedRect:footView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayerLB = [[CAShapeLayer alloc] init];
    maskLayerLB.frame = footView.bounds;
    maskLayerLB.path = maskPathLB.CGPath;
    footView.layer.mask = maskLayerLB;
    tableView.tableFooterView = footView;
    
    
    
    [self.view addSubview:tableView];
//    [tableView registerClass:[BNMobileRechargeListCell class] forCellReuseIdentifier:@"BNMobileRechargeBillCell"];
    
    _historyTableView = tableView;
    
    
    //没有记录
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge + (SCREEN_HEIGHT - 200 - self.sixtyFourPixelsView.viewBottomEdge)/2, 200, 200)];
    bkView.backgroundColor = [UIColor whiteColor];
    bkView.layer.cornerRadius = 100;
    bkView.layer.masksToBounds = YES;
    bkView.hidden = YES;
    bkView.center = self.view.center;
    _nothingBKView = bkView;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 180, 30)];
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.text = @"暂无记录";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor lightGrayColor];
    
    [bkView addSubview:tipsLabel];
    [self.view addSubview:bkView];
    
    
    //错误
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, SCREEN_WIDTH, 25)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"[网络连接中断]";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.hidden = YES;
    _errorLabel = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.hidden = YES;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"点击刷新"];
    [attStr addAttribute:NSForegroundColorAttributeName value:UIColor_Blue_BarItemText range:NSMakeRange(0, [attStr length])];
    [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [attStr length])];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [attStr length])];
    [button setAttributedTitle:attStr forState:UIControlStateNormal];
    
    button.frame = CGRectMake((SCREEN_WIDTH - 200)/2, label.frame.origin.y + label.frame.size.height, 200, 40);
    
    [button addTarget:self action:@selector(reloadDataSourceAction:) forControlEvents:UIControlEventTouchUpInside];
    _updateButton = button;
    
    [self.view addSubview:label];
    [self.view addSubview:button];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] init];
    
    [self setupLoadView];
}

- (void)loadDataSource
{
    __weak typeof(self) weakSelf = self;
//    weakSelf.loadDataStatus = LoadDataStatusStyleSuccess;
//    
//    [_dataSource addObjectsFromArray:@[@"234234", @"asdf"]];
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [MobileRechargeApi rechargeRecordListSuccess:^(NSDictionary *successData) {
        BNLog(@"phone recharge list--%@", successData);
        
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *billInfo = [successData valueForKey:kRequestReturnData];
            NSArray *list = [billInfo valueForKey:@"recharges"];
            if ([list count] > 0) {
                
                [weakSelf.dataSource removeAllObjects];
                [weakSelf.dataSource addObjectsFromArray:list];
                weakSelf.loadDataStatus = LoadDataStatusStyleSuccess;
            }else{
                weakSelf.loadDataStatus = LoadDataStatusStyleSuccessButNothing;
            }
        }else{
            weakSelf.loadDataStatus = LoadDataStatusStyleReturnFailed;
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        weakSelf.loadDataStatus = LoadDataStatusStyleNetworkError;
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataSource];
    
}
#pragma mark - action
- (void)reloadDataSourceAction:(UIButton *)btn
{
    _historyTableView.hidden = YES;
    _nothingBKView.hidden    = YES;
    _errorLabel.hidden       = YES;
    _updateButton.hidden     = YES;
    [self loadDataSource];
    
}
#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BNMobileRechargeBillCell";
    BNMobileRechargeListCell *cell = (BNMobileRechargeListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BNMobileRechargeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier width:tableView.frame.size.width];
    }
    [cell drawCellWithData:[_dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
