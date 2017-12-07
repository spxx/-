//
//  ScanToPayIntroViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 5/11/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import "ScanToPayIntroViewController.h"
#import <CoreText/CoreText.h>
#import "ScanViewController.h"

@interface ScanToPayIntroViewController ()

@end

@implementation ScanToPayIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
- (void)setupView {
    self.navigationTitle = @"扫码支付";
    self.sixtyFourPixelsView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-170)/2, (self.view.heightValue-180-170+self.sixtyFourPixelsView.viewBottomEdge)/2, 170, 170)];
    qrImageView.image = [UIImage imageNamed:@"qr_code_icon"];
    [self.view addSubview:qrImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, qrImageView.bottomValue + 50, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    [button setupTitle:@"我知道了" enable:YES];
    [button addTarget:self action:@selector(hasReadedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, button.bottomValue+5, SCREEN_WIDTH-10*2, 40)];
    introLabel.numberOfLines = 0;
    introLabel.textColor = [UIColor lightGrayColor];
    introLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:13 sixPlus:15]];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"到店付是指学生到学校内部商店或周边商家消费时，直接用喜付扫描商户二维码进行支付的消费方式"];
    [attriString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 3)];
    
    introLabel.attributedText = attriString;
    [self.view addSubview:introLabel];
}

- (void)hasReadedAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kScanToPayIntroHadRead];
    
    ScanViewController *scanViewController = [[ScanViewController alloc] init];
    [self pushViewController:scanViewController animated:YES];
}

@end
