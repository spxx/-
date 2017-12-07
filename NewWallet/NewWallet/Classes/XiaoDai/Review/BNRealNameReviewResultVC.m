//
//  BNRealNameReviewResultVC.m
//  Wallet
//
//  Created by mac1 on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNRealNameReviewResultVC.h"
#import "BNFCRealNameViewController.h"
#import "BNNewXiaodaiRealNameInfo.h"
#import "BNPersonalInfoViewController.h"
#import "BNUploadTools.h"
#import "XiaoDaiApi.h"
#import "BNNewXiaodaiRealNameInfo.h"
#import "BNXiaoDaiReadServiceAgreementVC.h"

@interface BNRealNameReviewResultVC ()

@property (weak, nonatomic) UILabel *reviewResultLabel;

@end

@implementation BNRealNameReviewResultVC


#pragma mark - button action
- (void)backButtonClicked:(UIButton *)sender
{
    // 提现
    if (_reviewResult == RealNameReviewResult_TixianReviewing || _reviewResult == RealNameReviewResult_TixianFailed)
    {
        if (self.navigationController.viewControllers >  0)
        {
            NSArray *viewControllers = self.navigationController.viewControllers;
            [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:NSClassFromString(@"BNBalanceViewController")] || [obj isKindOfClass:NSClassFromString(@"BNPersonalCenterViewController")]|| [obj isKindOfClass:NSClassFromString(@"BNFeeDetailViewController")])
                {
                    [self.navigationController popToViewController:obj animated:YES];
                }
            }];
        }
        return;
    }
    //xiaodai
    if (self.navigationController.viewControllers.count > 1) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"BNHomeViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}

