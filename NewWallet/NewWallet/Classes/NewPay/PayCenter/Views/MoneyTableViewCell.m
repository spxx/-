//
//  MoneyTableViewCell.m
//  yizhangtong
//
//  Created by sunpeng on 2017/10/24.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "MoneyTableViewCell.h"

@implementation MoneyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.viewHeight  = 50*NEW_BILI;
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    
    _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12*NEW_BILI, 100, 12*NEW_BILI)];
    _classLabel.textColor = UIColorFromRGB(0x494d4f);
    _classLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    [self.contentView addSubview:_classLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.viewSize = CGSizeMake(200, 10*NEW_BILI);
    _timeLabel.textColor = UIColorFromRGB(0x78909c);
    _timeLabel.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [_timeLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(20, self.viewHeight-10*NEW_BILI)];
    [self.contentView addSubview:_timeLabel];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.viewSize = CGSizeMake(20, 17*NEW_BILI);
    _moneyLabel.textColor = UIColorFromRGB(0xff866a);
    _moneyLabel.font = [UIFont systemFontOfSize:17*NEW_BILI];
    [_moneyLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-20, 14*NEW_BILI)];
    [self.contentView addSubview:_moneyLabel];
    
}

-(void)dicWithData:(NSDictionary *)dic{
    NSString *classStr = [dic[@"business_name"] length] > 0 ? dic[@"business_name"] : dic[@"position"];
    _classLabel.text = classStr;
    [_classLabel sizeToFit];
    _classLabel.viewHeight = 12*NEW_BILI;
    _classLabel.viewX = 20*NEW_BILI;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",[dic[@"transtime"] substringWithRange:NSMakeRange([dic[@"transtime"] length] - 8, 8)]];
    [_timeLabel sizeToFit];
    _timeLabel.viewHeight = 10*NEW_BILI;
    [_timeLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(20*NEW_BILI, self.viewHeight-10*NEW_BILI)];
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@",dic[@"amount"]];
    [_moneyLabel sizeToFit];
    _moneyLabel.viewHeight = 17*NEW_BILI;
    [_moneyLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-20*NEW_BILI, 14*NEW_BILI)];
    
}
    


@end
