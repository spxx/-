//
//  XJYSearchBar.m
//  helome
//
//  Created by XuEric on 14-9-18.
//  Copyright (c) 2014年 zhb. All rights reserved.
//

#import "XJYSearchBar.h"

@implementation XJYSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews {
	UITextField *searchField;
    
    UIView *baseView = self;
    if ([self respondsToSelector:@selector(barTintColor)]) {
        //UP_IOS7
        baseView = self.subviews[0];
    }
	NSUInteger numViews = [baseView.subviews count];
    
    //定义取消按钮
    for(int i = 0; i < numViews; i++) {
        UIView *view = [baseView.subviews objectAtIndex:i];
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)view;
            cancelButton.enabled = YES;
            [cancelButton setBackgroundImage:nil forState:UIControlStateNormal];//背景
            [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];//背景
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
            cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
            [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        } else if([view isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)view;
        }
    }
	for(int i = 0; i < numViews; i++) {
        UIView *view = [baseView.subviews objectAtIndex:i];
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [view removeFromSuperview];
            break;
        }
	}
    
	if(searchField != nil) {
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        [searchField setBackgroundColor:[UIColor whiteColor]];

    }
    if (![self respondsToSelector:@selector(barTintColor)]) {
        //修改IOS6下的放大镜位置
        UIImageView *leftImgView = (UIImageView *)searchField.leftView;
        CGRect leftRect = leftImgView.frame;
        
        //新建放大镜图标，
        UIImageView *newLeftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (self.frame.size.height-leftRect.size.height)/2, leftRect.size.width, leftRect.size.height)];
        newLeftImgView.image = leftImgView.image;
        [self addSubview:newLeftImgView];
        
        //本身放大镜图标不能移除，不能设位置。故重设一个无图的UIImageView来隐藏。宽度设为10，距离比较合适。可调节。
        searchField.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(leftRect.origin.x, leftRect.origin.y, 10, leftRect.size.height)];
    }
    
    //设置搜索栏输入框边框颜色
    searchField.layer.cornerRadius = 2.0f;
    searchField.layer.masksToBounds = YES;
    searchField.layer.borderColor = [UIColor whiteColor].CGColor;
    searchField.layer.borderWidth = 5.0f;    //textFiled的边框设宽些，覆盖本身的border阴影
    
    UIView *searchBarBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1)];
    searchBarBGView.backgroundColor = UIColorFromRGB(0xefeff4);
    [self insertSubview:searchBarBGView atIndex:0];
    
	[super layoutSubviews];
    
}
@end
