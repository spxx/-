//
//  CustomButton.h
//  Wallet
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property (nonatomic) NSString *biz_name;      //业务名称
@property (nonatomic) NSString *biz_sort;      //排列序号，从1开始
@property (nonatomic) NSString *biz_type;      //业务类型 0：原生  1：H5
@property (nonatomic) NSString *biz_area;      //1:首页主要业务 2:首页常规业务 3:校园页面热门应用 4:校园页面普通应用
@property (nonatomic) NSString *biz_icon_url;  //业务图标
@property (nonatomic) NSString *biz_id;        //业务Id
@property (nonatomic) NSString *biz_h5_url;        //url 原生的是xifu://开头，  h5的是http或https开头。
@property (nonatomic) NSString *needStuempno;    //是否需要绑定学号，0不需要，1需要。
@property (nonatomic) BOOL fromHomeScan;    //来自首页相机扫描。
@property (nonatomic) BOOL fromCanteen;    //来自食堂静脉信息。


-(void)setUpWithImgTopY:(CGFloat)imgTopY imgHeight:(CGFloat)imgHeight textBottomY:(CGFloat)textBottom;

-(CGRect) imageRectForContentRect:(CGRect)contentRect;

-(CGRect) titleRectForContentRect:(CGRect)contentRect;

//按钮属性赋值
-(void)setUpButtonData:(NSDictionary *)dict;


@end
