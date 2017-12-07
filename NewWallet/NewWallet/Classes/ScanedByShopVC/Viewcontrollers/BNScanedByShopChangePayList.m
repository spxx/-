//
//  BNScanedByShopChangePayList.m
//  Wallet
//
//  Created by mac on 2017/3/23.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNScanedByShopChangePayList.h"
#import "BNScanedByShopChangePayListCell.h"

@interface BNScanedByShopChangePayList ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSMutableArray *originDataArray;

@property (nonatomic) BOOL systemSelect;
@property (nonatomic) UILabel *systemTipsLbl;
@property (nonatomic) UIView *headView;

@end

@implementation BNScanedByShopChangePayList

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationTitle = @"扣款顺序设置";
    
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _systemSelect = NO;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, SCREEN_WIDTH+40, 120*NEW_BILI)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *systemBGView = [[UIView alloc]initWithFrame:CGRectMake(40, 30*NEW_BILI, SCREEN_WIDTH, 50*NEW_BILI)];
    systemBGView.backgroundColor = UIColor_Gray_BG;
    
    UILabel *systemLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-2*15-51, 50*NEW_BILI)];
    systemLbl.textColor = UIColor_NewBlack_Text;
    systemLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
    systemLbl.text = @"系统自动选择";
    [systemBGView addSubview:systemLbl];
    
    UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-51, (50*NEW_BILI-31)/2, 51, 31)];
    [systemBGView addSubview:switchBtn];
    [switchBtn addTarget:self action:@selector(switchBtnChanged:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:systemBGView];
    switchBtn.on = YES;
    
    UILabel *systemTipsLbl = [[UILabel alloc]initWithFrame:CGRectMake(55, systemBGView.bottomValue, SCREEN_WIDTH, 40*NEW_BILI)];
    systemTipsLbl.textColor = UIColor_NewBlack_Text;
    systemTipsLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
    systemTipsLbl.text = @"系统根据支付习惯，自动选择付款方式";
    [headView addSubview:systemTipsLbl];
    _systemTipsLbl = systemTipsLbl;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(-40, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH+40, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80.0;
    _tableView.tableHeaderView = headView;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[BNScanedByShopChangePayListCell class] forCellReuseIdentifier:@"BNScanedByShopChangePayListCell"];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.tintColor = UIColorFromRGB(0x8bc7e4);
    [_tableView setEditing:YES animated:YES];

    _dataArray = [@[] mutableCopy];

    
    [self requestPayList];
}

- (void)requestPayList
{
    _systemSelect = NO;
    _dataArray = [@[@{@"name" : @"一卡通支付", @"id" : @"1"},
                    @{@"name" : @"成都银行（1232）信用卡", @"id" : @"2"},
                    @{@"name" : @"工商银行（2533）储蓄卡", @"id" : @"3"},
                    @{@"name" : @"浦发银行（5186）信用卡", @"id" : @"4"},] mutableCopy];
    _originDataArray = _dataArray;
    [_tableView reloadData];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_systemSelect == YES) {
        return 0;
    }
    return 48*NEW_BILI;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headView) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, SCREEN_WIDTH+40, 48*NEW_BILI)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [headView addSubview:line];
        
        UILabel *payWayLbl = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, 200, 48*NEW_BILI)];
        payWayLbl.textColor = UIColor_NewLightTextColor;
        payWayLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
        payWayLbl.text = @"付款方式";
        [headView addSubview:payWayLbl];
        
        UILabel *moveLbl = [[UILabel alloc]initWithFrame:CGRectMake(40+SCREEN_WIDTH-15-100, 0, 100, 48*NEW_BILI)];
        moveLbl.textColor = UIColor_NewLightTextColor;
        moveLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
        moveLbl.text = @"拖动";
        moveLbl.textAlignment = NSTextAlignmentRight;
        [headView addSubview:moveLbl];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(40, 48*NEW_BILI - 0.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = UIColor_GrayLine;
        [headView addSubview:line2];
        _headView = headView;
    }
    
    return _headView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idGood = @"BNScanedByShopChangePayListCell";
    
    BNScanedByShopChangePayListCell *cell = [tableView dequeueReusableCellWithIdentifier:idGood forIndexPath:indexPath];
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell drawData:dict];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48*NEW_BILI+0.5;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark 排序 当移动了某一行时候会调用
//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 取出要拖动的模型数据
    NSDictionary *dict = _dataArray[sourceIndexPath.row];
    //删除之前行的数据
    [_dataArray removeObject:dict];
    // 插入数据到新的位置
    [_dataArray insertObject:dict atIndex:destinationIndexPath.row];
}

- (void)switchBtnChanged:(UISwitch *)switchBtn
{
    if (switchBtn.on) {
        //
        BNLog(@"开");
        _systemSelect = YES;

        _systemTipsLbl.text = @"系统根据支付习惯，自动选择付款方式";
        _dataArray = [@[] mutableCopy];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            _headView.frame = CGRectMake(_headView.frame.origin.x, _headView.frame.origin.y, _headView.frame.size.width, 0);
        }];
    } else {
        BNLog(@"关");
        _systemSelect = NO;

        _systemTipsLbl.text = @"系统将根据下面排列按顺序扣款";
        _dataArray = _originDataArray;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            _headView.frame = CGRectMake(_headView.frame.origin.x, _headView.frame.origin.y, _headView.frame.size.width, 48*NEW_BILI);
        }];
    }
    
}

@end
