//
//  BNNotLoginViewController.m
//  Wallet
//
//  Created by mac on 15/1/26.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNNotLoginViewController.h"
#import "UIImage+RetFitImage.h"
#import "BNXiaoDaiInfoRecordTool.h"
#import "GesturePasswordController.h"
#import "BNLoginViewController.h"
#import "BNVerifyPhoneViewController.h"
#import "BNPageControl.h"

@interface BNNotLoginViewController ()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) BNPageControl *pageControl;


@property (nonatomic, strong) NSMutableArray *bgViews;

@end

@implementation BNNotLoginViewController


- (NSMutableArray *)bgViews
{
    if (!_bgViews) {
        _bgViews = [[NSMutableArray alloc] init];
    }
    return _bgViews;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.showNavigationBar = NO;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 7, SCREEN_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [_scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT-NAVIGATION_STATUSBAR_HEIGHT) animated:NO];
    [self.view addSubview:_scrollView];

    
    CGFloat imageMaxY = 0.0;
    for (int i = 0; i < 7; i ++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH * i, _scrollView.heightValue)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.alpha = 0;
        if (i == 1) {
            bgView.alpha = 1;
        }
        [_scrollView addSubview:bgView];
        
        if (i != 0 && i != 6) {
            [self.bgViews addObject:bgView];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * NEW_BILI, [BNTools sizeFitfour:55 five:90 * NEW_BILI six:90 * NEW_BILI sixPlus:90 * NEW_BILI], SCREEN_WIDTH - 40 * NEW_BILI, 8/7.0 * (SCREEN_WIDTH - 40 * NEW_BILI))];
        [bgView addSubview:imageView];
        
        NSString *imageName = [NSString stringWithFormat:@"guide_0%d",i - 1];
        
        if (i == 0 || i == 5) {
            //第五张，布局不一致
            [bgView removeAllSubviews];
            
            imageName = @"guide_04";
            CGFloat w = 178/2.0, h = 257/2.0;
            UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            iconImageView.frame = CGRectMake((SCREEN_WIDTH - w) * 0.5, [BNTools sizeFitfour:58 five:94 * NEW_BILI six:94 * NEW_BILI sixPlus:94 * NEW_BILI], w * NEW_BILI, (h/w) *  w * NEW_BILI);
            [bgView addSubview:iconImageView];
            
            UIImageView *charImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iconImageView.bottomValue + [BNTools sizeFitfour:13 five:32 * NEW_BILI six:32 * NEW_BILI sixPlus:32 * NEW_BILI], 17 * NEW_BILI, 193 * NEW_BILI)];
            charImageView.centerXValue = iconImageView.centerXValue;
            charImageView.image = [UIImage imageNamed:@"verticalChar"];
            [bgView addSubview:charImageView];
            
        }
        
        if (i == 6) {
            // 最后一个放第一张
            imageName = @"guide_00";
        }
        
        imageView.image = [UIImage imageNamed:imageName];
        
        if (i == 1) {
            imageMaxY = imageView.bottomValue;
        }
    }
    
    self.pageControl = [[BNPageControl alloc] initWithYValue:imageMaxY + [BNTools sizeFitfour:11 five:38 * NEW_BILI six:38 * NEW_BILI sixPlus:38 * NEW_BILI]];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    

    CGFloat buttonHeight = [BNTools sizeFitfour:22 five:44*NEW_BILI six:44*NEW_BILI sixPlus:44*NEW_BILI];
    CGFloat buttonWidth = 148*NEW_BILI;
    
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.frame = CGRectMake(20 * NEW_BILI,_pageControl.bottomValue + 30 * NEW_BILI, buttonWidth, buttonHeight);
    signInBtn.tag = 101;
    [signInBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    [signInBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signInBtn setTitleColor:UIColorFromRGB(0x37474f) forState:UIControlStateNormal];
    signInBtn.layer.cornerRadius = 0.5 * buttonHeight;
    signInBtn.layer.masksToBounds = YES;
    signInBtn.layer.borderWidth = 1.0;
    signInBtn.layer.borderColor = UIColorFromRGB(0x37474f).CGColor;
    UIImage *singInButtonHighlightedImage = [Tools imageWithColor:[UIColor colorWithWhite:1.0f alpha:.2f] andSize:signInBtn.frame.size];
    [signInBtn setBackgroundImage:singInButtonHighlightedImage forState:UIControlStateHighlighted];
    [self.view addSubview:signInBtn];
    
    UIButton *logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame = CGRectMake(signInBtn.rightValue + 40 * NEW_BILI, signInBtn.topValue, buttonWidth, buttonHeight);
    logInBtn.tag = 102;
    [logInBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    logInBtn.titleLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    [logInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [logInBtn setTitleColor:UIColorFromRGB(0x37474f) forState:UIControlStateNormal];
    logInBtn.layer.cornerRadius = 0.5 * buttonHeight;
    logInBtn.layer.masksToBounds = YES;
    logInBtn.layer.borderWidth = 1.0;
    logInBtn.layer.borderColor = UIColorFromRGB(0x37474f).CGColor;
    UIImage *logInButtonHighlightedImage = [Tools imageWithColor:[UIColor colorWithWhite:1.0f alpha:0.2f] andSize:logInBtn.frame.size];
    [logInBtn setBackgroundImage:logInButtonHighlightedImage forState:UIControlStateHighlighted];
    [self.view addSubview:logInBtn];
    
    UILabel *or = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    or.center = CGPointMake(self.view.centerXValue, logInBtn.centerYValue);
    or.text = @"OR";
    or.font = [UIFont systemFontOfSize:11];
    or.textAlignment = NSTextAlignmentCenter;
    or.textColor = UIColorFromRGB(0xb6c2c8);
    [self.view addSubview:or];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (page < 1) {
        page = 5;
    }
    if (page>5) {
        page = 1;
    }
    
    //上一个View
    UIView *bgView = self.bgViews[page - 1];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.alpha = 0;
    }];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    
    if (page < 1) {
        [scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * 5,0,SCREEN_WIDTH,SCREEN_HEIGHT) animated:NO];
        page = 5;
    }
    if (page>5) {
        [scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO];
        page = 1;
    }
    
    _pageControl.currentPage = page - 1;
    
    
    //下一个View
    UIView *bgView = self.bgViews[page - 1];
    [UIView animateWithDuration:0.5 animations:^{
        bgView.alpha = 1.0;
    }];
    
}
- (void)buttonAction:(UIButton *)button
{
    BNNotLoginViewBUttonType type = BNNotLoginViewBUttonTypeSignIn;
    
    if (button.tag == 102) {
        //登录
        type = BNNotLoginViewBUttonTypeLogin;
    }
    if (_forGesturePswWrongToPush) {
        //从手势秘密输错5次过来。不走代理，直接走这里。
        if (type == BNNotLoginViewBUttonTypeLogin) {
            //登录
            BNLoginViewController *vc = [[BNLoginViewController alloc]init];
            vc.isFromChangeUser = YES;
            vc.isFromForget = YES;
            [self pushViewController:vc animated:YES];
        } else {
            //注册
            BNVerifyPhoneViewController *verifyVC = [[BNVerifyPhoneViewController alloc] init];
            verifyVC.useStyle = ViewControllerUseStyleRegist;
            [self pushViewController:verifyVC animated:YES];
        }

    } else {
        if ([self.delegate respondsToSelector:@selector(BNNotLoginViewbuttonAction:)]) {
            [BNXiaoDaiInfoRecordTool clearXiaoDaiInfo];
            [self.delegate BNNotLoginViewbuttonAction:type];
        }
    }
    
    
}
@end
