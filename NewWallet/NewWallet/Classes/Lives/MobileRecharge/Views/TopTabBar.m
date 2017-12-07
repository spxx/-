//
//  TopTabBar.m
//  Wallet
//
//  Created by 陈荣雄 on 15/12/16.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "TopTabBar.h"

@interface TopTabBar ()

@property (strong, nonatomic) UIView *spotView;
@property (strong, nonatomic) UIView *spotBGView;

@end

@implementation TopTabBar

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(HintStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hintStyle = style;
        self.backgroundColor = [UIColor whiteColor];
        self.hintColor = UIColorFromRGB(0x039dff);
        self.hintHeight = 4;
        
        self.spotBGView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-self.hintHeight, SCREEN_WIDTH, self.hintHeight)];
        [self addSubview:self.spotBGView];
        self.spotBGView.backgroundColor = [UIColor whiteColor];

        CGFloat itemWidth = frame.size.width/titles.count;
        for (NSString *title in titles) {
            NSUInteger index = [titles indexOfObject:title];
            UIButton *tabItem = [UIButton buttonWithType:UIButtonTypeCustom];
            tabItem.frame = CGRectMake(index*itemWidth, 0, itemWidth, frame.size.height);
            [tabItem setTitle:title forState:UIControlStateNormal];
            if ([titles indexOfObject:title] == 0) {
                [tabItem setTitleColor:_hintColor forState:UIControlStateNormal];
            } else {
                [tabItem setTitleColor:UIColor_Black_Text forState:UIControlStateNormal];
            }
            tabItem.titleLabel.font = [UIFont systemFontOfSize:14];
            [tabItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            tabItem.tag = index;
            [self addSubview:tabItem];
            
            if (title != titles.lastObject) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake((index+1)*itemWidth, (self.heightValue-20*NEW_BILI)/2, 1, 20*NEW_BILI)];
                line.backgroundColor = UIColor_GrayLine;
                [self addSubview:line];
            }
        }
        
        self.spotView = [[UIView alloc] initWithFrame:CGRectZero];

        if (self.hintStyle == HintStyle_EqualWidth) {
            
            self.spotView.frame = CGRectMake(0, frame.size.height-self.hintHeight, itemWidth, self.hintHeight);
        } else {
            
            for (UIButton *barItem in self.subviews) {
                if ([barItem isKindOfClass:[UIButton class]]) {
                    CGRect rect = [barItem titleRectForContentRect:barItem.bounds];
                    self.spotView.frame = CGRectMake(rect.origin.x, frame.size.height-self.hintHeight, rect.size.width, self.hintHeight);
                    break;
                }
            }
        }
        self.spotView.backgroundColor = _hintColor;
        [self addSubview:self.spotView];
    }
    return self;
}

- (void)setHintColor:(UIColor *)hintColor {
    _hintColor = hintColor;
    self.spotView.backgroundColor = hintColor;
    
    for (UIButton *barItem in self.subviews) {
        if ([barItem isKindOfClass:[UIButton class]]) {
            if (barItem.tag == self.selectedIndex) {
                [barItem setTitleColor:_hintColor forState:UIControlStateNormal];
            } else {
                [barItem setTitleColor:UIColor_Black_Text forState:UIControlStateNormal];
            }
        }
    }
}
- (void)setTitleFont:(UIFont *)titleFont
{
    for (UIButton *barItem in self.subviews) {
        if ([barItem isKindOfClass:[UIButton class]]) {
            barItem.titleLabel.font = titleFont;
        }
    }
}
- (void)setHintBGColor:(UIColor *)hintBGColor {
    _hintBGColor = hintBGColor;
    self.spotBGView.backgroundColor = hintBGColor;
}

- (void)setHintHeight:(CGFloat)hintHeight {
    _hintHeight = hintHeight;
    
    self.spotView.frame = CGRectMake(self.spotView.leftValue, self.heightValue-hintHeight, self.spotView.widthValue, hintHeight);
    self.spotBGView.frame = CGRectMake(0, self.heightValue-self.hintHeight, SCREEN_WIDTH, self.hintHeight);

}

- (void)itemAction:(UIButton *)button {

    self.selectedIndex = button.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.hintStyle == HintStyle_EqualWidth) {
            self.spotView.leftValue = button.tag*button.frame.size.width;
        } else {
            CGRect rect = [button titleRectForContentRect:button.bounds];
            self.spotView.frame = CGRectMake(button.tag*button.frame.size.width+rect.origin.x, self.spotView.topValue, rect.size.width, self.hintHeight);
        }
     
        for (UIButton *barItem in self.subviews) {
            if ([barItem isKindOfClass:[UIButton class]]) {
                if (barItem == button) {
                    [barItem setTitleColor:_hintColor forState:UIControlStateNormal];
                } else {
                    [barItem setTitleColor:UIColor_Black_Text forState:UIControlStateNormal];
                }
            }
        }
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(tabBarItemSelected:)]) {
            [self.delegate tabBarItemSelected:button.tag];
        }
    }];
}

@end
