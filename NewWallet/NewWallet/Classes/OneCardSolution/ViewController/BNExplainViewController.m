//
//  BNExplainViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNExplainViewController.h"
#import "UMHybrid.h"


@interface BNExplainViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) UIView *filterView;
@property (weak, nonatomic) UIView *filterCursor;
@property (weak, nonatomic) UIWebView *explainWebView;
@end
@implementation BNExplainViewController
static NSInteger tabBarCount;

- (void)setupLoadedView
{
    self.navigationTitle = @"说明";
    
    self.view.backgroundColor = UIColor_Gray_BG;

    UIView *filter = [[UIView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, 45*BILI_WIDTH)];
    _filterView = filter;
    filter.backgroundColor = [UIColor whiteColor];
    
    NSArray *filterTitles;
    if ([shareAppDelegateInstance.boenUserInfo.schoolId isEqualToString:@"13"]) {
        //schoolId==13是重庆大学 不显示同步地图。
        filterTitles = @[@"使用说明", @"充值限额"];
    } else {
        filterTitles = @[@"使用说明", @"充值限额", @"同步地图"];
    }
    tabBarCount = filterTitles.count;
    
    NSString *str = @"使用说明";

    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]]];
    UIView *cursorView = [[UIView alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH / filterTitles.count) - size.width)/2.0, 41 * BILI_WIDTH, size.width, 4*BILI_WIDTH)];

    cursorView.backgroundColor = UIColorFromRGB(0x039dff);
    _filterCursor= cursorView;
    [filter addSubview:cursorView];
   
    for (int i = 0; i < filterTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 10;
        button.frame = CGRectMake((SCREEN_WIDTH / filterTitles.count) *i , 0, SCREEN_WIDTH / filterTitles.count, 41 * BILI_WIDTH);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x039dff) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
        [button setTitle:[filterTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [filter addSubview:button];
    }
    UIButton *btn1 = (UIButton *)[_filterView viewWithTag:10];
    btn1.selected = YES;

    UIView *vLine1 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / filterTitles.count, 4*BILI_WIDTH, 0.5, 45 *BILI_WIDTH - 8*BILI_WIDTH)];
    vLine1.backgroundColor = UIColorFromRGB(0xcacaca);
    
    UIView *vLine2 = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / filterTitles.count) * 2.0, 4, .5, 45 *BILI_WIDTH - 6)];
    vLine2.backgroundColor = UIColorFromRGB(0xcacaca);
    
    [filter insertSubview:vLine1 aboveSubview:cursorView];
    [filter insertSubview:vLine2 aboveSubview:cursorView];
    [self.view addSubview:filter];
    
    
    UIWebView *webView= [[UIWebView alloc] initWithFrame:CGRectMake(0, filter.frame.origin.y + filter.frame.size.height + kSectionHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge - kSectionHeight - filter.frame.size.height)];
    _explainWebView = webView;
    webView.delegate = self;
    [self.view addSubview:webView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *btn1 = (UIButton *)[_filterView viewWithTag:10];
    UIButton *btn2 = (UIButton *)[_filterView viewWithTag:11];
    UIButton *btn3 = (UIButton *)[_filterView viewWithTag:12];
    
    switch (_useStyle) {
        case ExplainStyleUse:
        {
            [self moveCursorWithFrame:btn1.frame];
            btn1.selected = YES;
            btn2.selected = NO;
            btn3.selected = NO;
            NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/shiyongshuoming.html", shareAppDelegateInstance.boenUserInfo.schoolId];
            NSString *string = [BASE_URL stringByAppendingString:appendUrl];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [_explainWebView loadRequest:request];
        }
            break;
            
        case ExplainStyleLimite:
        {
            [self moveCursorWithFrame:btn2.frame];
            btn1.selected = NO;
            btn2.selected = YES;
            btn3.selected = NO;
            NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/chongzhixiane.html", shareAppDelegateInstance.boenUserInfo.schoolId];
            NSString *string = [BASE_URL stringByAppendingString:appendUrl];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [_explainWebView loadRequest:request];
        }
            break;
            
        case ExplainStyleMap:
        {
            [self moveCursorWithFrame:btn3.frame];
            btn1.selected = NO;
            btn2.selected = NO;
            btn3.selected = YES;
            NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/tongbuditu.html", shareAppDelegateInstance.boenUserInfo.schoolId];
            NSString *string = [BASE_URL stringByAppendingString:appendUrl];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [_explainWebView loadRequest:request];
        }
            break;
        default:
            break;
    }

}

- (void)buttonAction:(UIButton *)btn
{
    [self moveCursorWithFrame:btn.frame];
    
    UIButton *btn1 = (UIButton *)[_filterView viewWithTag:10];
    UIButton *btn2 = (UIButton *)[_filterView viewWithTag:11];
    UIButton *btn3 = (UIButton *)[_filterView viewWithTag:12];
    
    switch (btn.tag) {
        case 10:
        {
            [_explainWebView stopLoading];
            btn1.selected = YES;
            btn2.selected = NO;
            btn3.selected = NO;
            NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/shiyongshuoming.html", shareAppDelegateInstance.boenUserInfo.schoolId];
            NSString *string = [BASE_URL stringByAppendingString:appendUrl];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [_explainWebView loadRequest:request];
        }
            break;
        
        case 11:
        {
            [_explainWebView stopLoading];
            btn1.selected = NO;
            btn2.selected = YES;
            btn3.selected = NO;
            NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/chongzhixiane.html", shareAppDelegateInstance.boenUserInfo.schoolId];
            NSString *string = [BASE_URL stringByAppendingString:appendUrl];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [_explainWebView loadRequest:request];
        }
            break;
            
        case 12:
        {
            [_explainWebView stopLoading];
            btn1.selected = NO;
            btn2.selected = NO;
            btn3.selected = YES;
            NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/tongbuditu.html", shareAppDelegateInstance.boenUserInfo.schoolId];
            NSString *string = [BASE_URL stringByAppendingString:appendUrl];
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [_explainWebView loadRequest:request];

        }
            break;
        default:
            break;
    }
}

- (void)moveCursorWithFrame:(CGRect) frame
{
    __weak typeof(self) weakSelf = self;
    CGRect cursorFrame = _filterCursor.frame;
    CGFloat pianyi = ((SCREEN_WIDTH / tabBarCount) - cursorFrame.size.width)/2.0;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.filterCursor.frame = CGRectMake(frame.origin.x + pianyi, cursorFrame.origin.y, cursorFrame.size.width, cursorFrame.size.height);
    }];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@:%@",request.URL.scheme,request.URL.resourceSpecifier];
    NSString *parameters = [requestUrlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([UMHybrid execute:parameters webView:webView]) {
        return NO;
    }
    return YES;

}
@end
