//
//  BNPersonalCenterViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-22.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNPersonalCenterViewController.h"
#import "BNLoginViewController.h"
#import "BNSettingsViewController.h"
#import "LoginApi.h"
#import "PersonalCenterCell.h"
#import "TraineeHomeViewController.h"
#import "BNPersonalModStudentNoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "PesonCenterApi.h"
#import "BNUploadTools.h"
#import "BNCommonWebViewController.h"
#import "BNUploadAvatarProgressView.h"
#import "CustomButton.h"
#import "BNAllPayBillViewController.h"
#import "BNPublicHtml5BusinessVC.h"
#import "UnionPayApi.h"
#import "BNVeinInfoViewController.h"


//#import "BNUploadProgressView.h"
//#import "CardApi.h"
//#import <AddressBookUI/AddressBookUI.h>
//#import "BNBindYKTViewController.h"
//#import "BNXiHaDaiHomeViewController.h"
//#import "TiXianApi.h"
//#import "BNFCRealNameViewController.h"
//#import "BNRealNameReviewResultVC.h"

//还钱类型
typedef NS_ENUM(NSInteger, RealNameVerifyedStatus) {
    RealNameVerifyedStatusNone,              //未实名认证
    RealNameVerifyedStatusSuccessATP,        //已通过实名认证
    RealNameVerifyedStatusReviewingAUT,      //审核中
    RealNameVerifyedStatusFailedATNUPF,      //认证失败
};
@interface BNPersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) AFHTTPRequestOperation *lastGetDetailOp;
@property (nonatomic, strong) AFHTTPRequestOperation *lastBankCardCountOp;
@property (nonatomic, strong) AFHTTPRequestOperation *lastCouponCardCountOp;

@property (weak, nonatomic) UIImageView *avatar; //头像
@property (weak, nonatomic) UILabel *nameLabel;  //姓名
@property (weak, nonatomic) UILabel *phoneLbl;   //手机号
@property (weak, nonatomic) UITableView *personalTable;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
//@property (nonatomic, weak) UIButton *vipLevelBtn; //会员等级
@property (nonatomic, weak) UIView *userHeadView;

@property (nonatomic, assign) BOOL isFromImagePicker;

@property (weak, nonatomic) UIImageView *navBgView;

//@property (weak, nonatomic) UIView *statusBar;
//@property (weak, nonatomic) UIButton *bindYKTButton;
//@property (weak, nonatomic) UILabel *sumMoneyLabel;
//@property (weak, nonatomic) UILabel *sumCardLabel;
//@property (weak, nonatomic) UIImageView *cardLeftArrowImageView;
//@property (nonatomic) UIButton *verifyBtn;
//@property (nonatomic) UIButton *YKTButton;
//@property (assign, nonatomic) CGRect bkImgRect;
//@property (nonatomic) BOOL tixianVerifyed;
//@property (assign, nonatomic) RealNameReviewResult reviewResult;   //实名认证状态
//@property (nonatomic) NSString *errorInfo;

@end

@implementation BNPersonalCenterViewController

