//
//  ScanViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 16/5/10.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MaskView.h"
#import "ScanToPayApi.h"
#import "ScanToPayDetailViewController.h"
#import "CustomButton.h"
//#import "BNCommonWebViewController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (weak, nonatomic) UIView *scanLine;

@end

@implementation ScanViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        // Add the input to the session
        [self.session addInput:input];
    } else {
        BNLog(@"error: %@", error);
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相机隐私授权尚未打开，无法使用相机功能。请前往“设置-隐私-相机”中打开。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        shareAppDelegateInstance.alertView.tag = 103;
        [shareAppDelegateInstance.alertView show];
        return;
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.bounds = self.view.bounds;
    previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view.layer addSublayer:previewLayer];
    self.previewLayer = previewLayer;
    
    MaskView *bg = [[MaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:bg];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [self.session addOutput:output];
    // What different things can we register to recognise?
    //BNLog(@"%@", [output availableMetadataObjectTypes]);
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code]];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    /*AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.session addOutput:videoOutput];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("videoQueue", NULL);
    [videoOutput setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    videoOutput.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];*/
    
    // Start the AVSession running
    [self.session startRunning];
    
    UIImageView *frameView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-260)/2, (SCREEN_HEIGHT-260)/2, 260, 260)];
    frameView.image = [UIImage imageNamed:@"scan_frame"];
    [self.view addSubview:frameView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-250)/2, 250, 60)];
    line.image = [[UIImage imageNamed:@"scan_line"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [self.view addSubview:line];
    self.scanLine = line;
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(250-60);
    animation.duration = 2;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [line.layer addAnimation:animation forKey:@"scan"];
    
    [self.view bringSubviewToFront:self.sixtyFourPixelsView];
    self.sixtyFourPixelsView.backgroundColor = [UIColor blackColor];
    self.navigationTitle = @"扫码";
    self.navigationTitleColor = [UIColor whiteColor];
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
}

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startScan {
    [self.session startRunning];
    self.scanLine.layer.speed = 1.0;
}

- (void)stopScan {
    [self.session stopRunning];
    self.scanLine.layer.speed = 0;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]
			|| [metadata.type isEqualToString:AVMetadataObjectTypeEAN8Code]
			|| [metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
			
			[self stopScan];
			
            AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)metadata;
            // Update the view with the decoded text
            NSString *text = [transformed stringValue];
            BNLog(@"Result: %@", text);
            
            if ([text hasPrefix:@"https://"] || [text hasPrefix:@"http://"]) {
                if ([text hasPrefix:[NSString stringWithFormat:@"%@/external/shop_pay_biz/v1/scan_qr_code", BASE_URL]]) {
                    [SVProgressHUD show];
                    __weak __typeof(self) weakSelf = self;
                    [ScanToPayApi getPayInfo:text succeed:^(NSDictionary *returnData) {
                        BNLog(@"Info: %@", returnData);
                        
                        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
                        if ([retCode isEqualToString:@"000000"]) {
                            [SVProgressHUD dismiss];
                            ScanToPayDetailViewController *detailViewController = [[ScanToPayDetailViewController alloc] init];
                            detailViewController.shopInfo = returnData[kRequestReturnData];
                            [self pushViewController:detailViewController animated:YES];
                            
                        } else {
                            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:retMsg];
                                [weakSelf startScan];
                            });
                        }
                    } failure:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                            [weakSelf startScan];
                        });
                    }];
                } else {

					[SVProgressHUD show];
					__weak __typeof(self) weakSelf = self;
					[ScanToPayApi checkURLIsInternal:text succeed:^(NSDictionary *returnData) {
						BNLog(@"check url internal: %@", returnData);
						
						NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
						NSDictionary *data = returnData[kRequestReturnData];
						if ([retCode isEqualToString:@"000000"]) {
							[SVProgressHUD dismiss];

							if ([data[@"is_internal_url"] integerValue] == 1) {
								CustomButton *button = [[CustomButton alloc] init];
								button.biz_h5_url = text;
                                button.fromHomeScan = _fromHomeScan;
								[self suDoKuButtonAction:button];
							} else {
								UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此链接是外部链接，非喜付认证，可能有风险，是否要打开？" message:text delegate:self cancelButtonTitle:@"打开" otherButtonTitles:@"取消", nil];
								alertView.tag = 101;
								[alertView show];
							}
						} else {
							NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
							dispatch_async(dispatch_get_main_queue(), ^{
								[SVProgressHUD showErrorWithStatus:retMsg];
								[weakSelf startScan];
							});
						}

					} failure:^(NSError *error) {
						dispatch_async(dispatch_get_main_queue(), ^{
							[SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
							[weakSelf startScan];
						});
					}];
					
                }
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:self cancelButtonTitle:@"复制" otherButtonTitles:@"取消", nil];
                alertView.tag = 102;
                [alertView show];
            }
        }
    }
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
//    [self.session stopRunning];
//    // Create a UIImage from the sample buffer data
//    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            //BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
            //webViewController.navTitle = @"喜付";
            //[webViewController setUrlString:alertView.message];
            //[self pushViewController:webViewController animated:YES];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
        } else {
            [self startScan];
        }
    } else if (alertView.tag == 102) {
        if (buttonIndex == 0) {
            [[UIPasteboard generalPasteboard] setString:alertView.message];
            __weak __typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"复制成功"];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self startScan];
        }
    } else if (alertView.tag == 103) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
