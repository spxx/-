//
//  ReturnOrBorrowRecordTableViewCell.m
//  Wallet
//
//  Created by cyjjkz1 on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "ReturnOrBorrowRecordTableViewCell.h"


@interface ReturnOrBorrowRecordTableViewCell()

@property (strong , nonatomic) ReturnOrBorrowRecordViewController *viewController;
@property (nonatomic,strong) UILabel *huanOrJieLabel;
@property (nonatomic,strong) UILabel *jinELabel;
@property (nonatomic,strong) UILabel *yuanLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic ,strong) NSDictionary *dataDictionary;


@end

@implementation ReturnOrBorrowRecordTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewController:(ReturnOrBorrowRecordViewController *)viewController
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.viewController = viewController;
        self.huanOrJieLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * BILI_WIDTH, 15 * BILI_WIDTH, 37 * BILI_WIDTH, 37 * BILI_WIDTH)];
        _huanOrJieLabel.text = viewController.returnOrBorrow == YES?@"还":@"借";
        _huanOrJieLabel.backgroundColor = viewController.returnOrBorrow == YES?[UIColor colorWithRed:32/255.0 green:192/255.0 blue:230/255.0 alpha:1]:[UIColor colorWithRed:251/255.0 green:76/255.0 blue:82/255.0 alpha:1.0];
        _huanOrJieLabel.textAlignment = NSTextAlignmentCenter;
        _huanOrJieLabel.font = [UIFont systemFontOfSize:18 * BILI_WIDTH];
        _huanOrJieLabel.layer.cornerRadius = 5*BILI_WIDTH;
        _huanOrJieLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_huanOrJieLabel];
        
        self.jinELabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_huanOrJieLabel.frame) + 11*BILI_WIDTH, 17 * BILI_WIDTH, 50 * BILI_WIDTH, 11 * BILI_WIDTH)];
        _jinELabel.textAlignment = NSTextAlignmentCenter;
        _jinELabel.font = [UIFont boldSystemFontOfSize:12 * BILI_WIDTH];
        _jinELabel.text = @"借款金额";
        [self.contentView addSubview:_jinELabel];
        
        self.yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_jinELabel.frame.origin.x, CGRectGetMaxY(_jinELabel.frame) + 10*BILI_WIDTH, 70 * BILI_WIDTH, 14 * BILI_WIDTH)];
        _yuanLabel.textColor = [UIColor blackColor];
        _yuanLabel.font = [UIFont systemFontOfSize:17 * BILI_WIDTH];
        [self.contentView addSubview:_yuanLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_yuanLabel.frame) + 60 * BILI_WIDTH, 19 * BILI_WIDTH,120 * BILI_WIDTH, 10*BILI_WIDTH)];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        [self.contentView addSubview:_timeLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeLabel.frame.origin.x + 40 *BILI_WIDTH, CGRectGetMaxY(_timeLabel.frame) + 15 * BILI_WIDTH, 70 *BILI_WIDTH, 17 * BILI_WIDTH)];
        _statusLabel.layer.cornerRadius = _statusLabel.frame.size.height/2;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:13 * BILI_WIDTH];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_statusLabel];
                                
        
    }
    return self;
}

- (void)drawDataWithDict:(NSDictionary *)dict returnOrBorrow:(BOOL)returnOrBorrow
{
    self.dataDictionary = [NSDictionary dictionaryWithDictionary:dict];
    NSString *statusString = dict[@"status"];
    if (returnOrBorrow)
    {
        //还钱记录
        _yuanLabel.text = [NSString stringWithFormat:@"%@元",dict[@"loan_amount"]];
        if ([statusString isEqualToString:@"UN_REPAYMENT"])
        {
            _statusLabel.text = @"未还完";
            _statusLabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"REPAYENTED"]) {
            _statusLabel.text = @"已还完";
            _statusLabel.backgroundColor = [UIColor colorWithRed:35/255.0 green:214/255.0 blue:16/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"OVERDUE"])
        {
            _statusLabel.text = @"已逾期";
            _statusLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:83/255.0 blue:87/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"FAILURE"])
        {
            _statusLabel.text = @"还款失败";
            _statusLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:83/255.0 blue:87/255.0 alpha:1];
        }
        //if ([statusString isEqualToString:@"PAYING"])
        else
        {
            _statusLabel.text = @"未还完";
            _statusLabel.backgroundColor = UIColorFromRGB(0xfab600);
        }
        
    }
    else
    {
        //借款记录
        _yuanLabel.text = [NSString stringWithFormat:@"%@元",dict[@"amount"]];
        if([statusString isEqualToString:@"FALSE"])
        {
            _statusLabel.text = @"借款失败";
            _statusLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:83/255.0 blue:87/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"INIT"]||[statusString isEqualToString:@"AUDING"])
        {
            _statusLabel.text = @"处理中";
            _statusLabel.backgroundColor = UIColorFromRGB(0xfab600);
        }
        else
        {
            _statusLabel.text = @"借款成功";
            _statusLabel.backgroundColor = [UIColor colorWithRed:35/255.0 green:214/255.0 blue:16/255.0 alpha:1];
        }
    }
    _huanOrJieLabel.textColor = [UIColor whiteColor];
    _jinELabel.textColor = [UIColor colorWithRed:182/255.0 green:152/255.0 blue:152/255.0 alpha:1.0];
    //不要秒
    NSString *string = dict[@"create_time"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *string2 = [formatter2 stringFromDate:date];
    _timeLabel.text = string2;

}

//设置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _huanOrJieLabel.backgroundColor = _viewController.returnOrBorrow == YES?[UIColor colorWithRed:32/255.0 green:192/255.0 blue:230/255.0 alpha:1]:[UIColor colorWithRed:251/255.0 green:76/255.0 blue:82/255.0 alpha:1.0];
    NSString *statusString = _dataDictionary[@"status"];
    if (_viewController.returnOrBorrow)
    {
        if ([statusString isEqualToString:@"UN_REPAYMENT"])
        {
            _statusLabel.backgroundColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"REPAYENTED"])
        {
            _statusLabel.backgroundColor = [UIColor colorWithRed:35/255.0 green:214/255.0 blue:16/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"OVERDUE"])
        {
            _statusLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:83/255.0 blue:87/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"FAILURE"])
        {
            _statusLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:83/255.0 blue:87/255.0 alpha:1];
        }
        else
        {
            _statusLabel.text = @"未还完";
            _statusLabel.backgroundColor = UIColorFromRGB(0xfab600);
        }
        
    }
    else
    {
        if([statusString isEqualToString:@"FALSE"])
        {
            _statusLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:83/255.0 blue:87/255.0 alpha:1];
        }
        else if ([statusString isEqualToString:@"INIT"]||[statusString isEqualToString:@"AUDING"])
        {
            _statusLabel.backgroundColor = UIColorFromRGB(0xfab600);
        }
        else
        {
            _statusLabel.backgroundColor = [UIColor colorWithRed:35/255.0 green:214/255.0 blue:16/255.0 alpha:1];
        }
    }
}

@end