static NSString *const personaCenterCellID = @"personaCenterCellID";

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_RefreshPersonalCenterDetail object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLoadedView];
    [self refreshUserDetailInfo];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileRefreshHandler:) name:kNotification_RefreshPersonalCenterDetail object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if(!_isFromImagePicker){
        [self refreshUserDetailInfo];
    }
    _isFromImagePicker =  NO;
}

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.showNavigationBar = NO;
    _isFromImagePicker = NO;
    self.view.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
    
    CGFloat navBgHeight = 100;
    
    UIImageView *navBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100/2, SCREEN_WIDTH, navBgHeight)];
    navBgView.image = [UIImage imageNamed:@"nav_bg"];
    navBgView.layer.anchorPoint = CGPointMake(0.5, 0);
    [self.view addSubview:navBgView];
    self.navBgView = navBgView;
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, navBgHeight-29-25-(40-25)/2, 50, 40);
    [backBtn addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIImageView *navText = [[UIImageView alloc] initWithFrame:CGRectMake(50, navBgHeight-29-25+6.5, 154, 12)];
    navText.image = [UIImage imageNamed:@"nav_text"];
    [self.view addSubview:navText];
    
    //设置按钮
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"nav_setting"] forState:UIControlStateNormal];
    settingBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, navBgHeight-29-25-(40-25)/2, 60, 40);
    [settingBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    self.dataSource = [@[] mutableCopy];
     NSArray *section0 = @[
                           @{kPersonal_Cell_Icon : @"me_billCenter", kPersonal_Cell_Title : @"交易记录", kPersonal_Cell_Arrow : @"right_arrow"
                             , kPersonal_Cell_SubTitle: @"null"},
                           @{kPersonal_Cell_Icon : @"Me_BankCard", kPersonal_Cell_Title : @"我的银行卡", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: @"null"},
                           @{kPersonal_Cell_Icon : @"Me_Cards_icon", kPersonal_Cell_Title : @"我的优惠券", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: @"null"},
                           @{kPersonal_Cell_Icon : @"me_stu_card", kPersonal_Cell_Title : @"学生证认证", kPersonal_Cell_Arrow : @"right_arrow"
                             , kPersonal_Cell_SubTitle: @"_ _"},
                           
                          ];
    
//    NSArray *section2 = @[@{kPersonal_Cell_Icon : @"Me_Setting_icon", kPersonal_Cell_Title : @"设置", kPersonal_Cell_Arrow : @"right_arrow"}];

    _dataSource = @[section0].mutableCopy;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kPersonalCellHeight;
    tableView.sectionHeaderHeight = 134;
    
    //tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.frame];
    //tableView.backgroundView.backgroundColor = UIColor_Gray_BG;
    tableView.backgroundColor = [UIColor clearColor];

    CGFloat userHeadViewHeight = 134;
    UIView *userHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, userHeadViewHeight)];
    _userHeadView = userHeadView;
    
//    UIView *vipBGView = [[UIView alloc] initWithFrame:CGRectMake(0, userHeadViewHeight, SCREEN_WIDTH, headViewBG.heightValue - userHeadViewHeight)];
//    vipBGView.backgroundColor = UIColorFromRGB(0x609bff);
//    [headViewBG addSubview:vipBGView];
//    
//    UITapGestureRecognizer *vipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipTapAction)];
//    [vipBGView addGestureRecognizer:vipTap];

    //头像
    CGFloat avatarWidth = 60;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 17 - avatarWidth, 47, avatarWidth, avatarWidth)];
    avatar.layer.cornerRadius = avatar.frame.size.width/2;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    avatar.layer.borderWidth = 2;
    avatar.userInteractionEnabled = YES;
    [userHeadView addSubview:avatar];
    _avatar = avatar;
    
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAcion)];
    [avatar addGestureRecognizer:tapImg];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 53, SCREEN_WIDTH - 17 - avatarWidth - 20, 30)];
    nameLabel.font = [UIFont boldSystemFontOfSize:30];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.text = @"--";
    nameLabel.textColor = [UIColor darkTextColor];
    _nameLabel = nameLabel;
    
    UIImageView *phoneImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, nameLabel.bottomValue+14, 13, 13)];
    phoneImgV.image = [UIImage imageNamed:@"phone_icon"];
    
    //电话号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneImgV.rightValue+5, phoneImgV.topValue, SCREEN_WIDTH-17-avatarWidth-phoneImgV.rightValue, 13)];
    phoneLabel.font = [UIFont systemFontOfSize:13];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.text = @"***********";
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = UIColor_Gray_Text;
    _phoneLbl = phoneLabel;
    
    [userHeadView addSubview:nameLabel];
    [userHeadView addSubview:phoneImgV];
    [userHeadView addSubview:phoneLabel];
    
    //会员等级
