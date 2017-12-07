//
//  BNAllPayBillViewController.m
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNAllPayBillViewController.h"

#import "BillTableHeadView.h"

#import "BNAllPayBillCell.h"

#import "FilterView.h"
#import "BNBillDetailVC.h"


#define FILTER_BACKGROUND_HEIGHT 50 //过滤器的高度


@interface BNAllPayBillViewController ()<UITableViewDataSource, UITableViewDelegate, FilterDelegate>

@property (weak, nonatomic) UITableView *billTableView;

@property (weak, nonatomic) UIView *filterBKView;

@property (weak, nonatomic) UIButton *allBillButton;

@property (weak, nonatomic) UIButton *filterButton;

@property (weak, nonatomic) FilterView *filterViewForBill;

@property (weak, nonatomic) UIView *halfBlackView;

@property (weak, nonatomic) UIImageView *filterArrow;

@property (strong, nonatomic) NSArray *filterNames;

@property (strong, nonatomic) NSArray *dataSource;

@property (strong, nonatomic) NSArray *oneCardDataSource;

@property (strong, nonatomic) NSArray *contributeDataSource;

@property (strong, nonatomic) NSArray *tiXianDataSource;

@property (strong, nonatomic) NSArray *dianFeiDataSource;

@property (nonatomic, strong) NSArray *schoolFessSource;

@property (nonatomic, strong) NSArray *collectFeesSource;

@property (strong, nonatomic) NSArray *mobileRechargeDataSource;

@property (strong, nonatomic) NSArray *allOrdersDataSource;

@property (nonatomic, strong) NSArray *xiaoDaiSource;

@property (nonatomic, strong) NSArray *netFeesSource;//网费

@property (nonatomic, strong) NSArray *scanToPaySource;

@property (strong, nonatomic) NSArray *learnDrivingSource;

@property (strong, nonatomic) NSArray *veinPaySource;
@property (strong, nonatomic) NSArray *QRPaySource;

@property (assign, nonatomic) BillShowType  billShowType;

@property (weak, nonatomic) UIView *billNoteView;

@property (assign, nonatomic) BOOL isNetworkError;
@end

@implementation BNAllPayBillViewController


- (void)setupDidLoadView
{
    self.navigationTitle = @"订单中心";
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, self.view.frame.size.width, FILTER_BACKGROUND_HEIGHT)];
//    bkView.backgroundColor = UIColorFromRGB(0x128dff);
    bkView.backgroundColor = [UIColor whiteColor];
    
    CGFloat kleftWidth = 15;
    
    UIView *btnBKView = [[UIView alloc] initWithFrame:CGRectMake(kleftWidth, (FILTER_BACKGROUND_HEIGHT-32)/2, self.view.frame.size.width - kleftWidth * 2, 32)];
    btnBKView.backgroundColor = [UIColor whiteColor];
    btnBKView.layer.cornerRadius = 4;
    btnBKView.layer.masksToBounds = YES;
    [bkView addSubview:btnBKView];
    btnBKView.layer.borderColor = UIColor_NewBlueColor.CGColor;
    btnBKView.layer.borderWidth = 1;
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(1, 1, (self.view.frame.size.width - 2*kleftWidth)/2 - 1, 30);
    _allBillButton = allBtn;
    allBtn.backgroundColor = UIColor_NewBlueColor;
    allBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
    [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allBtn setTitle:@"全部订单" forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(showAllBillAction:) forControlEvents:UIControlEventTouchUpInside];
