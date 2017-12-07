//
//  BNSelectSchoolViewController.m
//  Wallet
//
//  Created by mac1 on 15/1/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNSelectSchoolViewController.h"
#import "BNTools.h"
#import "RegisterClient.h"
#import "SchoolName.h"
#import "LoginApi.h"

#import "BNSetLoginPwdViewController.h"
#import "HanyuPinyinOutputFormat.h"
#import "XifuLoginAccount.h"
#import "KeychainItemWrapper.h"

@interface BNSelectSchoolViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchControllerDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;

@property (strong, nonatomic) NSArray *tempDataSource;

@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSString *selectSchoolName;
@property (strong, nonatomic) NSString *selectSchoolID;
@end

@implementation BNSelectSchoolViewController
@synthesize dataSource = _dataSource;

@synthesize verifycode = _verifycode;
@synthesize registPhone = _registPhone;

- (void)setupLoadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, self.view.frame.size.width, self.view.frame.size.height - self.sixtyFourPixelsView.viewBottomEdge + 1) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    self.tableView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    
}


- (void)viewDidLoad
{
    [self setupLoadView];
    
    [super viewDidLoad];
    
    self.navigationTitle = @"选择学校";
    self.searchBar.placeholder = @"搜索学校名字";
    
    _isSearching = NO;
    
}

#pragma mark - Table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isSearching == NO ? [_dataSource count] : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSearching == NO ? [[_dataSource objectAtIndex:section] count] : [_tempDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    if (_isSearching == YES) {
        SchoolName *scName = [_tempDataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = scName.schoolName_Chinese;
    }else{
        NSDictionary *scNameInfo =[[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = [scNameInfo valueForKey:@"name"];
    }
    
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
    label.backgroundColor = UIColorFromRGB(0xe7e7e7);
    label.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:18]];
    label.text = [@"    " stringByAppendingString:[_indexArray objectAtIndex:section]];
    return _isSearching == NO ? label : nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _isSearching == NO ? 22 : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isSearching == NO) {
        NSDictionary *info = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        _selectSchoolName = [info valueForKey:@"name"];
        _selectSchoolID = [NSString stringWithFormat:@"%@",[info valueForKey:@"id"]];
        
    }else{
        SchoolName *info = [_tempDataSource objectAtIndex:indexPath.row];
        _selectSchoolName = info.schoolName_Chinese;
        _selectSchoolID = info.schoolName_ID;
    }
    NSString *alertText = [NSString stringWithFormat:@"为了保证信息准确性，请选择自己就读的学校，选择后暂时无法更改！\n\n已选择：%@", _selectSchoolName];
    shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:alertText delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    shareAppDelegateInstance.alertView.tag = 101;
    [shareAppDelegateInstance.alertView show];
    
}

- (void)registNextStepActionWithName:(NSString *)scName schoolID:(NSString *)scid
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候"];
    [RegisterClient setLoginPhoneNum:self.registPhone
                                 pwd:self.passwrod
                          verifyCode:self.verifycode
                            schoolId:scid
                             success:^(NSDictionary *successData) {
                                 BNLog(@"注册--%@", successData);
                                 NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                 
                                 if ([retCode isEqualToString:kRequestSuccessCode]) {
                                     [SVProgressHUD showSuccessWithStatus:@"恭喜您注册成功"];
                                     [kUserDefaults setObject:@"NO" forKey:kISOpenTouchIDKEY];
                                     [self loginActionWithPhoneNum:weakSelf.registPhone andPsw:weakSelf.passwrod];
                                     
                                 }else{
                                     NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                     [SVProgressHUD showErrorWithStatus:retMsg];
                                 }
                                 
                             } failure:^(NSError *error) {
                                 [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                             }];
}