//    UIButton *vipLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    vipLevelBtn.frame = CGRectMake(131 * NEW_BILI, userHeadViewHeight, SCREEN_WIDTH - 131 * NEW_BILI, 44*BILI_WIDTH);
//    [vipLevelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [vipLevelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    vipLevelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [vipLevelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    vipLevelBtn.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
//    [vipLevelBtn setTitle:@"XX会员" forState:UIControlStateNormal];
//    vipLevelBtn.userInteractionEnabled = NO;
//    [headViewBG addSubview:vipLevelBtn];
//    _vipLevelBtn = vipLevelBtn;
    
    tableView.tableHeaderView = userHeadView;
    [tableView registerClass:[PersonalCenterCell class] forCellReuseIdentifier:personaCenterCellID];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    tableView.tableFooterView.backgroundColor = UIColor_Gray_BG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _personalTable = tableView;
    [self.view insertSubview:tableView belowSubview:_navBgView];
    
    /*
    self.verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyBtn.tag = 101;
    _verifyBtn.frame = CGRectMake(0, userHeadViewHeight, SCREEN_WIDTH/2, 44*BILI_WIDTH);
    [_verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _verifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_verifyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_verifyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    [_verifyBtn setImage:[UIImage imageNamed:@"Me_RealName_unVerifyed"] forState:UIControlStateNormal];
    [_verifyBtn setTitle:@"实名认证" forState:UIControlStateNormal];
    [_verifyBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headViewBG addSubview:_verifyBtn];
    
    self.YKTButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _YKTButton.tag = 102;
    _YKTButton.frame = CGRectMake(SCREEN_WIDTH/2, userHeadViewHeight, SCREEN_WIDTH/2, 44*BILI_WIDTH);
    [_YKTButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_YKTButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _YKTButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _YKTButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_YKTButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_YKTButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    _YKTButton.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    [_YKTButton setImage:[UIImage imageNamed:@"Me_SchoolNum_binded"] forState:UIControlStateNormal];
    [_YKTButton setTitle:@"学号绑定" forState:UIControlStateNormal];
    [_YKTButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headViewBG addSubview:_YKTButton];

    UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, userHeadViewHeight+11*BILI_WIDTH, 0.5, 22*BILI_WIDTH)];
    btnLine.backgroundColor = [UIColor whiteColor];
    [headViewBG addSubview:btnLine];
     */
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonalCenterCell *cell = (PersonalCenterCell *)[tableView dequeueReusableCellWithIdentifier:personaCenterCellID forIndexPath:indexPath];
    BOOL isShowLine = (indexPath.row != ([[_dataSource objectAtIndex:indexPath.section] count] -1)) ? YES : NO;
    [cell setupDataForCell:_dataSource[indexPath.section][indexPath.row] isShowLine:isShowLine];
    
    return cell;
}

