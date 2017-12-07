//
//  BNHomeViewController.m
//  Wallet
//
//  Created by mac on 15/12/29.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNHomeViewController.h"
#import "CustomButton.h"
#import "JCTopic.h"
#import "BNYKTRechargeHomeVC.h"
#import "LoginApi.h"
#import "KeychainItemWrapper.h"
#import "BNNavigationController.h"
#import "BNNotLoginViewController.h"
#import "GesturePasswordController.h"
#import "BNShowActivityViewController.h"
#import "BNLoginViewController.h"
#import "BNVerifyPhoneViewController.h"
#import "ElectricChargeMainVC.h"
#import "ElectricChargeMainNewVC.h"
#import "NewElectricFeesApi.h"

#import "BNMobileRechargeVC.h"
#import "CardApi.h"
#import "BNAllPayBillViewController.h"

//学校费用缴纳
#import "BNPublicHtml5BusinessVC.h"   //H5页面
#import "BNPayFeesExplainViewController.h"
#import "BNBindYKTViewController.h"
#import "BNCollectFeesListVC.h"

//小贷
#import "BNXiaoDaiExplainViewController.h"
#import "XiaoDaiApi.h"
#import "BNPersonalInfoViewController.h"
#import "BNXiHaDaiHomeViewController.h"
#import "BNRealNameReviewResultVC.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "BNNewXiaodaiRealNameInfo.h"

#import "BNNetFeesHomeViewController.h"

#import "BannerApi.h"
#import "BNCommonWebViewController.h"
#import "TraineeHomeViewController.h"

#import "ScanViewController.h"
#import "ScanToPayIntroViewController.h"

#import "BNHomeActivityImgView.h"
#import "BNAllProjectVC.h"
#import "LDMainViewController.h"
#import "BNEventView.h"
#import "BNEventViewController.h"
#import "PesonCenterApi.h"

@interface BNHomeViewController ()<JCTopicDelegate, BNNotLoginViewDelegate, EventDelegate, UIScrollViewDelegate>

@property (nonatomic) UIView *baseView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *sudokuBaseView;
@property (nonatomic) UIView *eventBaseView;

@property (nonatomic) JCTopic *jcTopicView;
@property (nonatomic) BOOL expanded;    //是否展开
@property (nonatomic) CGFloat lastY;
@property (nonatomic) CGFloat scrollViewCoontentSizeHeight;
@property (nonatomic) NSArray *activityAry;
@property (nonatomic) NSArray *events;
@property (nonatomic) UILabel *xifuPrivilegeLbl;
@property (nonatomic) NSString *xifuPrivilegeTitleStr;
@property (nonatomic) BOOL scrolling;    //是否在滚动

@end

