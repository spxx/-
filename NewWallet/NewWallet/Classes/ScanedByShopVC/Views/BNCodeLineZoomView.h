//
//  BNCodeLineZoomView.h
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNCodeLineZoomView : UIView

@property (weak,   nonatomic) UIImageView *minionImgView;
@property (weak,   nonatomic) UILabel *QRCodeLbl;

- (id)initWithFrame:(CGRect)frame image:(UIImage *) initImg thubImgFrame:(CGRect)thubFrame lblFrame:(CGRect)lblFrame lblText:(NSString *)lblText dismiss:(void(^)(void))dismissed;

- (void)previewShow:(UIView *)superView;

@end
