//
//  CustomLayer.h
//  Wallet
//
//  Created by mac1 on 15/8/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CustomLayer : CALayer

@property (nonatomic, assign) int completed;

@property (nonatomic,assign) int total;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat innerRadius;

@property CGFloat startAngle;
@property CGFloat endAngle;


@property (nonatomic, assign) CFTimeInterval animationDuration;
@end