@implementation BNHomeViewController
static CGFloat jcTopicViewHeight;
static CGFloat activityOriginY;
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self getActivityList]; //改成和安卓一样，每次出现都获取一次喜付特权。
    [self getEventsData];

    if (shareAppDelegateInstance.haveGetPrefile == NO && shareAppDelegateInstance.haveKwdsToAutoLogIn == NO) {
        BNNotLoginViewController *notLoginVC = [[BNNotLoginViewController alloc]init];
        notLoginVC.delegate = self;
        [self pushViewController:notLoginVC animated:NO];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavigationBar = NO;
    self.activityAry = [[NSArray alloc]init];
    _expanded = YES;
    _scrolling = NO;
    _xifuPrivilegeTitleStr = @"喜付特权";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProfileInfoFromServer) name:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerData) name:kNotification_RefreshBanner object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSudokuItemList) name:kNotification_RefreshHomeSudokuItems object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getActivityList) name:kNotification_RefreshHomeActivityList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEventsData) name:kNotification_RefreshHomeEventList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindStumpH5Success:) name:kNotification_BindStumpH5Success_GotoBiz object:nil];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_STATUSBAR_HEIGHT)];
    bgView.backgroundColor = UIColor_NewBlueColor;
    [self.view addSubview:bgView];

    UIButton *billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    billBtn.frame = CGRectMake(0, 20, 90*BILI_WIDTH, 44);
    [billBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [billBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    billBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [billBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [billBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    billBtn.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    [billBtn setImage:[UIImage imageNamed:@"Home_BillBtn_icon"] forState:UIControlStateNormal];
    [billBtn setTitle:@"账单" forState:UIControlStateNormal];
    [billBtn addTarget:self action:@selector(billBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:billBtn];

    jcTopicViewHeight = 98*BILI_WIDTH;
    
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT-jcTopicViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT-49 + jcTopicViewHeight)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_baseView atIndex:0];
    _baseView.transform = CGAffineTransformMakeTranslation(0, jcTopicViewHeight);

    UIView *cornerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, jcTopicViewHeight + 50*BILI_WIDTH)];
    cornerBGView.backgroundColor = UIColor_NewBlueColor;
    [_baseView addSubview:cornerBGView];
    //    //暂时用UIImageView,不用JCTopic
    //    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-210*BILI_WIDTH)/2, jcTopicViewHeight-(20+110)*BILI_WIDTH, 210*BILI_WIDTH, 110*BILI_WIDTH)];
    //    [headImageView setImage:[UIImage imageNamed:@"Home_TopBaner"]];
    //    [self.view addSubview:headImageView];
    //    headImageView.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClick:)];
    //    [headImageView addGestureRecognizer:tap];
    
    //广告栏
    self.jcTopicView = [[JCTopic alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, jcTopicViewHeight)];
//    _jcTopicView.backgroundColor = UIColor_NewBlueColor;
    _jcTopicView.JCdelegate = self;
    self.jcTopicView.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, jcTopicViewHeight-30, 60,30)];
    //_jcTopicView.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xeeeeee);
    //_jcTopicView.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xffadad);
    _jcTopicView.pageControl.hidesForSinglePage = YES;
    [_baseView addSubview:_jcTopicView];
    
    //    NSMutableArray *tempImgArray = [@[] mutableCopy];
    //    UIImage * img1 = [UIImage imageNamed:@"OneCard_LocalAd"];
    //    [tempImgArray addObject:[NSDictionary dictionaryWithObjects:@[img1, @(YES), @"111"] forKeys:@[@"pic",@"isLoc",@"prj_id"]]];
    //    [self reloadJCTopicView:tempImgArray];
    
    NSArray *ads = [[NSUserDefaults standardUserDefaults] objectForKey:kBannerCache];
    if (ads.count == 0) {
        ads = @[@{@"pic": [UIImage imageNamed:@"Home_TopBaner"], @"isLoc": @YES, @"url": @""}];
    }
    [self reloadJCTopicView:ads];

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, jcTopicViewHeight, SCREEN_WIDTH, CGRectGetHeight(_baseView.frame)-2*jcTopicViewHeight)];
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    _scrollViewCoontentSizeHeight = _scrollView.contentSize.height;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [_baseView addSubview:_scrollView];
    
    [self addSudokuView];
    
//    NSString *nowDate = [Tools changeNSDateToNSString:[NSDate date]];

//    NSInteger days = [Tools intervalFromLastDate:[Tools getHomeItemLastDate] toTheDate:nowDate]; //上次刷新九宫格，距今有几天
//    if (days >= 1) {
//        //大于1天则刷新九宫格
        [self getSudokuItemList];
