//
//  BNHomeViewController.m
//  Wallet
//
//  Created by mac on 15/12/29.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNHomeViewController.h"
#import "CustomButton.h"
#import "JCTopicHome.h"
#import "LoginApi.h"
#import "KeychainItemWrapper.h"
#import "BNNavigationController.h"
#import "BNNotLoginViewController.h"
#import "GesturePasswordController.h"
#import "BNShowActivityViewController.h"
#import "BNLoginViewController.h"
#import "BNVerifyPhoneViewController.h"

#import "CardApi.h"
#import "BNAllPayBillViewController.h"

#import "BannerApi.h"
#import "BNCommonWebViewController.h"

#import "ScanViewController.h"
#import "ScanToPayIntroViewController.h"

#import "BNAllProjectVC.h"
#import "BNEventView.h"
#import "BNPersonalMessageVC.h"
#import "PesonCenterApi.h"
#import "BNHomeProjectTableViewCell.h"
#import "BNHomeEventTableViewCell.h"
#import "BNPersonalCenterViewController.h"
#import "BNNewsListViewController.h"
#import "BNXiFuNewsListViewController.h"

#import "BNSideMenuView.h"
#import "BNRefreshControl.h"
#import "BNNewsTool.h"
#import "BNHomeFirstGuidView.h"
//#import "BNScanedByShopVC.h"
#import "BNHomeDropView.h"
#import "UnionPayApi.h"
#import "BNPublicHtml5BusinessVC.h"
#import "BNVeinInfoViewController.h"
#import "BNCreditBalanceAlertView.h"

#import "BNMonthlyBillViewController.h"


#define kServiceCenterIcon @"icon"
#define kServiceCenterTitle @"title"
#define kServiceCenterLatestNewsTitle @"latestNewsTitle"
#define kServiceCenterNewsCount @"count"
@interface BNHomeViewController ()<JCTopicHomeDelegate, BNNotLoginViewDelegate, EventDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, SideMenuDelegate,RefreshDelegate,BNHomeDropViewDelegate>
{
    GesturePasswordController *_gestureVC;
}
@property (nonatomic) UIView *baseView;
@property (nonatomic) UIView *navBarView;
@property (nonatomic, weak) UIButton *headImgBtn;
@property (nonatomic, weak) UIButton *nameLblBtn;

@property (nonatomic) UIView *tableViewHeadView;


@property (nonatomic) UITableView *tableView;


@property (nonatomic) JCTopicHome *jcTopicView;
@property (nonatomic) BOOL expanded;    //是否展开
@property (nonatomic) CGFloat lastY;
//@property (nonatomic) CGFloat scrollViewCoontentSizeHeight;
@property (nonatomic) NSArray *events;
@property (nonatomic) NSMutableArray *mainProjectArray;
@property (nonatomic) NSMutableArray *otherProjectArray;
@property (nonatomic) NSMutableArray *messageTotalArray;

@property (nonatomic) BOOL scrolling;    //是否在滚动
@property (weak, nonatomic) BNSideMenuView *sideMenuView;
@property (nonatomic, weak) BNRefreshControl *refreshControl;
@property (nonatomic) NSInteger totalMsgCount;
@property (nonatomic) NSInteger eventsMsgCount;

@property (nonatomic) BOOL countLblAnimation;

@property (nonatomic) NSString *oneCardAmount;
@property (nonatomic) NSString *electricAmount;

@property (nonatomic, weak) BNHomeDropView *dropView;
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, strong) AFHTTPRequestOperation *lastBankCardCountOp;

@end

@implementation BNHomeViewController
static CGFloat navigationbarMoreHeight;
static CGFloat navigationbarInsetBili;
static CGFloat tableViewHeadViewHeight;
static CGFloat jcTopicViewHeight;

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.tabBarController.tabBar.hidden = YES;
    [self getEventsData];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (shareAppDelegateInstance.haveGetPrefile == NO && shareAppDelegateInstance.haveKwdsToAutoLogIn == NO) {
        _oneCardAmount = @"_ _";
        _electricAmount = @"_ _";
        BNNotLoginViewController *notLoginVC = [[BNNotLoginViewController alloc]init];
        notLoginVC.delegate = self;
        [self pushViewController:notLoginVC animated:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavigationBar = NO;
    _expanded = YES;
    _scrolling = NO;
    _totalMsgCount = 0;
    _countLblAnimation = YES;
    _oneCardAmount = @"_ _";
    _electricAmount = @"_ _";
    
    self.mainProjectArray = [@[] mutableCopy];
    self.otherProjectArray = [@[] mutableCopy];
    self.events = [[NSArray alloc]init];
    self.messageTotalArray = [@[] mutableCopy];
    
    navigationbarMoreHeight = 62*NEW_BILI - 44;
    navigationbarInsetBili = 1.0;
    
    self.navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, 44+navigationbarMoreHeight)];
    _navBarView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_navBarView atIndex:0];
    
    UIButton *headImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headImgBtn.tag = 101;
    headImgBtn.frame = CGRectMake(11*NEW_BILI,  (44+navigationbarMoreHeight-40*NEW_BILI*navigationbarInsetBili)/2, 40*NEW_BILI*navigationbarInsetBili, 40*NEW_BILI*navigationbarInsetBili);
    headImgBtn.layer.cornerRadius =CGRectGetWidth(headImgBtn.frame)/2;
    headImgBtn.layer.masksToBounds = YES;
    [headImgBtn setImage:[UIImage imageNamed:@"HomeVC_HeadBtn"] forState:UIControlStateNormal];
    [headImgBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:headImgBtn];
    _headImgBtn = headImgBtn;
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.tag = 102;
    nameBtn.frame = CGRectMake(51*NEW_BILI + 5*NEW_BILI, (navigationbarMoreHeight +44-38*NEW_BILI*navigationbarInsetBili)/2, 80, 38*NEW_BILI);
    [nameBtn setTitle:@"" forState:UIControlStateNormal];
    [nameBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:nameBtn];
    
    UIButton *nameLblBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameLblBtn.tag = 102;
    nameLblBtn.frame = CGRectMake(51*NEW_BILI + 5*NEW_BILI, (navigationbarMoreHeight +44-40*NEW_BILI*navigationbarInsetBili)/2, SCREEN_WIDTH-(51+5+25*4+30*2)*NEW_BILI, 40*NEW_BILI);
    [nameLblBtn setTitleColor:UIColor_NewBlack_Text forState:UIControlStateNormal];
    [nameLblBtn setTitleColor:UIColor_NewBlack_Text forState:UIControlStateHighlighted];
    nameLblBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nameLblBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
    [nameLblBtn setTitle:@"" forState:UIControlStateNormal];
