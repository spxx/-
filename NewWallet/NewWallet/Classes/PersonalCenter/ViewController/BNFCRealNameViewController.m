//
//  BNFCRealNameViewController.m
//  Wallet
//
//  Created by cyjjkz1 on 15/6/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

typedef NS_ENUM(NSInteger, BNUploadPhotoType) {
    BNUploadPhotoTypeOne,
    BNUploadPhotoTypeTwo,
    BNUploadPhotoTypeThree
};

#import "BNFCRealNameViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "BNDeleteRedPoint.h"
#import "BNUploadImgPreView.h"
#import "BNIDValidateSelectView.h"
#import "BNGradeSelectView.h"
#import "BNUploadTools.h"
#import "BNUploadProgressView.h"
#import "BNAnimitionBlockDelegate.h"
#import "BNRealNameReviewResultVC.h"
#import "TiXianApi.h"

@interface BNFCRealNameViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImage *upLoadDefaultImg;
@property (nonatomic) UIImageView *photo1ImageView;
@property (nonatomic) UIImageView *photo2ImageView;

@property (weak,   nonatomic) UILabel      *idValidateLab;
@property (assign, nonatomic) BNUploadPhotoType uploadType;

@property (weak, nonatomic) BNDeleteRedPoint     *photo1Dle;
@property (weak, nonatomic) BNDeleteRedPoint     *photo2Dle;

@property (strong, nonatomic) BNIDValidateSelectView *idValidateSelect;
@property (strong, nonatomic) BNGradeSelectView      *gradeSelect;

@property (strong, nonatomic) BNUploadProgressView *progress1UpLoad;
@property (strong, nonatomic) BNUploadProgressView *progress2UpLoad;

@property (weak, nonatomic) BNRealNameInfo *realNameInfo;

@property (weak, nonatomic) UIView *uploadPictureBK;

@property (strong, nonatomic) NSString             *certFrontPath;
@property (strong, nonatomic) NSString             *certBackPath;
@property (strong, nonatomic) NSString             *certHoldPath;



@property (weak, nonatomic) UIButton          *realnameButton;

@end

@implementation BNFCRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"实名认证";
    _uploadType = BNUploadPhotoTypeOne;
    [self setupLoadedView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self updateRealNameButtonEnabled];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self updateStatusWithPickerViewIsShow:NO];
}


- (void)setupLoadedView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.backgroundColor = UIColor_Gray_BG;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 70 * BILI_WIDTH);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    _realNameInfo = [BNRealNameInfo shareInstance];
    
