//
//  BNBillListCell.m
//  NewWallet
//
//  Created by mac on 14-10-27.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNBillListCell.h"

@interface BNBillListCell ()
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *moneyLabel;
@property (nonatomic) UILabel *circleLabel;
@property (nonatomic) UILabel *lineLabel;

@end

@implementation BNBillListCell
static NSInteger cellHeight = 60;

- (void)awakeFromNib {
    // Initialization code

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 1, cellHeight)];
        _lineLabel.backgroundColor = UIColorFromRGB((0xc5eaf7));
        [self.contentView addSubview:_lineLabel];

        self.circleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, (cellHeight-21)/2, 21, 21)];
        _circleLabel.backgroundColor = [UIColor whiteColor];
        _circleLabel.layer.cornerRadius = 21/2;
        _circleLabel.layer.masksToBounds = YES;
        _circleLabel.layer.borderWidth = 2;
        _circleLabel.layer.borderColor = UIColorFromRGB((0x79c9ff)).CGColor;
        [self.contentView addSubview:_circleLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(39, 14, 160, 14)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.text = @"持卡人：张豆豆";
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(39, 34, 150, 14)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = UIColorFromRGB(0xb4b4b4);
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.text = @"2014-10-09  12:00";
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-145, 13, 110, 16)];
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
- (void)drawData:(NSDictionary *)dict withAryCount:(NSInteger)aryCount andRow:(NSInteger)row
{
    _timeLabel.text = [dict valueNotNullForKey:@"transtime"];
    _moneyLabel.text = [dict valueNotNullForKey:@"amount"];

    if (aryCount <= 1) {
        _lineLabel.frame = CGRectMake(_lineLabel.frame.origin.x, 0, 0, 0);
    } else if (row == 0) {
        _lineLabel.frame = CGRectMake(_lineLabel.frame.origin.x, cellHeight/2, 1, cellHeight/2);
    } else if (row == aryCount-1) {
        _lineLabel.frame = CGRectMake(_lineLabel.frame.origin.x, 0, 1, cellHeight/2);
    } else {
        _lineLabel.frame = CGRectMake(_lineLabel.frame.origin.x, 0, 1, cellHeight);
    }
    if ([[dict valueNotNullForKey:@"position"] isEqualToString:@"null"] || [[dict valueNotNullForKey:@"position"] isEqualToString:@""]) {
        _nameLabel.text = [dict valueNotNullForKey:@"type"];
    } else {
        _nameLabel.text = [dict valueNotNullForKey:@"position"];
    }
    NSRange range = [[dict valueNotNullForKey:@"amount"] rangeOfString:@"+"];
    if (range.length > 0) {
        //+
        _circleLabel.layer.borderColor = UIColorFromRGB((0x79c9ff)).CGColor;
    } else {
        //-
        _circleLabel.layer.borderColor = UIColorFromRGB(0xfc657e).CGColor;
    }
   
}

@end
