//
//  BNFeesWebViewExplainVC.m
//  Wallet
//
//  Created by mac1 on 15/3/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//


#import "BNFeesWebViewExplainVC.h"
#import "UMHybrid.h"

@interface BNFeesWebViewExplainVC ()<UIWebViewDelegate>

@property (copy, nonatomic) NSString *urlStr;

@end

@implementation BNFeesWebViewExplainVC


- (void)setupLoadView{
    self.view.backgroundColor = UIColor_Gray_BG;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
     webView.delegate =self;
    [self.view addSubview:webView];
    
    switch (self.useType) {
        case ExpainUseTypeSchoolFees: {//教育缴费
            self.navigationTitle = @"教育缴费使用说明";
            self.urlStr = [NSString stringWithFormat:@"https://api.bionictech.cn/static/xifu_files/schools/school_%@/xuexiaofeiyongjiaonashiyongshuoming.html",shareAppDelegateInstance.boenUserInfo.schoolId];
            break;
        }
        case ExpainUseTypeDianFei: {//电费
            self.navigationTitle = @"房间号规则";
            webView.userInteractionEnabled = NO;//防止点击房间号示例，弹出拨打电话。
            self.urlStr = [NSString stringWithFormat:@"http://api.bionictech.cn/static/xifu_files/schools/school_%@/fangjianhaoshuoming.html",shareAppDelegateInstance.boenUserInfo.schoolId];
            break;
        }
        case ExpainUseTypeCollectFess: {//费用领取
            self.navigationTitle = @"费用领取说明";
            self.urlStr = [NSString stringWithFormat:@"http://api.bionictech.cn/static/xifu_files/schools/school_%@/feiyonglingqushuoming.html",shareAppDelegateInstance.boenUserInfo.schoolId];
            break;
        }
        case ExpainUseTypeXiFuTrainee: {//费用领取
            self.navigationTitle = @"规则说明";
            self.urlStr = @"http://api.bionictech.cn/static/xifu_files/activity/oldwelcomenew/i.html";
            break;
        }
        default: {
            break;
        }
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //WebView清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
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
    if ([requestUrlStr isEqualToString:self.urlStr])//避免费用领取点击数字打电话时候重复加载菊花
    {
        [SVProgressHUD showWithStatus:@"请稍候..."];
    }
   return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
}

@end
