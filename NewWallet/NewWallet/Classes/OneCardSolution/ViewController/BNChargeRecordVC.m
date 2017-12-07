//
//  BNChargeRecordVC.m
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNChargeRecordVC.h"
#import "BNChargeRecordTableViewCell.h"
#import "CardApi.h"

@interface BNChargeRecordVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) UIView *nullDataView;

@end

@implementation BNChargeRecordVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"充值记录";
    self.view.backgroundColor = UIColor_Gray_BG;
    self.dataArray = [@[] mutableCopy];
    
    [self addNullView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH-14, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = [[UIView alloc] initWithFrame:_tableView.frame];
    _tableView.backgroundView.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [_tableView registerClass:[BNChargeRecordTableViewCell class] forCellReuseIdentifier:@"BNChargeRecordTableViewCell"];
    if (IOS_VERSION >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    [self.view addSubview:_tableView];
    
    [self getData];
}
- (void)addNullView
{
    self.nullDataView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 170, 160, 160)];
    _nullDataView.layer.cornerRadius = _nullDataView.frame.size.width/2;
    _nullDataView.layer.masksToBounds = YES;
    _nullDataView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_nullDataView];
    _nullDataView.hidden = YES;

    UILabel *nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _nullDataView.frame.size.width, _nullDataView.frame.size.width)];
    nullLabel.textAlignment = NSTextAlignmentCenter;
    nullLabel.textColor = UIColorFromRGB(0xb0b0b0);
    nullLabel.font = [UIFont systemFontOfSize:12];
    nullLabel.backgroundColor = [UIColor clearColor];
    nullLabel.text = @"暂无记录";
    [_nullDataView addSubview: nullLabel];
}
- (void)getData
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [CardApi oneCardRecharges_listWithUserid:shareAppDelegateInstance.boenUserInfo.userid success:^(NSDictionary *successData) {
        BNLog(@"充值记录list--%@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *retData = [successData valueNotNullForKey:kRequestReturnData];
            NSArray *chargeAry = retData[@"recharges"];
            [weakSelf.dataArray addObjectsFromArray:chargeAry];
            [weakSelf.tableView reloadData];

            weakSelf.nullDataView.hidden = (chargeAry.count == 0) ? NO : YES;
            weakSelf.tableView.hidden = (chargeAry.count == 0) ? YES : NO;
            
        }else{
            NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

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
    static NSString *cellIdentifier = @"BNChargeRecordTableViewCell";
    BNChargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell drawData:_dataArray[indexPath.row]];
    
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
@end
