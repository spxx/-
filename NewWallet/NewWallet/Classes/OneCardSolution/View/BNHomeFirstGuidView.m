//
//  BNHomeFirstGuidView.m
//  Wallet
//
//  Created by mac on 2017/1/5.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNHomeFirstGuidView.h"

@interface BNHomeFirstGuidView ()

@property (weak, nonatomic) UIImageView *veinView;
@property (weak, nonatomic) UIImageView *QRView;

@end

@implementation BNHomeFirstGuidView
static NSInteger tapTimes;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.8];

        tapTimes = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped)];
        [self addGestureRecognizer:tap];
        
        UIImageView *veinView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*NEW_BILI*9, 20, 149*NEW_BILI, 141*NEW_BILI)];
        veinView.image = [UIImage imageNamed:@"BNHomeFirstGuidView_VeinView"];
        [self addSubview:veinView];
        _veinView = veinView;
        
        UIImageView *QRView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*NEW_BILI*6.7, 20, 149*NEW_BILI, 141*NEW_BILI)];
        QRView.image = [UIImage imageNamed:@"BNHomeFirstGuidView_QRView"];
        [self addSubview:QRView];
        _QRView = QRView;
        
        _QRView.hidden = YES;

    }
    return self;
}

- (void)taped
{
    ++tapTimes;
    self.tapedBlock(tapTimes);

    if (tapTimes == 0) {
        _veinView.hidden = NO;
        _QRView.hidden = YES;
    } else if (tapTimes == 1) {
        _veinView.hidden = YES;
        _QRView.hidden = NO;
    }

}


@end