//    [nameLblBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    nameLblBtn.userInteractionEnabled = NO;
    [_navBarView addSubview:nameLblBtn];
    _nameLblBtn = nameLblBtn;

    UIButton *veinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    veinBtn.tag = 103;
    veinBtn.frame = CGRectMake(SCREEN_WIDTH-30*NEW_BILI*3-25*NEW_BILI*3, (44+navigationbarMoreHeight-40*NEW_BILI)/2, 40*NEW_BILI, 40*NEW_BILI);
    [veinBtn setImage:[UIImage imageNamed:@"payment_icon"] forState:UIControlStateNormal];
    [veinBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_navBarView addSubview:veinBtn];

    UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qrBtn.tag = 107;
    qrBtn.frame = CGRectMake(SCREEN_WIDTH-100*NEW_BILI, (navigationbarMoreHeight + 44-40*NEW_BILI)/2, 40*NEW_BILI, 40*NEW_BILI);
    [qrBtn setImage:[UIImage imageNamed:@"jizhangben"] forState:UIControlStateNormal];
    [qrBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:qrBtn];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.tag = 104;
    scanBtn.frame = CGRectMake(SCREEN_WIDTH-(25+30)*NEW_BILI, (navigationbarMoreHeight + 44-40*NEW_BILI)/2, 40*NEW_BILI, 40*NEW_BILI);
    [scanBtn setImage:[UIImage imageNamed:@"scanToPay_icon"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:scanBtn];
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProfileInfoFromServer) name:kNotification_RefreshOneCardHomeInfoAndProfile object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerData) name:kNotification_RefreshBanner object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSudokuItemList) name:kNotification_RefreshHomeSudokuItems object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEventsData) name:kNotification_RefreshHomeEventList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindStumpH5Success:) name:kNotification_BindStumpH5Success_GotoBiz object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAvatarImage) name:kNotification_RefreshPersonalCenterDetail object:nil];

    jcTopicViewHeight = 111*NEW_BILI;
    tableViewHeadViewHeight = jcTopicViewHeight + 49*NEW_BILI;
    self.tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeadViewHeight)];
    _tableViewHeadView.backgroundColor = UIColor_Gray_BG;
//    [self.view addSubview:_tableViewHeadView];

    //广告栏
    self.jcTopicView = [[JCTopicHome alloc]initWithFrame:CGRectMake(0, 0, floorf(350*NEW_BILI+11), jcTopicViewHeight)];
