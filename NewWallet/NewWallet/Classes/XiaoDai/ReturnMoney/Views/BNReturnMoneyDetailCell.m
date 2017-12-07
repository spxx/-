//
//  BNReturnMoneyDetailCell.m
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnMoneyDetailCell.h"

@interface BNReturnMoneyDetailCell ()

@property (nonatomic) UILabel *titleLbl;
@property (nonatomic) UILabel *moneyLbl;
@property (nonatomic) UILabel *dayOutLbl;
@property (nonatomic) UILabel *moneyOutLbl;
@property (nonatomic) UILabel *timeLbl;

@end

@implementation BNReturnMoneyDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat originY = 15*BILI_WIDTH;
        
        self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, originY, SCREEN_WIDTH/2-10*BILI_WIDTH, 13*BILI_WIDTH)];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLbl];

        self.moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, originY-2, SCREEN_WIDTH/2-10*BILI_WIDTH, 16*BILI_WIDTH)];
        _moneyLbl.textColor = [UIColor blackColor];
        _moneyLbl.textAlignment = NSTextAlignmentRight;
        _moneyLbl.font = [UIFont systemFontOfSize:16*BILI_WIDTH];
        _moneyLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_moneyLbl];
        
        originY += _titleLbl.frame.size.height + 13*BILI_WIDTH;

        self.dayOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(10*BILI_WIDTH, originY, 78*BILI_WIDTH, 13*BILI_WIDTH)];
        _dayOutLbl.textColor = UIColor_XiaoDaiCellGray_Text;
        _dayOutLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _dayOutLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dayOutLbl];
        
        self.moneyOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(98*BILI_WIDTH, originY, 95*BILI_WIDTH, 13*BILI_WIDTH)];
        _moneyOutLbl.textColor = UIColor_XiaoDaiCellGray_Text;
        _moneyOutLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _moneyOutLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_moneyOutLbl];
        
        self.timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-(110+12)*BILI_WIDTH, originY, 110*BILI_WIDTH, 11*BILI_WIDTH)];
        _timeLbl.textColor = UIColor_XiaoDaiCellGray_Text;
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        _timeLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLbl];
    }
    return self;
}

- (void)drawDataWithDict:(NSDictionary *)dict andIndexPath:(NSIndexPath *)indexPath cellCount:(NSInteger)count
{
//    _titleLbl.text = [NSString stringWithFormat:@"%ld期还款",(long)count - indexPath.row];
    _moneyLbl.text = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"repay_amount"]];
//    _dayOutLbl.text = @"逾期0天";
//    _moneyOutLbl.text = @"罚息23.00元";
    _timeLbl.text = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"create_time"]];
}

@end
