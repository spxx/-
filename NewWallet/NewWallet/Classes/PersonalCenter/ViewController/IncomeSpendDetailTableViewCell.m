//
//  IncomeSpendDetailTableViewCell.m
//  Wallet
//
//  Created by cyjjkz1 on 15/6/3.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "IncomeSpendDetailTableViewCell.h"

@interface IncomeSpendDetailTableViewCell ()
@property (nonatomic) UILabel *typeLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *amountLabel;
@property (nonatomic) UILabel *statusLabel;

@end

@implementation IncomeSpendDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 20 * BILI_WIDTH, 90 * BILI_WIDTH, 15 * BILI_WIDTH)];
        _typeLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        [self.contentView addSubview:_typeLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, CGRectGetMaxY(_typeLabel.frame) + 6 * BILI_WIDTH, 150 * BILI_WIDTH, 13 * BILI_WIDTH)];
        _timeLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        _timeLabel.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.f];
        [self.contentView addSubview:_timeLabel];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130 * BILI_WIDTH, _typeLabel.frame.origin.y, 117 * BILI_WIDTH, CGRectGetHeight(_typeLabel.frame))];
        _amountLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:18]];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_amountLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130 * BILI_WIDTH, _timeLabel.frame.origin.y, 117 * BILI_WIDTH, CGRectGetHeight(_timeLabel.frame))];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        [self.contentView addSubview:_statusLabel];
    }
    return self;
}

- (void)drawCellWithDictionary:(NSDictionary *)dic
{

    NSString *type = dic[@"busi_type"];
    //类型
    if (type.integerValue == 4)
    {
        _typeLabel.text = @"钱包提现";
    }
    else
    {
        _typeLabel.text = @"其它交易";
    }
    
    
    //时间
    NSString *timeString = dic[@"create_time"];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fomatter dateFromString:timeString];
    fomatter.dateFormat = @"MM-dd HH:mm:ss";
    _timeLabel.text = [fomatter stringFromDate:date];
    
    //金额
    NSString *amount = dic[@"amount"];
    amount = [NSString stringWithFormat:@"%.2f",amount.floatValue];
    if (amount.floatValue > 0) {
        _amountLabel.text = [NSString stringWithFormat:@"+%@",amount];
        _amountLabel.textColor = [UIColor greenColor];
    }
    else
    {
        _amountLabel.text = amount;
        _amountLabel.textColor = [UIColor blackColor];
    }
    
    
    //状态
    NSString *status = dic[@"status"];
    if (status.integerValue == 9)
    {
        _statusLabel.text = @"交易处理中";
        _statusLabel.textColor = [UIColor colorWithRed:229/255.0 green:160/255.0 blue:110/255.0 alpha:1.0f];
    }
    else if(status.integerValue ==10)
    {
        _statusLabel.text = @"交易成功";
        _statusLabel.textColor = UIColorFromRGB(0x00c135);
    }
    else
    {
        _statusLabel.text = @"交易失败";
        _statusLabel.textColor = [UIColor redColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
