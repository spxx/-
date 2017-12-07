//
//  BNBillViewController.m
//  NewWallet
//
//  Created by mac on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBillViewController.h"
#import "BNBillListCell.h"
#import "CardApi.h"

@interface BNBillViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UIView *baseView;
@property (nonatomic) UIButton *oneCardMoneyBtn;
@property (nonatomic) UILabel *oneCardMoneyLbl;
@property (nonatomic) UIImageView *arrowImgView;
@property (nonatomic) UILabel *payMoneyLabel;
@property (nonatomic) UILabel *chargeMoneyLabel;
@property (nonatomic) UIView *nullDataView;
@property (nonatomic) BOOL expanded;    //是否展开
@property (nonatomic) CGFloat lastY;

@end

@implementation BNBillViewController
static CGFloat detailViewHeight;
static CGFloat oneCardMoneyHeight;
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"一卡通账单";
    self.view.backgroundColor = UIColor_Gray_BG;
    self.dataArray = [@[] mutableCopy];
    _expanded = NO;
    
    CGFloat btnHeight = 38*BILI_WIDTH;
    self.oneCardMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneCardMoneyBtn .frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, btnHeight);
    [_oneCardMoneyBtn setBackgroundColor:UIColorFromRGB(0x138dff)];
    [_oneCardMoneyBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_oneCardMoneyBtn];
    
    oneCardMoneyHeight = [BNTools sizeFit:17 six:19 sixPlus:21];
    self.oneCardMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/3*2, btnHeight)];
    _oneCardMoneyLbl.textColor = [UIColor whiteColor];
    _oneCardMoneyLbl.font = [UIFont boldSystemFontOfSize:oneCardMoneyHeight];
    _oneCardMoneyLbl.backgroundColor = [UIColor clearColor];
    NSString *yktBalance = [NSString stringWithFormat:@"一卡通余额：%@",@"_ _"];
    
    _oneCardMoneyLbl.attributedText = [Tools attributedStringWithText:yktBalance textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:oneCardMoneyHeight-4] colorRange:NSMakeRange(0, 6)];
    [_oneCardMoneyBtn addSubview:_oneCardMoneyLbl];

    UILabel *dayTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-20*BILI_WIDTH-80, 0, 80, btnHeight)];
    dayTitle.textColor = [UIColor whiteColor];
    dayTitle.textAlignment = NSTextAlignmentRight;
    dayTitle.font = [UIFont systemFontOfSize:oneCardMoneyHeight-4];
    dayTitle.backgroundColor = [UIColor clearColor];
    dayTitle.text = @"最近30天";
    [_oneCardMoneyBtn addSubview:dayTitle];
    
    self.arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-12*BILI_WIDTH, (btnHeight-12*BILI_WIDTH)/2, 12*BILI_WIDTH, 12*BILI_WIDTH)];
    _arrowImgView.image = [UIImage imageNamed:@"OneCard_BillList_ArrowBtn_up"];;
    [_oneCardMoneyBtn addSubview:_arrowImgView];

    
    CGFloat originY = self.sixtyFourPixelsView.viewBottomEdge + btnHeight;
    detailViewHeight = 112*BILI_WIDTH;
    CGFloat tableViewHeight = SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge-btnHeight;

    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, originY-detailViewHeight, SCREEN_WIDTH, detailViewHeight+tableViewHeight)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_baseView atIndex:0];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, detailViewHeight)];
    detailView.backgroundColor = UIColorFromRGB(0x138dff);
    [_baseView addSubview:detailView];
    
    UIView *grayLineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, _baseView.frame.size.width-30, 1)];
    grayLineView.backgroundColor = UIColorFromRGB(0x3ba7f7);
    [detailView addSubview:grayLineView];
    
    CGFloat moneyHeight = [BNTools sizeFit:30 six:32 sixPlus:34];
    self.payMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, detailView.frame.size.height/2-moneyHeight-5*BILI_WIDTH, 140, moneyHeight)];
    _payMoneyLabel.textColor = [UIColor whiteColor];
    _payMoneyLabel.font = [UIFont boldSystemFontOfSize:moneyHeight];
    _payMoneyLabel.backgroundColor = [UIColor clearColor];
    _payMoneyLabel.text = @"_ _";
    [detailView addSubview:_payMoneyLabel];
    
    self.chargeMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailView.frame.size.width-140-15, detailView.frame.size.height/2-moneyHeight, 140, moneyHeight)];
    _chargeMoneyLabel.textColor = [UIColor whiteColor];
    _chargeMoneyLabel.font = [UIFont boldSystemFontOfSize:moneyHeight];
    _chargeMoneyLabel.textAlignment = NSTextAlignmentRight;
    _chargeMoneyLabel.backgroundColor = [UIColor clearColor];
    _chargeMoneyLabel.text = @"_ _";
    [detailView addSubview:_chargeMoneyLabel];
    
    CGFloat payMoneyLblHeight = [BNTools sizeFit:15 six:17 sixPlus:19];

    UIImageView *payMoneyImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, detailView.frame.size.height/3*2, payMoneyLblHeight, payMoneyLblHeight)];
    payMoneyImgV.image = [UIImage imageNamed:@"OneCard_BillList_PayMoney"];
    [detailView addSubview:payMoneyImgV];


    UILabel *payMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(15+payMoneyLblHeight+9*BILI_WIDTH, detailView.frame.size.height/3*2, 80, payMoneyLblHeight)];
    payMoneyLbl.textColor = [UIColor whiteColor];
    payMoneyLbl.font = [UIFont systemFontOfSize:payMoneyLblHeight-2];
    payMoneyLbl.backgroundColor = [UIColor clearColor];
    payMoneyLbl.text = @"消费金额";
    [detailView addSubview:payMoneyLbl];
    
    UIImageView *chargeMoneyImgV = [[UIImageView alloc]initWithFrame:CGRectMake(detailView.frame.size.width-15-payMoneyLblHeight*4-payMoneyLblHeight-9*BILI_WIDTH+[BNTools sizeFit:8 six:5 sixPlus:4], detailView.frame.size.height/3*2, payMoneyLblHeight, payMoneyLblHeight)];
    chargeMoneyImgV.image = [UIImage imageNamed:@"OneCard_BillList_ChargeMoney"];
    [detailView addSubview:chargeMoneyImgV];
    
    UILabel *chargeMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(detailView.frame.size.width-80-payMoneyLblHeight, detailView.frame.size.height/3*2, 80, payMoneyLblHeight)];
    chargeMoneyLbl.textColor = [UIColor whiteColor];
    chargeMoneyLbl.font = [UIFont systemFontOfSize:payMoneyLblHeight-2];
    chargeMoneyLbl.backgroundColor = [UIColor clearColor];
    chargeMoneyLbl.textAlignment = NSTextAlignmentRight;
    chargeMoneyLbl.text = @"充值金额";
    [detailView addSubview:chargeMoneyLbl];
    
    originY = detailViewHeight;
    UIView *whiteBGView2 = [[UIView alloc]initWithFrame:CGRectMake(0, detailViewHeight, SCREEN_WIDTH, 40*BILI_WIDTH)];
    whiteBGView2.backgroundColor = [UIColor whiteColor];
    [_baseView addSubview:whiteBGView2];
    
    UILabel *totalListLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80*BILI_WIDTH, whiteBGView2.frame.size.height-7*BILI_WIDTH)];
    totalListLbl.textColor = detailView.backgroundColor;
    totalListLbl.font = [UIFont systemFontOfSize:payMoneyLblHeight-2];
    totalListLbl.backgroundColor = [UIColor clearColor];
    totalListLbl.textAlignment = NSTextAlignmentCenter;
    totalListLbl.text = @"总流水";
    [whiteBGView2 addSubview:totalListLbl];
    
    UIView *blueLineView = [[UIView alloc]initWithFrame:CGRectMake(20, whiteBGView2.frame.size.height-7*BILI_WIDTH, 80*BILI_WIDTH, 3*BILI_WIDTH)];
    blueLineView.backgroundColor = UIColorFromRGB((0x79c9ff));
    [whiteBGView2 addSubview:blueLineView];
    
    originY += whiteBGView2.frame.size.height;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, originY, SCREEN_WIDTH-14, _baseView.frame.size.height-detailViewHeight-whiteBGView2.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.tableHeaderView = headBaseView;
    [_tableView registerClass:[BNBillListCell class] forCellReuseIdentifier:@"BNBillListCell"];
    if (IOS_VERSION >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 39, 0, 15);
    }
    [_baseView addSubview: _tableView];
    
    [self addNullView];
    [self getyktBalance];
    [self getData];
}
- (void)getyktBalance
{
    __weak typeof(self) weakSelf = self;
    [CardApi oneCardStususWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                            stuempno:shareAppDelegateInstance.boenUserInfo.stuempno
                            schoolID:shareAppDelegateInstance.boenUserInfo.schoolId
                             success:^(NSDictionary *successData) {
                                 BNLog(@"一卡通状态--%@", successData);
                                 NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                 NSDictionary *dataDic = [successData valueForKey:kRequestReturnData];
                                 if ([retCode isEqualToString:kRequestSuccessCode]) {
                                     NSString *yktBalance0 = [NSString stringWithFormat:@"%@",[dataDic valueNotNullForKey:@"balance"]];
                                     if ([yktBalance0 isEqualToString:@"-1"] || [yktBalance0 isEqualToString:@"null"]) {
                                         yktBalance0 = @"_ _";
                                     }
                                     NSString *yktBalance = [NSString stringWithFormat:@"一卡通余额：%@",yktBalance0];

                                     weakSelf.oneCardMoneyLbl.attributedText = [Tools attributedStringWithText:yktBalance textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:oneCardMoneyHeight-4] colorRange:NSMakeRange(0, 6)];

            
        }
    } failure:^(NSError *error) {
    }];
}

