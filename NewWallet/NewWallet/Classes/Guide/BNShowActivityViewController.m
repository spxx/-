//
//  BNShowActivityViewController.m
//  Wallet
//
//  Created by mac1 on 14-12-15.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNShowActivityViewController.h"

#import "KeychainItemWrapper.h"

@interface BNShowActivityViewController ()

@property (weak, nonatomic) NSTimer *changVCTimer;

@end

@implementation BNShowActivityViewController

- (void)setupLoadView
{
    self.showNavigationBar = NO;
    self.customNavigationBar.hidden = YES;
    UIImageView *activityImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    if (SCREEN_HEIGHT < 500) {
        [activityImageView setImage:[UIImage imageNamed:@"Contribute_iPhone4.png"]];
    } else if (SCREEN_HEIGHT == 568) {
        [activityImageView setImage:[UIImage imageNamed:@"Contribute_iPhone5.png"]];
    } else if (SCREEN_HEIGHT == 667 || SCREEN_WIDTH == 375) {
        [activityImageView setImage:[UIImage imageNamed:@"Contribute_iPhone6.png"]];
    }
//    if (SCREEN_HEIGHT == 736 || SCREEN_WIDTH == 414) {
    else {
        [activityImageView setImage:[UIImage imageNamed:@"Contribute_iPhone6p.png"]];
    }
    [self.view addSubview:activityImageView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLoadView];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:kBundleKey];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    [userDefault setObject:version forKey:kBundleKey];
    
    [userDefault synchronize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _changVCTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(activityVCGoToMainVC) userInfo:nil repeats:NO];
}



- (void)activityVCGoToMainVC
{
    [_changVCTimer invalidate];
    _changVCTimer = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    KeychainItemWrapper * keychinLogin = [[KeychainItemWrapper alloc]initWithIdentifier:kKeyChainAccessGroup_LastLoginUserId accessGroup:kKeyChainAccessGroup_LastLoginUserId];
    NSString *userId      = [keychinLogin objectForKey:(__bridge id)kSecAttrDescription];
    BOOL userIDArrayContain = [Tools userIDArrayContain:userId];
    
    if ([userId length] > 0 && userIDArrayContain == YES) {//客户端已经登录过账户
        [self.homeVC autoLogin];
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
