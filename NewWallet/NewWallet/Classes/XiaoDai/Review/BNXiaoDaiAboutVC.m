//
//  BNXiaoDaiAboutVC.m
//  Wallet
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNXiaoDaiAboutVC.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "XiaoDaiApi.h"

static NSString *const kAboutXiaoDaiIntroduce = @"嘻哈贷是喜付联合哈尔滨银行，针对全国在校大学生，量身打造出的一款便捷贴心的互联网借贷产品，也是国内率先纳入央行征信的大学生个人借贷产品，全程APP申请，通过人脸识别完成实名认证，最快10秒到账，更有首贷免息三月的优惠让你刷完饭卡刷脸卡。";

@interface BNXiaoDaiAboutVC ()

@end

@implementation BNXiaoDaiAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"关于嘻哈贷";
    self.view.backgroundColor = UIColor_Gray_BG;
    
    CGFloat originY = 8*BILI_WIDTH;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    scrollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:scrollView];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 120*BILI_WIDTH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.borderColor = UIColor_GrayLine.CGColor;
    whiteView.layer.borderWidth = 0.5;
    [scrollView addSubview:whiteView];

    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(13*BILI_WIDTH, 13*BILI_WIDTH, 45*BILI_WIDTH, 45*BILI_WIDTH)];
    headerImgView.image = [UIImage imageNamed:@"XiaoDai_HeadIcon"];
    [whiteView addSubview:headerImgView];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(70*BILI_WIDTH, 12*BILI_WIDTH, 100*BILI_WIDTH, [BNTools sizeFit:16 six:18 sixPlus:20])];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.text = @"产品介绍";
    [whiteView addSubview:titleLbl];
    
    CGFloat discripTextHeight = [Tools caleNewsCellHeightWithTitle:kAboutXiaoDaiIntroduce font:[UIFont systemFontOfSize:[BNTools sizeFit:12 six:14 sixPlus:16]] width:SCREEN_WIDTH-70*BILI_WIDTH-10*BILI_WIDTH];

    CGFloat discripLblBeginY = CGRectGetMaxY(titleLbl.frame)+10*BILI_WIDTH;
    UILabel *discripLbl = [[UILabel alloc] initWithFrame:CGRectMake(70*BILI_WIDTH, discripLblBeginY, SCREEN_WIDTH-70*BILI_WIDTH-10*BILI_WIDTH, discripTextHeight)];
    discripLbl.numberOfLines = 0;
    discripLbl.textColor = [UIColor lightGrayColor];
    discripLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:14 sixPlus:16]];
    discripLbl.text = kAboutXiaoDaiIntroduce;
    [whiteView addSubview:discripLbl];
    whiteView.frame = CGRectMake(0, whiteView.frame.origin.y, SCREEN_WIDTH, CGRectGetMaxY(discripLbl.frame)+12*BILI_WIDTH);

    originY += whiteView.frame.size.height + 8*BILI_WIDTH;
    
    UIView *whiteView2 = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 3*45*BILI_WIDTH)];
    whiteView2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:whiteView2];
    
    for (int i = 0; i < 3; i++) {
        NSString *titleStr = @"";
        switch (i) {
            case 0: {
                titleStr = @"咨询热线：028-61831329";
                break;
            }
            case 1: {
                titleStr = @"客服QQ：2425839277";
                break;
            }
            case 2: {
                titleStr = @"QQ交流群：174866711";
                break;
            }
        }
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(12*BILI_WIDTH, i*45*BILI_WIDTH, SCREEN_WIDTH-2*12*BILI_WIDTH, 45*BILI_WIDTH)];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.text = titleStr;
        [whiteView2 addSubview:titleLbl];
        
        CGFloat lineOffsetX = i == 0 ? 0 : 12*BILI_WIDTH;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineOffsetX, i*45*BILI_WIDTH, SCREEN_WIDTH-lineOffsetX, 0.5)];
        lineView.backgroundColor = UIColor_GrayLine;
        [whiteView2 addSubview:lineView];

    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, whiteView2.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = UIColor_GrayLine;
    [whiteView2 addSubview:lineView];
    
    originY += whiteView2.frame.size.height + 8*BILI_WIDTH;

    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame = CGRectMake(0, originY, SCREEN_WIDTH, 45*BILI_WIDTH);
    agreementBtn.backgroundColor = [UIColor whiteColor];
    agreementBtn.layer.borderColor = UIColor_GrayLine.CGColor;
    agreementBtn.layer.borderWidth = 0.5;
    agreementBtn.layer.masksToBounds = YES;
    [agreementBtn setTitleColor:UIColorFromRGB(0x0166ff) forState:UIControlStateNormal];
    UIImage *image3 = [Tools imageWithColor:UIColor_Gray_Text andSize:CGSizeMake(agreementBtn.frame.size.width, 40)];
    [agreementBtn setBackgroundImage:image3 forState:UIControlStateHighlighted];
    agreementBtn.titleLabel.textColor = UIColorFromRGB(0x0166ff);
    agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    agreementBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5*BILI_WIDTH, 0, 0);
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    [agreementBtn setTitle:@"《嘻哈贷服务协议》" forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(readAgreementBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:agreementBtn];

    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26*BILI_WIDTH, (45*BILI_WIDTH - 16*BILI_WIDTH)/2, 16*BILI_WIDTH, 16*BILI_WIDTH)];
    arrowImg.backgroundColor = [UIColor clearColor];
    [arrowImg setImage:[UIImage imageNamed:@"right_arrow"]];
    [agreementBtn addSubview:arrowImg];
    
    originY += agreementBtn.frame.size.height;
    if (scrollView.frame.size.height <= originY + 1) {
        scrollView.contentSize = CGSizeMake(0, originY + 1);
    }
}

- (void)readAgreementBtn
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi checkRealNameReviewStatusWithSuccess:^(NSDictionary *successData) {
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            
            NSDictionary *returnData = [successData valueForKey:kRequestReturnData];
            NSDictionary *videoUploadDict = [returnData valueForKey:@"video_upload"];
            NSString *htmlStr = [videoUploadDict valueNotNullForKey:@"econtract"];
            BNXiaoDaiReadServiceAgreementVC *agreementVC = [[BNXiaoDaiReadServiceAgreementVC alloc] init];
            agreementVC.orderNO = @"";
            agreementVC.protocalType = XiaoDaiProtocalTypeServiceOnlyRead;
            agreementVC.econtractProtocol = htmlStr;
            [weakSelf pushViewController:agreementVC animated:YES];
        } else {
            NSString *retMsg = [successData valueForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];


}


@end