- (void)getData
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CardApi oneCardConsumes_listWithUserid:shareAppDelegateInstance.boenUserInfo.userid stuempno:shareAppDelegateInstance.boenUserInfo.stuempno schoolID:shareAppDelegateInstance.boenUserInfo.schoolId success:^(NSDictionary *successData) {
        BNLog(@"账单list--%@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *retData = [successData valueForKey:kRequestReturnData];
            NSString *total_consume = [NSString stringWithFormat:@"%@",[retData valueNotNullForKey:@"total_consume"]];
            if ([total_consume isEqualToString:@"-1"] || [total_consume isEqualToString:@"null"]) {
                total_consume = @"_ _";
            }
            NSString *total_recharge = [NSString stringWithFormat:@"%@",[retData valueNotNullForKey:@"total_recharge"]];
            if ([total_recharge isEqualToString:@"-1"] || [total_recharge isEqualToString:@"null"]) {
                total_recharge = @"_ _";
            }
            weakSelf.payMoneyLabel.text = total_consume;
            weakSelf.chargeMoneyLabel.text = total_recharge;

            NSArray *billAry = retData[@"consumes"];
            [weakSelf.dataArray addObjectsFromArray:billAry];
            [weakSelf.tableView reloadData];
            weakSelf.nullDataView.hidden = (billAry.count == 0) ? NO : YES;

        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
- (void)addNullView
{
    self.nullDataView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, (_tableView.frame.size.height-160)/2-20, 160, 160)];
    _nullDataView.layer.cornerRadius = _nullDataView.frame.size.width/2;
    _nullDataView.layer.masksToBounds = YES;
    _nullDataView.layer.borderWidth = 1;
    _nullDataView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    _nullDataView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:_nullDataView];
    _nullDataView.hidden = YES;
    _nullDataView.center = CGPointMake(_tableView.frame.size.width/2, _nullDataView.center.y);
    
    UILabel *nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _nullDataView.frame.size.width, _nullDataView.frame.size.width)];
    nullLabel.textAlignment = NSTextAlignmentCenter;
    nullLabel.textColor = UIColorFromRGB(0xb0b0b0);
    nullLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:14 sixPlus:16]];
    nullLabel.backgroundColor = [UIColor clearColor];
    nullLabel.text = @"暂无记录";
    [_nullDataView addSubview: nullLabel];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BNBillListCell";
    BNBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell drawData:_dataArray[indexPath.row] withAryCount:_dataArray.count andRow:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .1)];
    views.backgroundColor = UIColorFromRGB(0xe6e6e6);
    return views;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - buttonAction
- (void)buttonAction
{
    if (_expanded) {
        [UIView animateWithDuration:.3 animations:^{
            _baseView.transform = CGAffineTransformMakeTranslation(0, 0);
            _arrowImgView.image = [UIImage imageNamed:@"OneCard_BillList_ArrowBtn_up"];;
        }];
        _expanded = NO;
    } else {
        [UIView animateWithDuration:.3 animations:^{
            _baseView.transform = CGAffineTransformMakeTranslation(0, detailViewHeight);
            _arrowImgView.image = [UIImage imageNamed:@"OneCard_BillList_ArrowBtn_down"];;
        }];
        _expanded = YES;
    }
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float newY = 0;

    newY = scrollView.contentOffset.y;

    if (newY != _lastY) {
        if (newY > _lastY && newY > 0 && (newY - _lastY) > 2 && _expanded) {
            BNLog(@"up");
            [self buttonAction];
            
        } else if (newY < 0 && !_expanded) {
            [self buttonAction];
        }
        _lastY = newY;

    }
}
@end