//    }

    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
    NSString *userID   = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
    BOOL userIDArrayContain = [Tools userIDArrayContain:userID];
    
    if ([userID length] > 0 && userIDArrayContain == YES) {//客户端已经登录过账户
        //已经登录过账户，肯定有userid
        shareAppDelegateInstance.haveKwdsToAutoLogIn = YES;
        if ([userID length] > 0) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:userID accessGroup:kKeyChainAccessGroup_Gesture];
            NSString *gesturePassword = [keychin objectForKey:(__bridge id)kSecValueData];
            
            if ([gesturePassword length] > 0) {
                [self getAvatarImage];
                GesturePasswordController *gestureVC = [[GesturePasswordController alloc]init];
                gestureVC.vcType = VcTypeVerifyPsw;
                gestureVC.homeVC = self;
                BNNavigationController *navVC = [[BNNavigationController alloc]initWithRootViewController:gestureVC];
                [shareAppDelegateInstance.window.rootViewController presentViewController:navVC animated:NO completion:nil];
            }else{
               //2016-09-08更新，没有设置过手势密码直接进入主页
                [self autoLogin];
            }
        }
    }else{//客户端还没有登录过账户, 登录过账户处于退出状态
        
        BNNotLoginViewController *notLoginVC = [[BNNotLoginViewController alloc]init];
        notLoginVC.delegate = self;
        [self pushViewController:notLoginVC animated:NO];
        
        [self performSelector:@selector(showActivityViewController) withObject:nil afterDelay:0.2];
    }
    
}
- (void)showActivityViewController
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *hasShowActivity = [userDefault objectForKey:kHasShowedActivityView];
    if ([hasShowActivity length] <= 0) {
        [userDefault setObject:@"yes" forKey:kHasShowedActivityView];
        [userDefault synchronize];
        BNShowActivityViewController *showActivityVC = [[BNShowActivityViewController alloc] init];
        showActivityVC.homeVC = self;
        [shareAppDelegateInstance.window.rootViewController presentViewController:showActivityVC animated:YES completion:nil];
    }
}
- (UIView *)addTopFourView:(CGFloat)originY
{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 0)];
    baseView.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *topFourArray = [@[] mutableCopy];
    NSMutableArray *array = [[Tools getHomeItemRecordArray] mutableCopy];
    for (NSDictionary *dict in array) {
        if ([[dict valueWithNoDataForKey:@"biz_area"] integerValue] == 1) {
            [topFourArray addObject:dict];
        }
    }
    if (topFourArray && topFourArray.count > 4) {
        topFourArray = [[topFourArray subarrayWithRange:NSMakeRange(0, 4)] mutableCopy];
    }
    int cellNumber = 4;  //每行最多放几个
    
    CGFloat buttonWidth =  (SCREEN_WIDTH-20*BILI_WIDTH-3*15*BILI_WIDTH)/cellNumber;

    for (int i = 0; i < topFourArray.count; i++) {
        NSDictionary *itemDict = topFourArray[i];
        
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:2*BILI_WIDTH imgHeight:34*BILI_WIDTH textBottomY:12*BILI_WIDTH];
        button.frame = CGRectMake(10*BILI_WIDTH + i%cellNumber*(i%cellNumber == 0 ? 0 : 15*BILI_WIDTH) + i*buttonWidth, 10*BILI_WIDTH , buttonWidth, buttonWidth);
        [button addTarget:self action:@selector(suDoKuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
        
        [button setUpButtonData:itemDict];
        
        [button setTitle:[itemDict valueForKey:@"biz_name"] forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:button.biz_icon_url] forState:UIControlStateNormal];

    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, buttonWidth+12*BILI_WIDTH, SCREEN_WIDTH, 8*BILI_WIDTH)];
    line.backgroundColor = UIColor_Gray_BG;
    [baseView addSubview:line];
    
    baseView.frame = CGRectMake(0, originY, SCREEN_WIDTH, buttonWidth+20*BILI_WIDTH);
    return baseView;

}
- (void)addSudokuView
{
    _expanded = YES;

    if (!_sudokuBaseView) {
        self.sudokuBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*BILI_WIDTH)];
        _sudokuBaseView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_sudokuBaseView];
    }
    for (UIView *view in _sudokuBaseView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat originY = 0;
    int cellNumber = 4;  //每行最多放几个

    UIView *topFourView = [self addTopFourView:originY];
    [_sudokuBaseView addSubview:topFourView];
    originY += CGRectGetHeight(topFourView.frame);

    CGFloat buttonWidth =  (SCREEN_WIDTH-20*BILI_WIDTH-3*15*BILI_WIDTH)/cellNumber;

    NSMutableArray *normalArray = [@[] mutableCopy];
    NSMutableArray *array = [[Tools getHomeItemRecordArray] mutableCopy];
//    NSMutableArray *newAry0 = [@[] mutableCopy];
//    [newAry0 addObjectsFromArray:array];
//    [newAry0 addObject:@{
//                         @"biz_area" : @"2",
//                         @"biz_id" : @"6",
//                         @"biz_name" : @"网费充值1",
//                         @"image" : @"home_net_fees_icon"
//                         }];
//    [newAry0 addObject:@{
//                         @"biz_area" : @"2",
//                         @"biz_id" : @"6",
//                         @"biz_name" : @"网费充值2",
//                         @"image" : @"home_net_fees_icon"
//                         }];
//    [newAry0 addObject:@{
//                         @"biz_area" : @"2",
//                         @"biz_id" : @"6",
//                         @"biz_name" : @"网费充值3",
//                         @"image" : @"home_net_fees_icon"
//                         }];
//    [newAry0 addObject:@{
//                         @"biz_area" : @"2",
//                         @"biz_id" : @"6",
//                         @"biz_name" : @"网费充值4",
//                         @"image" : @"home_net_fees_icon"
//                         }];
//    array = newAry0;

    for (NSDictionary *dict in array) {
        if ([[dict valueWithNoDataForKey:@"biz_area"] integerValue] == 2) {
            [normalArray addObject:dict];
        }
    }
    if (normalArray.count > 8) {
        normalArray = [[normalArray subarrayWithRange:NSMakeRange(0, 7)] mutableCopy];
        [normalArray addObject:@{@"biz_name" : @"更多", @"biz_icon_url" : @"home_more_icon", @"biz_id" : @"999"}];
    }

    
    CGFloat buttonMaxY = 0.0;
    if (normalArray.count > 0) {
        originY += 12*BILI_WIDTH;
    }
    for (int i = 0; i < normalArray.count; i++) {
        NSDictionary *itemDict = normalArray[i];

        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:6*BILI_WIDTH imgHeight:25*BILI_WIDTH textBottomY:12*BILI_WIDTH];
        button.frame = CGRectMake(10*BILI_WIDTH + i%cellNumber*(i%cellNumber == 0 ? 0 : 15*BILI_WIDTH) + i%cellNumber*buttonWidth, originY+i/cellNumber*(buttonWidth) , buttonWidth, buttonWidth);
        [button addTarget:self action:@selector(suDoKuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sudokuBaseView addSubview:button];
        buttonMaxY = CGRectGetMaxY(button.frame);
        
        [button setUpButtonData:itemDict];
        
        [button setTitle:[itemDict valueForKey:@"biz_name"] forState:UIControlStateNormal];

        if ([button.biz_name isEqualToString:@"更多"]) {
            [button setImage:[UIImage imageNamed:[itemDict valueForKey:@"biz_icon_url"]] forState:UIControlStateNormal];
        } else {
            [button sd_setImageWithURL:[NSURL URLWithString:button.biz_icon_url] forState:UIControlStateNormal];
        }
    }
    if (normalArray.count > 0) {
        originY = buttonMaxY + 5*BILI_WIDTH;
    }
    activityOriginY = originY;
    _sudokuBaseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, activityOriginY);
    
    _scrollView.contentSize = CGSizeMake(0, activityOriginY);
    _scrollViewCoontentSizeHeight = _scrollView.contentSize.height;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_scrollView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10*BILI_WIDTH, 10*BILI_WIDTH)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
    maskLayer.path = maskPath.CGPath;
    _scrollView.layer.mask = maskLayer;

}

