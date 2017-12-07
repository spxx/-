//
//  BNSyncMapViewController.m
//  Wallet
//
//  Created by mac1 on 15/4/1.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNSyncMapViewController.h"
#import "UMHybrid.h"

@interface BNSyncMapViewController ()<UIWebViewDelegate>

@end
@implementation BNSyncMapViewController

- (void)setupLoadView{
    self.navigationTitle = @"同步地图";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIWebView *webView= [[UIWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString *appendUrl = [NSString stringWithFormat:@"/static/xifu_files/schools/school_%@/tongbuditu.html", shareAppDelegateInstance.boenUserInfo.schoolId];
    NSString *string = [BASE_URL stringByAppendingString:appendUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    [webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLoadView];
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
