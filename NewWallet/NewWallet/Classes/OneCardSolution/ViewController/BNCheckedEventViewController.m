//
//  BNCheckedEventViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 16/7/11.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNCheckedEventViewController.h"
#import "BNEventCell.h"
#import "BNPublicHtml5BusinessVC.h"
#import "TraineeHomeViewController.h"
#import "CustomButton.h"
#import "BannerApi.h"

@interface BNCheckedEventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *emptyView;

@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *cellHeights;

@end

@implementation BNCheckedEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
    [self getEventsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.navigationTitle = @"已处理事件";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
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
}

//获取事件流
- (void)getEventsData {
    __weak __typeof(self) weakSelf = self;
    [BannerApi getEventHistoryFlowPage:0 success:^(NSDictionary *returnData) {
        BNLog(@"event history data: %@", returnData);
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            weakSelf.events = returnData[kRequestReturnData];
            if (weakSelf.events.count > 0) {
                
                NSMutableArray *heights = [NSMutableArray array];
                
                //NSMutableArray *a = [NSMutableArray array];
                
                for (NSDictionary *event in weakSelf.events) {
                    /*NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:event];
                    d[@"app_type"] = @1;
                    d[@"describe"] = @"还有几天的时间";
                    [a addObject:d];*/
                    
                    
                    CGFloat height = 0;
                    if ([[event objectForKey:@"app_type"] integerValue]) {
                        height = 8+44+0.5+20+20+16+5+48+20;
                    } else {
                        CGFloat descriptionHeight = [Tools caleNewsCellHeightWithTitle:[event valueNotNullForKey:@"describe"] font:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH-106];
                        height = 8+44+0.5+20+20+16+5+MAX(24, descriptionHeight)+20;
                    }
                    
                    [heights addObject:@(height)];
                }
                
                //weakSelf.events = a;
                
                weakSelf.cellHeights = heights;
                
                [weakSelf.tableView reloadData];
            } else {
                weakSelf.emptyView.hidden = NO;
            }
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
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
    [cell setData:self.events[indexPath.row]];
    [cell setCheckMode:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = self.events[indexPath.row];
    NSString *url = [data valueNotNullForKey:@"goto_url"];
    NSString *app_type = [data valueNotNullForKey:@"app_type"];
    NSString *biz_id = [data valueNotNullForKey:@"biz_id"];
    
    CustomButton *button = [[CustomButton alloc] init];
    button.biz_id = biz_id;
    button.biz_type = app_type;
    button.biz_h5_url = url;
    [self suDoKuButtonAction:button];}

@end
