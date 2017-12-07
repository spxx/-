//
//  NewModifyPhoneTypeVC.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "NewModifyPhoneTypeVC.h"

#import "BNSettingCell.h"

#import "BNBindYKTViewController.h"
#import "NewModifyPhoneVerifyVC.h"
#import "BNCommonWebViewController.h"

@interface NewModifyPhoneTypeVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *subTitleArray;
@property (weak, nonatomic)   UITableView *detialTableView;
@end
@implementation NewModifyPhoneTypeVC

- (void)setupLoadedView
{
    self.navigationTitle = @"修改手机号";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UILabel *discriLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, self.sixtyFourPixelsView.viewBottomEdge, 300*BILI_WIDTH, 36)];
    discriLbl.backgroundColor = [UIColor clearColor];
    discriLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    discriLbl.textColor = UIColor_DarkGray_Text;
    discriLbl.text = @"请选择任意一种校验方式来进行修改手机号！";
    [self.view addSubview:discriLbl];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge+36, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge -36) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44 * BILI_WIDTH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detialTableView = tableView;
    [self.view addSubview:tableView];

}

- (void)setupData
{
    NSArray *section1TitleArray = @[@"验证身份信息", @"验证登录密码"];
    NSArray *section2TitleArray = @[@"联系客服处理"];
    _titlesArray = @[section1TitleArray, section2TitleArray];
    
    [_detialTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData];
}
#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_titlesArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_titlesArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BNSettingCell";
    BNSettingCell *cell = (BNSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BNSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellTitleLab.text = [[_titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headHeight = 0.0;
    switch (section) {
        case 0:
            headHeight = 0;
            break;
            
        case 1:
            headHeight = kSectionHeight + 5.0;
            break;
            
        default:
            break;
    }
    return headHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headHeight = 0.0;
    switch (section) {
        case 0:
            headHeight = kSectionHeight;
            break;
            
        case 1:
            headHeight = kSectionHeight + 5.0;
            break;
            
        default:
            break;
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headHeight)];
    headView.backgroundColor = UIColor_Gray_BG;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headHeight - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColor_GrayLine;
    [headView addSubview:line];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColor_GrayLine;
    return line;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //联系客服处理
        BNCommonWebViewController *webVC = [[BNCommonWebViewController alloc]init];
        webVC.navTitle = @"修改手机号";
        webVC.urlString = [BASE_URL stringByAppendingString:@"/static/xifu_files/manual_change_mobile/manual_change_mobile.html"];
        [self pushViewController:webVC animated:YES];
        return;
    }
    
    switch (indexPath.row) {
        case 0: {
            //验证身份信息
            NewModifyPhoneVerifyVC *verifyVC = [[NewModifyPhoneVerifyVC alloc]init];
            verifyVC.verifyType = ModifyPhoneVerifyTypeIdentity;
            [self pushViewController:verifyVC animated:YES];
            
            break;
        }
        case 1: {
            //验证登录密码
            NewModifyPhoneVerifyVC *verifyVC = [[NewModifyPhoneVerifyVC alloc]init];
            verifyVC.verifyType = ModifyPhoneVerifyTypeLoginPsw;
            [self pushViewController:verifyVC animated:YES];
            
            break;
        }
            
    }
}
@end
