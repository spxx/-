//
//  BNMobileRechargeListCell.m
//  Wallet
//
//  Created by mac1 on 15-1-5.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNMobileRechargeListCell.h"
@interface BNMobileRechargeListCell ()

@property (weak, nonatomic) UILabel *tradeNameLabel;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *buyDateLabel;
@property (weak, nonatomic) UILabel *currentStatusLabel;

@end

@implementation BNMobileRechargeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat) width
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, width - 20 - 75, 25)];
        nameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"50元手机话费-18280043434";
        [self.contentView addSubview:nameLabel];
        self.tradeNameLabel = nameLabel;
        
        UILabel *priceabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 90, 13, 75, 20)];
        priceabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:14 six:15 sixPlus:16]];
        priceabel.textColor = [UIColor blackColor];
        priceabel.backgroundColor = [UIColor clearColor];
        priceabel.textAlignment = NSTextAlignmentRight;
        priceabel.text = @"-500.34元";
        [self.contentView addSubview:priceabel];
        self.priceLabel = priceabel;
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20 + 25, width - 30 - 80, 25)];
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.text = @"2014-10-09  12:00";
        [self.contentView addSubview:dateLabel];
        self.buyDateLabel = dateLabel;
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 95, 20 + 27, 80, 20)];
        statusLabel.font = [UIFont systemFontOfSize:14];
        statusLabel.textColor = UIColor_Blue_BarItemText;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.text = @"充值成功";
        [self.contentView addSubview:statusLabel];
        self.currentStatusLabel = statusLabel;
        
        UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(15, 79.5, width - 30, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [self.contentView addSubview:line];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


//{
//    amount = "10.00";
//    "bndk_amount" = "9.98";
//    "busi_type" = 3;
//    "create_time" = "2015-01-08 11:11:34";
//    id = 1019;
//    "mb_recharge_orderid" = "c878b116-5cb1-42f4-a58d-aa7aeee64c8b";
//    "prj_id" = "<null>";
//    "recharge_mobile" = 13541134276;
//    "recharge_type" = 0;
//    "sale_amount" = "10.00";
//    "school_id" = "<null>";
//    "school_name" = "<null>";
//    "sp_amount" = "10.00";
//    status = 5;
//    stuempno = "<null>";
//    "update_time" = "2015-01-08 11:11:54";
//    userid = 438;
//    "ykt_name" = "<null>";
//    "ykt_orderid" = "<null>";
//    "ykt_payid" = "<null>";
//},


- (void)drawCellWithData:(NSDictionary *)info
{
    
    _tradeNameLabel.text = [NSString stringWithFormat:@"%@元手机话费-%@", [info valueNotNullForKey:@"amount"], [info valueNotNullForKey:@"recharge_mobile"]];
    _priceLabel.text = [NSString stringWithFormat:@"-%@", [info valueNotNullForKey:@"sale_amount"]];
    _buyDateLabel.text = [info valueNotNullForKey:@"create_time"];
    
    NSString *status = [NSString stringWithFormat:@"%@",  [info valueNotNullForKey:@"status"]];
    if ([status isEqualToString:@"4"] || [status isEqualToString:@"3"]) {
        _currentStatusLabel.textColor = UIColorFromRGB(0x01c5ff);
        _currentStatusLabel.text = @"充值成功";
    }else if([status isEqualToString:@"5"] || [status isEqualToString:@"6"])
    {
        _currentStatusLabel.textColor = [UIColor lightGrayColor];
        _currentStatusLabel.text = @"充值中...";
    }else{
        _currentStatusLabel.textColor = [UIColor lightGrayColor];
        _currentStatusLabel.text = @"充值失败";

    }

}
@end
