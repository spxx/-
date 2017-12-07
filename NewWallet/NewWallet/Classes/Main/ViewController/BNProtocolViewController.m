//
//  BNProtocolViewController.m
//  NewWallet
//
//  Created by mac1 on 14-11-4.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNProtocolViewController.h"
#import "UMHybrid.h"

@interface BNProtocolViewController()<UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *protocolWebView;

@end


@implementation BNProtocolViewController

@synthesize protocolFileName = _protocolFileName;
#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.navigationTitle = @"快捷支付协议";
    if (_titleName) {
        self.navigationTitle = _titleName;
    }
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.protocolWebView = webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    
    [self addWeb];
}


-(void)addWeb
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.protocolFileName ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.protocolWebView loadRequest:request];
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
