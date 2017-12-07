//
//  BNUploadImgPreView.h
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNUploadImgPreView : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage *) initImg thubImgFrame:(CGRect)thubFrame thubImge:(UIImage *)thubImg;

- (void)previewShow:(UIView *)superView;

@end