- (void)loginActionWithPhoneNum:(NSString *)phoneNums andPsw:(NSString *)pwds
{
    __block NSString *phoneNum = phoneNums;
    __block NSString *pwd      = pwds;
    __weak typeof(self) weakSelf = self;
    NSDictionary *loginInfo = @{@"mobile":phoneNum,
                                @"password":pwd};
    
    [SVProgressHUD showWithStatus:@"请稍候,正在登录..."];
    [LoginApi loginWithUsernameAndPwd:loginInfo
                              success:^(NSDictionary *successData) {
                                  BNLog(@"%@", successData);
                                  NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                  
                                  if ([retCode isEqualToString:kRequestSuccessCode]) {
                                      NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                      
                                      shareAppDelegateInstance.boenUserInfo.userid = [retData valueNotNullForKey:@"userid"];
                                      shareAppDelegateInstance.boenUserInfo.phoneNumber = phoneNum;
                                      
                                      //如果有邀请码，确立老带新关系
                                      if (shareAppDelegateInstance.boenUserInfo.invitedCode.length > 0) {
                                          [LoginApi checkInvitationCodeWithUserId:[retData valueNotNullForKey:@"userid"]
                                                                         Ivt_code:shareAppDelegateInstance.boenUserInfo.invitedCode
                                                                          Success:^(NSDictionary *data) {
                                                                              BNLog(@"确立新老关系--->>>> %@",data);
                                                                              if ([[data valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                                                  //donoting
                                                                              }else{
                                                                                  [SVProgressHUD showErrorWithStatus:[data valueNotNullForKey:kRequestRetMessage]];
                                                                              }
                                                                          }
                                                                          failure:^(NSError *error) {
                                                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                                          }];
                                      }
                                      
                                      //记录登录过的账号到数据库
                                      NSArray *accountSorted = [XifuLoginAccount MR_findByAttribute:@"xifuLoginAccount" withValue:phoneNum];
                                      if ([accountSorted count] == 0) {//没有在数据库中找到添加到数据库
                                          XifuLoginAccount *account = [XifuLoginAccount MR_createEntity];
                                          account.xifuLoginAccount = phoneNum;
                                          [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
                                      }
                                      
                                      KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
                                      [keychinLogin setObject:phoneNum forKey:(__bridge id)kSecAttrAccount];
                                      [keychinLogin setObject:shareAppDelegateInstance.boenUserInfo.userid forKey:(__bridge id)kSecAttrDescription];
                                      
                                      [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                                                   success:^(NSDictionary *successData) {
                                                       
                                                       BNLog(@"getProfile--%@", successData);
                                                       NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                                                       
                                                       if ([retCode isEqualToString:kRequestSuccessCode]||[retCode isEqualToString:@"2000"]) {
                                                           [SVProgressHUD dismiss];
                                                           
                                                           NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                                                           [BNTools setProfileUserInfo:retData];
                                                           
                                                           shareAppDelegateInstance.haveGetPrefile = YES;
                                                           
                                                           KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:shareAppDelegateInstance.boenUserInfo.userid accessGroup:kKeyChainAccessGroup_Gesture];
                                                           NSString *password = [keychin objectForKey:(__bridge id)kSecValueData];
                                                           if ([password isEqualToString:@""]) {
                                                               
                                                               GesturePasswordController *gestureVC = [[GesturePasswordController alloc]init];
                                                               gestureVC.vcType = VcTypeFirstSetPsw;
                                                               
                                                               NSArray *viewControllers = self.navigationController.viewControllers;
                                                               UIViewController *skipVC = nil;
                                                               Class tempClass =  NSClassFromString(@"BNSettingsViewController");
                                                               for (UIViewController *obj in viewControllers) {
                                                                   if ([obj isKindOfClass:tempClass] == YES) {
                                                                       skipVC = (UIViewController *)obj;
                                                                       break;
                                                                   }
                                                               }
                                                               if (skipVC != nil) {
                                                                   gestureVC.nameOfRootPushVC = @"BNSettingsViewController";
                                                                   
                                                               }else{
                                                                   if (!self.presentingViewController) {
                                                                       gestureVC.nameOfRootPushVC = @"BNHomeViewController";
                                                                   }
                                                               }
                                                               
                                                               [weakSelf pushViewController:gestureVC animated:YES];
                                                           }
                                                           else {
                                                               
                                                               if (self.presentingViewController) {
                                                                   [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                               } else {
                                                                   [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                               }
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
                                                           }
                                                           
                                                       }
                                                       else{
                                                           shareAppDelegateInstance.haveGetPrefile = NO;
                                                           NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                           [SVProgressHUD showErrorWithStatus:retMsg];
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       shareAppDelegateInstance.haveGetPrefile = NO;
                                                       
                                                       [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                   }];
                                      
                                      
                                  }else{
                                      NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                      [SVProgressHUD showErrorWithStatus:retMsg];
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
                                  [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  
                              }];
    
}
#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [super searchBarTextDidChange];
    if ([searchText length] > 0) {
        NSString *lowerSearchStr = [searchText lowercaseString];
        NSString *formart = [NSString stringWithFormat:@"schoolName_PinYin like '*%@*' OR schoolName_Chinese like '*%@*' OR schoolName_Code like '*%@*' OR schoolName_PinYin like '*%@*' OR schoolName_Code like '*%@*'", searchText, searchText, searchText, lowerSearchStr, lowerSearchStr];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:formart];
        
        NSArray *searchResult = [SchoolName MR_findAllWithPredicate:predicate];
        for (int i = 0; i < [searchResult count]; i++) {
            SchoolName *cs = [searchResult objectAtIndex:i];
            
            BNLog(@"wwwwww%@, %@", cs.schoolName_Chinese, cs.schoolName_PinYin);
        }
        _tempDataSource = [[NSMutableArray alloc] initWithArray:searchResult];
        _isSearching = YES;
        if (_tempDataSource.count <= 0) {
            self.noResultLabel.hidden = NO;
        } else {
            self.noResultLabel.hidden = YES;
        }
    }else
    {
        self.noResultLabel.hidden = YES;
        _isSearching = NO;
        
    }
    [self.tableView reloadData];
    
    
}
#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked];
    _isSearching = NO;
    [self.tableView reloadData];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 && buttonIndex == 1) {
        //确定所选学校。
        [self registNextStepActionWithName:_selectSchoolName schoolID:_selectSchoolID];
    }
}
@end
