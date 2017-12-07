//
//  BNAllProjectVC.m
//  Wallet
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNAllProjectVC.h"
#import "CustomButton.h"
#import "BNYKTRechargeHomeVC.h"
#import "BNMobileRechargeVC.h"
#import "BNPublicHtml5BusinessVC.h"
#import "ElectricChargeMainNewVC.h"
#import "ElectricChargeMainVC.h"
#import "BNBindYKTViewController.h"
#import "BNXiaoDaiExplainViewController.h"
#import "BNPayFeesExplainViewController.h"
#import "BNNetFeesHomeViewController.h"
#import "BNPersonalInfoViewController.h"
#import "BNRealNameReviewResultVC.h"
#import "BNXiHaDaiHomeViewController.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"
#import "BNCollectFeesListVC.h"

#import "BNNewXiaodaiRealNameInfo.h"

#import "CardApi.h"
#import "NewElectricFeesApi.h"
#import "XiaoDaiApi.h"

@interface BNAllProjectVC ()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;

@end
@implementation BNAllProjectVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    CGFloat originY = 20*BILI_WIDTH;
    int cellNumber = 4;  //每行放几个
    
    CGFloat buttonWidth =  (SCREEN_WIDTH-20*BILI_WIDTH-3*15*BILI_WIDTH)/cellNumber;
    NSArray *homeItemArray;
    if (_useTypes == UseTypeHomeProject) {
        homeItemArray = [Tools getHomeItemRecordArray];
        self.navigationTitle = @"全部应用";
    } else {
        homeItemArray = [Tools getSchoolProjectItemRecordArray];
        self.navigationTitle = @"校园应用";
    }
    CGFloat buttonMaxY = 0.0;
    for (int i = 0; i < homeItemArray.count; i++) {
        NSDictionary *itemDict = homeItemArray[i];

        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:6*BILI_WIDTH imgHeight:25*BILI_WIDTH textBottomY:12*BILI_WIDTH];
        button.frame = CGRectMake(10*BILI_WIDTH + i%cellNumber*(i%cellNumber == 0 ? 0 : 15*BILI_WIDTH) + i%cellNumber*buttonWidth, originY+i/cellNumber*(buttonWidth+5*BILI_WIDTH) , buttonWidth, buttonWidth);
        [button addTarget:self action:@selector(suDoKuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        buttonMaxY = CGRectGetMaxY(button.frame);
        
        [button setUpButtonData:itemDict];
        
        [button setTitle:[itemDict valueForKey:@"biz_name"] forState:UIControlStateNormal];
        
        if ([button.biz_name isEqualToString:@"更多"]) {
            [button setImage:[UIImage imageNamed:[itemDict valueForKey:@"biz_icon_url"]] forState:UIControlStateNormal];
        } else {
            [button sd_setImageWithURL:[NSURL URLWithString:button.biz_icon_url] forState:UIControlStateNormal];
        }
    }
    originY = buttonMaxY + 26 * BILI_WIDTH;
    _scrollView.contentSize = CGSizeMake(0, originY+1);
}
- (void)suDoKuButtonAction:(UIButton *)button
{
    [super suDoKuButtonAction:button];
}
@end
