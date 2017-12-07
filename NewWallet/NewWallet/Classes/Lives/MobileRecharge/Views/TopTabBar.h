//
//  TopTabBar.h
//  Wallet
//
//  Created by 陈荣雄 on 15/12/16.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopTabBarDelegate <NSObject>

- (void)tabBarItemSelected:(NSInteger)index;

@end

typedef enum : NSUInteger {
    HintStyle_EqualWidth,
    HintStyle_TitleWidth,
} HintStyle;

@interface TopTabBar : UIView

@property (weak, nonatomic) id<TopTabBarDelegate> delegate;

@property (assign, nonatomic) NSUInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(HintStyle)style;

@property (assign ,nonatomic) HintStyle hintStyle;
@property (strong, nonatomic) UIColor *hintColor;
@property (assign, nonatomic) CGFloat hintHeight;
@property (strong, nonatomic) UIColor *hintBGColor;
@property (strong, nonatomic) UIFont *titleFont;

@end
