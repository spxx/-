//
//  BNPageControl.m
//  Wallet
//
//  Created by mac1 on 2017/1/5.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNPageControl.h"

@interface BNPageControl ()

@property (nonatomic, strong) NSMutableArray *controls;

@property (nonatomic, weak) UIView *circalView;

@end

@implementation BNPageControl

- (NSMutableArray *)controls
{
    if (!_controls) {
        _controls = @[].mutableCopy;
    }
    return _controls;
}


- (instancetype)initWithYValue:(CGFloat)yValue
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, yValue, SCREEN_WIDTH, 20);
    }
    return self;
}


- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    CGFloat w = 4, interspace = 12;
    
    CGFloat x = (SCREEN_WIDTH - w * numberOfPages - interspace * (numberOfPages - 1))  * 0.5;
    CGFloat y = (CGRectGetHeight(self.frame) - w) * 0.5;
    
    for (int i = 0; i < numberOfPages; i ++) {
        
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(x + (w + interspace) * i, y, w, w)];
        point.backgroundColor = UIColorFromRGB(0xcfd8dc);
        point.layer.cornerRadius = w * 0.5;
        point.layer.masksToBounds = YES;
        [self addSubview:point];
        [self.controls addObject:point];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    if (currentPage < 0 || currentPage > _numberOfPages - 1) {
        return;
    }
    
    for (UIView *point in self.controls) {
        point.backgroundColor = UIColorFromRGB(0xcfd8dc);
    }
    
    
    //找到currentPage，改变颜色
    UIView *point = [self.controls objectAtIndex:currentPage];
    point.backgroundColor = UIColorFromRGB(0x263238);
    
    if (_circalView) {
        [_circalView removeFromSuperview];
        _circalView = nil;
    }
    //添加一个环
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    circleView.center = point.center;
    circleView.layer.cornerRadius = 6.5;
    circleView.layer.masksToBounds = YES;
    circleView.layer.backgroundColor = UIColorFromRGB(0x263238).CGColor;
    circleView.layer.borderWidth = 0.5;
    circleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self addSubview:circleView];
    [self bringSubviewToFront:point];
    _circalView = circleView;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
