//
//  BNEventViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 16/7/4.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNEventViewController.h"
#import "BNEventCell.h"
#import "BNCommonWebViewController.h"
#import "BNPublicHtml5BusinessVC.h"
#import "TraineeHomeViewController.h"
#import "CustomButton.h"
#import "BNCheckedEventViewController.h"
#import "BannerApi.h"

@interface BNEventViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, EventCheckDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *emptyView;

@property (assign, nonatomic) NSInteger selectedEventId;
@property (strong, nonatomic) NSArray *cellHeights;

@end

@implementation BNEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *heights = [NSMutableArray array];
    for (NSDictionary *event in self.events) {
        CGFloat height = 0;
        if ([[event objectForKey:@"app_type"] integerValue]) {
            height = 8+44+0.5+20+20+16+5+48+20;
        } else {
            CGFloat descriptionHeight = [Tools caleNewsCellHeightWithTitle:[event valueNotNullForKey:@"describe"] font:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH-106];
            height = 8+44+0.5+20+20+16+5+MAX(24, descriptionHeight)+20;
        }
        
        [heights addObject:@(height)];
    }
    
    self.cellHeights = heights;
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkedTapped:(UIButton *)sender {
    //友盟统计事件流点击
    [MobClick event:@"5_0_0_EventsHaveDoneBtn"];
    BNCheckedEventViewController *checkedEventVC = [[BNCheckedEventViewController alloc] init];
    [self pushViewController:checkedEventVC animated:YES];
}

- (void)setupViews {
    self.navigationTitle = @"事件流";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 70*NEW_BILI, 0, 70*NEW_BILI, 44);
    [rightItem setTitle:@"已处理" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*NEW_BILI)];
    [rightItem addTarget:self action:@selector(checkedTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    //tableView.rowHeight = 152;
    //tableView.estimatedRowHeight = 152;
    [tableView registerClass:[BNEventCell class] forCellReuseIdentifier:eventCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    footerView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = footerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *emptyView = UIImageView.new;
    emptyView.image = [UIImage imageNamed:@"event_empty"];
    emptyView.hidden = YES;
    [self.view addSubview:emptyView];
    self.emptyView = emptyView;
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@150);
        make.center.equalTo(emptyView.superview);
    }];
    
    [self updateStatus];
}

- (void)updateStatus {
    if (self.events.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}

#pragma mark - UITableViewDatasource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeights[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNEventCell *cell = (BNEventCell *)[tableView dequeueReusableCellWithIdentifier:eventCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setData:self.events[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
//    webViewController.urlString = @"http://192.168.1.114/app/web_files/v1/testcookie.html";
//    [self pushViewController:webViewController animated:YES];
    
    NSDictionary *data = self.events[indexPath.row];
    
    NSString *url = [data valueNotNullForKey:@"goto_url"];
    NSString *app_type = [data valueNotNullForKey:@"app_type"];
    NSString *biz_id = [data valueNotNullForKey:@"biz_id"];
    CustomButton *button = [[CustomButton alloc] init];
    button.biz_id = biz_id;
    button.biz_type = app_type;
    button.biz_h5_url = url;
    [self suDoKuButtonAction:button];
}

#pragma mark - EventCheckDelegate

- (void)eventCheck:(id)data {
    NSInteger index = [self.events indexOfObject:data];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@", shareAppDelegateInstance.boenUserInfo.userid, kEventHadChecked]]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@", shareAppDelegateInstance.boenUserInfo.userid, kEventHadChecked]];
        
        self.selectedEventId = [data[@"event_id"] integerValue];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"事件将标记为已处理，以后可以在已处理界面查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = index;
        [alertView show];
        
        return;
    }

    [SVProgressHUD show];
    __weak __typeof(self) weakSelf = self;
    [BannerApi closeEvent:[data[@"event_id"] integerValue] success:^(NSDictionary *returnData) {
        BNLog(@"close event data: %@", returnData);
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            [weakSelf.events removeObjectAtIndex:index];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf updateStatus];
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        __weak __typeof(self) weakSelf = self;
        [BannerApi closeEvent:self.selectedEventId success:^(NSDictionary *returnData) {
            BNLog(@"close event data: %@", returnData);
            
            NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                [SVProgressHUD dismiss];
                [weakSelf.events removeObjectAtIndex:alertView.tag];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self updateStatus];
            } else {
                NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
    }
}

@end
