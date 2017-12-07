//
//  BNCodeImgZoomView.m
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNCodeImgZoomView.h"

typedef void (^DismissBlock)(void);

@interface BNCodeImgZoomView ()<UIScrollViewDelegate>

@property (assign, nonatomic) CGRect       thubImgRect;
@property (assign, nonatomic) BOOL        canAcceptTap;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) DismissBlock dismissBlock;

@end

@implementation BNCodeImgZoomView
static CGFloat ZoomMax;

- (id)initWithFrame:(CGRect)frame image:(UIImage *) initImg thubImgFrame:(CGRect)thubFrame dismiss:(void (^)(void))dismissed{
    self = [super initWithFrame:frame];
    
    if (self) {
        _dismissBlock = dismissed;
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
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

    [UIView animateWithDuration:0.3 animations:^{
        _minionImgView.frame = _thubImgRect;
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
        _minionImgView.frame = CGRectMake(_thubImgRect.origin.x-(_thubImgRect.size.width*(ZoomMax-_scrollView.minimumZoomScale))/2, (_scrollView.frame.size.height-_thubImgRect.size.height-64)/2, _thubImgRect.size.width*ZoomMax, _thubImgRect.size.height*ZoomMax);
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
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