//    ***********************姓名and身份证***************************
    UIView *nameAndIdBKView = [[UIView alloc] initWithFrame:CGRectMake(-1, kSectionHeight, SCREEN_WIDTH + 2, 45 * BILI_WIDTH * 2)];
    nameAndIdBKView.backgroundColor = [UIColor whiteColor];
    nameAndIdBKView.layer.borderWidth = 1.0;
    nameAndIdBKView.tag = 999;
    nameAndIdBKView.layer.borderColor = UIColor_GrayLine.CGColor;
    [_scrollView addSubview:nameAndIdBKView];
    
    
    NSArray *titlesArray = @[@"姓    名",@"身份证"];
    NSArray *placeHolder = @[@"请输入姓名",@"请输入身份证号"];
    for (int i = 0; i < 2; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, i * 45 * BILI_WIDTH, 90, 45 *BILI_WIDTH)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        titleLabel.text = titlesArray[i];
        [nameAndIdBKView addSubview:titleLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, titleLabel.frame.origin.y, SCREEN_WIDTH - 110, CGRectGetHeight(titleLabel.frame))];
        textField.placeholder = placeHolder[i];
        textField.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
        textField.tag = 100 + i;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.borderStyle = UITextBorderStyleNone;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        textField.keyboardType = UIKeyboardTypeDefault;
        textField.delegate = self;
        [textField addTarget:self action:@selector(infoTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        if (i == 1) {
           textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.text = _realNameInfo.realNameInfoOfIdentity;
        }
        else{
            textField.text = _realNameInfo.realNameInfoOfName;
        }
        [nameAndIdBKView addSubview:textField];

    }
    UIView *nameIdLine = [[UIView alloc] initWithFrame:CGRectMake(10, 45*BILI_WIDTH , SCREEN_WIDTH - 10, 0.5)];
    nameIdLine.backgroundColor = UIColor_GrayLine;
    [nameAndIdBKView addSubview:nameIdLine];
    
//    ************************身份证有效期**************************
    UIView *dateBKView = [[UIView alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(nameAndIdBKView.frame) + kSectionHeight, SCREEN_WIDTH+2, 45 * BILI_WIDTH)];
    dateBKView.backgroundColor = [UIColor whiteColor];
    dateBKView.layer.borderWidth = 1.0;
    dateBKView.layer.borderColor = UIColor_GrayLine.CGColor;
    [_scrollView addSubview:dateBKView];
    
    UILabel *dateTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (SCREEN_WIDTH - 20.0)/2.0, 45 *BILI_WIDTH)];
    dateTipLabel.backgroundColor = [UIColor clearColor];
    dateTipLabel.textColor = [UIColor blackColor];
    dateTipLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    dateTipLabel.text = @"身份证有效期";
    [dateBKView addSubview:dateTipLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 20.0)/2.0, 0, (SCREEN_WIDTH - 20.0)/2.0, 45 *BILI_WIDTH)];
    _idValidateLab = dateLabel;
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    NSString *validate = [_realNameInfo getRealNameInfoOfValidateHasPoint];
    dateLabel.text = validate.length > 0 ? validate : @"例:2012.2.12";
    [dateBKView addSubview:dateTipLabel];
    [dateBKView addSubview:dateLabel];
    
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(0, 0, CGRectGetWidth(dateBKView.frame), CGRectGetHeight(dateBKView.frame));
    dateButton.backgroundColor = [UIColor clearColor];
    [dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateBKView addSubview:dateButton];
    
    
