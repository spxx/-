//
//  BNXiaoDaiExplainViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNXiaoDaiExplainViewController.h"

#import "UIButton+BNNextStepButton.h"

#import "BNBindYKTViewController.h"
#import "XiaoDaiApi.h"

@interface BNXiaoDaiExplainViewController ()<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL firstShow;
@property (nonatomic, weak) UIButton *button;

@end

@implementation BNXiaoDaiExplainViewController

- (void)setupLoadedView
{
    self.navigationTitle = @"嘻哈贷";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    
    CGFloat contentSizeY = SCREEN_HEIGHT == 480 ? 500 : SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 50*BILI_WIDTH;
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, contentSizeY);
    [self.view addSubview:theScollView];
    
    CGFloat originY = 30*BILI_WIDTH;

    UIImage *centerImg = [UIImage imageNamed:@"XiaoDai_ExplainBG"];
    CGSize imgSize = centerImg.size;
    CGFloat width = [BNTools sizeFitfour:160 five:200 six:240 sixPlus:260];
    CGFloat height = width *(imgSize.height / imgSize.width);

    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, originY, width, height)];
    
    centerImgView.backgroundColor = [UIColor clearColor];
    [centerImgView setImage:centerImg];
    [theScollView addSubview:centerImgView];
    
    originY += centerImgView.frame.size.height;
    
    CGFloat discripTextHeight = [Tools caleNewsCellHeightWithTitle:kDiscripIntroduce font:[UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]] width:SCREEN_WIDTH - 60*BILI_WIDTH];

    NSMutableAttributedString *discripText = [[NSMutableAttributedString alloc] initWithString:kDiscripIntroduce];
    [discripText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [discripText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]] range:NSMakeRange(0, 4)];
    
    UILabel *discripLbl = [[UILabel alloc] initWithFrame:CGRectMake(15*BILI_WIDTH, originY, SCREEN_WIDTH - 30*BILI_WIDTH, discripTextHeight)];
    discripLbl.numberOfLines = 0;
    discripLbl.textColor = [UIColor lightGrayColor];
    discripLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    discripLbl.attributedText = discripText;
    [theScollView addSubview:discripLbl];
    
     originY += discripLbl.frame.size.height;
    
    NSMutableAttributedString *funcationText = [[NSMutableAttributedString alloc] initWithString:kExplainFuncationIntroduce];
    [funcationText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [funcationText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]] range:NSMakeRange(0, 4)];
    
    CGFloat funcationIntroduceHeight = [Tools caleNewsCellHeightWithTitle:kExplainFuncationIntroduce font:[UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]] width:SCREEN_WIDTH - 60*BILI_WIDTH];
    UILabel *funcationIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(15*BILI_WIDTH, originY, SCREEN_WIDTH - 30*BILI_WIDTH, funcationIntroduceHeight)];
    funcationIntroduce.numberOfLines = 0;
    funcationIntroduce.textColor = [UIColor lightGrayColor];
    funcationIntroduce.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    funcationIntroduce.attributedText = funcationText;
    [theScollView addSubview:funcationIntroduce];
    
    originY += funcationIntroduce.frame.size.height + 20*BILI_WIDTH;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH - 20*BILI_WIDTH, 40 * BILI_WIDTH);
    [button setupRedBtnTitle:@"申请开通" enable:YES];
    [button addTarget:self action:@selector(hasReadedAction:) forControlEvents:UIControlEventTouchUpInside];
    originY += button.frame.size.height;
    [theScollView addSubview:button];
    _button = button;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkRealNameStatus];

}


#pragma mark - button action
-(void)hasReadedAction:(UIButton *)btn
{
    if (_firstShow) {
        shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"小额借贷需要经过实名认证才能使用，确定要实名认证吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [shareAppDelegateInstance.alertView show];
    }
    else
    {
        [self goDelegate];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)return;
    [self goDelegate];
        
}

- (void)checkRealNameStatus
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [XiaoDaiApi newCertifyStatusQuerySuccess:^(NSDictionary *successData) {
        
        if ([successData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];

            NSDictionary *dataDic = [successData valueNotNullForKey:kRequestReturnData];
            NSDictionary *applyDic = [dataDic valueNotNullForKey:@"credit_amount_apply"];
            NSString *certifyStatus = [applyDic valueNotNullForKey:@"status"];
            [weakSelf setupLoadedView];
            if ([certifyStatus isEqualToString:@"INIT"]||[certifyStatus isEqualToString:@"FALSE"])
            {
                _firstShow = YES;
            }else {
                _firstShow = NO;
                [_button setupRedBtnTitle:@"进入小额贷" enable:YES];
            }
            
        }else{
            NSString *retMsg = successData[kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
            [self performSelector:@selector(popVC) withObject:nil afterDelay:1.5];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}
- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goDelegate
{
    [BNXiaoDaiInfoRecordTool setHasShowXiaoDaiExplain];
    
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(BNXiaoDaiExplainViewControllerDelegatePopPush)]) {
        [_delegate BNXiaoDaiExplainViewControllerDelegatePopPush];
    }
}

@end
