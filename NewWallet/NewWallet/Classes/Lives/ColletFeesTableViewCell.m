//
//  ColletFeesTableViewCell.m
//  Wallet
//
//  Created by mac1 on 15/8/31.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#define kDrawedColor UIColorFromRGB(0xb0bec5)
#define kMoneyFont [UIFont systemFontOfSize:[BNTools sizeFit:22 six:24 sixPlus:26]]

#import "ColletFeesTableViewCell.h"


@interface ColletFeesTableViewCell ()
@property (strong, nonatomic) UIImageView *icon; //图标
@property (nonatomic, strong) UILabel *nameLabel;//title
@property (nonatomic, strong) UILabel *statusLabel;//状态
@property (nonatomic, strong) UILabel *moneyLabel;//钱
@property (nonatomic, strong) UILabel *dateLabel;//截止日期
@property (nonatomic, strong) UILabel *yuanLabel;//元
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ColletFeesTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor_Gray_BG;
        
        UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight, SCREEN_WIDTH, 77 * BILI_WIDTH)];
        whiteBGView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteBGView];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * BILI_WIDTH, 13 * BILI_WIDTH, 20 * BILI_WIDTH, 20 * BILI_WIDTH)];
        [whiteBGView addSubview:_icon];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + 10 * BILI_WIDTH, _icon.frame.origin.y, 150 * BILI_WIDTH, 18 * BILI_WIDTH)];
        _nameLabel.text = @"补考费用退费";
        [_nameLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]]];
        [whiteBGView addSubview:_nameLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * BILI_WIDTH, 13 * BILI_WIDTH, 83 * BILI_WIDTH, 18 * BILI_WIDTH)];
        _statusLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        _statusLabel.textColor = [UIColor colorWithRed:252/255.0 green:138/255.0 blue:7/255.0 alpha:1.0f];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.text = @"待领取";
        [whiteBGView addSubview:_statusLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetHeight(whiteBGView.frame)/2.0, SCREEN_WIDTH - 30 * BILI_WIDTH, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [whiteBGView addSubview:_lineView];
        
        self.moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"2000";
        _moneyLabel.font = kMoneyFont;
        [whiteBGView addSubview:_moneyLabel];
        
        self.yuanLabel = [[UILabel alloc] init];
        _yuanLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:14 sixPlus:16]];
        _yuanLabel.text = @"元";
        _yuanLabel.textColor = [UIColor colorWithRed:113/255.0 green:137/255.0 blue:149/255.0 alpha:1.f];
        [self.contentView addSubview:_yuanLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 167 * BILI_WIDTH, CGRectGetMaxY(_statusLabel.frame) + 24 * BILI_WIDTH, 150 * BILI_WIDTH, 12.5 * BILI_WIDTH)];
        _dateLabel.text = @"截止日期 2015-10-11";
        _dateLabel.textColor = [UIColor colorWithRed:113/255.0 green:137/255.0 blue:149/255.0 alpha:1.f];
        _dateLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:11 six:13 sixPlus:15]];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [whiteBGView addSubview:_dateLabel];
        
       
        
    }
    
    return self;
}

- (void)drawCellWithData:(NSDictionary *)dic
{
    //金额
    NSString *amount = [dic valueNotNullForKey:@"amount"];
    _moneyLabel.text = amount;
    NSAttributedString *monStr = [[NSAttributedString alloc] initWithString:_moneyLabel.text attributes:@{NSFontAttributeName:kMoneyFont}];
    CGFloat width = monStr.size.width;
    CGFloat height = monStr.size.height;
    //重新设置frame
    _moneyLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_lineView.frame) + (38 * BILI_WIDTH - height)/2.0, width , height);
    _yuanLabel.frame = CGRectMake(CGRectGetMaxX(_moneyLabel.frame) + 3 * BILI_WIDTH, 61 * BILI_WIDTH, 20 * BILI_WIDTH, 20 * BILI_WIDTH);
   
    
    //截止日期
    NSString *dateStr = [dic valueNotNullForKey:@"prj_end_time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:date];
    _dateLabel.text = [NSString stringWithFormat:@"截止日期 %@",dateString];
    
    
    //标题
    NSString *title = [dic valueNotNullForKey:@"prj_name"];
    _nameLabel.text = title;
    
    
    
    //状态
    
    NSInteger status = [[dic valueNotNullForKey:@"status"] integerValue];
    NSInteger prjStatus = [[dic valueNotNullForKey:@"prj_status"] integerValue];
    switch (status) {
        case 1:
        case 4:
        {
            _statusLabel.text = @"待领取";
            [self setStatusAvaliable];
            
            if (prjStatus == 4||prjStatus == 5) {
                _statusLabel.text = @"已结束";
                [self setStatusNotAvaliable];
            }
        }
            break;
        case 2:
        {
            _statusLabel.text = @"领取中";
            [self setStatusNotAvaliable];
            if (prjStatus == 4||prjStatus == 5) {
                _statusLabel.text = @"已结束";
                [self setStatusNotAvaliable];
            }
            
        }
            break;
        case 3:
        {
            _statusLabel.text = @"已领取";
            [self setStatusNotAvaliable];
        }
            break;
         
        default:
            break;
    }
    
}

//橙色待领取状态(解决单元格重用问题)
- (void)setStatusAvaliable
{
    _icon.image = [UIImage imageNamed:@"fees_list_available"];
    _nameLabel.textColor = [UIColor blackColor];
    _dateLabel.textColor = [UIColor colorWithRed:113/255.0 green:137/255.0 blue:149/255.0 alpha:1.f];
    _statusLabel.textColor = [UIColor colorWithRed:252/255.0 green:138/255.0 blue:7/255.0 alpha:1.0f];
    _moneyLabel.textColor = [UIColor colorWithRed:252/255.0 green:138/255.0 blue:7/255.0 alpha:1.0f];
}

//灰色不待领取状态
- (void)setStatusNotAvaliable
{
    _icon.image = [UIImage imageNamed:@"fees_list_notavailabble"];
    _statusLabel.textColor = kDrawedColor;
    _nameLabel.textColor = kDrawedColor;
    _dateLabel.textColor = kDrawedColor;
    _moneyLabel.textColor = kDrawedColor;
    _yuanLabel.textColor = kDrawedColor;
}

@end
