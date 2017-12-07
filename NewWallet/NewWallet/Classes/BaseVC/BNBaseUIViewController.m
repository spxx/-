//
//  BNBaseUIViewController.m
//
//  Created by BN on 14-10-24.
//  Copyright (c) 2014年 xjy. All rights reserved.
//

#import "BNBaseUIViewController.h"
#import "BNNavigationController.h"

#import "BNXiFuNewsListViewController.h"

@interface BNBaseUIViewController ()
@property (nonatomic, assign)BOOL initialized;




@end

@implementation BNBaseUIViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    BNLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
}

- (BOOL)appearForFirstTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"AppearForFirstTime_%@_v5.0.0", NSStringFromClass(self.class)];
    BOOL result = [userDefaults boolForKey:key];
    if (!result) {
        [userDefaults setBool:YES forKey:key];
        [userDefaults synchronize];
    }
    return !result;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)initialize
{
    if (_initialized) {
        return;
    }
    _initialized = YES;

    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.wantsFullScreenLayout = YES;
 
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //六十四像素的背景view
    _sixtyFourPixelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+NAVIGATION_STATUSBAR_HEIGHT)];
    _sixtyFourPixelsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _sixtyFourPixelsView.backgroundColor = UIColor_NavBarBGColor;
    [self.view insertSubview:_sixtyFourPixelsView atIndex:1];
    //init custom navigation bar
    _customNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, self.view.frame.size.width, 44)];
    _customNavigationBar.userInteractionEnabled = YES;
    _customNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_sixtyFourPixelsView addSubview:_customNavigationBar];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, _customNavigationBar.frame.size.height-0.5, _customNavigationBar.frame.size.width, 0.5)];
    line.tag = 10001;
    line.backgroundColor = UIColor_GrayLine;
    [_customNavigationBar addSubview:line];
    
    //title
    
    self.navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 120, 44)];
    _navigationLabel.tag = 10002;
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin;
    _navigationLabel.font = [UIFont boldSystemFontOfSize:16*BILI_WIDTH];
    _navigationLabel.textColor = UIColorFromRGB(0x37474f);
    _navigationLabel.text = _navigationTitle;
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.textAlignment = NSTextAlignmentCenter;
    _navigationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_customNavigationBar addSubview:_navigationLabel];
    //back button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 60, 44);
    _backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"Main_Back_btn"] forState:UIControlStateNormal];

    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
//    [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -14)];
    [_customNavigationBar addSubview:_backButton];

}


- (void)setupLoadedView
{
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- NAVIGATION_STATUSBAR_HEIGHT)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT + 1);
    theScollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:theScollView belowSubview:self.sixtyFourPixelsView];
    
    self.baseScrollView = theScollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notification_SetTabBarTo0:) name:kNotification_SetTabBarTo0 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentToMsgCenterListVC:) name:kNotification_RecievedMessage_AppLaunched_PresentToMsgCenterList object:nil];

}
- (void)Notification_SetTabBarTo0:(NSNotification *)notifacation
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;  //退出后跳到一卡通页面，并出现未登录页面

}
- (void)presentToMsgCenterListVC:(NSNotification *)notifacation
{
    BNXiFuNewsListViewController *xiFuNewsListVC = [[BNXiFuNewsListViewController alloc] init];
    xiFuNewsListVC.useStyle = NewsListViewControllerUseStyleXIFU;
    xiFuNewsListVC.enterMode = EnterModeFromNotificationCenter;
    
    BNNavigationController *navVC = [[BNNavigationController alloc]initWithRootViewController:xiFuNewsListVC];

    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    if (![_navigationTitle isEqualToString:navigationTitle]) {
        _navigationTitle = navigationTitle;
        _navigationLabel.text = _navigationTitle;
    }
}

- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        //防止多次连续点击崩溃
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setShowNavigationBar:(BOOL)showNavigationBar
{
    _showNavigationBar = showNavigationBar;
    _sixtyFourPixelsView.hidden = !_showNavigationBar;
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    [UIView animateWithDuration:.25 animations:^{
        if (hidden) {
            _sixtyFourPixelsView.transform = CGAffineTransformMakeTranslation(0, -64);
//            _sixtyFourPixelsView.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
        }
        else{
            _sixtyFourPixelsView.transform = CGAffineTransformMakeTranslation(0, 0);
//            _sixtyFourPixelsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        }
    }];
}

- (void)setNavigationTitleColor:(UIColor *)navigationTitleColor {
    _navigationLabel.textColor = navigationTitleColor;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    [MobClick beginLogPageView:className];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    [MobClick endLogPageView:className];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - keyboard
- (void)addResponseKeyboardAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeResponseKeyboardAction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardWillHidden:(NSNotification *)note
{
    
}

- (void)keyboardDidShow:(NSNotification *)note
{
    
}
- (void)pushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:animated];
}
- (void)popToRootViewControllerAnimated:(BOOL)animated compliton:(void(^)(void))complitionBlock
{
   
   [self.navigationController popToRootViewControllerAnimated:animated];
    if (complitionBlock) {
        complitionBlock();
    }
}

@end

