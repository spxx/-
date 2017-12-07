//
//  BNVeinCreditOrderListCell.m
//  Wallet
//
//  Created by xjy on 17/6/21.
//  Copyright (c) 2017年 BNDK. All rights reserved.

//

#import "BNVeinCreditOrderListCell.h"

#import "BNTools.h"

@interface BNVeinCreditOrderListCell ()

@property (weak, nonatomic) UILabel *amountLbl;
@property (weak, nonatomic) UILabel *statusLbl;

@property (weak, nonatomic) UILabel *billNameLbl;
@property (weak, nonatomic) UILabel *dateLbl;
@property (weak, nonatomic) UIImageView *iconImageView;

@end

@implementation BNVeinCreditOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = UIColor_Gray_BG;
        
        //whiteBGView
        UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBillCellHeight)];
        whiteBGView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteBGView];
        
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*NEW_BILI, (kBillCellHeight-38 * NEW_BILI)/2, 38 * NEW_BILI, 38 * NEW_BILI)];
        
        //项目名
        UILabel *billNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80*NEW_BILI, 26 * NEW_BILI, SCREEN_WIDTH - (80+90)*NEW_BILI, 20 * NEW_BILI)];
        billNameLabel.backgroundColor = [UIColor clearColor];
        billNameLabel.textAlignment = NSTextAlignmentLeft;
        billNameLabel.font = [UIFont boldSystemFontOfSize:15*NEW_BILI];
        billNameLabel.textColor = UIColor_Black_Text;
      
        //时间
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(billNameLabel.frame.origin.x, CGRectGetMaxY(billNameLabel.frame)+5*NEW_BILI, CGRectGetWidth(billNameLabel.frame), 17 * NEW_BILI)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:11 * NEW_BILI];
        dateLabel.textColor = UIColorFromRGB(0xa2a2a2);
        
        //金额
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 105*NEW_BILI, (kBillCellHeight- 20 * NEW_BILI)/2.0, 90*NEW_BILI, 20 * NEW_BILI)];
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = [UIFont boldSystemFontOfSize:19 * NEW_BILI];
        amountLabel.textColor = UIColor_Black_Text;
        
        //退款状态
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60*NEW_BILI, dateLabel.origin.y-(17-14)/2* NEW_BILI, 45*NEW_BILI, 14 * NEW_BILI)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont systemFontOfSize:11 * NEW_BILI];
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.layer.cornerRadius = statusLabel.heightValue/2;
        statusLabel.layer.masksToBounds = YES;
        statusLabel.backgroundColor = UIColor_NewBlueColor;
        
        //line
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15*NEW_BILI, kBillCellHeight-0.5, SCREEN_WIDTH-2*15*NEW_BILI, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];

        _amountLbl = amountLabel;
        _statusLbl = statusLabel;
        _billNameLbl = billNameLabel;
        _dateLbl = dateLabel;
        _iconImageView = iconImageView;
        
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:amountLabel];
        [self.contentView addSubview:billNameLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:_statusLbl];

    }
    return self;
}

- (void)setupDataTableViewCellWithInfo:(NSDictionary *)info
{
    NSString *amount = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"consume_amount"]];
    if ([info.allKeys containsObject:@"repay_amount"]) {
        amount = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"repay_amount"]];
    }
    _amountLbl.text = [NSString stringWithFormat:@"%@", amount];
    NSString *status = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"refund_reason"]];
    if (status && status.length > 0) {
        _statusLbl.hidden = NO;
        _statusLbl.text = @"有退款";
        _amountLbl.frame = CGRectMake(SCREEN_WIDTH - 105*NEW_BILI, _billNameLbl.origin.y, 90*NEW_BILI, 20 * NEW_BILI);

    } else {
        _statusLbl.hidden = YES;
        _amountLbl.frame = CGRectMake(SCREEN_WIDTH - 105*NEW_BILI, (kBillCellHeight- 20 * NEW_BILI)/2.0, 90*NEW_BILI, 20 * NEW_BILI);
    }

    _billNameLbl.text = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"goods_summary"]];

    NSString *dateString = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"consume_time"]];
    if ([info.allKeys containsObject:@"repay_time"]) {
        dateString = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"repay_time"]];
    }
    if (dateString.length > 5) {
        _dateLbl.text = [dateString substringWithRange:NSMakeRange(5, [dateString length] - 5)];
    }
   
    NSString *iconUrl = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"consume_icon_url"]];
    if ([info.allKeys containsObject:@"repay_way_icon"]) {
        iconUrl = [NSString stringWithFormat:@"%@", [info valueWithNoDataForKey:@"repay_way_icon"]];
    }

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:nil];
    
}
@end