//    allBtn.layer.borderColor = UIColor_NewBlueColor.CGColor;
//    allBtn.layer.borderWidth = 1;
//    allBtn.layer.masksToBounds = YES;
    
    UIBezierPath *maskPathLB = [UIBezierPath bezierPathWithRoundedRect:allBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayerLB = [[CAShapeLayer alloc] init];
    maskLayerLB.frame = allBtn.bounds;
    maskLayerLB.path = maskPathLB.CGPath;
    allBtn.layer.mask = maskLayerLB;
    
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = CGRectMake((self.view.frame.size.width - 2*kleftWidth)/2, 1, (self.view.frame.size.width - 2*kleftWidth)/2 - 1, 30);
    filterBtn.backgroundColor = [UIColor whiteColor];
    _filterButton = filterBtn;
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
    [filterBtn setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
    [filterBtn setTitle:@"分类订单" forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(showFilterAction:) forControlEvents:UIControlEventTouchUpInside];
//    filterBtn.layer.borderColor = UIColor_NewBlueColor.CGColor;
//    filterBtn.layer.borderWidth = 1;
//    filterBtn.layer.masksToBounds = YES;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:filterBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = allBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    filterBtn.layer.mask = maskLayer;
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(btnBKView.frame.size.width - 25, 8, 16, 16)];
    [arrow setImage:[UIImage imageNamed:@"filter_arrow_blue_down"]];
    _filterArrow = arrow;
    _filterNames = @[@"一卡通", @"手机充值",@"电费充值",@"教育缴费",@"费用领取",@"嘻哈贷",@"网费缴纳", @"到店付", @"喜付学车", @"静脉支付", @"二维码支付"];
    FilterView *filterView = [[FilterView alloc] initWithFilterNames:_filterNames relativeView:bkView];
    filterView.delegate = self;
    _filterViewForBill = filterView;

    UIView *hBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    hBlackView.backgroundColor = [UIColor blackColor];
    hBlackView.alpha = 0.0;
    hBlackView.userInteractionEnabled = YES;
    _halfBlackView = hBlackView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFiter:)];
    [hBlackView addGestureRecognizer:tap];
    
    
    
    [btnBKView addSubview:allBtn];
    [btnBKView addSubview:filterBtn];
    [btnBKView addSubview:arrow];
    
    [bkView addSubview:btnBKView];
    [self.view insertSubview:bkView belowSubview:self.sixtyFourPixelsView];
    [self.view insertSubview:filterView belowSubview:bkView];
    [self.view insertSubview:hBlackView belowSubview:filterView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge + FILTER_BACKGROUND_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - self.sixtyFourPixelsView.viewBottomEdge - FILTER_BACKGROUND_HEIGHT) style:UITableViewStylePlain];
    _billTableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kBillCellHeight;
    tableView.sectionHeaderHeight = kHeadViewHeight;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[BNAllPayBillCell class] forCellReuseIdentifier:@"BillCell"];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view insertSubview:tableView belowSubview:hBlackView];
    
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
    
    _billShowType = BillShowTypeAll;
    
    [self loadDataSource];
}
#pragma mark - load data
- (void)loadDataSource
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi newPay_QueryOrderListWithSuccess:^(NSDictionary *returnData) {
                                        BNLog(@"all list %@", returnData);
                                        
                                        if ([[returnData valueForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
                                            weakSelf.isNetworkError = NO;
                                            NSDictionary *data = [returnData valueForKey:kRequestReturnData];
                                            NSArray *orders = [data valueForKey:@"orders"];
                                            NSMutableArray *allOrdersArray = [[NSMutableArray alloc] init];
                                            
                                            NSMutableArray *allOneCardBill = [[NSMutableArray alloc] init];
                                            
                                            NSMutableArray *allContributeBill = [[NSMutableArray alloc] init];
                                            
                                            NSMutableArray *allMobileRechargeBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allTiXianBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allDidanFeiBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allSchoolFeesBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allCollectFeesBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allXiaoDaiBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allNetFeesBill = [[NSMutableArray alloc] init];
                                            NSMutableArray *allScanToPayBills = [[NSMutableArray alloc] init];
                                            NSMutableArray *allLearnDrivingBills = [[NSMutableArray alloc] init];
                                            NSMutableArray *allVeinPayBills = [[NSMutableArray alloc] init];
                                            NSMutableArray *allQRPayBills = [[NSMutableArray alloc] init];

                                            for (int i = 0; i < [orders count]; i++) {
                                                NSDictionary *monthOrderInfo = [orders objectAtIndex:i];
                                                NSArray *monthArray = [monthOrderInfo allKeys];
                                                NSString *month = [monthArray firstObject];
                                                NSArray *monthOreders = [monthOrderInfo objectForKey:month];
                                                
                                                NSMutableArray *oneCardBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *contributeBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *mobileRechargeBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *tiXianBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *dianFeiBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *schoolFees = [[NSMutableArray alloc] init];
                                                NSMutableArray *collectFeesBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *xiaoDaiBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *netFessBill = [[NSMutableArray alloc] init];
                                                NSMutableArray *scanToPayBills = [[NSMutableArray alloc] init];
                                                NSMutableArray *learnDrivingBills = [[NSMutableArray alloc] init];
                                                NSMutableArray *veinPayBills = [[NSMutableArray alloc] init];
                                                NSMutableArray *qrPayBills = [[NSMutableArray alloc] init];

                                                
                                                for (int j = 0; j < [monthOreders count]; j++) {
                                                    NSDictionary *order = [monthOreders objectAtIndex:j];
                                                    
                                                    NSString *busiType = [NSString stringWithFormat:@"%@",  [order valueNotNullForKey:@"biz_type"]];

                                                    switch ([busiType intValue]) {
                                                        case 1:
                                                            [oneCardBill addObject:order];
                                                            break;
                                                        
                                                        case 2:
                                                            [contributeBill addObject:order];
                                                            break;
                                                            
                                                        case 3:
                                                        case 6:
                                                            [mobileRechargeBill addObject:order];
                                                            break;
                                                        case 100:
                                                            [tiXianBill addObject:order];
                                                            break;
                                                        case 5:
                                                            [dianFeiBill addObject:order];
                                                            break;
                                                        case 101:
                                                            //费用领取
                                                            [collectFeesBill addObject:order];
                                                            break;
                                                        case 7:
                                                            //学校缴费
                                                            [schoolFees addObject:order];
                                                            break;
                                                        case 8:
                                                            [netFessBill addObject:order];
                                                            break;
                                                        case 102:
                                                        case 103:
                                                            //嘻哈贷
                                                            [xiaoDaiBill addObject:order];
                                                            break;
                                                        case 9:
                                                            [scanToPayBills addObject:order];
                                                            break;
                                                        case 10:
                                                            [learnDrivingBills addObject:order];
                                                            break;
                                                        case 19:
                                                            [veinPayBills addObject:order];
                                                            break;
                                                        case 20:
                                                            [qrPayBills addObject:order];
                                                            break;
                                                            
                                                        default:
                                                            break;
                                                    }
                                                }
                                                if ([oneCardBill count] > 0) {
                                                   
                                                    [allOneCardBill addObject:oneCardBill];
                                                }
                                                
                                                if ([contributeBill count] > 0) {
                                        
                                                    [allContributeBill addObject:contributeBill];
                                                }
                                                
                                                if ([mobileRechargeBill count] > 0) {
                                                    
                                                    [allMobileRechargeBill addObject:mobileRechargeBill];
                                                }
                                                if ([tiXianBill count] > 0) {
                                                    
                                                    [allTiXianBill addObject:tiXianBill];
                                                }
                                                if([dianFeiBill count] > 0)
                                                {
                                                    [allDidanFeiBill addObject:dianFeiBill];
                                                }
                                                if ([schoolFees count] > 0) {
                                                    [allSchoolFeesBill addObject:schoolFees];
                                                }
                                                if ([collectFeesBill count] > 0) {
                                                    [allCollectFeesBill addObject:collectFeesBill];
                                                }
                                                if ([xiaoDaiBill count] > 0) {
                                                    [allXiaoDaiBill addObject:xiaoDaiBill];
                                                }
                                                if ([netFessBill count] > 0) {
                                                    [allNetFeesBill addObject:netFessBill];
                                                }
                                                if ([scanToPayBills count] > 0) {
                                                    [allScanToPayBills addObject:scanToPayBills];
                                                }
                                                if ([learnDrivingBills count] > 0) {
                                                    [allLearnDrivingBills addObject:learnDrivingBills];
                                                }
                                                if ([veinPayBills count] > 0) {
                                                    [allVeinPayBills addObject:veinPayBills];
                                                }
                                                if ([qrPayBills count] > 0) {
                                                    [allQRPayBills addObject:qrPayBills];
                                                }
                                                if ([monthOreders count] > 0) {
                                                    
                                                    [allOrdersArray addObject:monthOreders];
                                                }
                                               
                                                
                                            }
                                            [SVProgressHUD dismiss];
                                            if ([allOrdersArray count] > 0) {
                                                weakSelf.billTableView.hidden = NO;
                                                weakSelf.dataSource = allOrdersArray;
                                                weakSelf.allOrdersDataSource = allOrdersArray;
                                                [weakSelf.billTableView reloadData];
                                            }else{
                                                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋，还没有交易记录哟" isHiddenButton:YES];
                                                weakSelf.billTableView.hidden = YES;
                                            }
                                            
                                            if ([allOneCardBill count] > 0) {
                                                weakSelf.oneCardDataSource = allOneCardBill;
                                            }
                                            
                                            if ([allContributeBill count] > 0) {
                                                weakSelf.contributeDataSource = allContributeBill;
                                            }
                                            
                                            if ([allMobileRechargeBill count] > 0) {
                                                weakSelf.mobileRechargeDataSource = allMobileRechargeBill;
                                            }
                                            if ([allTiXianBill count] > 0) {
                                                weakSelf.tiXianDataSource = allTiXianBill;
                                            }
                                            if ([allDidanFeiBill count] > 0) {
                                                weakSelf.dianFeiDataSource = allDidanFeiBill;
                                            }
                                            if ([allSchoolFeesBill count] > 0) {
                                                weakSelf.schoolFessSource = allSchoolFeesBill;
                                            }
                                            if ([allCollectFeesBill count] > 0) {
                                                weakSelf.collectFeesSource = allCollectFeesBill;
                                            }
                                            if ([allXiaoDaiBill count] > 0) {
                                                weakSelf.xiaoDaiSource = allXiaoDaiBill;
                                            }
                                            if ([allNetFeesBill count] > 0) {
                                                weakSelf.netFeesSource = allNetFeesBill;
                                            }
                                            if (allScanToPayBills.count > 0) {
                                                weakSelf.scanToPaySource = allScanToPayBills;
                                            }
                                            if (allLearnDrivingBills.count > 0) {
                                                weakSelf.learnDrivingSource = allLearnDrivingBills;
                                            }
                                            if (allVeinPayBills.count > 0) {
                                                weakSelf.veinPaySource = allVeinPayBills;
                                            }
                                            if (allQRPayBills.count > 0) {
                                                weakSelf.QRPaySource = allQRPayBills;
                                            }
                                            
                                            
                                        }else{
                                            weakSelf.billTableView.hidden = YES;
                                            weakSelf.isNetworkError = YES;
                                            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                            [self setupNoteImage:[UIImage imageNamed:@"network_error"] note:retMsg isHiddenButton:NO];
                                            
                                            [SVProgressHUD showErrorWithStatus:retMsg];
                                        }


        
    } failure:^(NSError *error) {
        weakSelf.isNetworkError = YES;
        weakSelf.billTableView.hidden = YES;
        [self setupNoteImage:[UIImage imageNamed:@"network_error"] note:@"世界上最远的距离是没有网..." isHiddenButton:NO];
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
#pragma mark - datasource add delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataSource objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BillCell";
    BNAllPayBillCell *cell = (BNAllPayBillCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *dicInfo = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setupDataTableViewCellWithInfo:dicInfo];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headID = @"BillHeadView";
    BillTableHeadView *head = (BillTableHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    if (head == nil) {
        head = [[BillTableHeadView alloc] init];
    }
    NSDictionary *dicInfo = [[_dataSource objectAtIndex:section] objectAtIndex:0];
    
    NSString *dateString = [dicInfo valueNotNullForKey:@"update_time"];

    NSString *yearStr = nil;
    NSString *monthStr = nil;
    if (dateString.length >= 4) {
        yearStr = [dateString substringWithRange:NSMakeRange(0, 4)];
    }
    if (dateString.length >= 7) {
        monthStr = [dateString substringWithRange:NSMakeRange(5, 2)];
    }
    if (yearStr.length > 0 && monthStr.length > 0) {
        [head setupDataForHeadViewWith:[NSString stringWithFormat:@"%@年%@月", yearStr, monthStr]];
    }
    
    return head;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *info = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    BNBillDetailVC *resultVC = [[BNBillDetailVC alloc] init];
    resultVC.returnRefreshBlock = ^(){
        [self loadDataSource];
    };
    resultVC.dict = info;
    [self pushViewController:resultVC animated:YES];
}
#pragma mark - button action
- (void)showAllBillAction:(UIButton *)btn
{
    if (_filterViewForBill.filterIsShowing == YES) {
        _filterButton.backgroundColor = [UIColor whiteColor];
        _allBillButton.backgroundColor = UIColor_NewBlueColor;
        
        [_allBillButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_filterButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
        [self showArrowAnimition:[UIImage imageNamed:@"Lives_Mobile_Center_BlueArrow"]];
        [_filterViewForBill filterHidden];
        [UIView animateWithDuration:0.5 animations:^{
            _halfBlackView.alpha = 0.0;
        }];
    }
    
    switch (_billShowType) {
        case BillShowTypeContribution:
        case BillShowTypeOneCardSolution:
        case BillShowTypeMobileRecharge:
        case BillShowTypeTiXian:
        case BillShowTypeDianFei:
        case BillShowTypeSchoolFees:
        case BillShowTypeCollectFees:
        case BillShowTypeXiaoDai:
        case BillShowTypeNetFees:
        case BillShowTypeScanToPay:
        case BillShowTypeLearnDriving:
        case BillShowTypeVeinPay:
        case BillShowTypeQRPay:
            _billShowType = BillShowTypeAll;
            _filterButton.backgroundColor = [UIColor whiteColor];
            _allBillButton.backgroundColor = UIColor_NewBlueColor;
            [_allBillButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_filterButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];

            [self showArrowAnimition:[UIImage imageNamed:@"Lives_Mobile_Center_BlueArrow"]];
            [_filterButton setTitle:@"分类订单" forState:UIControlStateNormal];
            _dataSource = _allOrdersDataSource;
            
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋，还没有交易记录哟" isHiddenButton:YES];
            }

            [_billTableView reloadData];
            break;
        case BillShowTypeAll:
            
            break;
        default:
            break;
    }
    
}

- (void)showFilterAction:(UIButton *)btn
{
    if (_isNetworkError == YES) {
        [SVProgressHUD showErrorWithStatus:@"请点击重新加载"];
        return;
    }
    
    if (_filterViewForBill.filterIsShowing == NO) {
        _filterButton.backgroundColor = UIColor_NewBlueColor;
        _allBillButton.backgroundColor = [UIColor whiteColor];
        [_allBillButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
        [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self showArrowAnimition:[UIImage imageNamed:@"Lives_Mobile_Center_WhiteArrow"]];
        [_filterViewForBill filterShow];
        
        [self showHalfBlackView];
    }else{
        if (_billShowType == BillShowTypeAll) {
            _filterButton.backgroundColor = [UIColor whiteColor];
            _allBillButton.backgroundColor = UIColor_NewBlueColor;
            [_allBillButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_filterButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
           
            [self showArrowAnimition:[UIImage imageNamed:@"Lives_Mobile_Center_BlueArrow"]];
        }else{
            _filterButton.backgroundColor = UIColor_NewBlueColor;
            _allBillButton.backgroundColor = [UIColor whiteColor];
            [_allBillButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
            [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self showArrowAnimition:[UIImage imageNamed:@"filter_arrow_white_up"]];
        }

        
        [_filterViewForBill filterHidden];
        
        [self hiddenHalfBlackView];
    }
}

- (void)showHalfBlackView{
    [UIView animateWithDuration:0.5 animations:^{
        _halfBlackView.alpha = 0.5;
    }];

}
- (void)hiddenHalfBlackView{
    [UIView animateWithDuration:0.5 animations:^{
        _halfBlackView.alpha = 0.0;
    }];
//    [self showArrowAnimition:[UIImage imageNamed:@"filter_arrow_white_up"]];
}

- (void)showArrowAnimition:(UIImage *)image
{
    [_filterArrow setImage:image];
    _filterArrow.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    CABasicAnimation *animition = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animition.fromValue = [NSNumber numberWithFloat:0.0];
    animition.toValue = [NSNumber numberWithFloat:M_PI];
    animition.duration = 0.5;
    animition.fillMode = kCAFillModeForwards;
    [_filterArrow.layer addAnimation:animition forKey:@"transform.rotation.z"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}
- (void)cancelFiter:(UITapGestureRecognizer *)tap
{
    [self showFilterAction:nil];
}

#pragma mark - filter delegate
- (void)filterSelectedIndex:(NSInteger)index
{
    switch (index) {
        case FILTER_BTN_TAG_BASE:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"一卡通"];
            
            _dataSource = _oneCardDataSource;
            [_filterButton setTitle:@"一卡通" forState:UIControlStateNormal];
            _billShowType = BillShowTypeOneCardSolution;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有一卡通充值记录哦" isHiddenButton:YES];
            }
        }
            break;
            
        case FILTER_BTN_TAG_BASE + 1:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"手机充值"];
            
            _dataSource = _mobileRechargeDataSource;
            [_filterButton setTitle:@"手机充值" forState:UIControlStateNormal];
            _billShowType = BillShowTypeMobileRecharge;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有手机充值记录哦" isHiddenButton:YES];
            }
        }
            break;
       
        case FILTER_BTN_TAG_BASE + 2:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"电费充值"];
            
            _dataSource = _dianFeiDataSource;
            [_filterButton setTitle:@"电费充值" forState:UIControlStateNormal];
            _billShowType = BillShowTypeDianFei;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }
            else
            {
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你没有电费充值记录哦" isHiddenButton:YES];
            }
            
        }
            break;
        case FILTER_BTN_TAG_BASE + 3:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"学校费用缴纳"];
            
            _dataSource = _schoolFessSource;
            BNLog(@"学校费用缴纳订单中心---->>>>%@",_dataSource);
            [_filterButton setTitle:@"教育缴费" forState:UIControlStateNormal];//字太长，加几个空格好看
            _billShowType = BillShowTypeSchoolFees;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有教育缴费记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 4:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"费用领取"];
            
            _dataSource = _collectFeesSource;
            BNLog(@"费用领取订单中心---->>>>%@",_dataSource);
            [_filterButton setTitle:@"费用领取" forState:UIControlStateNormal];
            _billShowType = BillShowTypeSchoolFees;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有费用领取记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 5:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"哈贷"];
            
            _dataSource = _xiaoDaiSource;
            BNLog(@"嘻哈贷订单中心---->>>>%@",_dataSource);
            [_filterButton setTitle:@"嘻哈贷" forState:UIControlStateNormal];
            _billShowType = BillShowTypeXiaoDai;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有嘻哈贷记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 6:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"网费缴纳"];
            
            _dataSource = _netFeesSource;
            BNLog(@"网费---->>>>%@",_dataSource);
            [_filterButton setTitle:@"网费缴纳" forState:UIControlStateNormal];
            _billShowType = BillShowTypeNetFees;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有网费缴纳记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 7:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"到店付"];
            
            _dataSource = _scanToPaySource;
            BNLog(@"到店付---->>>>%@",_dataSource);
            [_filterButton setTitle:@"到店付" forState:UIControlStateNormal];
            _billShowType = BillShowTypeScanToPay;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有到店付记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 8:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"喜付学车"];
            
            _dataSource = _learnDrivingSource;
            BNLog(@"学车---->>>>%@",_dataSource);
            [_filterButton setTitle:@"喜付学车" forState:UIControlStateNormal];
            _billShowType = BillShowTypeLearnDriving;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有喜付学车记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 9:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"静脉支付"];
            
            _dataSource = _veinPaySource;
            BNLog(@"静脉支付---->>>>%@",_dataSource);
            [_filterButton setTitle:@"静脉支付" forState:UIControlStateNormal];
            _billShowType = BillShowTypeVeinPay;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有静脉支付记录哦" isHiddenButton:YES];
            }
        }
            break;
        case FILTER_BTN_TAG_BASE + 10:
        {
            //友盟事件点击
            [MobClick event:@"AllPayBillListVC_Channel" label:@"二维码支付"];
            
            _dataSource = _QRPaySource;
            BNLog(@"二维码支付---->>>>%@",_dataSource);
            [_filterButton setTitle:@"二维码支付" forState:UIControlStateNormal];
            _billShowType = BillShowTypeQRPay;
            if ([_dataSource count] > 0) {
                _billTableView.hidden = NO;
            }else{
                _billTableView.hidden = YES;
                [self setupNoteImage:[UIImage imageNamed:@"view_null"] note:@"童鞋,你还没有二维码支付记录哦" isHiddenButton:YES];
            }
        }
            break;
        default:
            break;
    }
    [_allBillButton setTitleColor:UIColor_NewBlueColor forState:UIControlStateNormal];
    [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_filterViewForBill filterHidden];
    [self showArrowAnimition:[UIImage imageNamed:@"Lives_Mobile_Center_BlueArrow"]];
    
    [self showArrowAnimition:[UIImage imageNamed:@"filter_arrow_white_up"]];
    [self hiddenHalfBlackView];
    [self.billTableView reloadData];
    
    
}
-(void)backButtonClicked:(UIButton *)sender
{
    if (_returnsBlock) {
            self.returnsBlock();
    } else {
        [super backButtonClicked:sender];
    }


}

@end
