//
//  BNScanedByShopActionSheet.m
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNScanedByShopActionSheet.h"


@interface BNScanedByShopActionSheet ()

@property (nonatomic) NSArray *listArray;

@property (nonatomic, weak) UIView *grayBGView;
@property (nonatomic, weak) UIView *whiteView;

@end


@implementation BNScanedByShopActionSheet
static CGFloat whiteViewHeight;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.listArray = @[@"使用说明", @"暂停使用"];
        self.listArray = @[@"使用说明"];

        UIView *grayBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        grayBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [self addSubview:grayBGView];
        self.grayBGView = grayBGView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppearAnimation)];
        [grayBGView addGestureRecognizer:tap];
        
        CGFloat cellHeight = 50*NEW_BILI;
        whiteViewHeight = (_listArray.count+1) * cellHeight + 8*NEW_BILI;
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, whiteViewHeight)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        _whiteView = whiteView;
        
        for (int i = 0; i < _listArray.count; i++) {
            if (i > 0) {
                UIView *lineView0 = [[UIView alloc]initWithFrame: CGRectMake(30*NEW_BILI, i * cellHeight-0.5, whiteView.widthValue-2*30*NEW_BILI, 0.5)];
                lineView0.backgroundColor = UIColor_GrayLine;
                [whiteView addSubview:lineView0];
            }
            
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cellBtn.tag = 200 + i;
            cellBtn.frame = CGRectMake(0, i * cellHeight, whiteView.widthValue, cellHeight);
            [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cellBtn setTitle:_listArray[i] forState:UIControlStateNormal];
            UIImage *image3 = [Tools imageWithColor:[UIColor fromHexValue:0x999999 alpha:0.1] andSize:CGSizeMake(SCREEN_WIDTH, cellHeight+50)];
            [cellBtn setBackgroundImage:image3 forState:UIControlStateHighlighted];
            if ([cellBtn.currentTitle isEqualToString:@"暂停使用"]) {
                [cellBtn setTitleColor:UIColorFromRGB(0xef5350) forState:UIControlStateNormal];
            }
            cellBtn.titleLabel.font = [UIFont systemFontOfSize:15*NEW_BILI];
            [whiteView addSubview:cellBtn];
            [cellBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIView *lineView = [[UIView alloc]initWithFrame: CGRectMake(0, _listArray.count * cellHeight, whiteView.widthValue, 8*NEW_BILI)];
        lineView.backgroundColor = UIColor_GrayLine;
        [whiteView addSubview:lineView];
        
        UIButton *cacelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cacelBtn.frame = CGRectMake(0, _listArray.count * cellHeight+8*NEW_BILI, whiteView.widthValue, cellHeight);
        [cacelBtn setTitleColor:UIColor_NewBlack_Text forState:UIControlStateNormal];
        [cacelBtn setTitle:@"取消" forState:UIControlStateNormal];
        UIImage *image3 = [Tools imageWithColor:[UIColor fromHexValue:0x999999 alpha:0.1] andSize:CGSizeMake(SCREEN_WIDTH, cellHeight+50)];
        [cacelBtn setBackgroundImage:image3 forState:UIControlStateHighlighted];
        cacelBtn.titleLabel.font = [UIFont systemFontOfSize:15*NEW_BILI];
        [whiteView addSubview:cacelBtn];
        [cacelBtn addTarget:self action:@selector(disAppearAnimation) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)appearAnimation
{

    _whiteView.transform = CGAffineTransformMakeTranslation(0, 0);
    [_grayBGView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    [UIView animateWithDuration:0.3 animations:^{
        [_grayBGView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
        _whiteView.transform = CGAffineTransformMakeTranslation(0, -whiteViewHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)disAppearAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        [_grayBGView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        _whiteView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cellBtnAction:(UIButton *)button
{
    _selectedBlock(button.tag-200);
    
    [self performSelector:@selector(disAppearAnimation) withObject:nil afterDelay:0.1];
    
}


@end
