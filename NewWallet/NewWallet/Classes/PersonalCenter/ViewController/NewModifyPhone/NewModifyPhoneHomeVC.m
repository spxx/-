//
//  NewModifyPhoneHomeVC.m
//  Wallet
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "NewModifyPhoneHomeVC.h"
#import "BNModifyBindPhoneNumVC.h"
#import "NewModifyPhoneTypeVC.h"

@interface NewModifyPhoneHomeVC ()

@end

@implementation NewModifyPhoneHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"修改手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    
    CGFloat originY = [BNTools sizeFitfour:20*BILI_WIDTH five:45*BILI_WIDTH six:45*BILI_WIDTH sixPlus:45*BILI_WIDTH];
    
    UIImage *centerImg = [UIImage imageNamed:@"NewModifyPhoneHomeVC_Icon"];
    CGSize imgSize = centerImg.size;
    CGFloat width = 180*BILI_WIDTH;
    CGFloat height = width *(imgSize.height / imgSize.width);
    
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, originY, width, height)];
    
    centerImgView.backgroundColor = [UIColor clearColor];
    [centerImgView setImage:centerImg];
    [theScollView addSubview:centerImgView];
    
    originY += centerImgView.frame.size.height +[BNTools sizeFitfour:15*BILI_WIDTH five:30*BILI_WIDTH six:30*BILI_WIDTH sixPlus:30*BILI_WIDTH];

    UILabel *funcationIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 20)];
    funcationIntroduce.numberOfLines = 0;
    funcationIntroduce.textColor = UIColor_DarkGray_Text;
    funcationIntroduce.textAlignment = NSTextAlignmentCenter;
    funcationIntroduce.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    funcationIntroduce.text = @"请确认原有手机号是否可以接收短信？";
    [theScollView addSubview:funcationIntroduce];
    
    originY += funcationIntroduce.frame.size.height +[BNTools sizeFitfour:40*BILI_WIDTH five:50*BILI_WIDTH six:50*BILI_WIDTH sixPlus:50*BILI_WIDTH];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [button setupTitle:@"能够接收短信" enable:YES];
    [button addTarget:self action:@selector(canReceiveMsgAction:) forControlEvents:UIControlEventTouchUpInside];
    [theScollView addSubview:button];
    
    originY += button.frame.size.height +14*BILI_WIDTH;

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [button2 setupRedBtnTitle:@"无法接收短信" enable:YES];
    [button2 addTarget:self action:@selector(canNotReceiveMsgAction:) forControlEvents:UIControlEventTouchUpInside];
    originY += button2.frame.size.height;
    [theScollView addSubview:button2];
    
    
}

- (void)canReceiveMsgAction:(UIButton *)button
{
    //能接收
    BNModifyBindPhoneNumVC *modifyPhoneVC = [[BNModifyBindPhoneNumVC alloc] init];
    modifyPhoneVC.useStyle = ViewControllerUseStyleVerifyCurrentPhone;
    [self pushViewController:modifyPhoneVC animated:YES];
}
- (void)canNotReceiveMsgAction:(UIButton *)button
{
    //不能接收
    NewModifyPhoneTypeVC *modifyPhoneTypeVC = [[NewModifyPhoneTypeVC alloc] init];
    [self pushViewController:modifyPhoneTypeVC animated:YES];
}
@end
