//
//  BNPayFeesExplainViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPayFeesExplainViewController.h"

#import "UIButton+BNNextStepButton.h"

#import "BNBindYKTViewController.h"
#import "BNPublicHtml5BusinessVC.h"


@interface BNPayFeesExplainViewController ()<UIAlertViewDelegate>

@end

@implementation BNPayFeesExplainViewController

- (void)setupLoadedView
{
    self.navigationTitle = @"教育缴费";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    
    UIImage *centerImg = [UIImage imageNamed:@"explain_center_img"];
    CGSize imgSize = centerImg.size;
    CGFloat width = [BNTools sizeFitfour:170 five:210 six:250 sixPlus:270];
    CGFloat height = width *(imgSize.height / imgSize.width);
    
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, (theScollView.frame.size.height/2.0 - height)/2.0 + 20 * BILI_WIDTH, width, height)];
    
    centerImgView.backgroundColor = [UIColor clearColor];
    [centerImgView setImage:centerImg];
    [theScollView addSubview:centerImgView];
    
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(10, theScollView.frame.size.height/2.0 + 50 * BILI_WIDTH, SCREEN_WIDTH - 20, 0.5)];
    centerLine.backgroundColor = UIColor_GrayLine;
    [theScollView addSubview:centerLine];
    
    NSMutableAttributedString *funcationText = [[NSMutableAttributedString alloc] initWithString:kFuncationIntroduce];
    [funcationText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [funcationText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]] range:NSMakeRange(0, 4)];
    [funcationText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4, funcationText.length -4)];
    [funcationText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]] range:NSMakeRange(4, funcationText.length - 4)];
    
    UILabel *funcationIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(30, centerLine.frame.origin.y + BILI_WIDTH * 5, SCREEN_WIDTH - 60, funcationText.size.height)];
//    funcationIntroduce.backgroundColor = [UIColor redColor];
    funcationIntroduce.numberOfLines = 0;
    funcationIntroduce.attributedText = funcationText;
    [theScollView addSubview:funcationIntroduce];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(10, theScollView.frame.size.height -[BNTools sizeFitfour:20 five:45 *BILI_WIDTH six:45 *BILI_WIDTH sixPlus:45 *BILI_WIDTH]- 40 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    
    [button setupTitle:@"我知道了" enable:YES];
    
    [button addTarget:self action:@selector(hasReadedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [theScollView addSubview:button];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
}

#pragma mark - button action
-(void)hasReadedAction:(UIButton *)btn
{
    //已绑定学号,则直接保存已阅读校园缴费须知。。。跳转进入缴费项目列表。
    [Tools setHasShowPaySchoolFeesExplainWithUserId:shareAppDelegateInstance.boenUserInfo.userid];

    BNPublicHtml5BusinessVC *schoolFeesVC = [[BNPublicHtml5BusinessVC alloc] init];
    schoolFeesVC.businessType = Html5BusinessType_ThirdPartyBusiness;
    schoolFeesVC.url = _h5Url;
    [self pushViewController:schoolFeesVC animated:YES];
}

@end
