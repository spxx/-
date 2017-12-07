//
//  BNHomeActivityImgView.m
//  Wallet
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNHomeActivityImgView.h"

@implementation BNHomeActivityImgView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)addTarget:(id)target withAction:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:@selector(activityImgTaped:)];
    [self addGestureRecognizer:tap];

}
- (void)activityImgTaped:(UITapGestureRecognizer *)tap
{
    
}
@end
