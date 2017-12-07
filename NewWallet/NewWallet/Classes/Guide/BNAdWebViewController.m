//
//  BNAdWebViewController.m
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNAdWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "UMHybrid.h"

@interface BNAdWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

@end

@implementation BNAdWebViewController

#pragma mark - setup loaded view
- (void)setupLoadedView
{

    self.navigationTitle = _navTitle;

    self.view.backgroundColor = UIColor_Gray_BG;
    

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    self.webView = webView;
    
    [self.view addSubview:webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;
    
    NSURL *url =[NSURL URLWithString:self.urlString];
    BNLog(@"%@",self.urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //WebView清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    // Do any additional setup after loading the view.
    [self setupLoadedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)backButtonClicked:(UIButton *)sender
{
    NSString *requestStr = self.webView.request.URL.absoluteString;
    if ([_webView canGoBack] && ![requestStr isEqualToString:self.urlString]) {
        [_webView goBack];
    }else{
        if (_returnBlock) {
            _returnBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if (!self.navTitle) {
        self.navigationTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

@end
