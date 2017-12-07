//
//  BNLaoDaiXinViewController.m
//  Wallet
//
//  Created by mac1 on 15/12/22.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "BNLaoDaiXinViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "LBXScanWrapper.h"
#import "Base64.h"
#import "RegexModel.h"
#import "UMHybrid.h"

@interface BNLaoDaiXinViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation BNLaoDaiXinViewController
//static NSString *const noAuthority = @"你当前尚未满足邀请好友资格，请仔细阅读邀请注意事项。";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"邀请好友";
    
    NSString *str = [self.task_url stringByRemovingPercentEncoding]; //解码
    RegexModel *model = [self stringISmatchPatter:str andPattern:@"^.*[\u4e00-\u9fa5].*$"];
    if(model.isMatch){//如果包含汉字
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//UTF8编码汉字，url中有可能含有汉字“用户未绑卡”"用户未绑学号等信息"等信息,如果去掉webview无法加载
        BNLog(@"url包含汉字%@",str);
    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    _webView = webView;
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@:%@",request.URL.scheme,request.URL.resourceSpecifier];
    NSString *parameters = [requestUrlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([UMHybrid execute:parameters webView:webView]) {
        return NO;
    }
    if ([requestUrlStr hasPrefix:@"http://trigger_share_xifuapp.com/"])//表示点击了分享按钮，集成分享
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
 
/*
    NSString *code = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('my-code yahei')[0].innerHTML;"];
    if ([code isEqualToString:@"网络错误"]) {
        code = @"document.getElementsByClassName('my-code yahei')[0].innerHTML = '没有网才怪'";
        [webView stringByEvaluatingJavaScriptFromString:code];
    }*/
     NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
    BNLog(@"%@",html);
 
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    BNLog(@"邀请好友error--->>>>>%@",[error description]);
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
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"我在使用喜付手机钱包"]
                                       defaultContent:@"默认分享内容"
                                                image:localAttachment
                                                title:@"用喜付钱包真是太好了"
                                                  url:url
                                          description:@"喜付专属大学生的手机钱包"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制化分享
    [self customizePlatformShareContent:publishContent shareUrl:url];
    
    //自定义二维码分享
    id<ISSShareActionSheetItem> customItem = [ShareSDK shareActionSheetItemWithTitle:@"二维码"
                                                                                icon:[UIImage imageNamed:@"erweima.png"]
                                                                        clickHandler:^{
                                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                [self setupQRViewUrl:url];
                                                                            });
                                                                        }];
    
    //分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),customItem, nil];
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
    
    
    //定制QQ好友分享内容
    [publishContent addQQUnitWithType:@2
                              content:@"亲，邀请你使用喜付手机钱包"
                                title:@"喜付"
                                  url:url
                                image:localAttachment];
    //定制QQ空间分享内容
    [publishContent addQQSpaceUnitWithtitle:@"喜付"
                                        url:url
                                description:@"用喜付钱包真是太好了"
                                      image:localAttachment
                                       type:@4];
    
    NSString *contentStr = [NSString stringWithFormat:@"我在使用喜付手机钱包。%@",url];
    //定制新浪微博分享内容
    [publishContent addSinaWeiboUnitWithContent:contentStr
                                          image:localAttachment];

}
// 生成二维码
- (void)setupQRViewUrl:(NSString *)urlStr
{
    UIView *coverView = [[UIView alloc] initWithFrame:_webView.frame];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];//设置背景色的透明度，避免子势图的透明度跟着父视图透明度改变
    coverView.tag = 666;
    [self.view addSubview:coverView];
    
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 282 * NEW_BILI) * 0.5, 130 * NEW_BILI , 290 * NEW_BILI, 282 * NEW_BILI)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    whiteBGView.layer.cornerRadius = 8 * BILI_WIDTH;
    whiteBGView.layer.masksToBounds = YES;
    [coverView addSubview:whiteBGView];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(whiteBGView.frame) - 250*NEW_BILI) * 0.5, 27 * NEW_BILI, 250 * NEW_BILI, 17 * NEW_BILI)];
    shareLabel.text = @"让好友扫一扫 马上领红包！";
    shareLabel.textColor = [UIColor colorWithRed:61/255.0 green:83/255.0 blue:91/255.0 alpha:1];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont systemFontOfSize:15 * NEW_BILI];
    [whiteBGView addSubview:shareLabel];
    
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(whiteBGView.frame) - 150 * NEW_BILI) * 0.5,CGRectGetMaxY(shareLabel.frame) + 18 * NEW_BILI, 150 * NEW_BILI, 150 * NEW_BILI)];
    UIImage *qrImg = [LBXScanWrapper createQRWithString:urlStr size:qrImageView.bounds.size];
    qrImageView.image = qrImg; //如果需要在二维码中间加入logo则打开下面两行注释----->>>>>>>
//    UIImage *logoImg = [UIImage imageNamed:@"icon_erweima"];
    //qrImageView.image = [LBXScanWrapper addImageLogo:qrImg centerLogoImage:logoImg logoSize:CGSizeMake(30 * NEW_BILI, 30 * NEW_BILI)];
    [whiteBGView addSubview:qrImageView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(qrImageView.frame) + 15 * NEW_BILI, CGRectGetWidth(whiteBGView.frame) - 10, 1 * NEW_BILI)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBGView addSubview:line];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(whiteBGView.frame), 57 * NEW_BILI);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColor_LightBlueButtonBGNormal forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBGView addSubview:cancelButton];
}
- (void)cancelAction:(UIButton *)button
{
    UIView *coverView = [self.view viewWithTag:666];
    [coverView removeFromSuperview];
    coverView = nil;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