- (void)addEventView {
    if (!_eventBaseView) {
        self.eventBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, activityOriginY, SCREEN_WIDTH, 30*BILI_WIDTH)];
        _eventBaseView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_eventBaseView];
    }
    for (UIView *view in _eventBaseView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat originY = 0;
    
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 8*BILI_WIDTH)];
    grayLine.backgroundColor = UIColor_Gray_BG;
    [_eventBaseView addSubview:grayLine];
    
    originY += 8*BILI_WIDTH+10;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, originY, 20, 20)];
    iconView.image = [UIImage imageNamed:@"event_speaker"];
    [_eventBaseView addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, originY, 100, 20)];
    titleLabel.text = @"喜付小管家";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00];
    [_eventBaseView addSubview:titleLabel];
    
    UIButton *checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkAllButton.frame = CGRectMake(SCREEN_WIDTH-120, originY, 120, 20);
    checkAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (self.events.count > 0) {
        NSString *numberString = [NSString stringWithFormat:@" %lu ", (unsigned long)self.events.count];
        NSString *titleString = [NSString stringWithFormat:@"你有 %lu 条事件", (unsigned long)self.events.count];
        NSRange range = [titleString rangeOfString:numberString];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
        [attributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00]} range:NSMakeRange(0, titleString.length)];
        [attributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.98 green:0.48 blue:0.04 alpha:1.00]} range:range];
        [checkAllButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    } else {
        [checkAllButton setTitle:@"暂无事件" forState:UIControlStateNormal];
        [checkAllButton setTitleColor:[UIColor colorWithRed:0.49 green:0.58 blue:0.62 alpha:1.00] forState:UIControlStateNormal];
    }
    
    [checkAllButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    checkAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    checkAllButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0);
    [checkAllButton addTarget:self action:@selector(checkAllEvents:) forControlEvents:UIControlEventTouchUpInside];
    [_eventBaseView addSubview:checkAllButton];
    
    originY += 20+10;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [_eventBaseView addSubview:line];
    
    originY += 0.5;
    
    if (self.events.count > 0) {
        BNEventView *eventView = [[BNEventView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 100)];
        eventView.delegate = self;
        [_eventBaseView addSubview:eventView];
        [eventView setData:self.events.firstObject];
        
        originY += 100;
    } else {
        UIImageView *placeholderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 115*NEW_BILI)];
        placeholderView.image = [UIImage imageNamed:@"event_empty_banner"];
        [_eventBaseView addSubview:placeholderView];
        
        originY += 115*NEW_BILI;
    }
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = UIColor_GrayLine;
    [_eventBaseView addSubview:line2];
    
    originY += 10.5;
    
    _eventBaseView.frame = CGRectMake(0, activityOriginY, SCREEN_WIDTH, originY);

    if (!_expanded) {
        _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    } else {
        _scrollView.contentSize = CGSizeMake(0, activityOriginY+originY);
    }
}

