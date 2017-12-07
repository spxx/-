//
//  BNGesturePWDSettingVC.m
//  Wallet
//
//  Created by mac1 on 16/1/29.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNGesturePWDSettingVC.h"
#import "KeychainItemWrapper.h"
#import "BNGesturePWDTableViewCell.h"
#import "GesturePasswordController.h"
#import "BNVerifyPhoneViewController.h"
#import "BNGestureAlertView.h"
#import "Password.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>



@interface BNGesturePWDSettingVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation BNGesturePWDSettingVC

static NSString *const cellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"手势密码设置";
    [self setupLoadedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData];
    [_tableView reloadData];
}

- (void)setupData
{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
    NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
    if (!password || password.length <= 0) {//未设置手势密码
        NSMutableArray *section1 = @[@{kGesturePWD_Cell_Title : @"手势密码", kGesturePWD_Cell_right : @"switch",kGesturePWD_Cell_SwitchIsOn:@"NO"}].mutableCopy;
        _datas = [[NSMutableArray alloc] initWithObjects:section1, nil];
        
    }else{
        NSMutableArray *section1 = @[@{kGesturePWD_Cell_Title : @"手势密码", kGesturePWD_Cell_right : @"switch",kGesturePWD_Cell_SwitchIsOn:@"YES"},
                                     @{ kGesturePWD_Cell_Title : @"修改手势密码", kGesturePWD_Cell_right : @"right_arrow"}].mutableCopy;
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;
        context.localizedFallbackTitle = @"";
        //验证Touch ID是否存在
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            NSString *openTouchId = [[kUserDefaults objectForKey:kISOpenTouchIDKEY] isEqualToString:@"YES"] ? @"YES" : @"NO";
            NSArray *section2 = @[@{ kGesturePWD_Cell_Title : @"开启Touch ID指纹解锁", kGesturePWD_Cell_right : @"switch", kGesturePWD_Cell_SwitchIsOn:openTouchId}];
            _datas = [[NSMutableArray alloc] initWithObjects:section1,section2, nil];
        } else {
            _datas = [[NSMutableArray alloc] initWithObjects:section1, nil];
        }
       
    }

}