//    *************************上传照片and查看示例**************************
    UILabel *upLoadTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(dateBKView.frame), SCREEN_WIDTH - 20, 40*BILI_WIDTH)];
    upLoadTipLabel.backgroundColor = [UIColor clearColor];
    upLoadTipLabel.textColor = [UIColor blackColor];
    upLoadTipLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    upLoadTipLabel.text = @"上传照片";
    [_scrollView addSubview:upLoadTipLabel];
    
    UIButton *exampleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    exampleBtn.frame = CGRectMake(SCREEN_WIDTH - (80+10)*BILI_WIDTH, CGRectGetMaxY(dateBKView.frame) , 80*BILI_WIDTH, 40*BILI_WIDTH);
    exampleBtn.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    [exampleBtn setImage:[UIImage imageNamed:@"XiaoDai_searchBtn"] forState:UIControlStateNormal];
    [exampleBtn setTitle:@"查看示例" forState:UIControlStateNormal];
    [exampleBtn setTitleColor:UIColorFromRGB(0x0733ee) forState:UIControlStateNormal];
    [exampleBtn addTarget:self action:@selector(showExampleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:exampleBtn];

//    ****************************上传身份证正反面***************************
    CGFloat photoWidth = [BNTools sizeFit:90 six:100 sixPlus:120];
    
    UIView *uploadBKView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upLoadTipLabel.frame), SCREEN_WIDTH, 3 * (photoWidth + 12) + 30)];
    
    uploadBKView.backgroundColor = [UIColor whiteColor];
    uploadBKView.tag = 666;
    _uploadPictureBK = uploadBKView;
    [_scrollView addSubview:uploadBKView];
    
    
     _upLoadDefaultImg = [BNHandleImageTool createUploadDefaultBackGroundImage];
    
    UIImageView *photo1BK = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, photoWidth, photoWidth)];
    [photo1BK setImage:_upLoadDefaultImg];
    
    UIImageView *photo1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, photoWidth, photoWidth)];
    photo1.backgroundColor = [UIColor clearColor];
    photo1.userInteractionEnabled = YES;
    _photo1ImageView = photo1;
    
    __weak typeof(self) weakSelf = self ;

    
    BNDeleteRedPoint *photo1Delete = [[BNDeleteRedPoint alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photo1.frame) - 12, CGRectGetMinY(photo1.frame) - 12, 24, 24) relateImgView:photo1 deleteBlock:^(UIImageView *imgView) {
        [weakSelf updateStatusWithPickerViewIsShow:NO];
        weakSelf.certFrontPath = nil;
        weakSelf.realNameInfo.tiXianFrontImgPath = nil;
        weakSelf.realnameButton.enabled = NO;
        //添加删除图片动画
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf animitionDeleteThumbnail:weakSelf.photo1ImageView];
        });
        [weakSelf deleteUploadImgInDocuments:BNUploadPhotoTypeOne];
    }];
    _photo1Dle = photo1Delete;
    
    if (_realNameInfo.tiXianFrontImgPath.length > 0) {
        UIImage *photo1Img = [UIImage imageWithContentsOfFile:[self pathForUpLoadPhotoWithType:BNUploadPhotoTypeOne]];
        if (photo1Img != nil) {
            [photo1 setImage:[BNHandleImageTool thumbnailWithImage:photo1Img size:CGSizeMake(270, 270)]];
            photo1Delete.hidden = NO;
        }else{
            [photo1 setImage:nil];
            photo1Delete.hidden = YES;
            _realNameInfo.tiXianFrontImgPath = nil;
        }
    }else{
        [photo1 setImage:nil];
        photo1Delete.hidden = YES;
        _realNameInfo.tiXianFrontImgPath = nil;
    }
    [uploadBKView addSubview:photo1Delete];
    
    
    UIImageView *photo2BK = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(photo1.frame) + 12, photoWidth, photoWidth)];
    [photo2BK setImage:_upLoadDefaultImg];
    
    UIImageView *photo2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(photo1.frame) + 12, photoWidth, photoWidth)];
    photo2.backgroundColor = [UIColor clearColor];
    photo2.userInteractionEnabled = YES;
    _photo2ImageView = photo2;
    
    BNDeleteRedPoint *photo2Delete = [[BNDeleteRedPoint alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photo2.frame) - 12, CGRectGetMinY(photo2.frame) - 12, 24, 24) relateImgView:photo2 deleteBlock:^(UIImageView *imgView) {
        [weakSelf updateStatusWithPickerViewIsShow:NO];
        weakSelf.certBackPath = nil;
        weakSelf.realNameInfo.tiXianBackImgPath = nil;
        weakSelf.realnameButton.enabled = NO;
        //添加删除图片动画
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf animitionDeleteThumbnail:weakSelf.photo2ImageView];
        });
        [weakSelf deleteUploadImgInDocuments:BNUploadPhotoTypeTwo];
    }];
    _photo2Dle = photo2Delete;
    
    if (_realNameInfo.tiXianBackImgPath.length > 0) {
        
        UIImage *photo2Img = [UIImage imageWithContentsOfFile:[self pathForUpLoadPhotoWithType:BNUploadPhotoTypeTwo]];
        if (photo2Img) {
            [photo2 setImage:[BNHandleImageTool thumbnailWithImage:photo2Img size:CGSizeMake(270, 270)]];
            photo2Delete.hidden = NO;
        }else{
            [photo2 setImage:nil];
            photo2Delete.hidden = YES;
            _realNameInfo.tiXianBackImgPath = nil;
        }
    }else{
        [photo2 setImage:nil];
        photo2Delete.hidden = YES;
        _realNameInfo.tiXianBackImgPath = nil;
    }

    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoAction1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoAction2:)];
    
    [photo1 addGestureRecognizer:tap1];
    [photo2 addGestureRecognizer:tap2];
    
    [uploadBKView addSubview:photo1BK];
    [uploadBKView addSubview:photo2BK];
    
    [uploadBKView addSubview:photo1];
    [uploadBKView addSubview:photo2];
    
    [uploadBKView addSubview:photo1Delete];
    [uploadBKView addSubview:photo2Delete];
 
    

    UILabel *photo1Tip = [[UILabel alloc] initWithFrame:CGRectMake(10 + photoWidth + 20, CGRectGetMinY(photo1.frame), SCREEN_WIDTH - 120, 26)];
    photo1Tip.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    photo1Tip.textColor = [UIColor blackColor];
    photo1Tip.textAlignment = NSTextAlignmentLeft;
    photo1Tip.text = @"身份证正面照";

    
    UILabel *rulePhoto1Tip = [[UILabel alloc] initWithFrame:CGRectMake(10 + photoWidth + 20, CGRectGetMaxY(photo1Tip.frame), SCREEN_WIDTH - photoWidth - 30, photoWidth - 26)];
    rulePhoto1Tip.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    rulePhoto1Tip.textColor = [UIColor lightGrayColor];
    rulePhoto1Tip.textAlignment = NSTextAlignmentLeft;
    rulePhoto1Tip.numberOfLines = 3;
    rulePhoto1Tip.text = @"要求:\n身份证件完整\n证件字迹清晰";

    
    UILabel *photo2Tip = [[UILabel alloc] initWithFrame:CGRectMake(10 + photoWidth + 20, CGRectGetMinY(photo2.frame), SCREEN_WIDTH - photoWidth - 30, 26)];
    photo2Tip.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    photo2Tip.textColor = [UIColor blackColor];
    photo2Tip.textAlignment = NSTextAlignmentLeft;
    photo2Tip.text = @"身份证背面照";

    
    UILabel *rulePhoto2Tip = [[UILabel alloc] initWithFrame:CGRectMake(10 + photoWidth + 20, CGRectGetMaxY(photo2Tip.frame), SCREEN_WIDTH - photoWidth - 30, photoWidth - 26)];
    rulePhoto2Tip.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    rulePhoto2Tip.textColor = [UIColor lightGrayColor];
    rulePhoto2Tip.textAlignment = NSTextAlignmentLeft;
    rulePhoto2Tip.numberOfLines = 3;
    rulePhoto2Tip.text = @"要求:\n身份证件完整\n证件字迹清晰";
    
    
    
    [uploadBKView addSubview:photo1Tip];
    [uploadBKView addSubview:photo2Tip];

    [uploadBKView addSubview:rulePhoto1Tip];
    [uploadBKView addSubview:rulePhoto2Tip];




