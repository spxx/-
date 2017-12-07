//
//  BNUploadImgPreView.m
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNUploadImgPreView.h"

@interface BNUploadImgPreView ()<UIScrollViewDelegate>

@property (weak,   nonatomic) UIImageView *minionImgView;
@property (assign, nonatomic) CGRect       thubImgRect;
@property (assign, nonatomic) BOOL        canAcceptTap;
@property (strong, nonatomic) UIImage     *originImg;
@property (strong, nonatomic) UIImage     *thubImg;
@property (weak, nonatomic) UIScrollView *scrollView;
@end

@implementation BNUploadImgPreView

- (id)initWithFrame:(CGRect)frame image:(UIImage *) initImg thubImgFrame:(CGRect)thubFrame thubImge:(UIImage *)tImg{
    self = [super initWithFrame:frame];
    
    if (self) {
        _originImg = initImg;
        _thubImg   = tImg;
        _thubImgRect = thubFrame;
        _canAcceptTap = NO;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame) + 1.0, CGRectGetHeight(frame) + 1.0);
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        [self addSubview:scrollView];
        _scrollView = scrollView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:thubFrame];
        _minionImgView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:initImg];
        [scrollView addSubview:imageView];
    
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
    
    _scrollView.zoomScale = 1.0;
    self.backgroundColor = [UIColor clearColor];
    if (_thubImg != nil) {
        [_minionImgView setImage:_thubImg];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _minionImgView.frame = _thubImgRect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)previewShow:(UIView *)superView
{
    [superView addSubview:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.2 animations:^{
        _minionImgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.alpha = 1.0;
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
