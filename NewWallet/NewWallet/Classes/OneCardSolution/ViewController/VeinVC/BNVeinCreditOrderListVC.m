//
//  BNVeinCreditOrderListVC.m
//  Wallet
//
//  Created by xjy on 17/6/21.
//  Copyright (c) 2017年 BNDK. All rights reserved.
//

#import "BNVeinCreditOrderListVC.h"


#import "BNVeinCreditOrderListCell.h"

#import "BNVeinCreditOrderDetailVC.h"
#import "TopTabBar.h"
#import "OpenCenterApi.h"


@interface BNVeinCreditOrderListVC ()<UITableViewDataSource, UITableViewDelegate, TopTabBarDelegate>

@property (strong, nonatomic) TopTabBar *topTabBar;

@property (weak, nonatomic) UITableView *billTableView;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) NSArray *consumeSource;
@property (strong, nonatomic) NSArray *repaySource;

@property (weak, nonatomic) UIView *billNoteView;
@property (assign, nonatomic) BillShowType  billShowType;

@property (assign, nonatomic) BOOL isNetworkError;
@end

@implementation BNVeinCreditOrderListVC


- (void)setupDidLoadView
{
    self.navigationTitle = @"信用金账单";
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat tabbarVieHeight = 50*NEW_BILI;
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, tabbarVieHeight)];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];

    self.topTabBar = [[TopTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tabbarVieHeight) titles:@[@"消费账单", @"还款账单"] style:HintStyle_EqualWidth];
    _topTabBar.delegate = self;
    _topTabBar.hintColor = UIColor_NewIconColor;
    _topTabBar.hintHeight = 5*NEW_BILI;
    _topTabBar.hintBGColor = UIColor_Gray_BG;
    _topTabBar.titleFont = [UIFont boldSystemFontOfSize:15*NEW_BILI];
    [bkView addSubview:_topTabBar];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge + tabbarVieHeight, self.view.frame.size.width, self.view.frame.size.height - self.sixtyFourPixelsView.viewBottomEdge - tabbarVieHeight) style:UITableViewStylePlain];
    _billTableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kBillCellHeight;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[BNVeinCreditOrderListCell class] forCellReuseIdentifier:@"BillCell"];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    CGFloat noteViewWidth = [BNTools sizeFit:300 six:320 sixPlus:340];
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - noteViewWidth)/2, self.sixtyFourPixelsView.viewBottomEdge + (SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge - noteViewWidth)/2.0, noteViewWidth, noteViewWidth)];
    noteView.backgroundColor = [UIColor clearColor];
    
    UIImageView *noteImg = [[UIImageView alloc] initWithFrame:CGRectMake((noteViewWidth-160)/2, 0, 160, 160)];
    noteImg.tag = 10;
    [noteImg setImage:[UIImage imageNamed:@"view_null"]];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(noteImg.frame)+10, noteViewWidth, 24)];
    noteLabel.tag = 11;
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:17]];
    noteLabel.textColor = [UIColor lightGrayColor];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.tag = 12;
    reloadButton.frame = CGRectMake((noteViewWidth-100)/2, noteLabel.frame.size.height + noteLabel.frame.origin.y + 10, 100, 35);
    [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
    reloadButton.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:17]];
    [reloadButton setTitleColor:UIColor_Blue_BarItemText forState:UIControlStateNormal];
    reloadButton.layer.borderColor = UIColor_Blue_BarItemText.CGColor;
    reloadButton.layer.borderWidth = 1;
    reloadButton.layer.cornerRadius = CGRectGetHeight(reloadButton.frame)/2;
    reloadButton.layer.masksToBounds = YES;
    
    [reloadButton addTarget:self action:@selector(loadDataSource) forControlEvents:UIControlEventTouchUpInside];
    
    _billNoteView = noteView;
    [noteView addSubview:noteImg];
    [noteView addSubview:noteLabel];
    [noteView addSubview:reloadButton];
    [self.view insertSubview:noteView belowSubview:tableView];
}


