//
//  BNPublicHtml5BusinessVC.m
//  Wallet
//
//  Created by mac on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNPublicHtml5BusinessVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "EasyJSWebView.h"
#import "MyJSInterface.h"
#import "LoginApi.h"
#import "UMHybrid.h"
#import "ScanViewController.h"
#import "BNVeinInfoViewController.h"

@interface BNPublicHtml5BusinessVC ()<UIWebViewDelegate, NJKWebViewProgressDelegate, MyJSInterfaceDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) EasyJSWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@property (strong, nonatomic) NSString *titleStr;
@property (nonatomic) BOOL firstLoadTitle;
@property (strong, nonatomic) UIWebView *gifWebView;

@property (nonatomic) BOOL useToBNScanedByShopVC_isResult;//如果是结果页面，点击返回按钮怎退回主页，否则是取消订单，返回二维码页面

@end

@implementation BNPublicHtml5BusinessVC

static NSString *currentUrlStr;

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

    if (_useToBNScanedByShopVC == NO ) {
        //close button
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(44, 0, 44, 44);
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
        [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
        //    [closeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -14)];
        [self.customNavigationBar addSubview:closeButton];

    }
    
    self.navigationLabel.frame = CGRectMake(2*35, 0, self.view.frame.size.width - 4*35, 44);
    
    EasyJSWebView *webView = [[EasyJSWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    if (_hideNavigationbar == YES) {
        self.showNavigationBar = NO;
        webView.backgroundColor = [UIColor whiteColor];
        webView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    }
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
    
    if (_hideNavigationbar == NO) {
        CGFloat progressBarHeight = 2.f;
        CGRect barFrame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
        self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progress = 0;

    }
    
    if (_businessType == Html5BusinessType_NativeBusiness) {
         //自主业务，不获取code，直接加载webview
        [self loadWebView:nil];
    } else{
        //第三方的业务，先获取code
        [self getCodeFromPythonServer];//目前只有学校费用缴纳，电费，费用领取3个H5页面才获取code了，并且以后可能都不用获取code了。2016-08-17徐家勇
    }
    
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
    currentUrlStr = requestUrlStr;
    NSString *parameters = [requestUrlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([UMHybrid execute:parameters webView:webView]) {
        return NO;
    }
    if ([requestUrlStr hasPrefix:KBNScanedByShopVC_QR_payResult]) {
        //如果是结果页面，点击返回按钮怎退回主页，否则是取消订单，返回二维码页面
        _useToBNScanedByShopVC_isResult = YES;
        BNLog(@"这是QR支付结果URL");
    } else if ([requestUrlStr hasPrefix:KUserCenter_VeinInfo_H5BindBack])//静脉信息绑定后跳转URL
    {
        if ([requestUrlStr hasSuffix:@"?success=1"]) {
            //静脉信息-绑定成功
            if (self.bindStumpData.fromCanteen == YES) {
                //食堂的静脉绑定成功，引导用户去使用。
                shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请前往“首页”-“静脉信息”，查询静脉信息详情。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                shareAppDelegateInstance.alertView.tag = 101;
                [shareAppDelegateInstance.alertView show];
            } else {
                if (_backBlock) {
                    self.backBlock(@{});
                }
            }

        } else {
            //静脉信息-绑定失败
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return NO;
        
    } else if ([requestUrlStr hasPrefix:UnionXifuReturnBackUrl])//银联返回按钮-返回
    {
        [self.navigationController popViewControllerAnimated:YES];

    } else if ([requestUrlStr hasPrefix:PaycenterGotoPayURL])//调起收银台
    {
        NSArray *shareUrlArr = [requestUrlStr componentsSeparatedByString:@"/"];
        NSString *jsonParamas = shareUrlArr.lastObject;
//        jsonParamas = @"{\"order_no\" : \"3213213\" , \"biz_no\" : \"32131\"}";
        //从NSString转化为NSDictionary
        jsonParamas = [jsonParamas stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *resultData = [jsonParamas dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            NSString *order_no = [NSString stringWithFormat:@"%@", [dict valueForKey:@"order_no"]];
            NSString *biz_no = [NSString stringWithFormat:@"%@", [dict valueForKey:@"biz_no"]];
            if (order_no && biz_no && order_no.length > 0 && biz_no.length > 0) {
                
                BNPayModel *payModel = [[BNPayModel alloc]init];
                payModel.order_no = order_no;
                payModel.biz_no = biz_no;
                [self goToPayCenterWithPayProjectType:PayProjectTypeOther
                                             payModel:payModel
                                          returnBlockone:^(PayVCJumpType jumpType, id params) {
                                              if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {

                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                              }
                                          }];

            } else {
                [SVProgressHUD showErrorWithStatus:@"参数错误!"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"参数错误!"];
        }

        return NO;
    } else if ([requestUrlStr hasPrefix:PaycenterBindStumpSuccessURL]) {
        //绑定一卡通成功
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [LoginApi getProfile:shareAppDelegateInstance.boenUserInfo.userid
                     success:^(NSDictionary *successData) {
                         BNLog(@"getProfile--%@", successData);
                         [SVProgressHUD dismiss];
                         NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
                         
                         if ([retCode isEqualToString:kRequestSuccessCode]) {
                             NSDictionary *retData = [successData valueNotNullForKey:kRequestReturnData];
                             [BNTools setProfileUserInfo:retData];
                             
                             shareAppDelegateInstance.haveGetPrefile = YES;

                             if (_bindStumpData.biz_id && _bindStumpData.biz_id.length > 0) {

                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                 self.tabBarController.selectedIndex = 0;  //退出到首页，再进入相应的业务。
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_BindStumpH5Success_GotoBiz object:_bindStumpData];
                             } else {
                                 if (_backBlock) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     self.backBlock(@{});
                                 }
                             }
                         
                         }else{
                             [SVProgressHUD showErrorWithStatus:@"更新信息失败，请稍候再试。"];
                         }
                         
                     } failure:^(NSError *error) {
                         [SVProgressHUD showErrorWithStatus:@"更新信息失败，请稍候再试。"];
                     }];
        
    } else if ([requestUrlStr hasPrefix:ScanURL]) {
		//扫码
		ScanViewController *scanVC = [[ScanViewController alloc] init];
		[self pushViewController:scanVC animated:YES];
    } else if ([requestUrlStr hasPrefix:QR_PaymentAuthorize_succeedURL]) {
        //付款码-支付功能授权-返回成功，（失败的话H5会提示）
        self.backBlock(@{});
        [self.navigationController popViewControllerAnimated:YES];

    }

    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _gifWebView.hidden = YES;
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //特殊处理：如果体育场馆URL的后面拼接有"?showSchoolName",说明是体育场馆的首页，导航栏title显示学校名字。2017-04-11
    NSArray *valuesAry = [currentUrlStr componentsSeparatedByString:@"?"];
    if (valuesAry.count > 1) {
        NSString *showSchoolName = [NSString stringWithFormat:@"%@", valuesAry[1]];
        if ([showSchoolName hasPrefix:@"showSchoolName"]) {
            self.navigationTitle = shareAppDelegateInstance.boenUserInfo.schoolName;
        } else{
            self.navigationTitle = title;
        }
    } else{
        self.navigationTitle = title;
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    BNLog(@"error--->>>>>%@",[error description]);
}

- (void)backButtonClicked:(UIButton *)sender
{
    //重写返回按钮方法
    if (_useToBNScanedByShopVC == YES && _useToBNScanedByShopVC_isResult == YES) {
        PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
        _backBtnBlock(jumpType);
        
    } else if (_useToBNScanedByShopVC == YES && _useToBNScanedByShopVC_isResult == NO) {
        [self.navigationController popViewControllerAnimated:YES];
        
        PayVCJumpType jumpType = PayVCJumpType_PayCompletedGoToLastVC;
        _backBtnBlock(jumpType);
        
    } else {
        if (_webView.canGoBack) {
            [_webView goBack];
        } else {
            if (_backBtnBlock) {
                PayVCJumpType jumpType = PayVCJumpType_PayCompletedBackHomeVC;
                _backBtnBlock(jumpType);
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
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

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [self popToRootViewControllerAnimated:YES compliton:nil];
    }
}
@end
