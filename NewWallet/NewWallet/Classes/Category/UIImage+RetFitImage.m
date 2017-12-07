//
//  UIImage+RetFitImage.m
//  NewWallet
//
//  Created by mac1 on 14-11-19.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "UIImage+RetFitImage.h"

@implementation UIImage (RetFitImage)
+ (UIImage *)returnFitImageWithName:(NSString *) name
{
    UIImage *fitImage = nil;
    CGFloat screenHeight = SCREEN_HEIGHT;
    NSString *imageNmae = nil;
    if (name.length > 0) {
        if (screenHeight <= 480.0) {//iPhone4
            imageNmae = [NSString stringWithFormat:@"%@_iphone4", name];
        }else if(screenHeight <= 568.0){
            imageNmae = [NSString stringWithFormat:@"%@_iphone5", name];
        }else if(screenHeight <= 667.0){
            imageNmae = [NSString stringWithFormat:@"%@_iphone6", name];
        }else if(screenHeight <= 736.0){
            imageNmae = [NSString stringWithFormat:@"%@_iphone6p", name];
        }
        fitImage = [UIImage imageNamed:imageNmae];
    }
    return fitImage;
}
@end
