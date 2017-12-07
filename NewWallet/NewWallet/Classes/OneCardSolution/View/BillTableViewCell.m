//
//  BillTableViewCell.m
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BillTableViewCell.h"

#import "BNTools.h"

@interface BillTableViewCell ()

@property (weak, nonatomic) UILabel *amount;
@property (weak, nonatomic) UILabel *billName;
@property (weak, nonatomic) UILabel *date;
@property (weak, nonatomic) UILabel *status;
@property (weak, nonatomic) UIImageView *iconImageView;

@end

@implementation BillTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (kBillCellHeight - 30 * BILI_WIDTH)/2.0, 30 * BILI_WIDTH, 30 * BILI_WIDTH)];
        
        //项目名
        UILabel *billNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, 17 * BILI_WIDTH, SCREEN_WIDTH - 110, 20 * BILI_WIDTH)];
        billNameLabel.backgroundColor = [UIColor clearColor];
        billNameLabel.textAlignment = NSTextAlignmentLeft;
        billNameLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        billNameLabel.textColor = UIColor_Black_Text;
        
        //时间
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(billNameLabel.frame.origin.x, CGRectGetMaxY(billNameLabel.frame), SCREEN_WIDTH - 105, 15 * BILI_WIDTH)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
        dateLabel.textColor = UIColorFromRGB(0xa2a2a2);
        
        //金额
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, billNameLabel.frame.origin.y, 80, 20 * BILI_WIDTH)];
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        amountLabel.textColor = UIColor_Black_Text;
        
        //项目状态
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, dateLabel.frame.origin.y, 80, 15 * BILI_WIDTH)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
        statusLabel.textColor = UIColorFromRGB(0xa8a8a8);
        
        _amount = amountLabel;
        _billName = billNameLabel;
        _date = dateLabel;
        _status = statusLabel;
        _iconImageView = iconImageView;
        
        
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:amountLabel];
        [self.contentView addSubview:billNameLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:statusLabel];
    }
    return self;
}

