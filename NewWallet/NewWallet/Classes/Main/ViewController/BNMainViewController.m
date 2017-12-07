//
//  BNMainViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-21.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNMainViewController.h"

#import "BNServiceViewController.h"
#import "BNPersonalCenterViewController.h"
#import "BNNavigationController.h"
#import "BNNewsTool.h"
#import "BNDiscoverMainVC.h"
#import "BannerApi.h"
#import "BNHomeWindowADView.h"
#import "BNAdWebViewController.h"

@interface BNMainViewController ()<UITabBarControllerDelegate>

@property (weak, nonatomic) BNServiceViewController *serviceVC;
@property (strong, nonatomic) UIView *homeADView;
@property (nonatomic) NSString *haveShowHomeAD_UserID;

@end

@implementation BNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _haveShowHomeAD_UserID = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshUnReadNumber) name:kNotification_RefreshUnReadNumber object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomeADView) name:kNotification_showHomeADView object:nil];

    [self setupSubViewController];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}


- (void)setupSubViewController
{
    //首页
    BNHomeViewController *homeVC = [[BNHomeViewController alloc] init];
    
    //服务
    BNServiceViewController *serviceVC = [[BNServiceViewController alloc] init];
    
//    //发现
//    BNDiscoverMainVC *discoverVC = [[BNDiscoverMainVC alloc] init];
    //个人中心
    BNPersonalCenterViewController  *personalCenterVC = [[BNPersonalCenterViewController alloc] init];
    
    self.homeVC = homeVC;
    
    BNNavigationController *oneCardSolutionNavi = [[BNNavigationController alloc]initWithRootViewController:homeVC];
    BNNavigationController *serviceNavi = [[BNNavigationController alloc]initWithRootViewController:serviceVC];
    BNNavigationController *personalCenterNavi = [[BNNavigationController alloc]initWithRootViewController:personalCenterVC];
//    BNNavigationController *discoverNav = [[BNNavigationController alloc] initWithRootViewController:discoverVC];


    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home_unSelected"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    serviceVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"校园" image:[UIImage imageNamed:@"tabbar_campus_unSelected"] selectedImage:[UIImage imageNamed:@"tabbar_campus_selected"]];
//    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discover_unSelected"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    personalCenterVC.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_me_unSelected"] selectedImage:[UIImage imageNamed:@"tabbar_me_selected"]];
    
    
    
//    UIEdgeInsets edgeInset = UIEdgeInsetsMake(6, 0, -6, 0);
//    homeVC.tabBarItem.imageInsets = edgeInset;
//    serviceVC.tabBarItem.imageInsets = edgeInset;
//    personalCenterVC.tabBarItem.imageInsets = edgeInset;
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x31d1fe),UITextAttributeTextColor, nil] forState:UIControlStateSelected];

//    [[UITabBar appearance] setSelectedImageTintColor: UIColor_Button_Normal];

    oneCardSolutionNavi.tag = 101;
    serviceNavi.tag = 102;
    personalCenterNavi.tag = 103;
    
    NSArray *viewControllers = @[oneCardSolutionNavi];
    self.tabBar.hidden = YES;
    self.serviceVC = serviceVC;
    self.viewControllers = viewControllers;
    self.delegate = self;

}