#pragma mark -UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 134;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.userHeadView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: {
                    //账单中心
                    BNAllPayBillViewController *billVC = [[BNAllPayBillViewController alloc] init];
                    [self pushViewController:billVC animated:YES];
                    
                    [MobClick event:@"me_billCenter"];  //20170323添加事件统计。
                    break;
                }

                case 1:
                {
                    //友盟事件点击
                    [MobClick event:@"me_myBankCards"];
                    //我的银行卡
                    [self displayBankCardsAction];
                    break;
                }
                case 2:
                {
                    CustomButton *customButton = [[CustomButton alloc]init];
                    customButton.biz_id = @"11";
                    customButton.biz_name = @"卡券";
                    customButton.biz_type = @"1";
                    [self suDoKuButtonAction:customButton];
                    break;
                }
                case 3:
                {
                    //友盟事件点击
                    [MobClick event:@"me_XiFuStudentsIDCard"];
                    //                    BNFCRealNameViewController *vc = [[BNFCRealNameViewController alloc] init];
                    //                    [self pushViewController:vc animated:YES];
                    //                     喜付学生证
                    [self goXiFustudentsIDCard];
                    break;
                }
            }
        }
            break;
         
        case 1:
        {
            switch (indexPath.row) {
                case 2:
                {
                    //友盟事件点击
                    [MobClick event:@"me_XiFuTrainee"];
                    
                    //喜付实习生入口
                    TraineeHomeViewController *trainneHomeVC = [[TraineeHomeViewController alloc] init];
                    [self pushViewController:trainneHomeVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
}


// 设置
- (void)settingAction
{
    if (shareAppDelegateInstance.haveGetPrefile == NO) {
        [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
        return;
    }
    //友盟事件点击
    [MobClick event:@"me_setButton"];
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                 success:^(NSDictionary *successData) {
                     
                     BNLog(@"getProfile--%@", successData);
                     NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                     [SVProgressHUD dismiss];
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         
                         NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                         [BNTools setProfileUserInfo:retData];
                         
                         BNSettingsViewController *settingsVC = [[BNSettingsViewController alloc] init];
                         [weakSelf pushViewController:settingsVC animated:YES];
                         
                     }else{
                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                         BNLog(@"Get profile %@", retMsg);
                     }
                     
                     
                     
                 } failure:^(NSError *error) {
                     [SVProgressHUD dismiss];
                     BNLog(@"Get profile %@", kNetworkErrorMsg);
                     BNSettingsViewController *settingsVC = [[BNSettingsViewController alloc] init];
                     [weakSelf pushViewController:settingsVC animated:YES];
                 }];
    
}

//喜付学生证
- (void)goXiFustudentsIDCard
{
    BNCommonWebViewController *cardWebView = [[BNCommonWebViewController alloc] init];
    //    cardWebView.urlString = [NSString stringWithFormat:@"%@/app/web_files/v1/business/studentInfo/index.html",BASE_URL];
    cardWebView.urlString = [NSString stringWithFormat:@"%@/static/web_app/business/studentInfo/index.html",BASE_URL];
    [self pushViewController:cardWebView animated:YES];
}

//我的银行卡
- (void)displayBankCardsAction
{
    if (shareAppDelegateInstance.boenUserInfo.userid.length > 0 && shareAppDelegateInstance.haveGetPrefile == YES) {
        
        [SVProgressHUD showErrorWithStatus:@"暂不支持该功能"];
        
//        [self gotoYJPayBankCardList];//易极付银行卡管理
        
        //不再跳转易极付SDK，用银联H5页面。
//        __weak typeof(self) weakSelf = self;
//        [SVProgressHUD showWithStatus:@"请稍候..."];
//        [UnionPayApi getUnionBankListURLSucceed:^(NSDictionary *successData) {
//            BNLog(@"getUnionBankListURLSucceed--%@", successData);
//            NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
//            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
//                [SVProgressHUD dismiss];
//
//                NSDictionary *retData = [successData valueForKey:kRequestReturnData];
//                BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
//                bankVC.businessType = Html5BusinessType_NativeBusiness;
//                bankVC.hideNavigationbar = YES;
//                bankVC.url = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"bank_list_url"]];
//                [weakSelf pushViewController:bankVC animated:YES];
//                
//            }else{
//                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
//                [SVProgressHUD showErrorWithStatus:retMsg];
//            }
//        } failure:^(NSError *error) {
//            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
//        }];
//        
//    } else {
//        [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
    }
    
}


#pragma mark- Request
- (void)refreshUserDetailInfo
{
    if (!shareAppDelegateInstance.haveGetPrefile) {
        return;
    }
    
    // 名字（如果没有绑学号，就显示学校名）
    NSString *name = shareAppDelegateInstance.boenUserInfo.name;
//    NSString *schoolName = shareAppDelegateInstance.boenUserInfo.schoolName;
    if (name.length > 0 && ![name isEqualToString:@"null"]) {
        NSString *totalStr = [NSString stringWithFormat:@"%@",name];
        self.nameLabel.text = totalStr; //.attributedText = [Tools attributedStringWithText:totalStr textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:12*BILI_WIDTH] colorRange:NSMakeRange(name.length+1, schoolName.length)];
        
    }else{
        _nameLabel.text = shareAppDelegateInstance.boenUserInfo.schoolName;
    }
    
    //电话号码
    NSString *phoneStr = shareAppDelegateInstance.boenUserInfo.phoneNumber;
    NSString *subPhoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _phoneLbl.text= subPhoneStr;

    if (self.lastGetDetailOp.isCancelled == NO) {
        BNLog(@"cancel_getDetail");
        [self.lastGetDetailOp cancel];
    }
    
    if (self.lastBankCardCountOp.isCancelled == NO) {
         BNLog(@"cancel__getCardCount");
        [self.lastBankCardCountOp cancel];
    }
    if (self.lastCouponCardCountOp.isCancelled == NO) {
        BNLog(@"cancel__lastCouponCardCountOp");
        [self.lastCouponCardCountOp cancel];
    }
    
    // 用户详情
    self.lastGetDetailOp = [PesonCenterApi get_user_detail_info:^(NSDictionary *returnData) {
        BNLog(@"获取用户详细信息接口--->>>>%@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            //头像
            NSString *avatarUrl = [datas valueNotNullForKey:@"user_portrait_url"];
            [_avatar sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
            
            shareAppDelegateInstance.boenUserInfo.avatar = avatarUrl;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshPersonalCenterDetail object:nil];

            // 会员等级
            //[_vipLevelBtn setTitle:[datas valueNotNullForKey:@"user_level_desc"] forState:UIControlStateNormal];
            //NSString *imageName = [NSString stringWithFormat:@"vip_level_%@",[datas valueNotNullForKey:@"user_level"]];
            //[_vipLevelBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            
            NSString *userStudentCardStatus = [NSString stringWithFormat:@"%@",[datas valueNotNullForKey:@"user_student_card_status"]];
            NSDictionary *temDic = @{@"0":@"未认证", @"1": @"认证中", @"2": @"已认证", @"3": @"认证失败"};
            
            NSString *status = [temDic valueNotNullForKey:userStudentCardStatus];
            
            NSMutableArray *section0 = [_dataSource[0] mutableCopy];
            NSDictionary *dict0 = @{kPersonal_Cell_Icon : @"me_stu_card", kPersonal_Cell_Title : @"学生证认证", kPersonal_Cell_Arrow : @"right_arrow"
                                    , kPersonal_Cell_SubTitle:status};
            
            [section0 replaceObjectAtIndex:3 withObject:dict0];
            
            [_dataSource replaceObjectAtIndex:0 withObject:section0];
            NSIndexPath *refreshIndex = [NSIndexPath indexPathForRow:3 inSection:0];
            [_personalTable reloadRowsAtIndexPaths:@[refreshIndex] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSError *error) {
        if (error.code == -999) return; //手动取消operation的错误码
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
    // 用户绑卡张数
    self.lastBankCardCountOp = [PesonCenterApi get_bind_card_countWithCount_only:@"1" success:^(NSDictionary *returnData) {
        BNLog(@"绑卡列表--->>>>%@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            
            NSString *amount = [NSString stringWithFormat:@"%@",[datas valueNotNullForKey:@"total_amount"]];
            if ([amount isEqualToString:@"null"]) {
                amount = @"0";
            }
            NSString *total_amout = [NSString stringWithFormat:@"%@",amount];
            
//            NSArray *section1 = @[@{kPersonal_Cell_Icon : @"Me_BankCard", kPersonal_Cell_Title : @"我的银行卡", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: total_amout},
//                                  @{kPersonal_Cell_Icon : @"Me_Cards_icon", kPersonal_Cell_Title : @"卡和优惠券", kPersonal_Cell_Arrow : @"right_arrow"},
//                                  @{kPersonal_Cell_Icon : @"Me_Trainee_icon", kPersonal_Cell_Title : @"喜付实习生", kPersonal_Cell_Arrow : @"right_arrow"}];
            NSMutableArray *section0 = [_dataSource[0] mutableCopy];
            NSDictionary *dict0 = @{kPersonal_Cell_Icon : @"Me_BankCard", kPersonal_Cell_Title : @"我的银行卡", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: total_amout};
            
            [section0 replaceObjectAtIndex:1 withObject:dict0];

            [_dataSource replaceObjectAtIndex:0 withObject:section0];
            NSIndexPath *refreshIndex = [NSIndexPath indexPathForRow:1 inSection:0];
            [_personalTable reloadRowsAtIndexPaths:@[refreshIndex] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        

    } failure:^(NSError *error) {
//        if (error.code == -999) return; //手动取消operation的错误码
//        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];

    }];
    // 卡券数量
    self.lastCouponCardCountOp = [PesonCenterApi get_coupon_card_count:^(NSDictionary *returnData) {
        BNLog(@"卡券数量--->>>>%@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            
            NSString *amount = [NSString stringWithFormat:@"%@",[datas valueNotNullForKey:@"number_of_coupons"]];
            if ([amount isEqualToString:@"null"]) {
                amount = @"0";
            }
            NSString *total_amout = [NSString stringWithFormat:@"%@",amount];
            
//            NSArray *section1 = @[@{kPersonal_Cell_Icon : @"Me_BankCard", kPersonal_Cell_Title : @"我的银行卡", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: total_amout},
//                                  @{kPersonal_Cell_Icon : @"Me_Cards_icon", kPersonal_Cell_Title : @"卡和优惠券", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: total_amout},
//                                  @{kPersonal_Cell_Icon : @"Me_Trainee_icon", kPersonal_Cell_Title : @"喜付实习生", kPersonal_Cell_Arrow : @"right_arrow"}];
            NSMutableArray *section0 = [_dataSource[0] mutableCopy];
            NSDictionary *dict1 = @{kPersonal_Cell_Icon : @"Me_Cards_icon", kPersonal_Cell_Title : @"我的优惠券", kPersonal_Cell_Arrow : @"right_arrow", kPersonal_Cell_SubTitle: total_amout};
            
            [section0 replaceObjectAtIndex:2 withObject:dict1];

            [_dataSource replaceObjectAtIndex:0 withObject:section0];
            NSIndexPath *refreshIndex = [NSIndexPath indexPathForRow:2 inSection:0];
            [_personalTable reloadRowsAtIndexPaths:@[refreshIndex] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
        
    } failure:^(NSError *error) {
        //        if (error.code == -999) return; //手动取消operation的错误码
        //        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        
    }];

    
    
}



#pragma mark - button action

- (void)vipTapAction
{
    //友盟事件点击
    [MobClick event:@"me_VIPButton"];
    
    BNCommonWebViewController *vipWebView = [[BNCommonWebViewController alloc] init];
    //    vipWebView.urlString = [NSString stringWithFormat:@"%@/app/web_files/v1/business/member/index.html",BASE_URL];
    vipWebView.urlString = [NSString stringWithFormat:@"%@/static/web_app/business/member/index.html",BASE_URL];
    [self pushViewController:vipWebView animated:YES];


}
-(void)avatarAcion
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择上传头像方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [sheet showInView:self.view];
}

- (void)backTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    //友盟事件点击
    [MobClick event:@"me_avatarImage" label:(buttonIndex == 0) ? @"相机" : @"相册"];
    
    // 0 相机  1 相册
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->照片\"处进行设置" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil] show];
        return;
    }
    
    _imagePicker = [[UIImagePickerController alloc]  init];
    _imagePicker.sourceType = buttonIndex == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if (buttonIndex == 0) {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    _imagePicker.allowsEditing = YES;//允许编辑
    _imagePicker.delegate = self;//设置代理，检测操作
    [self presentViewController:_imagePicker animated:YES completion:nil];

}


#pragma mark - UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {//如果是照片
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing)
        {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }
        else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
        }
        _avatar.image = image;

        NSData *avatarData = UIImagePNGRepresentation(image);
        
        BNUploadAvatarProgressView *progressView = [[BNUploadAvatarProgressView alloc] initWithFrame:_avatar.frame];
        progressView.layer.cornerRadius = _avatar.widthValue/2.0;
        progressView.layer.masksToBounds = YES;
        progressView.backgroundColor = [UIColor clearColor];
        [_userHeadView addSubview:progressView];
        
        [[BNUploadTools shareInstance] uploadUserAvatarWithData:avatarData success:^(id responseObject) {
            if ([[responseObject valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];
                [progressView startAnimation];
                //友盟事件点击
                [MobClick event:@"me_avatarImage" label:@"上传头像成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshPersonalCenterDetail object:nil];

            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[kRequestRetMessage]];
                [progressView stopAnimation];
            }
            
        } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            [progressView changeProgressWithDataSize:totalBytesWritten amountSize:totalBytesExpectedToWrite];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
    }
    _imagePicker = nil;
    _isFromImagePicker = YES;
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    _isFromImagePicker = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        CGFloat scale = fabs(scrollView.contentOffset.y)/140;
        self.navBgView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
    }
}


#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            //绑定一卡通，改为H5页面
            BNPublicHtml5BusinessVC *bindOneCardVC = [[BNPublicHtml5BusinessVC alloc] init];
            bindOneCardVC.businessType = Html5BusinessType_NativeBusiness;
            bindOneCardVC.url = kBindStumpH5Url;
            bindOneCardVC.backBlock = ^(NSDictionary *dict) {
                BNLog(@"bindOneCard--backBlock--%@",dict);
                [self tableView:_personalTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            };
            [self pushViewController:bindOneCardVC animated:YES];
        }
    }

}

//#pragma mark - ProfileRefreshNotification
//- (void)profileRefreshHandler:(NSNotification *)notification
//{
//}


/* 实名认证 + 一卡通绑定逻辑 -------->>>>>>>>>>>>
#pragma mark 实名认证逻辑--和BNBalanceViewController中的实名认证判断逻辑保持一致。
- (void)enterWalletFetchCash
{
    //先判断是否经过小贷实名认证
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
                    _tixianVerifyed = NO;
                }
                else if ([status isEqualToString:@"AUT"])
                {
                    //认证中
                    _reviewResult = RealNameReviewResult_TixianReviewing;
                    _tixianVerifyed = NO;
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
                    _tixianVerifyed = NO;
                } else {
                    _tixianVerifyed = NO;
                }
            } else {
                _tixianVerifyed = NO;
            }
        }
        if (_tixianVerifyed == YES) {
            [_verifyBtn setImage:[UIImage imageNamed:@"Me_RealName_verifyed"] forState:UIControlStateNormal];
            [_verifyBtn setTitle:@"已实名认证" forState:UIControlStateNormal];
        } else {
            [_verifyBtn setImage:[UIImage imageNamed:@"Me_RealName_unVerifyed"] forState:UIControlStateNormal];
            [_verifyBtn setTitle:@"实名认证" forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
//钱包余额方法
- (void)goBanlanceVC
{
//    if (shareAppDelegateInstance.haveGetPrefile == NO) {
//        [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
//        return;
//    }
//    BNBalanceViewController *balanceVC = [[BNBalanceViewController alloc] init];
//    [self pushViewController:balanceVC animated:YES];

}
 
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 101: {
             //认证
            //去实名认证
            [self verifyRealName];
            break;
        }
        case 102: {
            //绑一卡通
            if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES)
            {
                //已绑定一卡通，则去修改页面
                BNPersonalModStudentNoViewController *modStuNoVC = [[BNPersonalModStudentNoViewController alloc] init];
                [self pushViewController:modStuNoVC animated:YES];
            }else{
                //未绑定一卡通，去绑定
                BNBindYKTViewController *bindYKTVC = [[BNBindYKTViewController alloc] init];
                bindYKTVC.yktType = shareAppDelegateInstance.boenUserInfo.yktType;
                [self pushViewController:bindYKTVC animated:YES];
            }
            break;
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
            realNameVC.RealNameSubmitedBlock = ^(void) {
                //提交了实名认证，在此刷新
                BNLog(@"提交了实名认证，在此刷新");
                [self enterWalletFetchCash];
            };
            [self pushViewController:realNameVC animated:YES];
        } else {
            BNRealNameReviewResultVC *resultVC = [[BNRealNameReviewResultVC alloc] init];
            resultVC.reviewResult = _reviewResult;
            resultVC.errorInfo = _errorInfo;
            [self pushViewController:resultVC animated:YES];
        }
    }
}
*/

/*
 // 刷新icon 姓名 学校 手机号等信息
 - (void)refreshHeadViewData
 {
 
 if (shareAppDelegateInstance.boenUserInfo.name.length > 0 && [shareAppDelegateInstance.boenUserInfo.name isEqualToString:@"null"] != YES) {
 NSString *name = shareAppDelegateInstance.boenUserInfo.name;
 NSString *schoolName = shareAppDelegateInstance.boenUserInfo.schoolName;
 if (name.length > 0 && ![name isEqualToString:@"null"]) {
 NSString *totalStr = [NSString stringWithFormat:@"%@ %@",name, schoolName];
 self.nameLabel.attributedText = [Tools attributedStringWithText:totalStr textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:12*BILI_WIDTH] colorRange:NSMakeRange(name.length+1, schoolName.length)];
 }
 
 }else{
 _nameLabel.text = shareAppDelegateInstance.boenUserInfo.schoolName;
 }
 
 //手机号
 if ((shareAppDelegateInstance.boenUserInfo.phoneNumber.length  > 0 && ![shareAppDelegateInstance.boenUserInfo.phoneNumber isEqualToString:@"null"])) {
 NSString *phoneStr = shareAppDelegateInstance.boenUserInfo.phoneNumber;
 NSString *newPhoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
 _phoneLbl.text = newPhoneStr;
 } else {
 _phoneLbl.text = shareAppDelegateInstance.boenUserInfo.phoneNumber;
 }
 
 //学号
 
 if(shareAppDelegateInstance.boenUserInfo.stuempno.length > 0 && [shareAppDelegateInstance.boenUserInfo.stuempno isEqualToString:@"null"] != YES) {
 [_YKTButton setTitle:[NSString stringWithFormat:@"%@", shareAppDelegateInstance.boenUserInfo.stuempno] forState:UIControlStateNormal];
 [_YKTButton setImage:[UIImage imageNamed:@"Me_SchoolNum_binded"] forState:UIControlStateNormal];
 
 } else {
 [_YKTButton setTitle:@"学号绑定" forState:UIControlStateNormal];
 [_YKTButton setImage:[UIImage imageNamed:@"Me_SchoolNum_unBind"] forState:UIControlStateNormal];
 }
 
 [_avatar setImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
 [_personalTable reloadData];
 
 }
 */


@end