//    _jcTopicView.backgroundColor = UIColor_NewBlueColor;
    _jcTopicView.JCdelegate = self;

    self.jcTopicView.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(15*NEW_BILI, jcTopicViewHeight+(49*NEW_BILI-40)/2, 60,30)];
    _jcTopicView.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xdbdfed);
    _jcTopicView.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xbec6e2);
    _jcTopicView.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _jcTopicView.pageControl.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _jcTopicView.pageControl.hidesForSinglePage = YES;
    [_tableViewHeadView addSubview:_jcTopicView];
    
    NSArray *ads = [[NSUserDefaults standardUserDefaults] objectForKey:kBannerCache];
    if (ads.count == 0) {
        ads = @[@{@"pic": [UIImage imageNamed:@"Home_TopBaner"], @"isLoc": @YES, @"url": @""}];
    }
    [self reloadJCTopicView:ads];

    UIButton *allPrjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allPrjBtn.tag = 105;
    allPrjBtn.frame = CGRectMake(SCREEN_WIDTH-(15+120)*NEW_BILI, jcTopicViewHeight+(49-25)/2*NEW_BILI, 120*NEW_BILI, 25*NEW_BILI);
    [allPrjBtn setImage:[UIImage imageNamed:@"HomeVC_MoreBtn"] forState:UIControlStateNormal];
    [allPrjBtn setTitle:@"全部功能" forState:UIControlStateNormal];
    [allPrjBtn setTitleColor:UIColor_NewBlack_Text forState:UIControlStateNormal];
    allPrjBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
    [allPrjBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100*NEW_BILI, 0, 0)];
    [allPrjBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20*BILI_WIDTH)];
    [allPrjBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tableViewHeadView addSubview:allPrjBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navBarView.viewBottomEdge, SCREEN_WIDTH,SCREEN_HEIGHT-self.navBarView.viewHeight-NAVIGATION_STATUSBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor_Gray_BG;
    _tableView.tableHeaderView = _tableViewHeadView;
    [_tableView registerClass:[BNHomeProjectTableViewCell class] forCellReuseIdentifier:@"BNHomeProjectTableViewCell"];
    [_tableView registerClass:[BNHomeEventTableViewCell class] forCellReuseIdentifier:@"BNHomeEventTableViewCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH-(114+20)*NEW_BILI, 0, 20*NEW_BILI);
    _tableView.separatorColor = UIColor_NewIconColor;
    [self.view addSubview: _tableView];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showSideMenu:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_tableView addGestureRecognizer:swipeGesture];
  
    BNRefreshControl *refreshControl = [[BNRefreshControl alloc] init];
    refreshControl.delegate = self;
    [_tableView addSubview:refreshControl];
    _refreshControl = refreshControl;
    
    
    //侧边菜单
    BNSideMenuView *sideMenuView = [[BNSideMenuView alloc] initWithFrame:self.view.bounds];
    sideMenuView.delegate = self;
    [self.view addSubview:sideMenuView];
    self.sideMenuView = sideMenuView;

//    NSString *nowDate = [Tools changeNSDateToNSString:[NSDate date]];

//    NSInteger days = [Tools intervalFromLastDate:[Tools getHomeItemLastDate] toTheDate:nowDate]; //上次刷新九宫格，距今有几天
//    if (days >= 1) {
//        //大于1天则刷新九宫格
//        [self getSudokuItemList];
//    }

    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
    NSString *userID   = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
    BOOL userIDArrayContain = [Tools userIDArrayContain:userID];
    
    if ([userID length] > 0 && userIDArrayContain == YES) {//客户端已经登录过账户
        //已经登录过账户，肯定有userid
        shareAppDelegateInstance.haveKwdsToAutoLogIn = YES;
        shareAppDelegateInstance.boenUserInfo.userid = userID;
        if ([userID length] > 0) {
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:userID accessGroup:kKeyChainAccessGroup_Gesture];
            NSString *gesturePassword = [keychin objectForKey:(__bridge id)kSecValueData];
            
            if ([gesturePassword length] > 0) {
                [self refreshGesturePassVC];
                _gestureVC = [[GesturePasswordController alloc]init];
                _gestureVC.vcType = VcTypeVerifyPsw;
                _gestureVC.homeVC = self;
                BNNavigationController *navVC = [[BNNavigationController alloc]initWithRootViewController:_gestureVC];
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
        
//        [self performSelector:@selector(showActivityViewController) withObject:nil afterDelay:0.2];
    }
}
- (void)showActivityViewController
{
    
    //第一次展示图片
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSString *hasShowActivity = [userDefault objectForKey:kHasShowedActivityView];
//    if ([hasShowActivity length] <= 0) {
//        [userDefault setObject:@"yes" forKey:kHasShowedActivityView];
//        [userDefault synchronize];
//        BNShowActivityViewController *showActivityVC = [[BNShowActivityViewController alloc] init];
//        showActivityVC.homeVC = self;
//        [shareAppDelegateInstance.window.rootViewController presentViewController:showActivityVC animated:YES completion:nil];
//    }
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
    
    CGFloat buttonWidth =  (SCREEN_WIDTH-20*NEW_BILI-3*15*NEW_BILI)/cellNumber;

    for (int i = 0; i < topFourArray.count; i++) {
        NSDictionary *itemDict = topFourArray[i];
        
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:2*NEW_BILI imgHeight:34*NEW_BILI textBottomY:12*NEW_BILI];
        button.frame = CGRectMake(10*NEW_BILI + i%cellNumber*(i%cellNumber == 0 ? 0 : 15*NEW_BILI) + i*buttonWidth, 10*NEW_BILI , buttonWidth, buttonWidth);
        [button addTarget:self action:@selector(suDoKuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
        
        [button setUpButtonData:itemDict];
        
        [button setTitle:[itemDict valueForKey:@"biz_name"] forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:button.biz_icon_url] forState:UIControlStateNormal];

    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, buttonWidth+12*NEW_BILI, SCREEN_WIDTH, 8*NEW_BILI)];
    line.backgroundColor = UIColor_Gray_BG;
    [baseView addSubview:line];
    
    baseView.frame = CGRectMake(0, originY, SCREEN_WIDTH, buttonWidth+20*NEW_BILI);
    return baseView;

}



//上拉刷新
- (void)headerRefresh
{
    [self getOnecardAmount];
}

