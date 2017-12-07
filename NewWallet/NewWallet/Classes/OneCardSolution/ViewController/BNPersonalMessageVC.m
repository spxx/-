//
//  BNPersonalMessageVC.h
//
//  Created by mac on 17/2/20.
//  Copyright © 2016年 xujiayong. All rights reserved.
//

#import "BNPersonalMessageVC.h"
#import "BNPersonalMessageCell.h"
#import "MJRefresh.h"
#import "BannerApi.h"
#import "CustomButton.h"

@interface BNPersonalMessageVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentPage;
}

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) UIButton *phoneBtn;
@property (nonatomic) UIButton *collectBtn;

@end
@implementation BNPersonalMessageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"个人消息";

    self.sixtyFourPixelsView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    self.dataArray = [@[] mutableCopy];
    
    currentPage = 0;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [_tableView registerClass:[BNPersonalMessageCell class] forCellReuseIdentifier:@"BNPersonalMessageCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    [self addRefreshFooter];

    [self requestData];
    
}
- (void)requestData
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [BannerApi getEventHistoryFlowPage:currentPage success:^(NSDictionary *returnData) {
        BNLog(@"event history data1: %@", returnData);
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            
            NSArray *array = returnData[kRequestReturnData];
            if (array.count > 0) {
                [self.dataArray addObjectsFromArray:array];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView.mj_footer endRefreshing];
            });
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView.mj_footer endRefreshing];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
        });
    }];

}
- (void)addRefreshFooter
{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ++currentPage;
        BNLog(@"currentPage   : %ld", (long)currentPage);

        [weakSelf requestData];

    }];
    
    _tableView.mj_footer = footer;
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;
    //        return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBNPersonalMessageCellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BNPersonalMessageCell";
    BNPersonalMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *description = [_dataArray objectAtIndex:indexPath.row];
    
    [cell drawDataWithInfo:description];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *data = self.dataArray[indexPath.row];
    NSString *url = [data valueNotNullForKey:@"goto_url"];
    NSString *app_type = [data valueNotNullForKey:@"app_type"];
    NSString *biz_id = [data valueNotNullForKey:@"biz_id"];
    
    CustomButton *button = [[CustomButton alloc] init];
    button.biz_id = biz_id;
    button.biz_type = app_type;
    button.biz_h5_url = url;
    [self suDoKuButtonAction:button];
}

@end