//    **************************提交审核******************************
    UIButton *realNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    realNameBtn.frame = CGRectMake(10*BILI_WIDTH, CGRectGetMaxY(photo2BK.frame)+ 25 * BILI_WIDTH, SCREEN_WIDTH - 2 * 10 * BILI_WIDTH, 40 * BILI_WIDTH);
    [realNameBtn setupRedBtnTitle:@"提交审核" enable:NO];
    [realNameBtn addTarget:self action:@selector(submitAuditing:) forControlEvents:UIControlEventTouchUpInside];
    [uploadBKView addSubview:realNameBtn];
    self.realnameButton = realNameBtn;
    
    BNIDValidateSelectView *selectDate = [[BNIDValidateSelectView alloc] initWithDelegate:self];
    _idValidateSelect = selectDate;

}




#pragma mark - ButtonAction

//backButton
- (void)backButtonClicked:(UIButton *)sender
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *skipVC = nil;
    Class tempClass =  NSClassFromString(@"BNBalanceViewController");
    for (UIViewController *obj in viewControllers) {
        if ([obj isKindOfClass:tempClass] == YES) {
            skipVC = (UIViewController *)obj;
            break;
        }
    }
    if (skipVC) {
        [self.navigationController popToViewController:skipVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
//身份证有效期按钮
- (void)dateButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    [self updateStatusWithPickerViewIsShow:YES];
}
//查看示例按钮
- (void)showExampleAction:(UIButton *)button
{
    [self.view endEditing:YES];
    [self updateStatusWithPickerViewIsShow:NO];
    CGRect btnFrame = button.frame;
    CGPoint contentOffset = _scrollView.contentOffset;
    CGRect convertRect = CGRectMake(CGRectGetMinX(btnFrame), CGRectGetMinY(btnFrame) + self.sixtyFourPixelsView.viewBottomEdge - contentOffset.y, CGRectGetWidth(btnFrame), CGRectGetHeight(btnFrame));
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tiXianExample" ofType:@"png"];
    UIImage *originImg = [UIImage imageWithContentsOfFile:path];
    
    BNUploadImgPreView *preView = [[BNUploadImgPreView alloc] initWithFrame:[UIScreen mainScreen].bounds image:originImg thubImgFrame:convertRect thubImge:nil];
    [preView previewShow:self.view];
}
//提交审核按钮
- (void)submitAuditing:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    UIView *nameAndIdBKView = [_scrollView viewWithTag:999];
    UITextField *nameTf = (UITextField *)[nameAndIdBKView viewWithTag:100];
    UITextField *IdTf = (UITextField *)[nameAndIdBKView viewWithTag:101];
    
    [SVProgressHUD showWithStatus:@"正在提交实名信息..."];
    [TiXianApi realnameCertifyApplyWithRealName:nameTf.text
                                       certType:nil
                                     certNumber:IdTf.text
                                  certValidTime:[weakSelf.realNameInfo getRealNameInfoOfValidateHasNotPoint]
                                   cerFrontPath:weakSelf.realNameInfo.tiXianFrontImgPath
                                   certBackPath:weakSelf.realNameInfo.tiXianBackImgPath
                                     occupation:nil
                                         mobile:nil
                                        address:nil
                                    attribution:nil success:^(NSDictionary *returnData) {
                                        BNLog(@"tixian  RealName  response%@",returnData);
                                        if ([[returnData valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                                        {
                                            //实名信息提交成功
                                            [SVProgressHUD dismiss];
                                            BNRealNameReviewResultVC *resultVC= [[BNRealNameReviewResultVC alloc] init];
                                            resultVC.reviewResult = RealNameReviewResult_TixianReviewing;
                                            [weakSelf pushViewController:resultVC animated:YES];
                                            //删除所有认证图片
                                            [weakSelf.realNameInfo clearRealNameInfo];
                                            [Tools deleteAllUploadImg];
                                        }
                                        else
                                        {
                                            [SVProgressHUD showErrorWithStatus:returnData[kRequestRetMessage]];
                                        }
                                    } failure:^(NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                    }];

}

// 上传身份证正面照
- (void)addPhotoAction1:(UITapGestureRecognizer *)gesture
{
    UIImage *image = _photo1ImageView.image;
    
    if (image == nil)
    {
        __weak typeof(self) weakSelf = self;
        UIView *uploadView = [_scrollView viewWithTag:666];
        CGRect rect = uploadView.frame;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, rect.origin.y)];
        } completion:^(BOOL finished) {
            weakSelf.uploadType = BNUploadPhotoTypeOne;
            [weakSelf showActionSheet];
        }];
    }
    else
    {
        CGRect rect = [self convertViewFrameToWindowFrameWithView:_photo1ImageView];
        NSString *path = [self pathForUpLoadPhotoWithType:BNUploadPhotoTypeOne];
        UIImage *originImg = [UIImage imageWithContentsOfFile:path];
        BNUploadImgPreView *preView = [[BNUploadImgPreView alloc] initWithFrame:[UIScreen mainScreen].bounds image:originImg thubImgFrame:rect thubImge:image];
        [self.view endEditing:YES];
        [preView previewShow:self.view];
    }

}