- (void)setupNoteImage:(UIImage *)img note:(NSString *)note isHiddenButton:(BOOL)isShow
{
    UILabel *noteLabel = (UILabel *)[_billNoteView viewWithTag:11];
    noteLabel.text = note;
    
    UIImageView *imageView = (UIImageView *)[_billNoteView viewWithTag:10];
    [imageView setImage:img];
    
    UIButton *button = (UIButton *)[_billNoteView viewWithTag:12];
    button.hidden = isShow;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDidLoadView];
    
    _billShowType = BillShowTypeConsume;
    
    [self loadDataSource];
}
//静脉信用金-信用金_消费账单
- (void)getVeinCreditConsumeOrder
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [OpenCenterApi getVeinCreditConsumeOrderWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                                                     success:^(NSDictionary *successData) {
                                                         BNLog(@"静脉信用金-消费账单--%@", successData);
                                                         NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
                                                         NSString *resultcode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:@"resultcode"]];
                                                         
                                                         [self getVeinCreditRepayOrder];

                                                         if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                             if ([resultcode isEqualToString:kRequestNewSuccessCode]) {

                                                                 NSArray *array = [successData valueForKey:kRequestReturnData];
                                                                 if ([array isKindOfClass:[NSArray class]]) {
                                                                     if ([array count] > 0) {
                                                                         weakSelf.consumeSource = array;
                                                                         weakSelf.billTableView.hidden = NO;
                                                                         weakSelf.dataSource = array;
                                                                         [weakSelf.billTableView reloadData];
                                                                     }else{
                                                                         [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋，还没有消费记录哟" isHiddenButton:YES];
                                                                         weakSelf.billTableView.hidden = YES;
                                                                     }
                                                                 } else{
                                                                     [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋，还没有消费记录哟" isHiddenButton:YES];
                                                                     weakSelf.billTableView.hidden = YES;
                                                                 }
                                                             }else{
                                                                 weakSelf.billTableView.hidden = YES;
                                                                 weakSelf.isNetworkError = YES;
                                                                 NSString *retMsg = [successData valueNotNullForKey:@"resultmsg"];
                                                                 [self setupNoteImage:[UIImage imageNamed:@"network_error"] note:retMsg isHiddenButton:NO];
                                                                 
                                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                                             }
                                                         }else{
                                                             weakSelf.billTableView.hidden = YES;
                                                             weakSelf.isNetworkError = YES;
                                                             NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                             [self setupNoteImage:[UIImage imageNamed:@"network_error"] note:retMsg isHiddenButton:NO];
                                                             
                                                             [SVProgressHUD showErrorWithStatus:retMsg];

                                                         }
                                                     } failure:^(NSError *error) {
                                                         [self getVeinCreditRepayOrder];

                                                         weakSelf.isNetworkError = YES;
                                                         weakSelf.billTableView.hidden = YES;
                                                         [self setupNoteImage:[UIImage imageNamed:@"network_error"] note:@"世界上最远的距离是没有网..." isHiddenButton:NO];
                                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                     }];
}
#pragma mark - load data
- (void)loadDataSource
{
    [self getVeinCreditConsumeOrder];
}
//静脉信用金-信用金_还款账单
- (void)getVeinCreditRepayOrder
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [OpenCenterApi getVeinCreditRepayOrderWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                                               success:^(NSDictionary *successData) {
                                                   BNLog(@"静脉信用金-还款账单--%@", successData);
                                                   NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
                                                   NSString *resultcode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:@"resultcode"]];
                                                   
                                                   if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                       if ([resultcode isEqualToString:kRequestNewSuccessCode]) {
                                                           [SVProgressHUD dismiss];
                                                           NSArray *array = [successData valueForKey:kRequestReturnData];
                                                           if ([array isKindOfClass:[NSArray class]]) {
                                                               if ([array count] > 0) {
                                                                   weakSelf.repaySource = array;
                                                               }
                                                           }
                                                       } else{
                                                           NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                           [SVProgressHUD showErrorWithStatus:retMsg];
                                                       }
                                                   } else{
                                                       NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                       [SVProgressHUD showErrorWithStatus:retMsg];
                                                   }
                                               } failure:^(NSError *error) {
                                                   [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                               }];

}
#pragma mark - datasource add delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BillCell";
    BNVeinCreditOrderListCell *cell = (BNVeinCreditOrderListCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    cell.separatorInset = UIEdgeInsetsMake(0, 50 * BILI_WIDTH, 0, 0);
    
    NSDictionary *dicInfo = [_dataSource objectAtIndex:indexPath.row];
    [cell setupDataTableViewCellWithInfo:dicInfo];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *info = [_dataSource objectAtIndex:indexPath.row];
    BNVeinCreditOrderDetailVC *resultVC = [[BNVeinCreditOrderDetailVC alloc] init];
    resultVC.returnRefreshBlock = ^(){
        [self loadDataSource];
    };
    resultVC.dict = info;
    [self pushViewController:resultVC animated:YES];
}

#pragma mark - TopTabBarDelegate
- (void)tabBarItemSelected:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            //友盟事件点击
            [MobClick event:@"BNVeinCreditOrderListVC_Channel" label:@"消费账单"];

            _dataSource = _consumeSource;
            _billShowType = BillShowTypeConsume;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有消费记录哦" isHiddenButton:YES];
            }
        }
            break;
            
        case 1:
        {
            //友盟事件点击
            [MobClick event:@"BNVeinCreditOrderListVC_Channel" label:@"还款账单"];
            
            _dataSource = _repaySource;
            _billShowType = BillShowTypeRepay;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有还款记录哦" isHiddenButton:YES];
            }
        }
            break;
        default:
            break;
    }

    [self.billTableView reloadData];
}
@end
