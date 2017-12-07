//
//  BNScanedByShopPayWaySelectView.m
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNScanedByShopPayWaySelectView.h"


@interface BNScanedByShopPayWaySelectView ()

@property (nonatomic) NSArray *payWayArray;

@property (nonatomic, weak) UIView *grayBGView;
@property (nonatomic, weak) UIView *whiteView;

@end


@implementation BNScanedByShopPayWaySelectView
static CGFloat whiteViewHeight;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *grayBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        grayBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [self addSubview:grayBGView];
        self.grayBGView = grayBGView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppearAnimation)];
        [grayBGView addGestureRecognizer:tap];
        
        whiteViewHeight = 256*NEW_BILI;
        CGFloat navBarViewHeight = 63*NEW_BILI;
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, whiteViewHeight)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];

        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 55*BILI_WIDTH, navBarViewHeight);
        backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [backButton addTarget:self action:@selector(disAppearAnimation) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
        [whiteView addSubview:backButton];
        self.whiteView = whiteView;
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(55*BILI_WIDTH, 0, SCREEN_WIDTH-2*55*BILI_WIDTH, navBarViewHeight)];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.textColor = [UIColor blackColor];
        [whiteView addSubview:titleLbl];
        titleLbl.font = [UIFont systemFontOfSize:16*BILI_WIDTH];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.text = @"选择支付方式";
        
        UIView *lineView0 = [[UIView alloc]initWithFrame: CGRectMake(0, navBarViewHeight-1, SCREEN_WIDTH, 0.5)];
        lineView0.backgroundColor = UIColor_GrayLine;
        [whiteView addSubview:lineView0];
        
        UIScrollView *listBaseView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, navBarViewHeight, SCREEN_WIDTH, whiteViewHeight-navBarViewHeight)];
        listBaseView.backgroundColor = [UIColor whiteColor];
        listBaseView.tag = 300;
        [whiteView addSubview:listBaseView];

    }
    return self;
}
-(void)setPayWayArray:(NSArray *)payWayArray andSelectItem:(NSDictionary *)selectItem
{
    _payWayArray = payWayArray;
    UIScrollView *listBaseView = [_whiteView viewWithTag:300];
    if (listBaseView) {
        [listBaseView removeAllSubviews];
    }

    CGFloat cellHeight = 62*NEW_BILI;
    for (int i = 0; i < payWayArray.count; i++) {
        UIImageView *payWayImage = [[UIImageView alloc]initWithFrame:CGRectMake(30*NEW_BILI, i * cellHeight + (cellHeight-20*NEW_BILI)/2, 20*NEW_BILI, 20*NEW_BILI)];
        payWayImage.tag = 101;
        [listBaseView addSubview:payWayImage];
        NSDictionary *paywayDict = payWayArray[i];
        [payWayImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[paywayDict valueWithNoDataForKey:@"image_url"]]]];
         
        UILabel *payWayLbl = [[UILabel alloc]initWithFrame:CGRectMake(78*NEW_BILI, i * cellHeight, listBaseView.widthValue-(78+65)*NEW_BILI, cellHeight)];
        payWayLbl.textColor = [UIColor blackColor];
        payWayLbl.tag = 102;
        payWayLbl.font = [UIFont systemFontOfSize:14*NEW_BILI];
        [listBaseView addSubview:payWayLbl];
        payWayLbl.text = [NSString stringWithFormat:@"%@",[paywayDict valueWithNoDataForKey:@"name"]];

        UIImageView *selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(listBaseView.widthValue-(30+27)*NEW_BILI, i * cellHeight + (cellHeight-27*NEW_BILI)/2, 27*NEW_BILI, 27*NEW_BILI)];
        selectImg.image = [UIImage imageNamed:@"Select_Bank_card"];
        selectImg.tag = 103;
        [listBaseView addSubview:selectImg];
        selectImg.hidden = YES;
        NSString *payWayID = [NSString stringWithFormat:@"%@",[paywayDict valueWithNoDataForKey:@"id"]];
        NSString *selectpayWayID = [NSString stringWithFormat:@"%@",[selectItem valueWithNoDataForKey:@"id"]];
        if ([payWayID isEqualToString:selectpayWayID]) {
            selectImg.hidden = NO;
        }
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.tag = 200 + i;
        cellBtn.frame = CGRectMake(0, i * cellHeight, listBaseView.widthValue, cellHeight);
        UIImage *image3 = [Tools imageWithColor:[UIColor fromHexValue:0x999999 alpha:0.1] andSize:CGSizeMake(SCREEN_WIDTH, cellHeight+50)];
        [cellBtn setBackgroundImage:image3 forState:UIControlStateHighlighted];
        [listBaseView addSubview:cellBtn];
        [cellBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == payWayArray.count-1) {
            UIView *lineView0 = [[UIView alloc]initWithFrame: CGRectMake(0, (i+1) * cellHeight-0.5, listBaseView.widthValue, 0.5)];
            lineView0.backgroundColor = UIColor_GrayLine;
            [listBaseView addSubview:lineView0];
        } else {
            UIView *lineView0 = [[UIView alloc]initWithFrame: CGRectMake(30*NEW_BILI, (i+1) * cellHeight-0.5, listBaseView.widthValue-2*30*NEW_BILI, 0.5)];
            lineView0.backgroundColor = UIColor_GrayLine;
            [listBaseView addSubview:lineView0];
        }
    }
    listBaseView.contentSize = CGSizeMake(listBaseView.widthValue, cellHeight*payWayArray.count);
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
    NSDictionary *payWayItem = _payWayArray[button.tag-200];
    _selectedBlock(payWayItem);
    
    [self setPayWayArray:_payWayArray andSelectItem:payWayItem];
    
    [self performSelector:@selector(disAppearAnimation) withObject:nil afterDelay:0.1];
    
}


@end
