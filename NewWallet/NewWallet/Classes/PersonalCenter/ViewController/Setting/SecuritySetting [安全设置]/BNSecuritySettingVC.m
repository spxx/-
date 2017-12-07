//
//  BNSecuritySettingVC.m
//  Wallet
//
//  Created by mac1 on 16/1/29.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNSecuritySettingVC.h"
#import "BNSettingCell.h"
#import "BNVerifyPhoneViewController.h"
#import "NewModifyPhoneHomeVC.h"
#import "BNGesturePWDSettingVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>

@interface BNSecuritySettingVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *datas;

@end

@implementation BNSecuritySettingVC
static NSString *const  cellID = @"Security";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"安全设置";
    [self setupLoadedView];
}

- (NSArray *)datas
{
    if (!_datas) {
        NSArray *section1TitleArray = @[@"手势、指纹解锁",@"修改登录密码"];
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;
        context.localizedFallbackTitle = @"";
        //验证Touch ID是否存在
        if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
           section1TitleArray = @[@"手势解锁",@"修改登录密码"];
        }

        NSArray *section2TitleArray = @[@"修改手机号"];
        _datas = [[NSArray alloc] initWithObjects:section1TitleArray,section2TitleArray, nil];
    }
    return _datas;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNSettingCell *cell = (BNSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BNSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellTitleLab.text = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (([[self.datas objectAtIndex:indexPath.section] count] - 1) == indexPath.row) {
        cell.sepLine.hidden = YES;
    }else{
        cell.sepLine.hidden = NO;
    }
    return cell;
}

#pragma mark - UITableViewDalegate
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
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0://手势指纹解锁
                {
                    //友盟事件点击
                    [MobClick event:@"SettingVC" label:@"手势/指纹解锁"];
                    
                    BNGesturePWDSettingVC *gestureVC = [[BNGesturePWDSettingVC alloc] init];
                    [self pushViewController:gestureVC animated:YES];
                }
                break;
                case 1://修改登录密码
                {
                    //友盟事件点击
                    [MobClick event:@"SettingVC" label:@"修改登录密码"];
                    
                    BNVerifyPhoneViewController *verifyVC = [[BNVerifyPhoneViewController alloc]init];
                    verifyVC.isFromForgetPsw = YES;
                    verifyVC.useStyle = ViewControllerUseStyleModifyLoginPwd;
                    [self pushViewController:verifyVC animated:YES];
                }
                break;
                
                default:
                break;
            }
            
        }
        break;
        case 1:{//修改手机号
            //友盟事件点击
            [MobClick event:@"SettingVC" label:@"修改手机号"];
            
            NewModifyPhoneHomeVC *modifyPhoneHomeVC = [[NewModifyPhoneHomeVC alloc] init];
            [self pushViewController:modifyPhoneHomeVC animated:YES];

        }
        break;
        
        default:
        break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