- (void)notificationRefreshUnReadNumber
{
    if ([[BNNewsTool sharedInstance] getTotalUnReadNumber] > 0) {
        _serviceVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)[[BNNewsTool sharedInstance] getTotalUnReadNumber]];
    } else {
        _serviceVC.tabBarItem.badgeValue = nil;
    }
}
- (void)showHomeADView
{
    if ([_haveShowHomeAD_UserID isEqualToString:shareAppDelegateInstance.boenUserInfo.userid]) {
        return;
    }
   
    [BannerApi getHomeWindowADSuccess:^(NSDictionary *dataDict) {
        BNLog(@"getHomeWindowADSuccess--%@", dataDict);
        NSString *retCode = [dataDict valueNotNullForKey:kRequestRetCode];
        
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            NSDictionary *retData = [dataDict valueNotNullForKey:kRequestReturnData];
            NSString *advId = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"advId"]];
            
            NSString *oldAdvId = [BNTools getLastHomeWindowADid];
            if ([oldAdvId isEqualToString:advId]) {
                //已经加载过此广告了。
                BNLog(@"已经加载过此广告了");
                return ;
            } else {
                BNLog(@"未加载过此广告");

                [BNTools saveHomeWindowADid:advId];

//                [self addADView:retData];
            }
            
        }else{
            NSString *retMsg1 = (NSString *)[dataDict valueNotNullForKey:kRequestRetMessage];
            BNLog(@"retMsg---%@", retMsg1);
        }
        
    } failure:^(NSError *error) {
        
    }];
   
}
- (void)addADView:(NSDictionary *)retData
{
    if (!_homeADView) {
        self.homeADView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _homeADView.backgroundColor = [UIColor colorWithRed:((float)((0x222222 & 0xFF0000) >> 16))/255.0 green:((float)((0x222222 & 0xFF00) >> 8))/255.0 blue:((float)(0x222222 & 0xFF))/255.0 alpha:0.7];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_homeADView];
        _homeADView.hidden = YES;
        _homeADView.userInteractionEnabled = YES;
        
        BNHomeWindowADView *imgView = [[BNHomeWindowADView alloc]initWithFrame:CGRectMake(30*BILI_WIDTH, 0, SCREEN_WIDTH-2*30*BILI_WIDTH, SCREEN_WIDTH-2*30*BILI_WIDTH)];
        imgView.tag = 201;
        imgView.centerYValue = SCREEN_HEIGHT/2;
        imgView.image = [UIImage imageNamed:@"Contribute_iPhone4"];
        [_homeADView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(homeADViewJumpAction:)];
        [imgView addGestureRecognizer:tap];
        
        CGFloat closeBtnWidth = 50*BILI_WIDTH;
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(CGRectGetWidth(imgView.frame)-closeBtnWidth, 0, closeBtnWidth, closeBtnWidth);
//        [closeBtn setImage:[UIImage imageNamed:@"HomeWindowADView_closeBtn"] forState:UIControlStateNormal];
        [closeBtn setBackgroundColor:[UIColor clearColor]];
        [imgView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(hideHomeADView) forControlEvents:UIControlEventTouchUpInside];

    }
    NSString *backgroundUrl = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"backgroundUrl"]];
    NSString *jumpToUrl = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"jumpToUrl"]];
    NSString *advId = [NSString stringWithFormat:@"%@", [retData valueWithNoDataForKey:@"advId"]];

    BNHomeWindowADView *imgView = [_homeADView viewWithTag:201];
    imgView.backgroundUrl = backgroundUrl;
    imgView.jumpToUrl = jumpToUrl;
    imgView.advId = advId;
    [imgView sd_setImageWithURL:[NSURL URLWithString:backgroundUrl]];
    
    _haveShowHomeAD_UserID = shareAppDelegateInstance.boenUserInfo.userid;
    
    _homeADView.alpha = 0;
    _homeADView.hidden = NO;
    _homeADView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:0.3 animations:^{
        _homeADView.alpha = 1;
        _homeADView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _homeADView.transform = CGAffineTransformMakeScale(1, 1);
            
        }];
    }];


}
- (void)homeADViewJumpAction:(UIGestureRecognizer *)tap
{
    [self hideHomeADView];

    BNHomeWindowADView *imgView = (BNHomeWindowADView *)tap.view;
    if (imgView.jumpToUrl && imgView.jumpToUrl.length > 0 && ![imgView.jumpToUrl isEqualToString:@"null"]) {
        BNAdWebViewController *VC = [[BNAdWebViewController alloc] init];
        VC.urlString = imgView.jumpToUrl;
        VC.returnBlock = ^(){ };
        [_homeVC pushViewController:VC animated:YES];
    }
}
- (void)hideHomeADView
{
    [UIView animateWithDuration:0.5 animations:^{
        _homeADView.alpha = 0;
        //        _homeADView.transform = CGAffineTransformMakeScale(2, 2);
        
    } completion:^(BOOL finished) {
        _homeADView.hidden = YES;
        _homeADView.alpha = 0;
        _homeADView = nil;
    }];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    BNNavigationController *navVC = (BNNavigationController *)viewController;
    switch (navVC.tag) {
        case 101: {
            //友盟事件点击
            [MobClick event:@"Tabbar_Clicked" label:@"首页"];
            break;
        }
        case 102: {
            //友盟事件点击
            [MobClick event:@"Tabbar_Clicked" label:@"校园"];
            break;
        }
        case 103: {
            //友盟事件点击
            [MobClick event:@"Tabbar_Clicked" label:@"个人中心"];
            break;
        }
        default:
            break;
    }
}
@end
