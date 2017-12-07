//
//  BNPersonalDetialsViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPersonalDetialsViewController.h"

#import "BNPersonalDetialCell.h"

#import "BNBindYKTViewController.h"
#import "TiXianApi.h"
#import "XiaoDaiApi.h"
#import "BNFCRealNameViewController.h"
#import "BNRealNameReviewResultVC.h"
#import "BNPersonalModStudentNoViewController.h"
#import "BNPublicHtml5BusinessVC.h"

//还钱类型
typedef NS_ENUM(NSInteger, RealNameVerifyedStatus) {
    RealNameVerifyedStatusNone,              //未实名认证
    RealNameVerifyedStatusSuccessATP,        //已通过实名认证
    RealNameVerifyedStatusReviewingAUT,      //审核中
    RealNameVerifyedStatusFailedATNUPF,      //认证失败
};

@interface BNPersonalDetialsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *titlesArray;
@property (strong, nonatomic) NSArray *subTitleArray;
@property (weak, nonatomic)   UITableView *detialTableView;
@property (nonatomic) BOOL tixianVerifyed;
@property (assign, nonatomic) RealNameReviewResult reviewResult;   //实名认证状态
@property (nonatomic) NSString *errorInfo;

@end

@implementation BNPersonalDetialsViewController

- (void)dealloc {
}