#pragma mark - NSNotification
//getProfile 刷新用户信息
- (void)getProfileInfoFromServer
{
    __weak typeof(self) weakSelf = self;
    //    [SVProgressHUD showWithStatus:@"请稍候..."];
    BNLog(@"---首页----正在getProfileInfoFromServer---userid是%@", shareAppDelegateInstance.boenUserInfo.userid);
    [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                 success:^(NSDictionary *successData) {
                     
                     BNLog(@"HomeVC-getProfile--%@", successData);
                     NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         

                         [weakSelf getBannerData];
                         
                         NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                         [BNTools setProfileUserInfo:retData];
                         
                         shareAppDelegateInstance.haveGetPrefile = YES;
                         
                         shareAppDelegateInstance.haveKwdsToAutoLogIn = YES;
                         [self getAvatarImage];
                         
                         [self getEventsData];

                     }else{
                         
                         shareAppDelegateInstance.haveGetPrefile = NO;
                         shareAppDelegateInstance.haveKwdsToAutoLogIn = NO;
                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                         [SVProgressHUD showErrorWithStatus:retMsg];
                         //                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                         if ([retCode isEqualToString:@"2002"]) {
                             BNNotLoginViewController *notLoginVC = [[BNNotLoginViewController alloc]init];
                             notLoginVC.delegate = self;
                             [self pushViewController:notLoginVC animated:NO];
                             
                         }
                     }
                     
                 } failure:^(NSError *error) {
                     
                     shareAppDelegateInstance.haveGetPrefile = NO;
                     shareAppDelegateInstance.haveKwdsToAutoLogIn = NO;
                     [SVProgressHUD showErrorWithStatus:@"网络错误，请重新登录！"];
                     
                     BNNotLoginViewController *notLoginVC = [[BNNotLoginViewController alloc]init];
                     notLoginVC.delegate = self;
                     [self pushViewController:notLoginVC animated:NO];
                     
                 }];
    
}

//获取学校已对接的业务-九宫格数据
- (void)getSudokuItemList
{
    [BannerApi querySchoolBizCodeWithBiz_area:@"1,2" success:^(NSDictionary *successData) {
        BNLog(@"querySchoolBizCodeWithSuccess---%@", successData);
        NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            NSArray *list = [successData valueForKey:kRequestReturnData];
                [Tools saveHomeItemRecordArray:[successData valueForKey:kRequestReturnData]];//本地保存列表
                
                NSString *nowDate = [Tools changeNSDateToNSString:[NSDate date]];
                [Tools saveHomeItemUpdateDate:nowDate];  //保存刷新时间

            [self addSudokuView];
            [self getEventsData];

        } else{
           
        }
    } failure:^(NSError *error) {
        BNLog(@"querySchoolBizCodeWith failure---");

    }];
    
}