//上传身份证背面照
- (void)addPhotoAction2:(UITapGestureRecognizer *)gesture
{
    UIImage *image = _photo2ImageView.image;
    
    if (image == nil) {
        __weak typeof(self) weakSelf = self;
        UIView *uploadView = [_scrollView viewWithTag:666];
        CGRect rect = uploadView.frame;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, rect.origin.y)];
        } completion:^(BOOL finished) {
            weakSelf.uploadType = BNUploadPhotoTypeTwo;
            [weakSelf showActionSheet];
        }];
    }else{
        CGRect rect = [self convertViewFrameToWindowFrameWithView:_photo2ImageView];
        NSString *path = [self pathForUpLoadPhotoWithType:BNUploadPhotoTypeTwo];
        UIImage *originImg = [UIImage imageWithContentsOfFile:path];
        BNUploadImgPreView *preView = [[BNUploadImgPreView alloc] initWithFrame:[UIScreen mainScreen].bounds image:originImg thubImgFrame:rect thubImge:image];
        [self.view endEditing:YES];
        [preView previewShow:self.view];
    }

}


// 隐藏或开启pickerView
- (void)updateStatusWithPickerViewIsShow:(BOOL) isShowValidate
{
    if (isShowValidate == YES)
    {
        if (self.idValidateSelect.pickIsShow == NO)
        {
            [self.idValidateSelect show];
        }
    }else
    {
        if (self.idValidateSelect.pickIsShow == YES)
        {
            [self.idValidateSelect dismiss];
        }
    }
    
}