- (void)refreshGesturePassVC{
    __weak typeof(self) weakSelf = self;
    [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                 success:^(NSDictionary *successData) {
                     BNLog(@"gesture---%@--",successData);
                     [shareAppDelegateInstance getAndRefreshNewsData];
                     NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
                     if ([retCode isEqualToString:kRequestSuccessCode]) {
                         
                         NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                         [BNTools setProfileUserInfo:retData];
                         
                         shareAppDelegateInstance.haveGetPrefile = YES;
                         
                         shareAppDelegateInstance.haveKwdsToAutoLogIn = YES;
                         
                         [weakSelf getAvatarImage];
                     }
                 } failure:^(NSError *error) {
                     
                     [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
                     
                 }];

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
                     [shareAppDelegateInstance getAndRefreshNewsData];

                     BNLog(@"HomeVC-getProfile--%@", successData);
                     NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
                     if ([retCode isEqualToString:kRequestSuccessCode]) {

                         [weakSelf getBannerData];
                         
                         NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                         [BNTools setProfileUserInfo:retData];
                         
                         shareAppDelegateInstance.haveGetPrefile = YES;
                         
                         shareAppDelegateInstance.haveKwdsToAutoLogIn = YES;
                         [_nameLblBtn setTitle:shareAppDelegateInstance.boenUserInfo.name forState:UIControlStateNormal];

                         [self getAvatarImage];
                         
                         [self getSudokuItemList];

                         //是否已显示过首次加载的引导蒙版
//                         BOOL firstGuidViewAppeared = [Tools ifHasShowHomeFirstGuidView];
//                         if (!firstGuidViewAppeared) {
//                             [Tools saveHasShowHomeFirstGuidView];
//                             BNHomeFirstGuidView *homeFirstGuidView = [[BNHomeFirstGuidView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//                             __weak BNHomeFirstGuidView *homeFirstGuidView2 = homeFirstGuidView;
//                             [self.view addSubview:homeFirstGuidView];
//                             homeFirstGuidView.tapedBlock = ^(NSInteger tapTimes){
//                                 
//                                 if (tapTimes == 2) {
//                                     [homeFirstGuidView2 removeFromSuperview];
//                                 }
//                             };
//                         }

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
    [BannerApi querySchoolBizCodeWithBiz_area:@"" success:^(NSDictionary *successData) {
        BNLog(@"querySchoolBizCodeWithSuccess---%@", successData);
        NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            NSArray *list = [successData valueForKey:kRequestReturnData];
//                [Tools saveHomeItemRecordArray:[successData valueForKey:kRequestReturnData]];//本地保存列表
//                
//                NSString *nowDate = [Tools changeNSDateToNSString:[NSDate date]];
//                [Tools saveHomeItemUpdateDate:nowDate];  //保存刷新时间

            if (list && list.count > 1) {
                _mainProjectArray = [list[0] mutableCopy];

                _otherProjectArray = [list[1] mutableCopy];

                [self.sideMenuView setMenu:_otherProjectArray];
            }
            [self getOnecardAmount];
            
//            [self performSelector:@selector(getEventsData) withObject:nil afterDelay:0.2];

        } else{
            if (![retCode isEqualToString:@"000002"]) {  //除了第一次登陆cookie null不提示，其他错误要提示。
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
        }
      
    } failure:^(NSError *error) {
        BNLog(@"querySchoolBizCodeWith failure---");

    }];
    
}
- (void)getOnecardAmount
{
    dispatch_queue_t disQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t disGroup = dispatch_group_create();
    
    dispatch_group_async(disGroup, disQueue, ^{
        dispatch_group_enter(disGroup);
        BNLog(@"----1-----");
        if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
        {
            //未绑定学号
            
            _oneCardAmount = @"绑定一卡通号可实时查看余额";
            dispatch_group_leave(disGroup);
        } else {
            [NewCardApi newPay_oneCardCheckGoodsInfoWithStudent_no:shareAppDelegateInstance.boenUserInfo.studentno
                                                         school_id:shareAppDelegateInstance.boenUserInfo.schoolId
                                                           success:^(NSDictionary *successData) {
                                                               BNLog(@"获取一卡通余额---%@", successData);
                                                               NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
                                                               if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                                   NSDictionary *data = [successData valueForKey:kRequestReturnData];
                                                                   NSString *oneCardAmount = [NSString stringWithFormat:@"%@", [data valueWithNoDataForKey:@"balance"]];
                                                                   _oneCardAmount = oneCardAmount;
                                                                   
                                                               }
                                                               dispatch_group_leave(disGroup);
                                                               
                                                           } failure:^(NSError *error) {
                                                               [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                               
                                                               BNLog(@"获取一卡通余额 failure---");
                                                               dispatch_group_leave(disGroup);
                                                           }];
        }
    });
    dispatch_group_async(disGroup, disQueue, ^{
        dispatch_group_enter(disGroup);
        [BannerApi homeVCGetElecBalanceSuccess:^(NSDictionary *successData) {
            BNLog(@"获取电费余额---%@", successData);
            NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
            if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                NSDictionary *data = [successData valueForKey:kRequestReturnData];
                NSString *electricAmount = @"";
                NSString *existRoom = @"";
                if ([data isKindOfClass:[NSDictionary class]]) {
                    electricAmount = [NSString stringWithFormat:@"%@", [data valueWithNoDataForKey:@"amount"]];
                    existRoom = [NSString stringWithFormat:@"%@", [data valueWithNoDataForKey:@"existRoom"]];
                }
                
                
                if ([existRoom isEqualToString:@"1"]) {
                    //绑定了房间号
                    _electricAmount = electricAmount.length <= 0 ? @"_ _" : electricAmount;
                } else {
                    //未绑定房间号
                    _electricAmount = @"一键充值，火速来电";
                }
                
            } else {
                _electricAmount = @"_ _";
                
            }
            dispatch_group_leave(disGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(disGroup);
            BNLog(@"获取电费余额 failure---");
        }];
    });
    dispatch_group_notify(disGroup, disQueue, ^{
        BNLog(@"---end----");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _countLblAnimation = YES;
            [self.tableView reloadData];
            [self performSelector:@selector(changeCountAnimationStatus) withObject:nil afterDelay:0.2];
            [_refreshControl endRefreshing];
            
        });
    });
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
            if (construct.count == 1) {
                self.jcTopicView.contentOffset = CGPointMake(0, 0);
            }
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
//        [weakSelf reloadJCTopicView:@[@{@"pic": [UIImage imageNamed:@"Home_TopBaner0"], @"isLoc": @YES, @"url": @""},
//                                      @{@"pic": [UIImage imageNamed:@"Home_TopBaner1"], @"isLoc": @YES, @"url": @""}]];

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
            NSArray *list = returnData[kRequestReturnData];
            weakSelf.events = list;
            NSString *eventsMsgCount = [returnData valueWithNoDataForKey:@"count"];

            _eventsMsgCount = [eventsMsgCount integerValue];
            
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        [self combineThreeNotifications];

    } failure:^(NSError *error) {
        [self combineThreeNotifications];

    }];
}
- (void)combineThreeNotifications
{
    //个人消息
    NSDictionary *eventNews = @{@"describe" : @"", @"push_time" : @""};
    if (_events && _events.count > 0) {
        eventNews = _events[0];
    }
    NSString *eventSubtitle = [NSString stringWithFormat:@"%@", [eventNews valueWithNoDataForKey:@"describe"]];
    BNHomeMessageModel *eventModel = [[BNHomeMessageModel alloc]init];
    eventModel.title = @"个人消息";
    eventModel.subTitle = eventSubtitle.length > 0 ? eventSubtitle : @"暂无消息";
    eventModel.time = [NSString stringWithFormat:@"%@", [eventNews valueWithNoDataForKey:@"push_time"]];
    eventModel.count = _eventsMsgCount;
    eventModel.icon = @"HomeVC_Events_Icon";

    //校园公告
    NSInteger oneCardNewsUnreadNumber = [[BNNewsTool sharedInstance] getOneCardNewsUnReadNumber];
    OneCardNews *oneCardNews = [[BNNewsTool sharedInstance] getOneCardLatestNewsObject];
    
    BNHomeMessageModel *oneCardModel = [[BNHomeMessageModel alloc]init];
    oneCardModel.title = @"校园公告";
    oneCardModel.subTitle = [NSString stringWithFormat:@"%@", oneCardNews.title];
    oneCardModel.time = [NSString stringWithFormat:@"%@", oneCardNews.create_time];
    oneCardModel.count = oneCardNewsUnreadNumber;
    oneCardModel.icon = @"HomeVC_SchoolNews_Icon";

    //喜付说
    NSInteger xiFuNewsUnreadNumber = [[BNNewsTool sharedInstance] getXifuNewsUnReadNumber];
    XifuNews *xiFuNews = [[BNNewsTool sharedInstance] getXiFuLatestNewsObject];
    BNLog(@"xiFuNews--------%@", xiFuNews);

    BNHomeMessageModel *xiFuModel = [[BNHomeMessageModel alloc]init];
    xiFuModel.title = @"喜付说";
    xiFuModel.subTitle = [NSString stringWithFormat:@"%@", xiFuNews.desc];
    xiFuModel.time = [NSString stringWithFormat:@"%@", xiFuNews.create_time];
    xiFuModel.count = xiFuNewsUnreadNumber;
    xiFuModel.icon = @"HomeVC_XiFu_Icon";
    
    _totalMsgCount = oneCardNewsUnreadNumber + xiFuNewsUnreadNumber + _eventsMsgCount;
    _messageTotalArray = [@[eventModel, oneCardModel, xiFuModel] mutableCopy];
    
    NSArray *sortArray = [_messageTotalArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        BNHomeMessageModel *model1 = [[BNHomeMessageModel alloc]init];
        model1.time = ((BNHomeMessageModel *)obj1).time;
        BNHomeMessageModel *model2 = [[BNHomeMessageModel alloc]init];
        model2.time = ((BNHomeMessageModel *)obj2).time;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        if (!model1.time || [model1.time isEqualToString:@"null"] || [model1.time isEqualToString:@""]) {
            model1.time = @"1970-01-01 00:00:00";
        }
        if (!model2.time || [model2.time isEqualToString:@"null"] || [model2.time isEqualToString:@""]) {
            model2.time = @"1970-01-01 00:00:00";
        }
        NSDate *date1 = [formatter dateFromString:model1.time];
        NSDate *date2 = [formatter dateFromString:model2.time];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
        
//        if ([model1.time integerValue] > [model2.time integerValue]) { //不使用intValue比较无效
//            return NSOrderedDescending;//降序
//        }else if ([model1.time integerValue] < [model2.time integerValue]){
//            return NSOrderedAscending;//升序
//        }else {
//            return NSOrderedSame;//相等
//        }
        
        
    }];
    _messageTotalArray = [sortArray mutableCopy];
    [self.tableView reloadData];
    BNLog(@"combineThreeNotifications0--------");
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
    self.jcTopicView.pageControl.frame = CGRectMake(15*NEW_BILI, self.jcTopicView.pageControl.frame.origin.y, pageControlSize.width,30);
    
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

}
- (void)autoLogin
{
    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
    NSString *phoneNum = [keychinLogin objectForKey:(__bridge id)kSecAttrAccount];
    NSString *userId = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
    
    shareAppDelegateInstance.boenUserInfo.userid = userId;
    shareAppDelegateInstance.boenUserInfo.phoneNumber = phoneNum;
    
//    KeychainItemWrapper *keychinGesture = [[KeychainItemWrapper alloc]initWithIdentifier:userId accessGroup:kKeyChainAccessGroup_Gesture];
//    NSString *gesturePwd = [keychinGesture objectForKey:(__bridge id)kSecValueData];
    if (userId.length <= 0) {
        return;
    }
    
//    if (phoneNum.length <= 0) {
//        return ;
//    }
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

//- (void)checkAllEvents:(UIButton *)sender {
//    BNEventViewController *eventViewController = [[BNEventViewController alloc] init];
//    eventViewController.events = [NSMutableArray arrayWithArray:self.events];
//    [self pushViewController:eventViewController animated:YES];
//    
//    //友盟统计事件流点击
//    [MobClick event:@"home_allEvent"];
//}

- (void)showSideMenu:(UISwipeGestureRecognizer *)gesture {
    
    CGFloat bannerHeight = 111*NEW_BILI;
    CGPoint loc = [gesture locationInView:self.tableView];
    if (loc.y <= bannerHeight) {
        return;
    }
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = 105;
    [self buttonAction:button];
}

#pragma mark - SideMenuDelegate

- (void)menuSelected:(NSDictionary *)data {
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button setUpButtonData:data];
    [self suDoKuButtonAction:button];
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
            
            if (_gestureVC) {
                [_gestureVC refreshHeadAndTitle];
            }
            
            [_headImgBtn sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"HomeVC_HeadBtn"]];
            

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
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _mainProjectArray.count;
    }
    return _messageTotalArray.count;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *msgBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49*NEW_BILI)];
    msgBaseView.backgroundColor = UIColor_Gray_BG;
    msgBaseView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myMessageBtnTaped)];
    [msgBaseView addGestureRecognizer:tap];
    
    UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*NEW_BILI, (49-15)/2*NEW_BILI, 15*NEW_BILI, 15*NEW_BILI)];
    numberLbl.font = [UIFont boldSystemFontOfSize:13*NEW_BILI];
    numberLbl.textColor = [UIColor whiteColor];
    numberLbl.backgroundColor = UIColor_NewIconColor;
    numberLbl.layer.cornerRadius = 2;
    numberLbl.layer.masksToBounds = YES;
    numberLbl.layer.borderWidth = 1;
    numberLbl.layer.borderColor = UIColor_NewIconColor.CGColor;
    numberLbl.textAlignment = NSTextAlignmentCenter;
    [msgBaseView addSubview:numberLbl];
    numberLbl.text = [NSString stringWithFormat:@"%ld", (long)_totalMsgCount];
    
    UILabel *msgLbl = [[UILabel alloc]initWithFrame:CGRectMake(37*NEW_BILI, (49-15)/2*NEW_BILI, 80*NEW_BILI, 15*NEW_BILI)];
    msgLbl.font = [UIFont boldSystemFontOfSize:13*NEW_BILI];
    msgLbl.textColor = UIColor_NewIconColor;
    [msgBaseView addSubview:msgLbl];
    msgLbl.text = @"新消息";
    
    if (_totalMsgCount > 0) {
        numberLbl.backgroundColor = UIColorFromRGB(0xf19797);//红色背景
        numberLbl.layer.borderColor = UIColorFromRGB(0xf19797).CGColor;
    }
    CGFloat numberLblWidth = [Tools getTextWidthWithText:numberLbl.text font:numberLbl.font height:numberLbl.frame.size.height];
    numberLbl.frame = CGRectMake(numberLbl.frame.origin.x, numberLbl.frame.origin.y, numberLblWidth+7*NEW_BILI, numberLbl.frame.size.height);
    msgLbl.frame = CGRectMake(CGRectGetMaxX(numberLbl.frame)+11*NEW_BILI, msgLbl.frame.origin.y, msgLbl.frame.size.width, msgLbl.frame.size.height);
    
    UIButton *allPrjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allPrjBtn.tag = 106;
    allPrjBtn.frame = CGRectMake(SCREEN_WIDTH-(15+120)*NEW_BILI, (49-25)/2*NEW_BILI, 120*NEW_BILI, 25*NEW_BILI);
    [allPrjBtn setImage:[UIImage imageNamed:@"HomeVC_MoreBtn"] forState:UIControlStateNormal];
    [allPrjBtn setTitle:@"我的信息" forState:UIControlStateNormal];
    [allPrjBtn setTitleColor:UIColor_NewBlack_Text forState:UIControlStateNormal];
    allPrjBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
    [allPrjBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100*NEW_BILI, 0, 0)];
    [allPrjBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20*BILI_WIDTH)];
    [allPrjBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [msgBaseView addSubview:allPrjBtn];

    
    return msgBaseView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 49*NEW_BILI;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kHomeProjectCellHeight;
    }
    return kHomeMessageCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier1 = @"BNHomeProjectTableViewCell";
    static NSString *cellIdentifier2 = @"BNHomeEventTableViewCell";

    if (indexPath.section == 0) {
        BNHomeProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        [cell drawData:_mainProjectArray[indexPath.row] animation:_countLblAnimation oneCardAmount:_oneCardAmount electricAmount:_electricAmount];

        return cell;
    } else {
        BNHomeEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        [cell drawMessageData:_messageTotalArray[indexPath.row]];

        return cell;
    }
 
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
    if (indexPath.section == 0) {
        //业务点击
        NSDictionary *itemDict = _mainProjectArray[indexPath.row];

        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpButtonData:itemDict];
        [self suDoKuButtonAction:button];

    } else {
        BNHomeMessageModel *model = _messageTotalArray[indexPath.row];
        if ([model.title hasPrefix:@"个人消息"]) {
            //友盟事件点击
            [MobClick event:@"home_allEvent"];
            
            BNPersonalMessageVC *eventViewController = [[BNPersonalMessageVC alloc] init];
            [self pushViewController:eventViewController animated:YES];
            
            [BannerApi markAsReadEventWithSuccess:^(NSDictionary *returnData) {
                BNLog(@"markAsReadEventWithSuccess: %@", returnData);
                
            } failure:^(NSError *error) {
//                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
            }];

        } else if ([model.title hasPrefix:@"校园公告"]) {
            //友盟事件点击
            [MobClick event:@"school_SchoolNewsCenter"];
            
            BNNewsListViewController *newsListVC = [[BNNewsListViewController alloc] init];
            newsListVC.useStyle = NewsListViewControllerUseStyleYKT;
            [self pushViewController:newsListVC animated:YES];

        } else {
            //喜付说
            //友盟事件点击
            [MobClick event:@"school_XifuNewsCenter"];
            
            BNXiFuNewsListViewController *xiFuNewsListVC = [[BNXiFuNewsListViewController alloc] init];
            xiFuNewsListVC.useStyle = NewsListViewControllerUseStyleXIFU;
            xiFuNewsListVC.enterMode = EnterModeFromVC;
            [self pushViewController:xiFuNewsListVC animated:YES];

        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float newY = 0;
    newY = scrollView.contentOffset.y;
    if (newY != _lastY) {
        if (newY > _lastY && newY > 0 && _expanded) {
            //伸展状态-伸展变为缩小
            [self scrollAnimation];
            
        } else if (newY+1 < _tableView.contentSize.height-_tableView.frame.size.height && newY < _lastY && newY > 0 && !_expanded) {
             //缩小状态-缩小变为伸展
            [self scrollAnimation];
        }
        _lastY = newY;
    }
}
- (void)scrollAnimation
{
    if (_scrolling) {
        return;
    }
    _scrolling = YES;
    CGFloat addHeight = 0;

    if (_expanded) {
        //伸展状态-伸展变为缩小
        addHeight = 0;
        navigationbarInsetBili = 44.0/(62.0*NEW_BILI);
//        BNLog(@"navigationbarInsetBili伸展变为缩小----%f", navigationbarInsetBili);
        [UIView animateWithDuration:.3 animations:^{
            _navBarView.frame = CGRectMake(0,NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, 44+addHeight);
            _tableView.frame = CGRectMake(0, _navBarView.viewBottomEdge, SCREEN_WIDTH,SCREEN_HEIGHT-_navBarView.viewBottomEdge);
            
            for (UIView *btn in _navBarView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    btn.center = CGPointMake(btn.center.x, (44+addHeight)/2);
                }
            }
        } completion:^(BOOL finished) {
            _expanded = NO;
            _scrolling = NO;
        }];
        for (UIView *btn in _navBarView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag == 101) {
                    //头像缩小
                    CABasicAnimation *scale = [CABasicAnimation animation];
                    scale.keyPath = @"transform.scale";
                    scale.fromValue =[NSNumber numberWithFloat:1.0];
                    scale.toValue =[NSNumber numberWithFloat:0.8];

                    CAAnimationGroup *group = [CAAnimationGroup animation];
                    group.animations = @[scale];
                    group.duration =.3;
                    group.removedOnCompletion = NO;
                    group.fillMode = kCAFillModeForwards;
                    [btn.layer addAnimation:group forKey:nil];
                }
            }
        }


    } else {
        //缩小状态-缩小变为伸展
        addHeight = navigationbarMoreHeight;
        navigationbarInsetBili = (62.0*NEW_BILI)/44.0;
//        BNLog(@"navigationbarInsetBili缩小变为伸展----%f", navigationbarInsetBili);
        
        [UIView animateWithDuration:.3 animations:^{
            _navBarView.frame = CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, 44+addHeight);
            _tableView.frame = CGRectMake(0, _navBarView.viewBottomEdge, SCREEN_WIDTH,SCREEN_HEIGHT-_navBarView.viewBottomEdge);
            
            for (UIView *btn in _navBarView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    btn.center = CGPointMake(btn.center.x, 44/2);
                }
            }
        } completion:^(BOOL finished) {
            _expanded = YES;
            _scrolling = NO;
        }];
        for (UIView *btn in _navBarView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag == 101) {
                    //头像放大
                    CABasicAnimation *scale = [CABasicAnimation animation];
                    scale.keyPath = @"transform.scale";
                    scale.fromValue = [NSNumber numberWithFloat:0.8];
                    scale.toValue = [NSNumber numberWithFloat:1.0];

                    CAAnimationGroup *group = [CAAnimationGroup animation];
                    group.animations = @[scale];
                    group.duration =.3;
                    group.removedOnCompletion = NO;
                    group.fillMode = kCAFillModeForwards;
                    [btn.layer addAnimation:group forKey:nil];
                    
                }
            }
        }

    }
}

