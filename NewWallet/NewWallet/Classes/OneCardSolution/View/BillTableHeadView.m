//
//  BillTableHeadView.m
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BillTableHeadView.h"


@interface BillTableHeadView ()

@property (weak, nonatomic) UILabel *billDateLabel;

@end

@implementation BillTableHeadView
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeadViewHeight)];
    
    if (self) {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, kHeadViewHeight)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:13 sixPlus:15]];
        dateLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _billDateLabel = dateLabel;
        [self addSubview:dateLabel];
        
        self.backgroundColor = UIColor_Gray_BG;
    }
    return self;
}

- (void)setupDataForHeadViewWith:(NSString *)date
{
    _billDateLabel.text = date;
}
@end