#pragma mark show action sheet
- (void)showActionSheet
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"相 册" otherButtonTitles:@"照相机", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    switch (buttonIndex) {
        case 0:
        {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if(author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied){
                shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->照片\"处进行设置" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [shareAppDelegateInstance.alertView show];
                return;
            }
            
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.delegate = self;
                picker.allowsEditing = YES;  //是否可编辑
                //摄像头
                picker.videoQuality = UIImagePickerControllerQualityTypeLow;
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                //如果没有提示用户
                [SVProgressHUD showErrorWithStatus:@"您没有摄像头"];
            }
        }
            break;
            
        case 1:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有授权我们访问您的相册和照相机,请在\"设置->隐私->相机\"处进行设置" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [shareAppDelegateInstance.alertView show];
                return;
            }
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                picker.delegate = self;
                picker.allowsEditing = YES;  //是否可编辑
                //摄像头
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                //如果没有提示用户
                [SVProgressHUD showErrorWithStatus:@"您没有摄像头"];
            }
        }
            break;
      case 2:
        {
           [UIView animateWithDuration:0.3 animations:^{
               _scrollView.contentOffset = CGPointMake(0, 0);
           }];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self updateStatusWithPickerViewIsShow:NO];
    if (SCREEN_HEIGHT == 568) {
        if (textField.tag == 111 || textField.tag == 112) {
            [UIView animateWithDuration:.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0, kSectionHeight + 45 *BILI_WIDTH)];
            }];
        }
        
    }
    if (SCREEN_HEIGHT == 480) {
        if (textField.tag == 111 ) {
            [UIView animateWithDuration:.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0, kSectionHeight + 45 *BILI_WIDTH)];
            }];
        }
        if (textField.tag == 112 ) {
            [UIView animateWithDuration:.3 animations:^{
                [_scrollView setContentOffset:CGPointMake(0, kSectionHeight + 45 *BILI_WIDTH * 2)];
            }];
            
        }
        
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateRealNameButtonEnabled];
}

