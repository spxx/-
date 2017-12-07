//
//  BNCodeLineZoomView.m
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNCodeLineZoomView.h"

typedef void (^DismissBlock)(void);

@interface BNCodeLineZoomView ()<UIScrollViewDelegate>

@property (assign, nonatomic) CGRect       thubImgRect;
@property (assign, nonatomic) BOOL        canAcceptTap;
@property (strong, nonatomic) UIImage     *originImg;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) DismissBlock dismissBlock;

@end

@implementation BNCodeLineZoomView
static CGFloat ZoomMax;
- (id)initWithFrame:(CGRect)frame image:(UIImage *) initImg thubImgFrame:(CGRect)thubFrame lblFrame:(CGRect)lblFrame lblText:(NSString *)lblText dismiss:(void(^)(void))dismissed
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _dismissBlock = dismissed;
        _originImg = initImg;
        _thubImgRect = thubFrame;
        _canAcceptTap = NO;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        scrollView.delegate = self;
        ZoomMax = 1.5;
        scrollView.maximumZoomScale = 1.0;
        scrollView.minimumZoomScale = 1.0;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    
        UILabel *QRCodeLbl = [[UILabel alloc]initWithFrame:lblFrame];
        QRCodeLbl.font = [UIFont boldSystemFontOfSize:19*NEW_BILI];
        QRCodeLbl.textColor = [UIColor blackColor];
        QRCodeLbl.textAlignment = NSTextAlignmentCenter;
            QRCodeLbl.text = lblText;
        [scrollView addSubview:QRCodeLbl];
        self.QRCodeLbl = QRCodeLbl;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:thubFrame];
        _minionImgView = imageView;
        [imageView setImage:initImg];
        [scrollView addSubview:imageView];
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:scrollView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHiddenPreView:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)tapHiddenPreView:(UITapGestureRecognizer *)tap
{
    if (_canAcceptTap) {
        _canAcceptTap = NO;
        [self previewDismiss];
    }
}

- (void)previewDismiss
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

    [UIView animateWithDuration:0.3 animations:^{

        _scrollView.transform = CGAffineTransformTranslate(_scrollView.transform, 0*NEW_BILI, -70*NEW_BILI);
        _scrollView.transform = CGAffineTransformScale(_scrollView.transform, 1/ZoomMax, 1/ZoomMax);
        _scrollView.transform = CGAffineTransformRotate (_scrollView.transform, (-90 *M_PI / 180.0));

        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0];

    } completion:^(BOOL finished) {
        if (finished) {
            _dismissBlock();
            [self removeFromSuperview];
        }
    }];
}

- (void)previewShow:(UIView *)superView
{
    [superView addSubview:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

        _scrollView.transform = CGAffineTransformScale(_scrollView.transform, ZoomMax, ZoomMax);
        _scrollView.transform = CGAffineTransformRotate (_scrollView.transform, (90 *M_PI / 180.0));
        _scrollView.transform = CGAffineTransformTranslate(_scrollView.transform, 0*NEW_BILI, 70*NEW_BILI);

    } completion:^(BOOL finished) {
        if (finished) {
            _canAcceptTap = YES;
        }
    }];
}
#pragma mark - scroll delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.minionImgView;
}


@end
