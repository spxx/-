//
//  BNPayResultShareH5VC.m
//  Wallet
//
//  Created by mac on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNPayResultShareH5VC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "EasyJSWebView.h"
#import "MyJSInterface.h"
#import "LoginApi.h"
#import "UMHybrid.h"
#import "ScanViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "Base64.h"
#import "RegexModel.h"

@interface BNPayResultShareH5VC ()<UIWebViewDelegate, NJKWebViewProgressDelegate, MyJSInterfaceDelegate>

@property (weak, nonatomic) EasyJSWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NSString *titleStr;
@property (nonatomic) BOOL firstLoadTitle;
@property (strong, nonatomic) UIWebView *gifWebView;


@end

@implementation BNPayResultShareH5VC


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_titleStr && _titleStr.length > 0) {
        [MobClick endLogPageView:_titleStr];
        [MobClick endEvent:@"H5_BizViewControllr" label:_titleStr];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"";
    _firstLoadTitle = YES;
    
    //WebView清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    //修改UserAgent，添加xifuapp字段
    UIWebView *webView0 = [[UIWebView alloc] initWithFrame:CGRectZero];  //必须先new一个UIWebView，下次创建_webView时，UserAgent才生效。
    NSString *oldAgent = [webView0 stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUagent = [NSString stringWithFormat:@"%@; xifuapp/%@",oldAgent, APP_VERSION];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

//    //close button
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeButton.frame = CGRectMake(44, 0, 44, 44);
//    closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [closeButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
//    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
//    //    [closeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -14)];
//    [self.customNavigationBar addSubview:closeButton];
    
    self.navigationLabel.frame = CGRectMake(2*35, 0, self.view.frame.size.width - 4*35, 44);
    
    EasyJSWebView *webView = [[EasyJSWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    webView.delegate = self;
    [self.view addSubview:webView];
    _webView = webView;
    
    MyJSInterface* interface = [MyJSInterface new];
    interface.delegate = self;
    interface.params = _params;
    [_webView addJavascriptInterfaces:interface WithName:@"client"];

    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progress = 0;
    
    [self loadWebView:nil];
    
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
//从python端请求code 将code存入UserDefaults,再去java端请求费用列表
- (void)getCodeFromPythonServer
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [[HttpTools shareInstance] JsonPostRequst:@"/openapi/version_1.0/auth/auth_code" parameters:@{@"code":@"code"} success:^(id responseObject) {
        NSDictionary *successData = responseObject;
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            NSDictionary *data = [successData valueNotNullForKey:@"data"];
            NSString *code = data[@"code"];
            BNLog(@"html5-get-code--->>>%@",code);
            if (code || code.length > 0) {
                [SVProgressHUD dismiss];
                
                [self loadWebView:code];
               
            } else {
                [SVProgressHUD showErrorWithStatus:@"获取code参数失败！"];
                return ;
            }
           
        }else{
            [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}
- (void)loadWebView:(NSString *)code
{
    if (code || code.length > 0) {
        code = [NSString stringWithFormat:@"?code=%@", code];
    } else {
        code = @"";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _url, code]]];
    [_webView loadRequest:request];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSString *requestUrlStr = [NSString stringWithFormat:@"%@", request.URL.absoluteString];
    BNLog(@"requestUrlStr---%@",requestUrlStr);
    NSString *parameters = [requestUrlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([UMHybrid execute:parameters webView:webView]) {
        return NO;
    }
    if ([requestUrlStr hasPrefix:@"xifu://coupon_share"])//表示点击了分享按钮，集成分享
    {
        NSArray *shareUrlArr = [requestUrlStr componentsSeparatedByString:@"share_url="];
        NSString *url = shareUrlArr.lastObject;
        
        [self addSharePlatformsWithUrlString:url];
        return NO;
    }

    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _gifWebView.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    BNLog(@"error--->>>>>%@",[error description]);
}

- (void)backButtonClicked:(UIButton *)sender
{
    //重写返回按钮方法
//    if (_webView.canGoBack) {//支付结果好像不需要返回上一级H5，直接返回外面
//        [_webView goBack];
//    } else {
        if (_backBtnBlock) {
            PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
            _backBtnBlock(jumpType);
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
//    }
    
}
- (void)closeButtonClicked:(UIButton *)sender
{
    if (_backBtnBlock) {
        PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
        _backBtnBlock(jumpType);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationTitle = title;
    if (_firstLoadTitle == YES && title && title.length > 0) {
        [MobClick beginLogPageView:title];
        _titleStr = [NSString stringWithFormat:@"H5_BizViewControllr--%@", title];
        _firstLoadTitle = NO;
        
        [MobClick beginEvent:@"H5_BizViewControllr" label:_titleStr];
    }
}

#pragma mark - MyJSInterfaceDelegate
-(void)MyJSInterfaceGetParams:(NSDictionary *)dict
{
    BNLog(@"MyJSInterfaceGetParams----%@", dict);
    self.backBlock(dict);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加分享平台
- (void)addSharePlatformsWithUrlString:(NSString *)url
{
    RegexModel *model = [self stringISmatchPatter:url andPattern:@"[\u4e00-\u9fa5]."];
    BNLog(@"%@",model);
    if (model.isMatch) {//url包含汉字,使用base64编码汉字，再替换掉
        NSString *chineseString = [url substringWithRange:model.resultRange];
        NSString *base64Str = [chineseString base64EncodedString];
        url =  [url stringByReplacingOccurrencesOfString:chineseString withString:base64Str];
    }
    
    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"icon_erweima" ofType:@"png"]];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"您的同学分享了一张优惠券给你，请注意查收！"]
                                       defaultContent:@"您的同学分享了一张优惠券给你，请注意查收！"
                                                image:localAttachment
                                                title:@"喜付"
                                                  url:url
                                          description:@"喜付--专属大学生的手机钱包"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制化分享
    [self customizePlatformShareContent:publishContent shareUrl:url];
    
    //分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo), nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"分享失败:%@",error.errorDescription]];
                                    BNLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
    
    
}

#pragma marl - 定制各平台分享内容
- (void)customizePlatformShareContent:(id<ISSContent>)publishContent shareUrl:(NSString *)url
{
    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"icon_erweima" ofType:@"png"]];
    
    NSString *contentStr = @"您的同学分享了一张优惠券给你，请注意查收！";
    NSString *titleStr = @"喜付";

    //定制QQ好友分享内容
    [publishContent addQQUnitWithType:@2
                              content:contentStr
                                title:titleStr
                                  url:url
                                image:localAttachment];
    //定制QQ空间分享内容
    [publishContent addQQSpaceUnitWithtitle:titleStr
                                        url:url
                                description:contentStr
                                      image:localAttachment
                                       type:@4];
    //微信好友
    [publishContent addWeixinSessionUnitWithType:@2
                                         content:contentStr
                                           title:titleStr
                                             url:url
                                           image:localAttachment
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //微信朋友圈
    [publishContent addWeixinTimelineUnitWithType:@2
                                          content:contentStr
                                            title:titleStr
                                              url:url
                                            image:localAttachment
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];

    //定制新浪微博分享内容
    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@%@",contentStr,url]
                                          image:localAttachment];
    
}
/**
 *  判断string是否符合pattern规则
 *
 *  @param string  需要判断的string
 *  @param pattern 规则
 *
 *  @return  模型对象
 */
- (RegexModel *)stringISmatchPatter:(NSString *)string andPattern:(NSString *)pattern
{
    RegexModel *model = [[RegexModel alloc] init];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    model.isMatch = results.count > 0;
    for (NSTextCheckingResult *result in results) {
        model.resultRange = result.range;
        BNLog(@"url中的汉字是：%@，range是：%@",[string substringWithRange:result.range],NSStringFromRange(result.range));
    }
    return model;
}
//处理进入后台还弹出分享界面的问题
- (void)viewWillDisappear:(BOOL)animated
{
    BNLog(@"window--->>>%@",[UIApplication sharedApplication].windows);
    [super viewWillDisappear:YES];
    [_progressView removeFromSuperview];

    UIWindow *shareActionSheet = nil;
    for (id window in [UIApplication sharedApplication].windows) {
        if ( [window isKindOfClass:NSClassFromString(@"SSFlatShareActionSheet")]) {
            shareActionSheet = window;
            shareActionSheet.hidden = YES;
            [shareActionSheet removeFromSuperview];
            shareActionSheet = nil;
            BNLog(@"remove");
        }
    }
}

@end