#pragma mark - setup view
- (void)setupLoadedView
{
    self.view.backgroundColor = UIColor_Gray_BG;
    self.navigationTitle = @"等待信息认证";
    
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1);
    [self.view addSubview:theScollView];
    
    UIImageView *tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 184.0)/2.0, (CGRectGetHeight(theScollView.frame)/2.0 - 120)/2.0, 184, 96)];
    UIImage *tipsImage = nil;
    NSString *resultStr = nil;
    switch (_reviewResult) {
        case RealNameReviewResult_Failed:
        case RealNameReviewResult_TixianFailed:
        {
            tipsImage = [UIImage imageNamed:@"XiaoDai_realNameField"];
            resultStr = _errorInfo.length>0?[NSString stringWithFormat:@"因为[%@]原因导致实名认证信息审核未通过，请重新提交实名信息进行认证。",_errorInfo]:@"实名认证信息审核未通过，请重新提交实名信息进行认证";
            
            UIButton *tryAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tryAgainBtn.frame = CGRectMake(10*BILI_WIDTH, CGRectGetHeight(theScollView.frame) - 2 * 40 * BILI_WIDTH, SCREEN_WIDTH-2*10*BILI_WIDTH, 40*BILI_WIDTH);
            [tryAgainBtn setupRedBtnTitle:@"重新认证" enable:YES];
            [tryAgainBtn addTarget:self action:@selector(tryAgainReviewAction:) forControlEvents:UIControlEventTouchUpInside];
            [theScollView addSubview:tryAgainBtn];
        }
            break;
        case RealNameReviewResult_UploadFailed:
        {
            tipsImage = [UIImage imageNamed:@"XiaoDai_realNameField"];
            resultStr = [NSString stringWithFormat:@"目前服务器连接中断，请确认手机网络情况是否良好？\n然后点击“重新上传”提交相关认证资料。\n更多信息也可以咨询客服热线:028-61831329"];
            
            UIButton *tryAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tryAgainBtn.frame = CGRectMake(10*BILI_WIDTH, CGRectGetHeight(theScollView.frame) - 168 * BILI_WIDTH, SCREEN_WIDTH-2*10*BILI_WIDTH, 40*BILI_WIDTH);
            [tryAgainBtn setupRedBtnTitle:@"重新上传" enable:YES];
            [tryAgainBtn addTarget:self action:@selector(tryAgainUploadAction:) forControlEvents:UIControlEventTouchUpInside];
            [theScollView addSubview:tryAgainBtn];
            
            UIButton *reCertifyButon = [UIButton buttonWithType:UIButtonTypeCustom];
            reCertifyButon.frame = CGRectMake(10*BILI_WIDTH, CGRectGetMaxY(tryAgainBtn.frame) + 11 * BILI_WIDTH, SCREEN_WIDTH-2*10*BILI_WIDTH, 40*BILI_WIDTH);
            [reCertifyButon setTitle:@"重新认证" forState:UIControlStateNormal];
            [reCertifyButon setTitleColor:UIColorFromRGB(0xe96a6a) forState:UIControlStateNormal];
            [reCertifyButon.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]]];
            reCertifyButon.layer.cornerRadius = 2;
            reCertifyButon.layer.masksToBounds = YES;
            reCertifyButon.layer.borderWidth = 1;
            reCertifyButon.layer.borderColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1].CGColor;
            [reCertifyButon addTarget:self action:@selector(reCertify:) forControlEvents:UIControlEventTouchUpInside];
            [theScollView addSubview:reCertifyButon];
            
        }
            break;
        case RealNameReviewResult_Reviewing:
            tipsImage = [UIImage imageNamed:@"XiaoDai_realNameAudit"];
            resultStr = @"信息审核中，审核通过后将以短信通知您。\n审核通过后， 即可查看授信额度。";
            
            break;
        case RealNameReviewResult_TixianReviewing:
        {
            tipsImage = [UIImage imageNamed:@"XiaoDai_reviewing"];
            tipsImageView.frame = CGRectMake((SCREEN_WIDTH - 160)/2.0, (CGRectGetHeight(theScollView.frame)/2.0 - 120)/2.0, 160, 160);
            resultStr = @"实名认证信息审核中，\n审核结果将以短信通知您。";
        }
            break;
                default:
            break;
    }
    
    
    
    [tipsImageView setImage:tipsImage];

    [theScollView addSubview:tipsImageView];
    
    UIFont *font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    
    CGFloat textHeight = [Tools caleNewsCellHeightWithTitle:resultStr font:font width:SCREEN_WIDTH - 20];
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(theScollView.frame)/2.0, SCREEN_WIDTH - 20, textHeight)];
    resultLabel.textColor = [UIColor lightGrayColor];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.text = resultStr;
    resultLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    resultLabel.numberOfLines = 0;
    
    [theScollView addSubview:resultLabel];
    
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
}
- (void)tryAgainReviewAction:(UIButton *)btn
{
    if (self.reviewResult == RealNameReviewResult_Failed) {//实名认证失败
//        //清除模型类的数据
//        [[BNNewXiaodaiRealNameInfo sharedBNNewXiaodaiRealNameInfo] clearRealNameInfo];
        
        [Tools removeLivenessDetectionImagesWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
        BNPersonalInfoViewController *infoVC = [[BNPersonalInfoViewController alloc] init];
        [self pushViewController:infoVC animated:YES];
        
    }
    else if(self.reviewResult == RealNameReviewResult_TixianFailed){//提现认证失败
        BNFCRealNameViewController *realNameVC = [[BNFCRealNameViewController alloc] init];
        [[BNRealNameInfo shareInstance] clearRealNameInfo];
        [Tools deleteAllUploadImg];
        [self pushViewController:realNameVC animated:YES];
    }
    
}



- (void)reCertify:(UIButton *)button
{
    //清除沙盒文件
    [Tools removeLivenessDetectionImagesWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    
//    //清除内存
//     [[BNNewXiaodaiRealNameInfo sharedBNNewXiaodaiRealNameInfo] clearRealNameInfo];
    
    //跳转
    BNPersonalInfoViewController *infoVC = [[BNPersonalInfoViewController alloc] init];
    [self pushViewController:infoVC animated:YES];
}

//重新上传
- (void)tryAgainUploadAction:(UIButton *)button
{
    BNUploadTools *uploadTools = [BNUploadTools shareInstance];
    NSMutableDictionary *pramData = [NSMutableDictionary dictionaryWithDictionary:@{@"service":@"realNameCertifyPersonal",  @"file_type":@"jpg", @"mimeType":@"image/jpeg"}];
    
    NSArray *file_nameArray = @[@"cert_front_path", @"cert_back_path", @"hold_cert_pic_path", @"fourth_cert_path"];
    
    __block BOOL firstImgSuccess = NO;
    __block NSString *firstImgFilePath = @"";
    
    [SVProgressHUD showWithStatus:@"正在验证..."];
    
    BNNewXiaodaiRealNameInfo  *realNameInfo = [BNNewXiaodaiRealNameInfo sharedBNNewXiaodaiRealNameInfo];
    NSArray *faceImages = [Tools getLivenessDetectionImages:shareAppDelegateInstance.boenUserInfo.userid];
    for (int i = 0; i < faceImages.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(faceImages[i], 0.5);
        [pramData setValue:imageData forKey:@"up_file"];
        [pramData setObject:file_nameArray[i] forKey:@"file_name"];
        
        __weak typeof(self) weakSelf = self;
        [uploadTools JsonParameters:pramData type:UploadFileTypeImage success:^(id responseObject) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            BNLog(@"Upload XiaoDai face Image--- %@", responseObject);
            if ([[dict valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                [SVProgressHUD dismiss];
                NSDictionary *retData = [dict valueForKey:kRequestReturnData];
                NSString *fileName = [retData valueNotNullForKey:@"file_name"];
                if ([fileName isEqualToString:@"cert_front_path"]) {
                    //第一张上传成功
                    firstImgSuccess = YES;
                    firstImgFilePath = [retData valueNotNullForKey:@"file_path"];
                    realNameInfo.realNameInfoOfFrontImgPath = firstImgFilePath;
                    
                    [XiaoDaiApi newCreditAmountApplyWithRealName:realNameInfo.realNameInfoOfName
                                                      certNumber:realNameInfo.realNameInfoOfIdentity
                                                   certFrontPath:realNameInfo.realNameInfoOfFrontImgPath
                                                          mobile:shareAppDelegateInstance.boenUserInfo.phoneNumber
                                                           grade:realNameInfo.realNameInfoOfGradeCode
                                                          degree:nil //degree不用传
                                                   andEnrollYear:realNameInfo.realNameInfoOfEnrollYear
                                                         success:^(NSDictionary *successData) {
                                                             BNLog(@"额度申请%@",successData);
                                                             if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]){
                                                                 //成功
                                                                 //查询电子协议
                                                                 [XiaoDaiApi newCreditAmountQueryEcontractSuccess:^(NSDictionary *successData) {
                                                                     if ([[successData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
                                                                         NSDictionary *dataDic = [successData valueForKey:kRequestReturnData];
                                                                         BNXiaoDaiReadServiceAgreementVC *readServiceVC = [[BNXiaoDaiReadServiceAgreementVC alloc] init];
                                                                         readServiceVC.protocalType = XiaoDaiProtocalTypeService;
                                                                         readServiceVC.econtractProtocol = [dataDic valueNotNullForKey:@"econtract"];
                                                                         [weakSelf.navigationController pushViewController:readServiceVC animated:YES];
                                                                     }else{
                                                                         NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                         [SVProgressHUD showErrorWithStatus:retMsg];
                                                                     }
                                                                     
                                                                 } failure:^(NSError *error) {
                                                                     [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                                 }];
                                                                 
                                                                 
                                                             }else
                                                             {//失败
                                                                 NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                                 BNRealNameReviewResultVC *resultVC = [[BNRealNameReviewResultVC alloc] init];
                                                                 resultVC.reviewResult = RealNameReviewResult_Failed;
                                                                 resultVC.errorInfo = retMsg;
                                                                 [weakSelf.navigationController pushViewController:resultVC animated:YES];
                                                             }
                                                         }
                                                         failure:^(NSError *error) {
                                                             [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                         }];
                    
                }
                
            }else{
                if (firstImgSuccess == NO) {
                    NSString *retMsg = [dict valueForKey:@"retmsg"];
                    [SVProgressHUD showErrorWithStatus:retMsg];
                    
                    //保存照片，下次免重新检测
                    [Tools saveLivenessDetectionImages:faceImages WithUserId:shareAppDelegateInstance.boenUserInfo.userid];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"验证成功"];
                }
                
            }
        } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } failure:^(NSError *error) {
            if (firstImgSuccess == NO) {
                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                
                //保存照片，下次免重新检测
                [Tools saveLivenessDetectionImages:faceImages WithUserId:shareAppDelegateInstance.boenUserInfo.userid];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            }
        }];
        
    }

}

@end
