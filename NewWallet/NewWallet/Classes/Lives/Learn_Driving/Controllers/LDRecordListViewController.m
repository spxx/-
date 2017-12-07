//
//  LDRecordListViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 16/6/3.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDRecordListViewController.h"
#import "LDRecordListViewCell.h"
#import "LearnDrivingApi.h"
#import "LDProgressViewController.h"


@interface LDRecordListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *records;
@property (nonatomic, weak) UIView *noRecordView;

@end

@implementation LDRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.navigationTitle = @"学车进度";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[LDRecordListViewCell class] forCellReuseIdentifier:recordCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *noRecordBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    noRecordBGView.backgroundColor = UIColor_Gray_BG;
    noRecordBGView.hidden = YES;
    [self.view addSubview:noRecordBGView];
    _noRecordView = noRecordBGView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160 * NEW_BILI) * 0.5,  212 * NEW_BILI, 160 * NEW_BILI, 60 * NEW_BILI)];
    imageView.image = [UIImage imageNamed:@"ld_progress_noRecord"];
    [noRecordBGView addSubview:imageView];
    
    UILabel *noRecordLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) * 0.5, CGRectGetMaxY(imageView.frame) + 16 * NEW_BILI, 200, 12 * NEW_BILI)];
    noRecordLbl.font = [UIFont systemFontOfSize:12 * NEW_BILI];
    noRecordLbl.textAlignment = 1;
    noRecordLbl.text = @"暂无学车记录";
    noRecordLbl.textColor =  BNColorRGB(155, 174, 183);
    [noRecordBGView addSubview:noRecordLbl];
   
}

- (void)loadData {
    [SVProgressHUD show];
    __weak __typeof(self) weakSelf = self;
    [LearnDrivingApi getDrivingRecord:^(NSDictionary *returnData) {
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:@"000000"]) {
            [SVProgressHUD dismiss];
            
            weakSelf.records = returnData[kRequestReturnData][@"driving_records"];
             _noRecordView.hidden = weakSelf.records.count != 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark UITableViewDatasource&&UITableViewDelegate -

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = UIColor_Gray_BG;
    return headerView;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDRecordListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellIdentifier forIndexPath:indexPath];
    NSDictionary *data = self.records[indexPath.row];
    [cell setData:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LDProgressViewController *progressViewController = [[LDProgressViewController alloc] init];
    NSDictionary *data = self.records[indexPath.row];
    progressViewController.recordInfo = data;
    [self pushViewController:progressViewController animated:YES];
}

@end