//获取广告栏
- (void)getBannerData {
    __weak __typeof(self) weakSelf = self;
    [BannerApi getBannerData:^(NSDictionary *returnData) {
        BNLog(@"banner data: %@", returnData);
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            
            NSArray *ads = [[returnData valueForKey:kRequestReturnData] valueForKey:@"ad_infos"];
            NSMutableArray *construct = [NSMutableArray arrayWithCapacity:ads.count];
            for (NSDictionary *ad in ads) {
                NSString *imageURLKey = @"ad_img_url_m";
                if (weakSelf.view.widthValue > 375) {
                    imageURLKey = @"ad_img_url_l";
                }
                NSString *imageURL = [ad valueNotNullForKey: imageURLKey];
                NSString *linkURL = [ad valueNotNullForKey: @"ad_redirect_url"];
                [construct addObject:@{@"pic": imageURL, @"isLoc": @NO, @"url": linkURL}];
            }
            [[NSUserDefaults standardUserDefaults] setObject:construct forKey:kBannerCache];
            
            if (construct.count) {
                [weakSelf reloadJCTopicView:construct];
            } else {
                [weakSelf reloadJCTopicView:@[@{@"pic": [UIImage imageNamed:@"Home_TopBaner"], @"isLoc": @YES, @"url": @""}]];
            }
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        //[SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

//获取事件流
- (void)getEventsData {
    if (!shareAppDelegateInstance.boenUserInfo.userid || shareAppDelegateInstance.boenUserInfo.userid.length <= 0) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [BannerApi getEventFlow:^(NSDictionary *returnData) {
        BNLog(@"event data: %@", returnData);
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            weakSelf.events = returnData[kRequestReturnData];
            [weakSelf addEventView];
            
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - BNNotLoginViewDelegate
-(void)BNNotLoginViewbuttonAction:(BNNotLoginViewBUttonType)buttonType
{
    if (buttonType == BNNotLoginViewBUttonTypeLogin) {
        //登录
        BNLoginViewController *vc = [[BNLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushViewController:vc animated:YES];
    } else {
        //注册
        BNVerifyPhoneViewController *verifyVC = [[BNVerifyPhoneViewController alloc] init];
        verifyVC.useStyle = ViewControllerUseStyleRegist;
        [self pushViewController:verifyVC animated:YES];
    }
    
}
- (void)suDoKuButtonAction:(CustomButton *)button
{
    [super suDoKuButtonAction:button];
}

- (void)reloadJCTopicView:(NSArray *)tempImgArray
{
    CGSize pageControlSize = [self.jcTopicView.pageControl sizeForNumberOfPages:tempImgArray.count];
    self.jcTopicView.pageControl.frame = CGRectMake((SCREEN_WIDTH-pageControlSize.width)/2, self.jcTopicView.pageControl.frame.origin.y, pageControlSize.width,40);
    
    _jcTopicView.pics = tempImgArray;
    [_jcTopicView upDate];
    
}

#pragma mark - JCTopicDelegate
-(void)didClick:(id)data
{
    BNLog(@"data--%@",data);
    NSString *url = [data valueNotNullForKey:@"url"];
    CustomButton *button = [[CustomButton alloc] init];
    button.biz_h5_url = url;
    [self suDoKuButtonAction:button];

    //友盟事件点击
    [MobClick event:@"home_banner" label:url];

//    if ([url hasPrefix:@"xifu://"]) {
//        if ([url isEqualToString:@"xifu://page_redirect/biz_page/ykt_page"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"0";
//            [self suDoKuButtonAction:button];
//        } else if ([url isEqualToString:@"xifu://page_redirect/biz_page/mobile_page"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"1";
//            [self suDoKuButtonAction:button];
//        } else if ([url isEqualToString:@"xifu://page_redirect/biz_page/ele_page"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"2";
//            [self suDoKuButtonAction:button];
//        } else if ([url isEqualToString:@"xifu://page_redirect/biz_page/loan_page"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"3";
//            [self suDoKuButtonAction:button];
//        } else if ([url isEqualToString:@"xifu://page_redirect/user_page/intern_page"]) {
//            //喜付实习生
//            TraineeHomeViewController *trainneHomeVC = [[TraineeHomeViewController alloc] init];
//            [self pushViewController:trainneHomeVC animated:YES];
//        } else if ([url isEqualToString:@"xifu://page_redirect/user_page/wallet_page"]) {
//            //喜付钱包--已废弃
//            if (shareAppDelegateInstance.haveGetPrefile == NO) {
//                [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
//                return;
//            }
////            BNBalanceViewController *balanceVC = [[BNBalanceViewController alloc] init];
////            [self pushViewController:balanceVC animated:YES];
//        } else if ([url isEqualToString:@"xifu://page_redirect/user_page/bankcard_page"]) {
//            //银行卡列表
//            if (shareAppDelegateInstance.boenUserInfo.userid.length > 0 && shareAppDelegateInstance.haveGetPrefile == YES) {
//                
//                [self gotoYJPayBankCardList];//易极付银行卡管理
//            } else {
//                [SVProgressHUD showErrorWithStatus:kHomeLoadingMsg];
//            }
//        }
//        return;
//    }
//    
//    if ([url isEqualToString:@"#"]) {
//        NSURL *url = [[NSURL alloc] initWithString:@"http://weibo.com/xifuapp"];
//        [[UIApplication sharedApplication] openURL:url];
//        return;
//    }
//    
//    if (url.length > 0 && ![url isEqualToString:@"null"] && [url hasPrefix:@"http"]) {
////        BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
////        webViewController.navTitle = @"喜付";
////        [webViewController setUrlString:url];
////        [self pushViewController:webViewController animated:YES];
//        
//        //可能会支付，所以用BNPublicHtml5BusinessVC，不用BNCommonWebViewController
//        BNPublicHtml5BusinessVC *schoolFeesVC = [[BNPublicHtml5BusinessVC alloc] init];
//        schoolFeesVC.businessType = Html5BusinessType_NativeBusiness;
//        schoolFeesVC.url = url;
//        [self pushViewController:schoolFeesVC animated:YES];
//
//        return;
//    }
}
- (void)autoLogin
{
    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
    NSString *phoneNum = [keychinLogin objectForKey:(__bridge id)kSecAttrAccount];
    NSString *userId = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
    
    shareAppDelegateInstance.boenUserInfo.userid = userId;
    shareAppDelegateInstance.boenUserInfo.phoneNumber = phoneNum;
    
    KeychainItemWrapper *keychinGesture = [[KeychainItemWrapper alloc]initWithIdentifier:userId accessGroup:kKeyChainAccessGroup_Gesture];
    NSString *gesturePwd = [keychinGesture objectForKey:(__bridge id)kSecValueData];
    if ([gesturePwd isEqualToString:@""]) {
        return;
    }
    
    if (phoneNum.length <= 0) {
        return ;
    }
    [self getProfileInfoFromServer];
}

#pragma mark - EventDelegate

- (void)eventSelected:(id)data {
    NSString *url = [data valueNotNullForKey:@"goto_url"];
    NSString *app_type = [data valueNotNullForKey:@"app_type"];
    NSString *biz_id = [data valueNotNullForKey:@"biz_id"];
    
    CustomButton *button = [[CustomButton alloc] init];
    button.biz_id = biz_id;
    button.biz_type = app_type;
    button.biz_h5_url = url;
    [self suDoKuButtonAction:button];

    //友盟事件点击
    [MobClick event:@"home_eventClicked" label:url];
    
//    if (app_type == 0) {
//        if ([biz_id isEqualToString:@"0"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"0";
//            [self suDoKuButtonAction:button];
//        } else if ([biz_id isEqualToString:@"1"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"1";
//            [self suDoKuButtonAction:button];
//        } else if ([biz_id isEqualToString:@"2"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"2";
//            [self suDoKuButtonAction:button];
//        } else if ([biz_id isEqualToString:@"3"]) {
//            CustomButton *button = [[CustomButton alloc] init];
//            button.biz_id  = @"3";
//            [self suDoKuButtonAction:button];
//        }
//    } else {
//        if (url.length > 0 && ![url isEqualToString:@"null"] && [url hasPrefix:@"http"]) {
//            //可能会支付，所以用BNPublicHtml5BusinessVC，不用BNCommonWebViewController
//            BNPublicHtml5BusinessVC *schoolFeesVC = [[BNPublicHtml5BusinessVC alloc] init];
//            schoolFeesVC.businessType = Html5BusinessType_NativeBusiness;
//            schoolFeesVC.url = url;
//            [self pushViewController:schoolFeesVC animated:YES];
//        }
//    }
}

- (void)checkAllEvents:(UIButton *)sender {
    BNEventViewController *eventViewController = [[BNEventViewController alloc] init];
    eventViewController.events = [NSMutableArray arrayWithArray:self.events];
    [self pushViewController:eventViewController animated:YES];
    
    //友盟统计事件流点击
    [MobClick event:@"home_allEvent"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    static float newY = 0;
    
    newY = scrollView.contentOffset.y;
    
    if (newY != _lastY) {
        if (newY > _lastY && newY > 0 && (newY - _lastY) > 0 && _expanded) {
            [self scrollAnimation];
            
        } else if (newY < 0 && !_expanded) {
            [self scrollAnimation];
        }
        _lastY = newY;
        
    }

    
    @autoreleasepool {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_scrollView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10*BILI_WIDTH, 10*BILI_WIDTH)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height);
        maskLayer.path = maskPath.CGPath;
        _scrollView.layer.mask = maskLayer;
        
    }

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    _scrolling = NO;
}
- (void)billBtn:(UIButton *)button
{
    BNAllPayBillViewController *billVC = [[BNAllPayBillViewController alloc] init];
    [self pushViewController:billVC animated:YES];
    [MobClick event:@"home_bill"];
}

- (void)scrollAnimation
{
    if (_scrolling) {
        return;
    }
    _scrolling = YES;

    if (_expanded) {
        [UIView animateWithDuration:.3 animations:^{
            _baseView.transform = CGAffineTransformMakeTranslation(0, 0);
             _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT-49);
            if (_scrollViewCoontentSizeHeight <= _scrollView.frame.size.height+1) {
                _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
                _scrollViewCoontentSizeHeight = _scrollView.contentSize.height;
            }
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:.3 animations:^{
//                if (_scrollViewCoontentSizeHeight <= _scrollView.frame.size.height+1) {
//                    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
//                }
//            }];
            
            _expanded = NO;
            _scrolling = NO;

        }];
       
    } else {
        [UIView animateWithDuration:.3 animations:^{
            _baseView.transform = CGAffineTransformMakeTranslation(0, jcTopicViewHeight);
            _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT-49-jcTopicViewHeight);

            if (_scrollViewCoontentSizeHeight > _scrollView.frame.size.height) {
                _scrollView.contentSize = CGSizeMake(0, _scrollViewCoontentSizeHeight+1);
//                _scrollViewCoontentSizeHeight = _scrollView.contentSize.height;
            }
        } completion:^(BOOL finished) {
            _expanded = YES;
            _scrolling = NO;

        }];
    }
}

- (void)activityImgTaped:(UITapGestureRecognizer *)tapGR
{
    BNHomeActivityImgView *imgView = (BNHomeActivityImgView *)tapGR.view;
    BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
    [webViewController setUrlString:imgView.jumpURL];
    [self pushViewController:webViewController animated:YES];
}

- (void)getAvatarImage
{
    [PesonCenterApi get_user_detail_info:^(NSDictionary *returnData) {
        BNLog(@"homeVC-获取用户详细信息接口--->>>>%@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            //头像
            NSString *avatarUrl = [datas valueNotNullForKey:@"user_portrait_url"];

            shareAppDelegateInstance.boenUserInfo.avatar = avatarUrl;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshPersonalCenterDetail object:nil];
            
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failure:^(NSError *error) {
        if (error.code == -999) return; //手动取消operation的错误码
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}

#pragma  mark - kNotification_BindStumpH5Success_GotoBiz
- (void)bindStumpH5Success:(NSNotification *)notification
{
    CustomButton *bindStumpData = notification.object;
    [self suDoKuButtonAction:bindStumpData];

}
@end
