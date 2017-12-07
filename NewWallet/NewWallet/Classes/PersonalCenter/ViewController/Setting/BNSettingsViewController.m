//
//  BNSettingsViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-30.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNSettingsViewController.h"

#import "GesturePasswordController.h"

#import "CardApi.h"

#import "LoginApi.h"

#import "KeychainItemWrapper.h"

#import "ServiceCenterApi.h"

#import "BNVerifyPhoneViewController.h"

#import "BNAboutViewController.h"

#import "BNSettingCell.h"

#import "NewModifyPhoneHomeVC.h"

#import "BNXiaoDaiInfoRecordTool.h"
#import "QYSDK.h"
#import "JavaHttpTools.h"
#import "BNCommonWebViewController.h"
#import "UnionPayApi.h"
#import "BNPublicHtml5BusinessVC.h"

@interface BNSettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *titlesArray;
@end


@implementation BNSettingsViewController

#pragma mark - set loaded view
- (void)setupLoadedView
{
    self.navigationTitle = @"设 置";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1) style:UITableViewStylePlain];
    tableView.tag = 100;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44 * BILI_WIDTH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    
}


- (void)setupData
{
//    NSMutableArray *section1 = @[@{@"title":@"安全设置",@"class":@"BNSecuritySettingVC"}, @{@"title":@"支付设置",@"class":@"YJPaySetting"},  @{@"title":@"一卡通支付设置",@"class":@"YKTPaySetting"}].mutableCopy;
    NSMutableArray *section1 = @[@{@"title":@"安全设置",@"class":@"BNSecuritySettingVC"}, @{@"title":@"支付设置",@"class":@"YJPaySetting"}].mutableCopy;
    NSArray *section2 = @[@{@"title":@"关于我们",@"class":@"BNAboutViewController"},@{@"title":@"意见反馈",@"class":@"UMFeedback"}];
    NSArray *section3 = @[@{@"title":@"安全退出",@"selector":@"logoutAction"}];

    _titlesArray = [[NSArray alloc] initWithObjects:section1,section2, section3,nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    [self setupData];
}

#pragma mark - table view datasource and delegate
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
    static NSString *cellID = @"Setting";
    BNSettingCell *cell = (BNSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BNSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellTitleLab.text = [[[_titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (([[_titlesArray objectAtIndex:indexPath.section] count] - 1) == indexPath.row) {
        cell.sepLine.hidden = YES;
    }else{
        cell.sepLine.hidden = NO;
    }
    
    if ([cell.cellTitleLab.text isEqualToString:@"安全退出"]) {
        cell.arrowImg.hidden = YES;
//        cell.cellTitleLab.center = cell.contentView.center;
        cell.cellTitleLab.textAlignment = NSTextAlignmentCenter;
        cell.cellTitleLab.textColor = [UIColor redColor];
    }else{
        cell.cellTitleLab.textColor = UIColor_BlackBlue_Text;
        cell.arrowImg.hidden = NO;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSectionHeight)];
    headView.backgroundColor = UIColor_Gray_BG;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight - 1.0, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = UIColor_GrayLine;
    [headView addSubview:line];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = UIColor_GrayLine;
    return line;
}
 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *titleStr = [[[_titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];

    //友盟事件点击
    [MobClick event:@"SettingVC" label:titleStr];
    
    NSDictionary *rowDic = _titlesArray[indexPath.section][indexPath.row];
    Class desClass = NSClassFromString([rowDic objectForKey:@"class"]);
    NSString *classStr = [rowDic objectForKey:@"class"];
    SEL logout = NSSelectorFromString([rowDic objectForKey:@"selector"]);//??crash了，就一次    还有boenUserInfo赋值失败;
    if ([classStr isEqualToString:@"UMFeedback"]) {
		
		
		
		
		QYUserInfo *userInfo = [[QYUserInfo alloc] init];
		userInfo.userId = shareAppDelegateInstance.boenUserInfo.userid;
		userInfo.data = [NSString stringWithFormat:@"[{\"key\":\"real_name\", \"value\":\"%@\"},"
		"{\"key\":\"mobile_phone\", \"value\":\"%@\"},"
		"{\"index\":0, \"key\":\"school_name\", \"label\":\"学校\", \"value\":\"%@\"},"
		"{\"index\":1, \"key\":\"stuempno\", \"label\":\"学工号\", \"value\":\"%@\"},"
		"{\"index\":2, \"key\":\"app_version\", \"label\":\"版本\", \"value\":\"%@\"}]",
						 shareAppDelegateInstance.boenUserInfo.name,
						 shareAppDelegateInstance.boenUserInfo.phoneNumber,
						 shareAppDelegateInstance.boenUserInfo.schoolName,
						 shareAppDelegateInstance.boenUserInfo.stuempno,
						 APP_VERSION];
		
		[[QYSDK sharedSDK] setUserInfo:userInfo];
		
		QYSource *source = [[QYSource alloc] init];
		source.title =  @"喜付";
		source.urlString = @"https://www.xifuapp.com/";
		
		QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
		vc.sessionTitle = @"喜付";
		vc.source = source;
		
		vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Main_Back_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
		[self presentViewController:nav animated:YES completion:nil];
		
//		[self.navigationController setNavigationBarHidden:NO animated:NO];
//		[self pushViewController:vc animated:YES];
		
    } else if ([classStr isEqualToString:@"YJPaySetting"]) {

//        NSString *userid = shareAppDelegateInstance.boenUserInfo.yjf_bind_id;
//        NSDictionary *init = @{kYJPayServer:YJPayServerType, kYJPayPartnerId:YJPayPartnerid, kYJPaySecurityKey: YJPaySecKey};
//        [YJPayService initEnvironment:init error:nil];//
//        NSDictionary *info = @{kYJPayUserId: userid, kYJPayUserType: MEMBER_TYPE_YIJI};
//        [YJPayService startPaymentSetting:info delegate:nil error:nil];//
        
        //不再跳转易极付SDK，用银联H5页面。
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [UnionPayApi getUnionPaySettingURLSucceed:^(NSDictionary *successData) {
            BNLog(@"getUnionPaySettingURLSucceed--%@", successData);
            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                [SVProgressHUD dismiss];
                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
                bankVC.businessType = Html5BusinessType_NativeBusiness;
                bankVC.hideNavigationbar = YES;
                bankVC.url = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"pay_config_url"]];
                [weakSelf pushViewController:bankVC animated:YES];
                
            }else{
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
        
    } else if ([classStr isEqualToString:@"YKTPaySetting"]) {
        //一卡通支付设置
        BNCommonWebViewController *yktPayVC = [[BNCommonWebViewController alloc] init];
        yktPayVC.urlString = KBNScanedByShopVC_QR_yktPayManage;
        [self pushViewController:yktPayVC animated:YES];
    }else{
        UIViewController *desVC = [[desClass alloc] init];
        [self pushViewController:desVC animated:YES];
    }
    
    if (logout) {
        [self logoutAction];
    }
    
}
#pragma mark - button action

- (void)backAction {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoutAction
{
    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出当前账户吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [shareAppDelegateInstance.alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logoutRequest];
    }
}
- (void)logoutRequest
{
    //友盟事件点击
    [MobClick event:@"SettingVC" label:@"确定退出账户"];
    
    [BNXiaoDaiInfoRecordTool clearXiaoDaiInfo];
    
    [[BNRealNameInfo shareInstance] clearRealNameInfo];
    
    [Tools deleteAllUploadImg];
    
    __weak typeof(shareAppDelegateInstance) weakAppDelegate = shareAppDelegateInstance;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [LoginApi loginOutwithUserID:shareAppDelegateInstance.boenUserInfo.userid
                         success:^(NSDictionary *returnData) {
                             BNLog(@"logout--%@", returnData);
                             NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                             if ([retCode isEqualToString:kRequestSuccessCode]) {
                                 [SVProgressHUD dismiss];
                                 
                                 //登录信息删除
                                 KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
                                 [keychinLogin setObject:@"" forKey:(__bridge id)kSecAttrDescription];
                                 
                                 [[JavaHttpTools shareInstance] removeHttpCookie];
                                 [BNTools removeLoginCookies];
                                 //内存删除
                                 shareAppDelegateInstance.haveKwdsToAutoLogIn = NO;
                                 weakAppDelegate.boenUserInfo.userid = @"";
                                 weakAppDelegate.boenUserInfo.name = @"";
                                 weakAppDelegate.haveGetPrefile = NO;
								 
								 //七鱼注销
								 [[QYSDK sharedSDK] logout:^(){}];
                                 
                                 //回到跟视图控制器
                                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                 
                                 //消息通知
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
                                 
                                 //退出后跳到主页
                                 weakSelf.tabBarController.selectedIndex = 0;
                        
                             }else{
                                 NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                 [SVProgressHUD showErrorWithStatus:retMsg];
                             }
                         }
                         failure:^(NSError *error) {
                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                         }];
    
}

@end
