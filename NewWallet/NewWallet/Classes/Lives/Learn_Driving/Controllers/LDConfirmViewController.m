//
//  LDConfirmViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 5/30/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import "LDConfirmViewController.h"
#import "LDSubmitViewController.h"
#import "TopTabBar.h"
#import "LearnDrivingApi.h"
#import "TTTAttributedLabel.h"
#import "UMHybrid.h"

@interface LDConfirmViewController () <TopTabBarDelegate, UIWebViewDelegate>

@property (weak, nonatomic) UILabel *schoolNameLabel;
@property (weak, nonatomic) UILabel *classNameLabel;
@property (weak, nonatomic) UILabel *classDescriptionLabel;
@property (weak, nonatomic) UIButton *onetimePayButton;
@property (weak, nonatomic) UIButton *segmentedPayButton;
@property (weak, nonatomic) UIButton *commitButton;
@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) UIView *whiteBg;
@property (weak, nonatomic) TopTabBar *topTabBar;

@property (assign, nonatomic) CGFloat originalHeight;

@property (strong, nonatomic) NSDictionary *classInfo;

@end

@implementation LDConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLoadedView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLoadedView {
    [super setupLoadedView];
    
    self.navigationTitle = @"驾校报名";
    
    self.view.backgroundColor = UIColor_Gray_BG;

    UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 80)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBg];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.text = @"报名驾校";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];

    label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-100, 40)];
    label.text = @"";
    label.font = [UIFont systemFontOfSize:14];
    [whiteBg addSubview:label];
    self.schoolNameLabel = label;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-80, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBg addSubview:line];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 100, 40)];
    label.text = @"报名课程";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-80, 40)];
    label.text = @"";
    label.font = [UIFont systemFontOfSize:14];
    [whiteBg addSubview:label];
    self.classNameLabel = label;
    
    
    whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, whiteBg.bottomValue+10, SCREEN_WIDTH, 80)];
    whiteBg.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:whiteBg];
    self.whiteBg = whiteBg;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.text = @"缴费方式";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(67, 0, 110, 40);
    [button setImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button setTitle:@"一次性缴清" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [button addTarget:self action:@selector(payTypeTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
    [whiteBg addSubview:button];
    self.onetimePayButton = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(67+110, 0, 110, 40);
    [button setImage:[UIImage imageNamed:@"Protocol_Unselected"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button setTitle:@"分段缴费" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [button addTarget:self action:@selector(payTypeTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    button.hidden = YES;
    [whiteBg addSubview:button];
    self.segmentedPayButton = button;
    
    line = [[UIView alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-80, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [whiteBg addSubview:line];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 100, 40)];
    label.text = @"详情描述";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(126, 147, 158);
    [whiteBg addSubview:label];
    self.classDescriptionLabel = label;
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40+10, SCREEN_WIDTH-90, 30)];
    tLabel.text = @"";
    tLabel.font = [UIFont systemFontOfSize:14];
    tLabel.numberOfLines  = 0;
    //tLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    [whiteBg addSubview:tLabel];
    self.classDescriptionLabel = tLabel;
    
    
    TopTabBar *topTabBar = [[TopTabBar alloc] initWithFrame:CGRectMake(0, whiteBg.bottomValue+10, SCREEN_WIDTH, 44) titles:@[@"报名须知", @"费用明细", @"培训内容"] style:HintStyle_TitleWidth];
    topTabBar.hintColor = RGB(54, 113, 255);
    topTabBar.hintHeight = 2;
    topTabBar.delegate = self;
    [self.baseScrollView addSubview:topTabBar];
    self.topTabBar = topTabBar;
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, topTabBar.bottomValue+3, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge-50-topTabBar.bottomValue-3)];
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.hao123.com"]]];
    webView.delegate = self;
    webView.userInteractionEnabled = NO;
    [self.baseScrollView addSubview:webView];
    self.webView = webView;
    self.originalHeight = webView.heightValue;
    
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [commitButton setupTitle:@"确认信息" enable:NO];
    [commitButton setBackgroundImage:[Tools imageWithColor:RGB(54, 113, 255) andSize:CGSizeMake(SCREEN_WIDTH, 50)] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 0;
    [commitButton addTarget:self action:@selector(commitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    self.commitButton = commitButton;
}

- (void)loadData {
    if (!self.classKey) {
        return;
    }
    
    [SVProgressHUD show];
    
    __weak __typeof(self) weakSelf = self;
    
    [LearnDrivingApi getDrivingClassDetail:self.classKey succeed:^(NSDictionary *returnData) {
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:@"000000"]) {
            [SVProgressHUD dismiss];
            
            weakSelf.classInfo = returnData[kRequestReturnData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.commitButton.enabled = YES;
                
                weakSelf.schoolNameLabel.text = [weakSelf.classInfo valueNotNullForKey:@"driving_school_name"];
                weakSelf.classNameLabel.text = [weakSelf.classInfo valueNotNullForKey:@"class_name"];
                weakSelf.classDescriptionLabel.text = self.onetimePayButton.selected ? [weakSelf.classInfo valueForKey:@"once_pay_desc"] : [weakSelf.classInfo valueForKey:@"installment_pay_desc"];
                CGFloat height = [Tools caleNewsCellHeightWithTitle:weakSelf.classDescriptionLabel.text font:[UIFont systemFontOfSize:14] width:weakSelf.classDescriptionLabel.widthValue];
                weakSelf.classDescriptionLabel.heightValue = height;
                weakSelf.whiteBg.heightValue = 40+15+height+5;
                weakSelf.topTabBar.topValue = weakSelf.whiteBg.bottomValue+10;
                weakSelf.webView.topValue = weakSelf.topTabBar.bottomValue+3;
                
                if ([[weakSelf.classInfo valueForKey:@"support_installment"] integerValue] > 0) {
                    weakSelf.segmentedPayButton.hidden = NO;
                }
                
                [weakSelf tabBarItemSelected:0];
            });
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

- (void)payTypeTapped:(UIButton *)button {
    button.selected = YES;
    [button setImage:[UIImage imageNamed:@"Protocol_Selected"] forState:UIControlStateNormal];
    if (button == self.onetimePayButton) {
        [self.segmentedPayButton setImage:[UIImage imageNamed:@"Protocol_Unselected"] forState:UIControlStateNormal];
        self.segmentedPayButton.selected = NO;
        self.classDescriptionLabel.text = [self.classInfo valueForKey:@"once_pay_desc"];
    } else {
        [self.onetimePayButton setImage:[UIImage imageNamed:@"Protocol_Unselected"] forState:UIControlStateNormal];
        self.onetimePayButton.selected = NO;
        self.classDescriptionLabel.text = [self.classInfo valueForKey:@"installment_pay_desc"];
    }
}

- (void)commitTapped:(UIButton *)button {
    LDSubmitViewController *submitViewController = [[LDSubmitViewController alloc] init];
    submitViewController.classInfo = self.classInfo;
    submitViewController.payType = self.onetimePayButton.selected ? @(1) : @(2);
    [self pushViewController:submitViewController animated:YES];
}

#pragma mark - TopTabBarDelegate

- (void)tabBarItemSelected:(NSInteger)index {
    switch (index) {
        case 0:
            [self.webView loadHTMLString:self.classInfo[@"apply_notice"] baseURL:nil];
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.hao123.com"]]];
            break;
        case 1:
            [self.webView loadHTMLString:self.classInfo[@"fee_detail"] baseURL:nil];
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baidu.com"]]];
            break;
        case 2:
            [self.webView loadHTMLString:self.classInfo[@"class_content"] baseURL:nil];
//            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ithome.com"]]];
            break;
        default:
            break;
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGRect frame = webView.frame;
    frame.size.height = self.originalHeight;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, webView.topValue+webView.scrollView.contentSize.height+50);
    webView.heightValue = webView.scrollView.contentSize.height;
    
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
