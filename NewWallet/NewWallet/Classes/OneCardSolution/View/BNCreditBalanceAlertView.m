//
//  BNCreditBalanceAlertView.m
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNCreditBalanceAlertView.h"


@interface BNCreditBalanceAlertView ()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIImageView *iconImgV;

@end


@implementation BNCreditBalanceAlertView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(15*NEW_BILI, 0, SCREEN_WIDTH-2*15*NEW_BILI, frame.size.height)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = whiteView.heightValue/2;
        whiteView.layer.masksToBounds = YES;
        [self addSubview:whiteView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped)];
        [whiteView addGestureRecognizer:tap];
        
        CALayer *subLayer=[CALayer layer];
        CGRect fixframe=whiteView.frame;
        //    fixframe.size.width=[UIScreen mainScreen].bounds.size.width-40;
        subLayer.frame=fixframe;
        subLayer.cornerRadius=whiteView.heightValue/2;
        subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        subLayer.masksToBounds=NO;
        subLayer.shadowColor=[UIColor grayColor].CGColor;
        subLayer.shadowOffset=CGSizeMake(0,0);
        subLayer.shadowOpacity=0.6;
        subLayer.shadowRadius=6;
        [self.layer insertSublayer:subLayer below:whiteView.layer];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10*NEW_BILI, (whiteView.heightValue-30*NEW_BILI)/2, 30*NEW_BILI, 30*NEW_BILI)];
        icon.image = [UIImage imageNamed:@"BNVeinInfoVC_Icon"];
        [whiteView addSubview:icon];
        self.iconImgV = icon;
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(50*NEW_BILI, 0, whiteView.widthValue-(30+10+50)*NEW_BILI, whiteView.heightValue)];
        titleLbl.font = [UIFont boldSystemFontOfSize:13*NEW_BILI];
        titleLbl.textColor = UIColor_Black_Text;
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.numberOfLines = 2;
        titleLbl.contentMode = UIViewContentModeCenter;
        [whiteView addSubview:titleLbl];
        self.titleLbl = titleLbl;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(whiteView.widthValue-50*NEW_BILI, 0, 50*NEW_BILI, 50*NEW_BILI);
        cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [cancelButton addTarget:self action:@selector(disAppearAnimation) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
        [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
        [whiteView addSubview:cancelButton];
        
    }
    return self;
}
-(void)setTitle:(NSString *)title iconName:(NSString *)iconName
{
    self.titleLbl.text = title;
    self.iconImgV.image = [UIImage imageNamed:iconName];
}
- (void)appearAnimation
{
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)disAppearAnimation
{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)taped
{
    self.tapBlock();
    [self disAppearAnimation];
    
}

@end
