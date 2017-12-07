//
//  BNReturnMoneyDetailVC.m
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnMoneyDetailVC.h"
#import "BNReturnMoneyDetailCellTemp.h"
#import "XiaoDaiApi.h"

@interface BNReturnMoneyDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSDictionary *borrowInfoDic;
@property (nonatomic) UIView *noDataBGView;

@end

@implementation BNReturnMoneyDetailVC
- (id)initWithBorrowInfo:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        self.borrowInfoDic = aDic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"还款明细";
    self.view.backgroundColor = UIColor_Gray_BG;
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10*BILI_WIDTH, 0, 0);
    [_tableView registerClass:[BNReturnMoneyDetailCellTemp class] forCellReuseIdentifier:@"BNReturnMoneyDetailCellTemp"];
    [self.view addSubview:_tableView];
    
    [self requestData];
    
}
- (void)requestData
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    //请求数据
    NSString *orderNumber = _borrowInfoDic[@"order_no"];
    [XiaoDaiApi repayQueryWithOrderNumber:orderNumber success:^(NSDictionary *returnData) {
        NSArray *array = returnData[@"data"];
        [SVProgressHUD dismiss];
        [_dataArray addObjectsFromArray:array];
        if (_dataArray.count <= 0) {
            _noDataBGView.hidden = NO;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.tableFooterView = [self getTableViewBackgroundView];
        } else {
            _noDataBGView.hidden = YES;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.tableFooterView = nil;
            //        _returnMoneyStatus = ReturnMoneyStatusReturnAll;
        }
        _tableView.tableHeaderView = [self getTableViewHeadView];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}

- (UIView *)getTableViewHeadView
{
    CGFloat originY = 0;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = UIColor_Gray_BG;
    
    //----->>>>>111  临时不显示红色逾期内容，要显示就打开111，
//    if (_returnMoneyStatus == ReturnMoneyStatusTimeOut) {
//        NSString *yuqiStr = @"本期还款已逾期3天，罚息12元!若逾期30天未还款将记入征信系统，影响个人信用记录！请尽快还款！";
//        CGFloat redTitleHeight = [Tools caleNewsCellHeightWithTitle:yuqiStr font:[UIFont systemFontOfSize:13*BILI_WIDTH] width:SCREEN_WIDTH-2*10*BILI_WIDTH];
//        
//        UIView *redBGView =[[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 10)];
//        redBGView.backgroundColor = UIColor_RedButtonBGHighLight;
//        [headView addSubview:redBGView];
//        
//        UILabel *timeOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 7*BILI_WIDTH, SCREEN_WIDTH-2*10*BILI_WIDTH, redTitleHeight)];
//        timeOutLbl.backgroundColor = [UIColor clearColor];
//        timeOutLbl.textColor = [UIColor whiteColor];
//        timeOutLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
//        timeOutLbl.numberOfLines = 0;
//        timeOutLbl.text = yuqiStr;
//        [redBGView addSubview:timeOutLbl];
//
//        redBGView.frame = CGRectMake(0, originY, SCREEN_WIDTH, 2*7*BILI_WIDTH+redTitleHeight);
//        
//        originY += redBGView.frame.size.height;
//    }
    //<<<<----111
    
    UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.frame = CGRectMake(0, originY, SCREEN_WIDTH, 90*BILI_WIDTH);
    [statusBtn setBackgroundColor:UIColor_Gray_BG];
    [statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    statusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20*BILI_WIDTH];
    statusBtn.userInteractionEnabled = NO;
    [statusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [headView addSubview:statusBtn];
    
    NSString *statusString = _borrowInfoDic[@"status"];

    if ([statusString isEqualToString:@"UN_REPAYMENT"])
    {
        //未还完
        [statusBtn setTitle:@"未还完" forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];
    }
    else if ([statusString isEqualToString:@"REPAYENTED"]) {
        //已还完
        [statusBtn setTitle:@"已还完" forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
    }
    else if ([statusString isEqualToString:@"OVERDUE"])
    {
        //已逾期
        [statusBtn setTitle:@"已逾期" forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
    }
    else if ([statusString isEqualToString:@"FAILURE"])
    {
        //还款失败
        [statusBtn setTitle:@"还款失败" forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
    }
    //if ([statusString isEqualToString:@"PAYING"])
    else
    {
        //处理中
        [statusBtn setTitle:@"未还完" forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];

    }

    originY += statusBtn.frame.size.height;

    CGFloat whiteViewOriginY = 9*BILI_WIDTH;
    UIView *whiteView =[[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 122*BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:whiteView];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH-(110+2*14)*BILI_WIDTH, 14*BILI_WIDTH)];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    titleLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:titleLbl];
    titleLbl.text = [NSString stringWithFormat: @"分期还（%@期-%@元/期）",@4,_borrowInfoDic[@"installment_amount"]];
    
    UILabel *timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(110+14)*BILI_WIDTH, whiteViewOriginY+2, 110*BILI_WIDTH, 11*BILI_WIDTH)];
    timeLbl.textColor = UIColorFromRGB(0xbcbcbc);
    timeLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:timeLbl];
    timeLbl.text = [NSString stringWithFormat:@"%@",[_borrowInfoDic valueNotNullForKey:@"create_time"]];

    NSString *repaymentTypeString = [NSString stringWithFormat:@"%@",[_borrowInfoDic valueNotNullForKey:@"repayment_type"]];
    NSString *next_installment_repay_date = @"";
    
    if ([repaymentTypeString isEqualToString:@"SCHEDULED"]) {
        repaymentTypeString = @"随时还";
        titleLbl.text = @"随时还";
        next_installment_repay_date = [NSString stringWithFormat:@"还款时间：%@前",[_borrowInfoDic valueNotNullForKey:@"repay_date"]];
    }else{
        repaymentTypeString = @"分期还";
        titleLbl.text = [NSString stringWithFormat:@"分期还（%@期-%@元/期)",[_borrowInfoDic valueNotNullForKey:@"installments"],[_borrowInfoDic valueNotNullForKey:@"installment_amount"]];
        next_installment_repay_date = [NSString stringWithFormat:@"还款时间：每月%@号之前",[_borrowInfoDic valueNotNullForKey:@"current_installment_repay_date"]];
    }
    
    whiteViewOriginY += titleLbl.frame.size.height + 28*BILI_WIDTH;

    UILabel *moneyTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 13*BILI_WIDTH)];
    moneyTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
    moneyTitleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    moneyTitleLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:moneyTitleLbl];
    moneyTitleLbl.text = @"借款金额(元)";

    UILabel *remainMoneyTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (145+14)*BILI_WIDTH, whiteViewOriginY, 145*BILI_WIDTH, 13*BILI_WIDTH)];
    remainMoneyTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
    remainMoneyTitleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
    remainMoneyTitleLbl.backgroundColor = [UIColor clearColor];
    remainMoneyTitleLbl.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:remainMoneyTitleLbl];
    remainMoneyTitleLbl.text = @"余额加利息剩余未还(元)";

    UIView *redLineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, whiteViewOriginY, 0.5, 47*BILI_WIDTH)];
    redLineView.backgroundColor = UIColorFromRGB(0xffe0e5);
    [whiteView addSubview:redLineView];

    whiteViewOriginY += moneyTitleLbl.frame.size.height + 10*BILI_WIDTH;

    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 22*BILI_WIDTH)];
    moneyLbl.textColor = [UIColor blackColor];
    moneyLbl.font = [UIFont systemFontOfSize:22*BILI_WIDTH];
    moneyLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview:moneyLbl];
    //借款金额
    moneyLbl.text = [NSString stringWithFormat:@"%@",[_borrowInfoDic valueNotNullForKey:@"loan_amount"]];
    
    UILabel *remainMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (115+14)*BILI_WIDTH, whiteViewOriginY, 115*BILI_WIDTH, 22*BILI_WIDTH)];
    remainMoneyLbl.textColor = UIColor_RedButtonBGNormal;
    remainMoneyLbl.font = [UIFont systemFontOfSize:22*BILI_WIDTH];
    remainMoneyLbl.backgroundColor = [UIColor clearColor];
    remainMoneyLbl.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:remainMoneyLbl];
    //剩余还款
    remainMoneyLbl.text = [NSString stringWithFormat:@"%@",[_borrowInfoDic valueNotNullForKey:@"current_installment_amount"]];
    
    whiteViewOriginY += moneyLbl.frame.size.height + 27*BILI_WIDTH;

    originY += whiteViewOriginY;
    
    //还款时间
    UIButton *remainTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remainTimeBtn.frame = CGRectMake(0, originY, SCREEN_WIDTH, 28*BILI_WIDTH);
    [remainTimeBtn setBackgroundColor:UIColorFromRGB(0xf4f4f4)];
    [remainTimeBtn setTitleColor:UIColorFromRGB(0xbcbcbc) forState:UIControlStateNormal];
    remainTimeBtn.titleLabel.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    remainTimeBtn.userInteractionEnabled = NO;
    [remainTimeBtn setImage:[UIImage imageNamed:@"ReturnMoney_timeIcon"] forState:UIControlStateNormal];
    [remainTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15*BILI_WIDTH)];
    [remainTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10*BILI_WIDTH)];
    remainTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [headView addSubview:remainTimeBtn];
    [remainTimeBtn setTitle:next_installment_repay_date forState:UIControlStateNormal];

    originY += remainTimeBtn.frame.size.height;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = UIColor_GrayLine;
    [headView addSubview:lineView];
    
    UILabel *recordTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, originY, 110*BILI_WIDTH, 28*BILI_WIDTH)];
    recordTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
    recordTitleLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    recordTitleLbl.backgroundColor = [UIColor clearColor];
    [headView addSubview:recordTitleLbl];
    recordTitleLbl.text = @"还款记录";
    
    originY += recordTitleLbl.frame.size.height;

    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, originY);
    return headView;
}

- (UIView *)getTableViewBackgroundView
{
    if (!_noDataBGView) {
        self.noDataBGView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _noDataBGView.backgroundColor = [UIColor clearColor];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, 19*BILI_WIDTH, SCREEN_WIDTH-2*20*BILI_WIDTH, 12*BILI_WIDTH)];
        lbl.textColor = UIColor_DarkGray_Text;
        lbl.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        lbl.backgroundColor = [UIColor clearColor];
        [_noDataBGView addSubview:lbl];
        lbl.text = @"暂无还款记录";
    }
    return _noDataBGView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10*BILI_WIDTH,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10*BILI_WIDTH,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,10*BILI_WIDTH,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,10*BILI_WIDTH,0,0)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 60*BILI_WIDTH;  //BNReturnMoneyDetailCell
    return 45*BILI_WIDTH;  //BNReturnMoneyDetailCellTemp

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BNReturnMoneyDetailCellTemp";
    BNReturnMoneyDetailCellTemp *cell = (BNReturnMoneyDetailCellTemp *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
   
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell drawDataWithDict:dic andIndexPath:indexPath cellCount:[_dataArray count]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