- (void)setupLoadedView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1) style:UITableViewStylePlain];
    tableView.tag = 100;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44 * BILI_WIDTH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [tableView registerClass:[BNGesturePWDTableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.datas objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    BNGesturePWDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setupCellWithDictonary:_datas[indexPath.section][indexPath.row] indexPath:indexPath];
    cell.theSwitch.tag = indexPath.section;
    [cell.theSwitch addTarget:self action:@selector(siwtchAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark -UITabelViewDelegate
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {//修改手势密码
        BNVerifyPhoneViewController *verifyVC = [[BNVerifyPhoneViewController alloc]init];
        verifyVC.useStyle = ViewControllerUseStyleModifyGesturePwd;
        [self pushViewController:verifyVC animated:YES];
    }
    
}

- (void)siwtchAction:(UISwitch *)theSwitch
{
    switch (theSwitch.tag) {
        case 0:{//手势密码
            if (theSwitch.isOn) {
                //开启手势密码
                [[[MMAlertView alloc] initWithInputTitle:@"我们需要验证你的登录密码" detail:nil placeholder:@"请输入登录密码" handler:^(NSString *text) {
                    if (text == nil || text.length == 0) {
                        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
                        
                    }else if(text.length > 0 && shareAppDelegateInstance.boenUserInfo.userid.length > 0){
                        NSDictionary *info = @{@"userid":shareAppDelegateInstance.boenUserInfo.userid,
                                               @"password":text};
                        [SVProgressHUD showWithStatus:@"请稍候..."];
                        [Password verifyLoginPwd:info
                                         success:^(NSDictionary *successData) {
                                             NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                             if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                 [SVProgressHUD dismiss];
                                                 GesturePasswordController *gestureVC = [[GesturePasswordController alloc]init];
                                                 gestureVC.nameOfRootPushVC = @"BNGesturePWDSettingVC";
                                                 gestureVC.vcType = VcTypeFirstSetPsw;
                                                 [self pushViewController:gestureVC animated:YES];
                                             }else{
                                                 theSwitch.on = NO;
                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                             }
                                         }
                                         failure:^(NSError *error) {
                                             theSwitch.on = NO;
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
                        
                    }
                } cancelHandle:^{
                    BNLog(@"cancel --- >>>>>>  cancel");
//                    [SVProgressHUD showErrorWithStatus:@"未能成功关闭手势密码"];
                    theSwitch.on = NO;
                    
                }] showWithBlock:^(MMPopupView *view) {
                    
                }];

            }else{//关闭手势密码
                [[[MMAlertView alloc] initWithInputTitle:@"我们需要验证你的登录密码" detail:nil placeholder:@"请输入登录密码" handler:^(NSString *text) {
                    if (text == nil || text.length == 0) {
                        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
                        
                    }else if(text.length > 0 && shareAppDelegateInstance.boenUserInfo.userid.length > 0){
                        NSDictionary *info = @{@"userid":shareAppDelegateInstance.boenUserInfo.userid,
                                               @"password":text};
                        [SVProgressHUD showWithStatus:@"请稍候..."];
                        [Password verifyLoginPwd:info
                                         success:^(NSDictionary *successData) {
                                             NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                             if ([retCode isEqualToString:kRequestSuccessCode]) {
                                                 [SVProgressHUD dismiss];
                                                 KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
                                                 [keychin resetKeychainItem];
                                                 //关闭touch id
                                                 [kUserDefaults setObject:@"NO" forKey:kISOpenTouchIDKEY];
                                                 
                                                 //刷新表
                                                 NSMutableArray *section1 = @[@{kGesturePWD_Cell_Title : @"手势密码", kGesturePWD_Cell_right : @"switch",kGesturePWD_Cell_SwitchIsOn:@"NO"}].mutableCopy;
                                                 _datas = [[NSMutableArray alloc] initWithObjects:section1, nil];
                                                 [_tableView reloadData];
                                                 
                                             }else{
                                                 theSwitch.on = YES;
                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                 [SVProgressHUD showErrorWithStatus:retMsg];
                                             }
                                             
                                         }
                                         failure:^(NSError *error) {
                                             theSwitch.on = YES;
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
                        
                    }
                } cancelHandle:^{
                    BNLog(@"cancel --- >>>>>>  cancel");
//                    [SVProgressHUD showErrorWithStatus:@"未能成功关闭手势密码"];
                    theSwitch.on = YES;
                    
                }] showWithBlock:^(MMPopupView *view) {
                    
                }];
            }
            
        }
        
        break;
        case 1:{
            if (theSwitch.isOn) {
                //开启Touch ID
                LAContext *context = [[LAContext alloc] init];
                NSError *error = nil;
                context.localizedFallbackTitle = @"";
                //验证Touch ID是否存在
                if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {//Touch ID开始运作
                    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证您的指纹" reply:^(BOOL succes, NSError *error)
                     {
                         if (succes) {
                             //打开偏好设置
                             [kUserDefaults setObject:@"YES" forKey:kISOpenTouchIDKEY];
                         }
                         else{
                             BNLog(@"error---->>>>>> %@",error.localizedDescription);
                             NSString *str = [NSString stringWithFormat:@"%@",error.localizedDescription];
                             if ([str isEqualToString:@"Canceled by user."]) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [SVProgressHUD showErrorWithStatus:@"你取消了指纹验证"];
                                     theSwitch.on = NO;
                                 });
                               
                             }
                             
                         }
                     }];
                    
                }else{
                   [SVProgressHUD showErrorWithStatus:@"对不起你的手机或系统不支持Touch ID功能"];
                }
            }else{
                //关闭Touch ID
                //偏好设置关闭
                [kUserDefaults setObject:@"NO" forKey:kISOpenTouchIDKEY];
                
                //刷新UI
                theSwitch.on = NO;
                
            }
        }
        
        break;
        
        default:
        break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
