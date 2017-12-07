//
//  BNXiaoDaiReadServiceAgreementVC.m
//  Wallet
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "XiaoDaiApi.h"
#import "BNReturnAndBorrowMoneyResultVC.h"
#import "BNXiHaDaiHomeViewController.h"

@interface BNXiaoDaiReadServiceAgreementVC () <UIScrollViewDelegate, UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic) UIWebView *protocolWebView;
@property (nonatomic) UIButton *agreeBtn;
@property (nonatomic) UIButton *nextbutton;
@property (nonatomic) BOOL agreeProtocol;
@property (nonatomic) BOOL isLoadingFinished;
@end

@implementation BNXiaoDaiReadServiceAgreementVC

static NSString *const xiaoDaiProtocalTypeElectronTicketBackAlertStr = @"点击返回此笔借款作废，确定要返回吗？";

#pragma mark - button action
- (void)backButtonClicked:(UIButton *)sender
{
    switch (_protocalType) {
        case XiaoDaiProtocalTypeService:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case XiaoDaiProtocalTypeElectronTicket:
        {
            shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:xiaoDaiProtocalTypeElectronTicketBackAlertStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [shareAppDelegateInstance.alertView show];
        }
            break;
            
        default:
            [super backButtonClicked:sender];
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = (_protocalType == XiaoDaiProtocalTypeService || _protocalType == XiaoDaiProtocalTypeServiceOnlyRead) ? @"嘻哈贷" :@"我要用钱";
    _agreeProtocol = NO;
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.tag = 101;
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [theScollView addSubview:whiteView];
    
    CGFloat originY = 0;
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45*BILI_WIDTH)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor blackColor];
    [whiteView addSubview:titleLbl];
    titleLbl.text = (_protocalType == XiaoDaiProtocalTypeElectronTicket || _protocalType == XiaoDaiProtocalTypeElectronTicketOnlyRead) ? @"嘻哈贷电子借据" : @"嘻哈贷服务协议";
    
    originY += titleLbl.frame.size.height;
    
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 0.5)];
    centerLine.backgroundColor = UIColor_GrayLine;
    [whiteView addSubview:centerLine];
    
    originY += centerLine.frame.size.height;

    self.protocolWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT-100*BILI_WIDTH-originY-self.sixtyFourPixelsView.viewBottomEdge)];
    _protocolWebView.scalesPageToFit = NO;
    _protocolWebView.scrollView.delegate = self;
    [whiteView addSubview:_protocolWebView];

    //html是否加载完成
    _isLoadingFinished = NO;
    //第一次加载先隐藏protocolWebView
    _protocolWebView.scrollView.alwaysBounceVertical = YES;
    [self.protocolWebView setHidden:YES];
    self.protocolWebView.delegate = self;
    
    originY += _protocolWebView.frame.size.height;

    whiteView.frame = CGRectMake(0, whiteView.frame.origin.y, SCREEN_WIDTH, originY);

    originY += 15*BILI_WIDTH;

    if (_protocalType == XiaoDaiProtocalTypeService || _protocalType == XiaoDaiProtocalTypeElectronTicket) {
        self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(20*BILI_WIDTH, originY, SCREEN_WIDTH-2*20*BILI_WIDTH, 13*BILI_WIDTH);
        [_agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_agreeBtn setTitle:@"我已阅读并同意《嘻哈贷服务协议》" forState:UIControlStateNormal];
        [_agreeBtn setTitle:@"请阅读完服务协议并点击同意进入下一步" forState:UIControlStateDisabled];

        [_agreeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10*BILI_WIDTH, 0, 0)];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        [_agreeBtn setImage:[UIImage imageNamed:@"Protocol_Unselected"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateSelected];
        UIImage *nilImg = [Tools imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)];
        [_agreeBtn setImage:nilImg forState:UIControlStateDisabled];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [theScollView addSubview:_agreeBtn];
        _agreeBtn.enabled = NO;
        
        if (_protocalType == XiaoDaiProtocalTypeElectronTicket) {
            [_agreeBtn setTitle:@"我已阅读并同意《嘻哈贷电子借据》" forState:UIControlStateNormal];
            [_agreeBtn setTitle:@"请阅读完电子借据并点击同意进入下一步" forState:UIControlStateDisabled];
        }
        originY += _agreeBtn.frame.size.height + 15*BILI_WIDTH;
    }

    if (_protocalType == XiaoDaiProtocalTypeService || _protocalType == XiaoDaiProtocalTypeElectronTicket) {
        self.nextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextbutton.frame = CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
        [_nextbutton setupRedBtnTitle:@"下一步" enable:YES];
        [_nextbutton addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [theScollView addSubview:_nextbutton];
        originY += _nextbutton.frame.size.height;
        _nextbutton.enabled = NO;
    } else {
        //XiaoDaiProtocalType-OnlyRead
        whiteView.frame = CGRectMake(0, whiteView.frame.origin.y, SCREEN_WIDTH, theScollView.frame.size.height-8*BILI_WIDTH);
        _protocolWebView.frame = CGRectMake(0, _protocolWebView.frame.origin.y, SCREEN_WIDTH, whiteView.frame.size.height-45*BILI_WIDTH);
    }
    
    if (theScollView.frame.size.height <= originY + 10*BILI_WIDTH+8*BILI_WIDTH) {
        theScollView.contentSize = CGSizeMake(0, originY + 10*BILI_WIDTH+8*BILI_WIDTH);
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fast_pay_protocol.htm" ofType:nil]];
    if (_protocalType != XiaoDaiProtocalTypeService) {
        [_nextbutton setupRedBtnTitle:@"确认" enable:NO];
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fast_pay_protocol.htm" ofType:nil]];
    }
    
    [self.protocolWebView loadHTMLString:_econtractProtocol baseURL:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 101 || _protocalType == XiaoDaiProtocalTypeElectronTicketOnlyRead || _protocalType == XiaoDaiProtocalTypeServiceOnlyRead) {
        return;
    }
    //webView里面的scrollView 监听滚动到底部
    CGPoint contentOffsetPoint = scrollView.contentOffset;
    
    CGRect frame = scrollView.frame;
    
    if (contentOffsetPoint.y+10 >= scrollView.contentSize.height - frame.size.height || scrollView.contentSize.height < frame.size.height) {
        //滚动到底部
        _agreeBtn.enabled = YES;
        [self refreshBtnStatus];
    }
}

- (void)agreeBtnAction
{
    _agreeProtocol = !_agreeProtocol;
    [self refreshBtnStatus];
}

- (void)nextBtnAction
{
    if (_protocalType == XiaoDaiProtocalTypeService) {
//        [BNXiaoDaiInfoRecordTool setHaveAgreeTheXiaoDaiProtocal];
//        VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
//        vc.realNameOrderNO = self.orderNO;
//        [self pushViewController:vc animated:YES];
//        return;
        //确认电子协议
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [XiaoDaiApi newConfirmEcontractWithAgree:@"yes"
                                         success:^(NSDictionary *successData) {
                                             if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                                             {
                                                 //额度查询，跳转到小贷主页
                                                 [XiaoDaiApi newAmoutQuerySuccess:^(NSDictionary *successData) {
                                                     if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                         [SVProgressHUD dismiss];
                                                         NSDictionary *dataInfo = [successData valueNotNullForKey:kRequestReturnData];
                                                         BNXiHaDaiHomeViewController *xiaoDaiHome = [[BNXiHaDaiHomeViewController alloc] init];
                                                         xiaoDaiHome.creditLoanAmount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"credit_amount"]]doubleValue];
                                                         xiaoDaiHome.loanRemainAmount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"remain_amount"]]doubleValue];
                                                         xiaoDaiHome.overduedLoanCount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"overdued_loan_count"]]integerValue];
                                                         xiaoDaiHome.closeReturnCount = [[NSString stringWithFormat:@"%@", [dataInfo valueForKey:@"almost_overdued_loan_count"]]integerValue];
                                                         [weakSelf pushViewController:xiaoDaiHome animated:YES];
                                                         
                                                     }else{
                                                         NSString *retMsg = [successData valueForKey:kRequestRetMessage];
                                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                                     }
                                                 } failure:^(NSError *error) {
                                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                     
                                                 }];

                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
                                             }

                                         }
                                         failure:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                         }];
        
    } else {
        //发请求确认电子借据，
        [SVProgressHUD showWithStatus:@"请稍候..."];
        [XiaoDaiApi confirmReceiptWithOrderNumber:self.orderNO
                                            agree:@"true"
                                          success:^(NSDictionary *returnData) {
                                              if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                                              {
                                                  [SVProgressHUD dismiss];
                                                //  跳转到借款结果界面,结果为申请借款时的状态同安卓
                                                  NSString *status = shareAppDelegateInstance.xiaodaiBorrowInfo.status;
                                                  BNReturnAndBorrowMoneyResultVC *resultVC = [[BNReturnAndBorrowMoneyResultVC alloc] init];
                                                  if ([status isEqualToString:@"INIT"]||[status isEqualToString:@"AUDING"]) {
                                                      resultVC.resultStatus = XiaoDaiPayResultStatusBorrowMoneyProcessing;
                                                  }
                                                  else if([status isEqualToString:@"FALSE"])
                                                  {
                                                      resultVC.resultStatus = XiaoDaiPayResultStatusBorrowMoneyFailed;
                                                  }
                                                  else
                                                  {
                                                      resultVC.resultStatus = XiaoDaiPayResultStatusBorrowMoneySuccess;
                                                  }
                                                  [self pushViewController:resultVC animated:YES];
                                              }
                                              else
                                              {
                                                  [SVProgressHUD showErrorWithStatus:returnData[@"retmsg"]];
                                              }
                                          }
                                          failure:^(NSError *error) {
                                              [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                          }];
        
                
    }
}
- (void)refreshBtnStatus
{
    if (_agreeProtocol == YES) {
        _agreeBtn.selected = YES;
        _nextbutton.enabled = YES;
    } else {
        _agreeBtn.selected = NO;
        _nextbutton.enabled = NO;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '500%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    //若已经加载完成，则显示webView并return
    if(_isLoadingFinished)
    {
        [self.protocolWebView setHidden:NO];
       
        return;
    }
    
    //js获取body宽度
    NSString *bodyWidth= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth"];
    
    int widthOfBody = [bodyWidth intValue];
    
    //获取实际要显示的html
    NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                              html:_econtractProtocol
                                           webView:webView];
    
    //设置为已经加载完成
    _isLoadingFinished = YES;
    //加载实际要现实的html
    [self.protocolWebView loadHTMLString:html baseURL:nil];
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}


#pragma mark -UIAlertVeiwDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi confirmReceiptWithOrderNumber:self.orderNO
                                        agree:@"false"
                                      success:^(NSDictionary *returnData) {
                                          BNLog(@"不同意电子借据----->>>>>>%@",returnData);
                                          if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                                          {
                                              [SVProgressHUD dismiss];
                                              //返回小额贷主页
                                              if (self.navigationController.viewControllers.count > 1) {
                                                  for (UIViewController *vc in self.navigationController.viewControllers) {
                                                      if ([vc isKindOfClass:NSClassFromString(@"BNXiHaDaiHomeViewController")]) {
                                                          [self.navigationController popToViewController:vc animated:YES];
                                                          break;
                                                      }
                                                  }
                                              }
                                          }
                                          else
                                          {
                                              [SVProgressHUD showErrorWithStatus:returnData[@"retmsg"]];
                                          }
                                      }
                                      failure:^(NSError *error) {
                                          [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                      }];

}

@end
