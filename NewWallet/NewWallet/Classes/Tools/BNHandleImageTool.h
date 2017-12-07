//
//  BNHandleImageTool.h
//  Wallet
//
//  Created by mac1 on 15/5/18.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNHandleImageTool : NSObject

//制作缩略图，image为原始图片, size是想要得大小
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;


//创建上传图片控件的默认图片 虚线加白色十字架
+ (UIImage *)createUploadDefaultBackGroundImage;

@end