- (void)infoTextFieldChanged:(UITextField *)tf
{
    switch (tf.tag) {
        case 100:
        {
            NSString *nameStr = tf.text;
            if (nameStr.length > 20) {
                nameStr = [nameStr substringWithRange:NSMakeRange(0, 20)];
                tf.text = nameStr;
            }
            self.realNameInfo.realNameInfoOfName = nameStr;
        }
            break;
            
        case 101:
        {
            self.realNameInfo.realNameInfoOfIdentity = tf.text;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark UIImagePickerControllerDelegate UINavigationControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    UIImage *thumbnailImage = [BNHandleImageTool thumbnailWithImage:image size:CGSizeMake(270, 270)];
    BNUploadTools *uploadTools = [BNUploadTools shareInstance];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableDictionary *pramData = [NSMutableDictionary dictionaryWithDictionary:@{@"service":@"realNameCertifyPersonal",  @"file_type":@"png", @"mimeType":@"image/png", @"up_file":imageData}];
    
    __weak typeof(self) weakSelf = self;
    switch (_uploadType) {
        case BNUploadPhotoTypeOne:
        {
            [_photo1ImageView setImage:thumbnailImage];
            [UIImagePNGRepresentation(image) writeToFile:[self pathForUpLoadPhotoWithType:BNUploadPhotoTypeOne] atomically:YES];
            [self createProgressViewWithType:BNUploadPhotoTypeOne totalSize:imageData.length];
            [_uploadPictureBK insertSubview:_progress1UpLoad belowSubview:_photo1Dle];
            [pramData setObject:@"cert_front_path" forKey:@"file_name"];
            //上传文件请求
            [uploadTools uploadTiXianFileWithParameters:pramData success:^(id responseObject) {
                NSDictionary *dict = (NSDictionary *)responseObject;
                BNLog(@"Update cert front %@", responseObject);
                if ([[dict valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                {
                    NSDictionary *retData = [dict valueForKey:kRequestReturnData];
                    
                    weakSelf.realNameInfo.tiXianFrontImgPath = [retData valueForKey:@"file_path"];
                    
                    weakSelf.photo1Dle.hidden = NO;
                    
                    [weakSelf updateRealNameButtonEnabled];
                }
                else
                {
                    NSString *retMsg = [dict valueForKey:@"retmsg"];
                    [SVProgressHUD showErrorWithStatus:retMsg];
                }

                
            } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite)
            {
                [weakSelf.progress1UpLoad changeProgressWithDataSize:totalBytesWritten amountSize:totalBytesExpectedToWrite];
                
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
            }];
        }
            break;

        case BNUploadPhotoTypeTwo:
        {
            [_photo2ImageView setImage:thumbnailImage];
            [UIImagePNGRepresentation(image) writeToFile:[self pathForUpLoadPhotoWithType:BNUploadPhotoTypeTwo] atomically:YES];
            [self createProgressViewWithType:BNUploadPhotoTypeTwo totalSize:imageData.length];
            [_uploadPictureBK insertSubview:_progress2UpLoad belowSubview:_photo2Dle];
            
            [pramData setObject:@"cert_back_path" forKey:@"file_name"];
            [uploadTools uploadTiXianFileWithParameters:pramData success:^(id responseObject) {
                NSDictionary *dict = (NSDictionary *)responseObject;
                BNLog(@"Update cert front %@", responseObject);
                if ([[dict valueForKey:kRequestRetCode] isEqualToString:kRequestSuccessCode])
                {
                    NSDictionary *retData = [dict valueForKey:kRequestReturnData];
                    
                    weakSelf.realNameInfo.tiXianBackImgPath = [retData valueForKey:@"file_path"];
                    
                    weakSelf.photo2Dle.hidden = NO;
                    
                    [weakSelf updateRealNameButtonEnabled];
                }
                else
                {
                    NSString *retMsg = [dict valueForKey:@"retmsg"];
                    [SVProgressHUD showErrorWithStatus:retMsg];
                }
                
                
            } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite)
             {
                 [weakSelf.progress2UpLoad changeProgressWithDataSize:totalBytesWritten amountSize:totalBytesExpectedToWrite];
                 
             } failure:^(NSError *error) {
                 [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
             }];
        }
            break;

        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        _scrollView.contentOffset = CGPointZero;
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
         _scrollView.contentOffset = CGPointZero;
    }];
}
#pragma mark  BNIDValidateSelectDelegate 选择身份证有效期
- (void)selectedIDValidate:(NSString *)str
{
    _idValidateLab.text = str;
    self.realNameInfo.realNameInfoOfValidate = str;
    if ([self.realNameInfo checkTiXianRealNameInfoCanSubmit]) {
        _realnameButton.enabled = YES;
    }else{
        _realnameButton.enabled = NO;
    }
}

#pragma mark -Other Custom Method

/***
 ***预览需要上传的图片，转换为屏幕坐标转换
 ***/
- (CGRect)convertViewFrameToWindowFrameWithView:(UIImageView *)imgView
{
    CGRect imgViewFrame = imgView.frame;
    CGRect superViewFrame = imgView.superview.frame;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    
    CGRect convertRect = CGRectMake(CGRectGetMinX(imgViewFrame), CGRectGetMinY(superViewFrame) + CGRectGetMinY(imgViewFrame) + self.sixtyFourPixelsView.viewBottomEdge - contentOffset.y, CGRectGetWidth(imgViewFrame), CGRectGetHeight(imgViewFrame));
    
    return convertRect;
}

/***
 ***创建显示上传进度
 ***/
- (void)createProgressViewWithType:(BNUploadPhotoType)type totalSize:(long long) size
{
    CGRect rect = CGRectZero;
    switch (type) {
        case BNUploadPhotoTypeOne:
        {
            rect = _photo1ImageView.frame;
            _progress1UpLoad = [[BNUploadProgressView alloc] initWithFrame:rect];
            _progress1UpLoad.backgroundColor = [UIColor clearColor];
        }
            
            break;
        case BNUploadPhotoTypeTwo:
        {
            rect = _photo2ImageView.frame;
            _progress2UpLoad = [[BNUploadProgressView alloc] initWithFrame:rect];
            _progress2UpLoad.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }
}

/***
 ***返回保存图片的路径
 ***/
- (NSString *)pathForUpLoadPhotoWithType:(BNUploadPhotoType) type
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Img"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDic = NO;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDic]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    switch (type) {
        case BNUploadPhotoTypeOne:
        {
            filePath = [filePath stringByAppendingPathComponent:@"tiXianUpLoadPhoto1.png"];
        }
            break;
            
        case BNUploadPhotoTypeTwo:
            filePath = [filePath stringByAppendingPathComponent:@"tiXianUpLoadPhoto2.png"];
            break;
            
        default:
            break;
    }
    return filePath;
}
/***
 ***删除上传图片的动画
 ***/
- (void)animitionDeleteThumbnail:(UIImageView *)imgView
{
    CGRect frame = imgView.frame;
    CABasicAnimation *animit1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animit1.removedOnCompletion = YES;
    animit1.fillMode = kCAFillModeForwards;
    animit1.fromValue = [NSValue valueWithCGRect:frame];
    animit1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    [animit1 setRemovedOnCompletion:YES];
    
    CABasicAnimation *animit2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animit2 setRemovedOnCompletion:YES];
    animit2.removedOnCompletion = YES;
    animit2.fillMode = kCAFillModeForwards;
    animit2.fromValue = [NSValue valueWithCGPoint:imgView.center];
    animit2.toValue   = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
    
    CAAnimationGroup *animitGroup = [CAAnimationGroup animation];
    [animitGroup setRemovedOnCompletion:YES];
    animitGroup.removedOnCompletion = YES;
    animitGroup.fillMode = kCAFillModeForwards;
    animitGroup.animations = @[animit1, animit2];
    animitGroup.duration = 0.3;
    animitGroup.delegate = [BNAnimitionBlockDelegate animationDelegateWithBeginning:nil completion:^(BOOL finished) {
        [imgView setImage:nil];
        imgView.frame = frame;
    }];
    animitGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [imgView.layer addAnimation:animitGroup forKey:nil];
    imgView.layer.bounds = CGRectMake(0, 0, 1, 1);
    imgView.layer.position = CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame));
}
/***
 ***删除图片
 ***/
- (void)deleteUploadImgInDocuments:(BNUploadPhotoType)type
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Img"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    switch (type) {
        case BNUploadPhotoTypeOne:
        {
            filePath = [filePath stringByAppendingPathComponent:@"tiXianUpLoadPhoto1.png"];
        }
            break;
            
        case BNUploadPhotoTypeTwo:
            filePath = [filePath stringByAppendingPathComponent:@"tiXianUpLoadPhoto2.png"];
            break;
        default:
            break;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            BNLog(@"Delete upload img %@", error.localizedDescription);
        }
    });
}

/***
 ***更新提交实名信息的button可用状态
 ***/
- (void)updateRealNameButtonEnabled{
    if ([_realNameInfo checkTiXianRealNameInfoCanSubmit]) {
        _realnameButton.enabled = YES;
    }else{
        _realnameButton.enabled = NO;
    }
}


//点击键盘return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
