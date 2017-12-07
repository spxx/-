//
//  BNGuideVC.m
//  Wallet
//
//  Created by 神说有光 on 14-8-26.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "BNGuideVC.h"
#import "BNMainViewController.h"



#define kImageCount 3

@interface BNGuideVC ()<UIScrollViewDelegate>
{
    UIScrollView *_scroll;
    UIPageControl *_pageControl;
}
@end

@implementation BNGuideVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addScroll];
    [self addImage];
    [self addPageContol];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"yes" forKey:kHasShowedActivityView];
    [userDefault synchronize];
}

-(void)addScroll
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scroll.bounces = NO;
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH * kImageCount, 0);
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

-(void)addImage
{
    for (int i = 1; i<=kImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"guide0%d", i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage returnFitImageWithName:imageName]];
        imageView.frame = CGRectMake((i-1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
        [_scroll addSubview:imageView];
        if (i == kImageCount) {
            imageView.userInteractionEnabled = YES;
            [self addSureBtn:imageView];
        }
    }
}

-(void)addPageContol
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.currentPageIndicatorTintColor = UIColorFromRGB(0xd2f6ff);
    page.pageIndicatorTintColor = UIColorFromRGB(0x00c6fe);
    page.frame = CGRectMake((SCREEN_WIDTH - 200)/2, SCREEN_HEIGHT * 0.85, 200, 44);
    page.numberOfPages = kImageCount;
    [self.view addSubview: page];
    _pageControl = page;
}

-(void)addSureBtn:(UIImageView *)imageView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(85, SCREEN_HEIGHT * 0.85, SCREEN_WIDTH - 85 * 2, 44);
    btn.backgroundColor = UIColorFromRGB(0x00c6fe);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
}

-(void)sureBtnClick:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:kBundleKey] forKey:kBundleKey];
    [[NSUserDefaults standardUserDefaults] synchronize]; //修改版本到沙河
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[BNMainViewController alloc] init];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_pageControl setCurrentPage: scrollView.contentOffset.x / scrollView.frame.size.width];
    
    _pageControl.hidden = _pageControl.currentPage == kImageCount -1;
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:YES];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    [MobClick beginLogPageView:className];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:(BOOL)animated];
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarHidden:NO];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    [MobClick endLogPageView:className];
}
@end
