//
//  FilterView.m
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "FilterView.h"




@interface FilterView ()

@property (strong, nonatomic) UIView *relativeView;

@end

@implementation FilterView

- (id)initWithFilterNames:(NSArray *) names relativeView:(UIView *) relativeView{
    
    self = [names count] % 3 !=0 ? [super initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT+44 - 44 * ([names count] / 3 + 1), SCREEN_WIDTH, 44 * ([names count] / 3 + 1 ))]:[super initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT+44 - 44 * ([names count] / 3 ), SCREEN_WIDTH, 44 * ([names count] / 3 ))];
    
    if (self) {
        _relativeView = relativeView;
        
        self.backgroundColor = [UIColor whiteColor];
        
       // NSInteger filterCount = [names count];
        CGFloat marginAndBtnWith = SCREEN_WIDTH/3;
        
        for (int i = 0; i < [names count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i % 3 * (SCREEN_WIDTH / 3), (i / 3) * 44, SCREEN_WIDTH /3, 44);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:UIColor_NewBlueColor forState:UIControlStateHighlighted];
//            UIImage *image1 = [Tools imageWithColor:UIColorFromRGB(0xdadada) andSize:CGSizeMake(btn.frame.size.width,btn.frame.size.height)];
//            [btn setBackgroundImage:image1 forState:UIControlStateHighlighted];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12*BILI_WIDTH]];
            btn.tag = FILTER_BTN_TAG_BASE + i;
            [btn setTitle:[names objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(filterSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
//            //竖线
//            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(marginAndBtnWith + marginAndBtnWith * (i%3), 2 + btn.frame.origin.y * (i/3), 0.5, 40)];
//            verticalLine.backgroundColor = UIColorFromRGB(0xdadada);
//            [self insertSubview:verticalLine aboveSubview:btn];
//            
//            //横线
//            UIView *HLine = [[UIView alloc] initWithFrame:CGRectMake(marginAndBtnWith * (i%3), CGRectGetHeight(btn.frame) + CGRectGetHeight(btn.frame) * (i/3), marginAndBtnWith, 0.5)];
//            HLine.backgroundColor = UIColorFromRGB(0xdadada);
//            [self insertSubview:HLine aboveSubview:btn];
        }
        
        _filterIsShowing = NO;
    }
    return self;
}

- (void)filterSelectAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(filterSelectedIndex:)]) {
        [self filterHidden];
        [self.delegate filterSelectedIndex:btn.tag];
    }
}


- (void)filterShow
{
    _filterIsShowing = YES;
    CGRect rect = self.frame;
    CGRect relative = _relativeView.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, relative.origin.y + relative.size.height, rect.size.width, rect.size.height);
    }];
}
- (void)filterHidden
{
    _filterIsShowing = NO;
    CGRect rect = self.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT+44 - rect.size.height, rect.size.width, rect.size.height);
    }];
}
@end