- (void)setupLoadedView
{
    self.navigationTitle = @"个人资料";
    _tixianVerifyed = NO;
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44 * BILI_WIDTH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detialTableView = tableView;
    [self.view addSubview:tableView];

}
#pragma mark 实名认证逻辑--和BNBalanceViewController中的实名认证判断逻辑保持一致。
- (void)enterWalletFetchCash
{
    //先判断是否经过小贷实名认证
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [TiXianApi realnameCertifyQuerySuccess:^(NSDictionary *returnData) {
        BNLog(@"tixian realname certify %@",returnData);
        [SVProgressHUD dismiss];
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
        {
            NSDictionary *returnDic = [returnData valueForKey:kRequestReturnData];
            NSString *applyedStr = returnDic[@"applyed"];
            if (applyedStr.integerValue == 1)
            {
                //申请过提现实名认证
                NSString *status = returnDic[@"status"];
                if ([status isEqualToString:@"NOA"])
                {
                    //未认证,弹出提示框是否认证
                    _reviewResult = RealNameReviewResult_None;
                }
                else if ([status isEqualToString:@"AUT"])
                {
                    //认证中
                    _reviewResult = RealNameReviewResult_TixianReviewing;
                }
                else if([status isEqualToString:@"ATP"])
                {
                    //审核通过
                    _tixianVerifyed = YES;
                }
                else if([status isEqualToString:@"ATN"] || [status isEqualToString:@"UPF"])
                {
                    //审核失败了
                    _reviewResult = RealNameReviewResult_TixianFailed;
                    _errorInfo = returnDic[@"result_message"];
                }
            }
        }
        [weakSelf.detialTableView reloadData];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
//暂时屏蔽实名认证相关入口。（替换了setupData整个方法）
- (void)setupData
{
    NSArray *section1TitleArray = @[@"学校", @"姓名", @"一卡通"];
    NSArray *section3TitleArray = @[@"实名认证"];
    _titlesArray = [NSMutableArray arrayWithObjects:section1TitleArray, section3TitleArray, nil];
    
    if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && ![shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"])
    {
        NSArray *section2TitleArray = @[@"学工号"];
        [_titlesArray insertObject:section2TitleArray atIndex:1];
        
        NSString *name = shareAppDelegateInstance.boenUserInfo.name;
        NSString *yktNum = shareAppDelegateInstance.boenUserInfo.stuempno;
        NSString *schoolName = shareAppDelegateInstance.boenUserInfo.schoolName;
        NSString *studentno = shareAppDelegateInstance.boenUserInfo.studentno;
        
        NSArray *section1SubTitleArray = @[schoolName, name, yktNum];
        NSArray *section2SubTitleArray = @[studentno];
        NSArray *section3SubTitleArray = @[@""];
        _subTitleArray = @[section1SubTitleArray, section2SubTitleArray, section3SubTitleArray];
    }
    else {
        NSString *name = (shareAppDelegateInstance.boenUserInfo.name.length > 0 && ![shareAppDelegateInstance.boenUserInfo.name isEqualToString:@"null"]) ? shareAppDelegateInstance.boenUserInfo.name : @"--";
        NSString *yktNum = @"未绑定";
        NSString *schoolName = shareAppDelegateInstance.boenUserInfo.schoolName;
        
        NSArray *section1SubTitleArray = @[schoolName, name, yktNum];
        NSArray *section2SubTitleArray = @[@""];
        NSArray *section3SubTitleArray = @[@""];
        _subTitleArray = @[section1SubTitleArray, section2SubTitleArray, section3SubTitleArray];
    }
    
    [_detialTableView reloadData];
    
}

//- (void)setupData //要屏蔽实名认证，就用下面这个，屏蔽上面那个
//{
//    NSArray *section1TitleArray = @[@"学校", @"姓名", @"一卡通"];
////    NSArray *section3TitleArray = @[@"实名认证"];
//    _titlesArray = [NSMutableArray arrayWithObjects:section1TitleArray, nil];
//    
//    if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && ![shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"])
//    {
//        NSArray *section2TitleArray = @[@"学工号"];
//        [_titlesArray insertObject:section2TitleArray atIndex:1];
//        
//        NSString *name = shareAppDelegateInstance.boenUserInfo.name;
//        NSString *yktNum = shareAppDelegateInstance.boenUserInfo.stuempno;
//        NSString *schoolName = shareAppDelegateInstance.boenUserInfo.schoolName;
//        NSString *studentno = shareAppDelegateInstance.boenUserInfo.studentno;
//        
//        NSArray *section1SubTitleArray = @[schoolName, name, yktNum];
//        NSArray *section2SubTitleArray = @[studentno];
//        NSArray *section3SubTitleArray = @[@""];
//        _subTitleArray = @[section1SubTitleArray, section2SubTitleArray, section3SubTitleArray];
//    }
//    else {
//        NSString *name = (shareAppDelegateInstance.boenUserInfo.name.length > 0 && ![shareAppDelegateInstance.boenUserInfo.name isEqualToString:@"null"]) ? shareAppDelegateInstance.boenUserInfo.name : @"--";
//        NSString *yktNum = @"未绑定";
//        NSString *schoolName = shareAppDelegateInstance.boenUserInfo.schoolName;
//        
//        NSArray *section1SubTitleArray = @[schoolName, name, yktNum];
//        NSArray *section2SubTitleArray = @[@""];
//        NSArray *section3SubTitleArray = @[@""];
//        _subTitleArray = @[section1SubTitleArray, section2SubTitleArray, section3SubTitleArray];
//    }
//    
//    [_detialTableView reloadData];
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    [self setupData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self enterWalletFetchCash];

}

#pragma mark - ProfileRefreshNotification

- (void)profileRefreshHandler:(NSNotification *)notification {
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
    static NSString *cellID = @"PersonalDetial";
    BNPersonalDetialCell *cell = (BNPersonalDetialCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BNPersonalDetialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellTitleLab.text = [[_titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.cellSubTitleLab.text = [[_subTitleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isBind = NO;
    if (indexPath.section == 0) {
        if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
        {
            isBind = YES;
        }else{
            isBind = NO;
        }
    }
    else if (indexPath.section == 1) {
        if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
        {
            isBind = YES;
        }else{
            isBind = NO;
        }
    }
//    else if (indexPath.section == 2) {
//        isBind = _tixianVerifyed;
//    }
//   
    
    [cell setupCellViewIndexPath:indexPath isBind:isBind isRealNamed:_tixianVerifyed];
    if ((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0)) {
        cell.sepLine.hidden = YES;
    }else{
        cell.sepLine.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headHeight = 0.0;
    switch (section) {
        case 0:
            headHeight = kSectionHeight;
            break;
        
        case 1:
            headHeight = kSectionHeight + 5.0;
            break;
            
        case 2:
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
            
        case 2:
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
    if ((indexPath.section == 2 && indexPath.row == 0)) {
        //去实名认证
        [self verifyRealName];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
        {
            BNPersonalModStudentNoViewController *modStuNoVC = [[BNPersonalModStudentNoViewController alloc] init];
            [self pushViewController:modStuNoVC animated:YES];
        }
        else {
            //去实名认证
            [self verifyRealName];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
        {
            
        }else{
            //去绑定一卡通
            //绑定一卡通，改为H5页面
            BNPublicHtml5BusinessVC *bindOneCardVCVC = [[BNPublicHtml5BusinessVC alloc] init];
            bindOneCardVCVC.businessType = Html5BusinessType_NativeBusiness;
            bindOneCardVCVC.url = kBindStumpH5Url;
            [self pushViewController:bindOneCardVCVC animated:YES];

//            BNBindYKTViewController *bindYKTVC = [[BNBindYKTViewController alloc] init];
//            bindYKTVC.yktType = shareAppDelegateInstance.boenUserInfo.yktType;
//            [self pushViewController:bindYKTVC animated:YES];
        }
    }
   
}

- (void)verifyRealName {
    if (_tixianVerifyed == NO) {
        if ([shareAppDelegateInstance.boenUserInfo.isCert isEqualToString:@"no"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"实名认证前必须要绑定银行卡，是否现在绑定？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
            [alertView show];
            return;
        }
        
        if (_reviewResult == RealNameReviewResult_None) {
            BNFCRealNameViewController *realNameVC = [[BNFCRealNameViewController alloc] init];
            [self pushViewController:realNameVC animated:YES];
        } else {
            BNRealNameReviewResultVC *resultVC = [[BNRealNameReviewResultVC alloc] init];
            resultVC.reviewResult = _reviewResult;
            resultVC.errorInfo = _errorInfo;
            [self pushViewController:resultVC animated:YES];
        }
    }
}

- (void)alertView:(UIAlertView * _Nonnull)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        shareAppDelegateInstance.popToViewController = @"BNPersonalCenterViewController";
        [self gotoYJPayBankCardList];

    }
}

@end
