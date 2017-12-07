//
//  CustomButton.m
//  Wallet
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "CustomButton.h"

#define BILI ([UIScreen mainScreen].bounds.size.width/320)

@interface CustomButton ()

@property (nonatomic) CGFloat imgTopY;
@property (nonatomic) CGFloat imgHeight;
@property (nonatomic) CGFloat textBottomY;

@end
@implementation CustomButton

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpButtonData:@{}];
    }
    return self;
}
-(void)setUpWithImgTopY:(CGFloat)imgTopY imgHeight:(CGFloat)imgHeight textBottomY:(CGFloat)textBottomY
{
    _imgTopY = imgTopY;
    _imgHeight = imgHeight;
    _textBottomY = textBottomY;

//        self.layer.borderColor = UIColorFromRGB(0xd2d2d2).CGColor;
//        self.layer.borderWidth = .5;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:10*BILI_WIDTH];
    
    UIImage *image1 = [Tools imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    UIImage *image2 = [Tools imageWithColor:[UIColor groupTableViewBackgroundColor] andSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    [self setBackgroundImage:image1 forState:UIControlStateNormal];
    [self setBackgroundImage:image2 forState:UIControlStateHighlighted];
    [self setTitleColor:UIColor_XiaoDaiCellGray_Text forState:UIControlStateNormal];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //图片的位置大小
    return CGRectMake((contentRect.size.width-_imgHeight)/2,_imgTopY, _imgHeight, _imgHeight);}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //文本的位置大小
    return CGRectMake(0, contentRect.size.height-_textBottomY-10*BILI_WIDTH, contentRect.size.width, 10*BILI_WIDTH);
}

//按钮属性赋值
-(void)setUpButtonData:(NSDictionary *)itemDict
{
    self.biz_name = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_name"]];
    self.biz_sort = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_sort"]];
    self.biz_type = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_type"]];
    self.biz_area = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_area"]];
    self.biz_icon_url = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_icon_url"]];
    self.biz_id = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_id"]];
    self.biz_h5_url = [NSString stringWithFormat:@"%@", [itemDict valueWithNoDataForKey:@"biz_h5_url"]];
}

@end



