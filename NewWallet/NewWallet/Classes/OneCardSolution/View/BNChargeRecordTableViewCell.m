//
//  BNChargeRecordTableViewCell.m
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNChargeRecordTableViewCell.h"

@interface BNChargeRecordTableViewCell ()
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *moneyLabel;

@end

@implementation BNChargeRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 160, 14)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.text = @"持卡人：张豆豆";
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 34, 150, 14)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGB(0x959595);
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.text = @"2014-10-09  12:00";
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 13, 110, 16)];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:15];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_moneyLabel];
        _moneyLabel.text = @"100.00";

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)drawData:(NSDictionary *)dict
{
    _nameLabel.text = [dict valueNotNullForKey:@"ykt_name"];
    _timeLabel.text = [dict valueNotNullForKey:@"create_time"];
    _moneyLabel.text = [dict valueNotNullForKey:@"amount"];

}

@end
