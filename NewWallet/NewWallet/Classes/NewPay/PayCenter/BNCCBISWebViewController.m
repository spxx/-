//
//  BNCCBISWebViewController.m
//  Wallet
//
//  Created by liuchun on 2017/8/12.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNCCBISWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <WebKit/WebKit.h>


@interface BNCCBISWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,WKNavigationDelegate>
{
    NSURL *_url;
}

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIWebView *gifWebView;

@property(nonatomic, strong) WKWebView *wkWebView;
@property(strong, nonatomic) NJKWebViewProgressView *progressView;
@property(strong, nonatomic) NJKWebViewProgress *progressProxy;
@property(nonatomic, assign) BOOL confirmPay; /** 点击确认按钮*/
@property(nonatomic, assign) BOOL useToBNScanedByShopVC_isResult;/** 用于判断是否支付*/



@end

@implementation BNCCBISWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(44, 0, 44, 44);
    closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
    [self.customNavigationBar addSubview:closeButton];

    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.delegate = self;
    _webView.contentMode = UIViewContentModeScaleToFill;
    _webView.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_webView];
    
    
//    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
//    config.suppressesIncrementalRendering = YES;
//    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
//    _wkWebView.navigationDelegate = self;
//    _wkWebView.multipleTouchEnabled = YES;
//    _wkWebView.exclusiveTouch = YES;
//    _wkWebView.contentMode = UIViewContentModeScaleToFill;
//    _wkWebView.scrollView.userInteractionEnabled = YES;
//    
//    [self.view addSubview:_wkWebView];

    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;
    [self.view addSubview:_progressView];
    
    
    //添加加载动画gif
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Webview_loading" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    self.gifWebView = [[UIWebView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-122*BILI_WIDTH)/2,(SCREEN_HEIGHT-122*BILI_WIDTH)/2, 122*BILI_WIDTH, 122*BILI_WIDTH)];
    [_gifWebView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    _gifWebView.scalesPageToFit = YES;
    _gifWebView.userInteractionEnabled = NO;
    _gifWebView.layer.cornerRadius = CGRectGetHeight(_gifWebView.frame)/2;
    _gifWebView.layer.masksToBounds = YES;
    [self.view addSubview:_gifWebView];
}





-(void)setHtmlUrl:(NSString *)htmlUrl{
    _htmlUrl = htmlUrl;
    _url = [[NSURL alloc]initWithString:_htmlUrl];
    if(!_url){
        NSString *encode = [_htmlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _url = [NSURL URLWithString:[encode stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
   
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    BNLog(@"---%@---%@",error.description,_url);
    if (error.code == NSURLErrorCancelled) {
        return;
    }
}





-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _gifWebView.hidden = YES;
//    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    BNLog(@"%@",title);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@", request.URL.absoluteString];
    BNLog(@"requestUrlStr---%@",requestUrlStr);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mbspay://"]]) {
        if ([requestUrlStr containsString:@"ibsbjstar.ccb.com.cn/CCBIS/B2CMainPlat"]) {
            _useToBNScanedByShopVC_isResult = YES;
        }
    }else{
        if ([requestUrlStr containsString:@"ibsbjstar.ccb.com.cn/CCBIS/V6/STY2/CN/accountPay_protocol_m2.jsp?colorCSS=B&isAcctProtected=0"]) {
            _confirmPay = YES;
        }
        if (_confirmPay) {
            if ([requestUrlStr containsString:@"ibsbjstar.ccb.com.cn/CCBIS/B2CMainPlat"]) {
                _useToBNScanedByShopVC_isResult = YES;
            }
        }
    }
    
    if ([requestUrlStr containsString:@"api.bionictech.cn/ccbl_pay"]) {
        PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
        _backBtnBlock(jumpType);
    }
    
    return YES;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    BNLog(@"%@",title);
}

- (void)backButtonClicked:(UIButton *)sender
{
    //重写返回按钮方法
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mbspay://"]]) {
        if (_useToBNScanedByShopVC_isResult) {
            PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
            _backBtnBlock(jumpType);
        } else {
            PayVCJumpType jumpType = PayVCJumpType_PayCancle;
            _backBtnBlock(jumpType);
            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (_webView.canGoBack) {
            [_webView goBack];
        } else {
            if (_useToBNScanedByShopVC_isResult) {
                PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
                _backBtnBlock(jumpType);
            } else {
                PayVCJumpType jumpType = PayVCJumpType_PayCancle;
                _backBtnBlock(jumpType);
                [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
}

- (void)closeButtonClicked:(UIButton *)sender
{
    if (_useToBNScanedByShopVC_isResult) {
        PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
        _backBtnBlock(jumpType);
    } else {
        PayVCJumpType jumpType = PayVCJumpType_PayCancle;
        _backBtnBlock(jumpType);
        [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end