#pragma mark - ButtonAction
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 101:
        case 102: {
            //头像、姓名按钮
            //友盟事件点击
            [MobClick event:@"5_0_0_Home_HeadBtnTaped"];
            BNPersonalCenterViewController *personCenterVC = [[BNPersonalCenterViewController alloc]init];
            [self pushViewController:personCenterVC animated:YES];
            
            break;
        }
        case 103: {
            //付款码页面
            CustomButton *button = [[CustomButton alloc] init];
            button.biz_id = @"20";
            [self suDoKuButtonAction:button];
            //友盟事件点击
            [MobClick event:@"5_3_0_Home_ScanToPayBtnTaped"];
//
//            //走九宫格，不走下面
//            [self QR_CheckIfBindedVein];
            
            break;
        }
        case 104: {
            
            //扫码支付
            //友盟事件点击
            [MobClick event:@"5_0_0_Home_ScanBtnTaped"];
            ScanViewController *scanVC = [[ScanViewController alloc] init];
            scanVC.fromHomeScan = YES;
            [self pushViewController:scanVC animated:YES];
            
            break;
        }
        case 105: {
            //全部功能按钮
            //友盟事件点击
            [MobClick event:@"5_0_0_Home_AllProjectBtnTaped"];
            [self.sideMenuView show];
            
            break;
        }
        case 106: {
            //我的信息按钮
            //友盟事件点击
            [MobClick event:@"5_0_0_Home_MyMessageBtnTaped"];
            [self myMessageBtnTaped];
            break;
        }
        case 107: {
            //静脉按钮
            //友盟事件点击
//            [MobClick event:@"5_3_0_Home_VeinBtnTaped"];

//            [self gotoVein];
            //记账本事件
            if(shareAppDelegateInstance.boenUserInfo.studentno.length <= 0)
            {
                //未绑定学号
                shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"使用此功能需要绑定学号，确认绑定吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
                shareAppDelegateInstance.alertView.tag = 101;
                [shareAppDelegateInstance.alertView show];
                return;
            }
            [MobClick event:@"1001"];
            BNMonthlyBillViewController *billVC = [[BNMonthlyBillViewController alloc] init];
            [self pushViewController:billVC animated:YES];

            break;
        }
        default:
            break;
    }
}
- (void)gotoVein
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi veinInfo_checkIfBindedVeinWithSuccess:^(NSDictionary *returnData) {
        BNLog(@"查询是否已绑定静脉--->>>>%@",returnData);
        //返回值："is_bound": 0 // 0-未绑定 1-已绑定*/
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *datas = [returnData valueWithNoDataForKey:kRequestReturnData];
            NSString *is_bound = [datas valueWithNoDataForKey:@"is_bound"];
            if ([is_bound integerValue] == 0) {
                //静脉信息-未绑定，H5页面绑定
                BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
                bankVC.businessType = Html5BusinessType_NativeBusiness;
                bankVC.url = KUserCenter_VeinInfo_H5BindVC;
                bankVC.backBlock = ^(NSDictionary *dict){
                    BNVeinInfoViewController *vc = [[BNVeinInfoViewController alloc] init];
                    [self pushViewController:vc animated:YES];
                };
                [self pushViewController:bankVC animated:YES];

            } else {
                NSString *user_type = [datas valueWithNoDataForKey:@"user_type"];
                NSString *user_type_name = [datas valueWithNoDataForKey:@"user_type_name"];

                shareAppDelegateInstance.boenUserInfo.user_type = user_type;
                shareAppDelegateInstance.boenUserInfo.user_type_name = user_type_name;

                //静脉信息-已绑定
                BNVeinInfoViewController *vc = [[BNVeinInfoViewController alloc] init];
                [self pushViewController:vc animated:YES];
            }
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
}
- (void)QR_CheckIfBindedVein
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi veinInfo_checkIfBindedVeinWithSuccess:^(NSDictionary *returnData) {
        BNLog(@"查询是否已绑定静脉--->>>>%@",returnData);
        //返回值："is_bound": 0 // 0-未绑定 1-已绑定*/
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *datas = [returnData valueWithNoDataForKey:kRequestReturnData];
            NSString *is_bound = [datas valueWithNoDataForKey:@"is_bound"];
            if ([is_bound integerValue] == 0) {
                //静脉信息-未绑定，H5页面绑定
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"使用二维码付款功能\n需要绑定静脉信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上绑定", nil];
                alert.tag = 107;
                shareAppDelegateInstance.alertView = alert;
                [alert show];
                
            } else {
                NSString *user_type = [datas valueWithNoDataForKey:@"user_type"];
                NSString *user_type_name = [datas valueWithNoDataForKey:@"user_type_name"];
                
                shareAppDelegateInstance.boenUserInfo.user_type = user_type;
                shareAppDelegateInstance.boenUserInfo.user_type_name = user_type_name;
                
                //静脉信息已绑定-进入二维码页面
//                BNScanedByShopVC *scanedByShopVC = [[BNScanedByShopVC alloc]init];
//                [self pushViewController:scanedByShopVC animated:YES];

            }
        }else{
            NSString *msg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
    
}
- (void)myMessageBtnTaped
{
    //我的信息按钮
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageTotalArray.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
   
}
- (void)changeCountAnimationStatus
{
    _countLblAnimation = NO;
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 103) {
        if (buttonIndex == 1) {
            //去验证银行卡,用银联H5页面。
            __weak typeof(self) weakSelf = self;
            [SVProgressHUD showWithStatus:@"请稍候..."];
            [UnionPayApi getUnionBankListURLSucceed:^(NSDictionary *successData) {
                BNLog(@"getUnionBankListURLSucceed--%@", successData);
                NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                    [SVProgressHUD dismiss];

                    NSDictionary *retData = [successData valueForKey:kRequestReturnData];
                    BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
                    bankVC.businessType = Html5BusinessType_NativeBusiness;
                    bankVC.hideNavigationbar = YES;
                    bankVC.url = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"bank_list_url"]];
                    [weakSelf pushViewController:bankVC animated:YES];
                    
                }else{
                    NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                    [SVProgressHUD showErrorWithStatus:retMsg];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
            }];

        }
    } else if (alertView.tag == 107) {
        if (buttonIndex == 1) {
            BNPublicHtml5BusinessVC *bankVC = [[BNPublicHtml5BusinessVC alloc] init];
            bankVC.businessType = Html5BusinessType_NativeBusiness;
            bankVC.url = KUserCenter_VeinInfo_H5BindVC;
            bankVC.backBlock = ^(NSDictionary *dict){
                //静脉信息已绑定-进入二维码页面
//                BNScanedByShopVC *scanedByShopVC = [[BNScanedByShopVC alloc]init];
//                [self pushViewController:scanedByShopVC animated:YES];
            };
            [self pushViewController:bankVC animated:YES];
        }
    }else {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }

}


- (void)appearCreditAmountAlertView
{
    BNCreditBalanceAlertView *alert = [[BNCreditBalanceAlertView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(50+23)*NEW_BILI, SCREEN_WIDTH, 50*NEW_BILI)];
    [alert setTitle:@"您的信用金即将超限，请及时还款噢！" iconName:@"HomeVC_VeinCreditAmountAlert"];
    [self.view addSubview:alert];
    alert.tapBlock = ^(void) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 107;
        [self buttonAction:button];
    };
    [alert appearAnimation];
}

@end
