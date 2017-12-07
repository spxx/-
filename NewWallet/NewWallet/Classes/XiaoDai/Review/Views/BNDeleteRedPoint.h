//
//  BNDeleteRedPoint.h
//  Wallet
//
//  Created by mac1 on 15/4/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DeleteImgAction)(UIImageView *imgView);

@interface BNDeleteRedPoint : UIView

- (id)initWithFrame:(CGRect)frame relateImgView:(UIImageView *)imgView deleteBlock:(DeleteImgAction)delBlock;
@end