- (void)setupDataTableViewCellWithInfo:(NSDictionary *)info
{
    NSString *amount = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"amount"]];
    if ([amount isEqualToString:@"null"] == NO) {
        NSRange range = [amount rangeOfString:@"."];
        if (range.length == 1 && (amount.length > (range.location + 3))) {
            amount = [amount substringWithRange:NSMakeRange(0, range.location + 3)];
        }
        _amount.text = [NSString stringWithFormat:@"-%@", amount];
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"create_time"]];
    if (dateString.length > 5) {
        _date.text = [dateString substringWithRange:NSMakeRange(5, [dateString length] - 5)];
    }
    NSString *busi_type = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"busi_type"]];
    
    NSString *orderStatus = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"status"]];
    NSInteger status = [orderStatus integerValue];
    
    switch ([busi_type intValue]) {
        case 1:
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_oneCardCharge_icon"];
            busi_type = @"一卡通充值";

            NSString *yktName = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"ykt_name"]];
            if ([yktName isEqualToString:@"null"] == NO) {
                _billName.text = [NSString stringWithFormat:@"%@-%@",busi_type, yktName];
            }else{
                _billName.text = busi_type;
            }
        }
            break;
        
        case 2:
        {
            busi_type = @"爱心捐助";
            _iconImageView.image = [UIImage imageNamed:@"bill_default_icon"];
            NSString *projectName = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"prj_name"]];
            if ([projectName isEqualToString:@"null"] == NO) {
                _billName.text = [NSString stringWithFormat:@"%@-%@",busi_type, projectName];
            }else{
                _billName.text = busi_type;
            }
        }
            break;
            
        case 3:
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_mobileCharge_icon"];
            busi_type = @"手机话费";
            NSString *saleAmount = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"sale_amount"]];
            if ([saleAmount isEqualToString:@"null"] == NO) {
                NSRange range = [saleAmount rangeOfString:@"."];
                if (range.length == 1 && (saleAmount.length > (range.location + 3))) {
                    saleAmount = [saleAmount substringWithRange:NSMakeRange(0, range.location + 3)];
                }
                _amount.text = [NSString stringWithFormat:@"-%@", saleAmount];
            }
            
            NSString *shangPing = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"recharge_mobile"]];
            if ([shangPing isEqualToString:@"null"] == NO) {
                _billName.text = [NSString stringWithFormat:@"%@元%@-%@",[info valueNotNullForKey:@"amount"], busi_type, shangPing];
            }else{
                _billName.text = busi_type;
            }
            
        }
            break;
        case 4:
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_fetchCash_icon"];
            _billName.text = @"钱包提现";
            NSString *amount = info[@"amount"];
            amount = [NSString stringWithFormat:@"%.2f",amount.floatValue];
            if (amount.floatValue > 0) {
                _amount.text = [NSString stringWithFormat:@"+%@",amount];
            }
            else
            {
                _amount.text = amount;
            }
        }
            break;
        case 5:
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_ElectricCharge_icon"];
            busi_type = @"电费充值";
            if ([amount isEqualToString:@"null"] == NO) {
                NSRange range = [amount rangeOfString:@"."];
                if (range.length == 1 && (amount.length > (range.location + 3))) {
                    amount = [amount substringWithRange:NSMakeRange(0, range.location + 3)];
                }
                _amount.text = [NSString stringWithFormat:@"-%@", amount];
            }
            NSString *roomId = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"room_id"]];
            if ([roomId isEqualToString:@"null"] == NO) {
                _billName.text = [NSString stringWithFormat:@"%@-%@(%@元)",busi_type,roomId,[info valueNotNullForKey:@"amount"]];
            }else{
                _billName.text = busi_type;
            }

        }
            break;
        case 6:
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_collectFees_icon"];
            NSString *prj_name = [info valueNotNullForKey:@"prj_name"];
            busi_type = [NSString stringWithFormat:@"费用领取-%@",prj_name];
            _billName.text = busi_type;
            if ([amount isEqualToString:@"null"] == NO) {
                NSRange range = [amount rangeOfString:@"."];
                if (range.length == 1 && (amount.length > (range.location + 3))) {
                    amount = [amount substringWithRange:NSMakeRange(0, range.location + 3)];
                }
                _amount.text = [NSString stringWithFormat:@"+%@", amount];
            }
            
          
        }
            break;
        case 8:
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_mobileCharge_icon"];
            busi_type = @"手机流量";
            NSString *saleAmount = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"sale_amount"]];
            if ([saleAmount isEqualToString:@"null"] == NO) {
                NSRange range = [saleAmount rangeOfString:@"."];
                if (range.length == 1 && (saleAmount.length > (range.location + 3))) {
                    saleAmount = [saleAmount substringWithRange:NSMakeRange(0, range.location + 3)];
                }
                _amount.text = [NSString stringWithFormat:@"-%@", saleAmount];
            }
            
            NSString *shangPing = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"recharge_mobile"]];
            if ([shangPing isEqualToString:@"null"] == NO) {
                _billName.text = [NSString stringWithFormat:@"%@%@-%@",[info valueNotNullForKey:@"prj_name"], busi_type, shangPing];
            }else{
                _billName.text = busi_type;
            }
        }
            break;
        case 1001://学校费用缴纳
        
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_schoolFees_icon"];
            busi_type = [info valueNotNullForKey:@"prj_name"];
            NSString *amount = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"amount"]];
            if ([amount isEqualToString:@"null"] == NO) {
                NSRange range = [amount rangeOfString:@"."];
                if (range.length == 1 && (amount.length > (range.location + 3))) {
                    amount = [amount substringWithRange:NSMakeRange(0, range.location + 3)];
                }
                _amount.text = [NSString stringWithFormat:@"-%@", amount];
            }
            
            NSString *shangPing = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"recharge_mobile"]];
            if ([shangPing isEqualToString:@"null"] == NO) {
                _billName.text = [NSString stringWithFormat:@"%@元%@-%@",[info valueNotNullForKey:@"amount"], busi_type, shangPing];
            }else{
                _billName.text = busi_type;
            }
        }
            break;
        case 1002://学校费用缴纳退费
        {
            _iconImageView.image = [UIImage imageNamed:@"bill_default_icon"];
            _billName.text = @"退费";
            NSString *amount = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"amount"]];
            if ([amount isEqualToString:@"null"] == NO) {
                NSRange range = [amount rangeOfString:@"."];
                if (range.length == 1 && (amount.length > (range.location + 3))) {
                    amount = [amount substringWithRange:NSMakeRange(0, range.location + 3)];
                }
                _amount.text = [NSString stringWithFormat:@"-%@", amount];
            }
        }
            
        default:
            break;
    }
    

    switch (status) {
        case 0: {
            _status.text = @"交易失败";
            _status.textColor = UIColorFromRGB(0xfe6362);
            break;
        }
        case 1:
            _status.text = @"交易失败";
            _status.textColor = UIColorFromRGB(0xfe6362);
            break;
            
        case 2:
            _status.text = @"交易失败";
            _status.textColor = UIColorFromRGB(0xfe6362);
            break;
        
        case 3:
            _status.text = @"交易成功";
            _status.textColor = UIColorFromRGB(0x00c135);
            break;
        
        case 4:
            _status.text = @"交易成功";
            _status.textColor = UIColorFromRGB(0x00c135);
            break;
            
        case 5:
            _status.text = @"交易成功";
            _status.textColor = UIColorFromRGB(0x00c135);
            break;
            
        case 6:
            _status.text = @"交易失败";
            _status.textColor = UIColorFromRGB(0xfe6362);
            break;
            
        case 7:
        case 8:
        case 9:
            _status.text = @"交易中";
            _status.textColor = UIColorFromRGB(0xda8f0d);
            break;
            
        case 10:
            _status.text = @"交易成功";
            _status.textColor = UIColorFromRGB(0x00c135);
            break;
            
        case 11:
        case 12:
            _status.text = @"交易失败";
            _status.textColor = UIColorFromRGB(0xfe6362);
            break;
        default:
            break;
    }

    //    电费特殊情况。
    if ([busi_type intValue] == 5)//电费
    {
        switch (status) {
            case 1:{
                _status.text = @"交易失败";
                _status.textColor = UIColorFromRGB(0xfe6362);
            }
                break;
            case 4:{
                _status.text = @"交易成功";
                _status.textColor = UIColorFromRGB(0x00c135);
            }
            default:
            {
                _status.text = @"交易中";
                _status.textColor = UIColorFromRGB(0xda8f0d);
            }
                break;
        }
    }
}
@end
