//
//  BNAllPayBillCell.m
//  Wallet
//
//  Created by mac1 on 15/2/2.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNAllPayBillCell.h"

#import "BNTools.h"

@interface BNAllPayBillCell ()

@property (strong, nonatomic) UILabel *amount;
@property (strong, nonatomic) UILabel *billName;
@property (strong, nonatomic) UILabel *sallerName; /** 收款方*/
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *status;
@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation BNAllPayBillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = UIColor_Gray_BG;
        
        //whiteBGView
        UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBillCellHeight-10*BILI_WIDTH)];
        whiteBGView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteBGView];
        
        //收款方
        UILabel *sallerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 0, SCREEN_WIDTH - 20*BILI_WIDTH, 33 * BILI_WIDTH)];
        sallerNameLabel.backgroundColor = [UIColor clearColor];
        sallerNameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:12 sixPlus:14]];
        sallerNameLabel.textColor = UIColorFromRGB(0xa2a2a2);

        //项目状态
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90*BILI_WIDTH, 0, 80*BILI_WIDTH, 33 * BILI_WIDTH)];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
        //        statusLabel.textColor = UIColorFromRGB(0xa8a8a8);
        statusLabel.textColor = [UIColor blackColor];

        //line
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, CGRectGetHeight(sallerNameLabel.frame), SCREEN_WIDTH-10*BILI_WIDTH, 0.5)];
        line.backgroundColor = UIColor_GrayLine;
        [self.contentView addSubview:line];

        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, CGRectGetHeight(sallerNameLabel.frame)+(kBillCellHeight- CGRectGetHeight(sallerNameLabel.frame) - 40 * BILI_WIDTH)/2.0, 30 * BILI_WIDTH, 30 * BILI_WIDTH)];
        
        //项目名
        UILabel *billNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10*BILI_WIDTH, 47 * BILI_WIDTH, SCREEN_WIDTH - 110*BILI_WIDTH, 20 * BILI_WIDTH)];
        billNameLabel.backgroundColor = [UIColor clearColor];
        billNameLabel.textAlignment = NSTextAlignmentLeft;
        billNameLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:14 sixPlus:16]];
        billNameLabel.textColor = [UIColor blackColor];
        
      
        //时间
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(billNameLabel.frame.origin.x, kBillCellHeight-(10+28)*BILI_WIDTH, SCREEN_WIDTH - 105*BILI_WIDTH, 15 * BILI_WIDTH)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
        dateLabel.textColor = UIColorFromRGB(0xa2a2a2);
        
        //金额
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90*BILI_WIDTH, CGRectGetHeight(sallerNameLabel.frame)+(kBillCellHeight- CGRectGetHeight(sallerNameLabel.frame) - 30 * BILI_WIDTH)/2.0, 80*BILI_WIDTH, 20 * BILI_WIDTH)];
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
        amountLabel.textColor = [UIColor blackColor];
        
        _amount = amountLabel;
        _billName = billNameLabel;
        _date = dateLabel;
        _status = statusLabel;
        _iconImageView = iconImageView;
        _sallerName = sallerNameLabel;
        
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:amountLabel];
        [self.contentView addSubview:billNameLabel];
        [self.contentView addSubview:sallerNameLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:statusLabel];
    }
    return self;
}

- (void)setupDataTableViewCellWithInfo:(NSDictionary *)info
{
    NSString *amount = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"pay_amount"]];
    _amount.text = [NSString stringWithFormat:@"%@", amount];

    _billName.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"goods_name"]];

    _sallerName.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"seller_name"]];

    NSString *dateString = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"update_time"]];
    if (dateString.length > 5) {
        _date.text = [dateString substringWithRange:NSMakeRange(5, [dateString length] - 5)];
    }
    NSString *busi_type = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"biz_type"]];
    
    switch ([busi_type intValue]) {
        case 1:
        {
            //一卡通充值
            _iconImageView.image = [UIImage imageNamed:@"bill_oneCardCharge_icon"];
            break;
        }
        
        case 2:
        {
            //爱心捐助
            _iconImageView.image = [UIImage imageNamed:@"bill_default_icon"];
            break;
        }
        case 3:
        case 6:
        {
            //手机话费
            _iconImageView.image = [UIImage imageNamed:@"bill_mobileCharge_icon"];
            break;
        }
        case 100:
        {
            //钱包提现
            _iconImageView.image = [UIImage imageNamed:@"bill_fetchCash_icon"];
            break;
        }
        case 5:
        {
            //电费充值
            _iconImageView.image = [UIImage imageNamed:@"bill_ElectricCharge_icon"];
            break;
        }
        case 101:
        {
            //费用领取
            _iconImageView.image = [UIImage imageNamed:@"bill_collectFees_icon"];
            break;
        }
        case 7:
        {
            //学校费用缴纳
            _iconImageView.image = [UIImage imageNamed:@"bill_schoolFees_icon"];
            break;
        }
        case 8:
        {
            //网费缴纳
            _iconImageView.image = [UIImage imageNamed:@"netFees_icon"];
            break;
        }

        case 102:
        {
            //小额贷----借钱
            _iconImageView.image = [UIImage imageNamed:@"bill_xiaodai_icon"];
            break;
        }
        case 103:
        {
            //小额贷----还钱
            _iconImageView.image = [UIImage imageNamed:@"bill_xiaodai_icon"];
            break;
        }
        case 9:
        {
            //到店付
            _iconImageView.image = [UIImage imageNamed:@"bill_scan_icon"];
            break;
        }
        case 10:
        {
            //喜付学车
            _iconImageView.image = [UIImage imageNamed:@"bill_learn_driving_icon"];
            break;
        }
        case 19:
        {
            //静脉支付
            _iconImageView.image = [UIImage imageNamed:@"bill_VeinPay_icon"];
            break;
        }
        case 20:
        {
            //二维码支付
            _iconImageView.image = [UIImage imageNamed:@"bill_QRPay_icon"];
            break;
        }
        default:
            //默认图标
            _iconImageView.image = [UIImage imageNamed:@"bill_default_icon"];
            break;
    }
    NSString *payStatus = [[info valueNotNullForKey:@"pay_status"] uppercaseString];
    if ([payStatus isEqualToString:@"SUCCESS"]) {
        //为1的时候展示业务状态，为0的时候展示支付状态,
        //规则改为success的时候展示业务状态，其他的时候展示支付状态,
        NSString *biz_desc = [NSString stringWithFormat:@"%@", [info valueForKey:@"biz_desc"]];
        if (biz_desc.length <= 0) {
            _status.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"pay_desc"]];
            _status.textColor = UIColor_NewBlueColor;
        } else {
            _status.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"biz_desc"]];

            NSInteger status = [[info valueNotNullForKey:@"biz_finish"] integerValue];
            //为1的时候业务已经完成，为0的时候表示未完成,
            //    UIColor *failColor = UIColorFromRGB(0xfe6362);
            //    UIColor *payingColor = UIColorFromRGB(0xda8f0d);
            if (status == 1) {
                _status.textColor = UIColor_NewBlueColor;
            } else {
                _status.textColor = UIColorFromRGB(0xda8f0d);
            }

        }
//        BNLog(@"biz_desc----%@", _status.text);
    } else{
        _status.text = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"pay_desc"]];
        _status.textColor = UIColorFromRGB(0xda8f0d);
//        BNLog(@"pay_desc----%@", _status.text);
    }
    
}


- (void)loadView{
    //whiteBGView
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBillCellHeight-10*BILI_WIDTH)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteBGView];
    
    _sallerName = [[UILabel alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 0, SCREEN_WIDTH - 20*BILI_WIDTH, 33 * BILI_WIDTH)];
    _sallerName.backgroundColor = [UIColor clearColor];
    _sallerName.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:12 sixPlus:14]];
    _sallerName.textColor = UIColorFromRGB(0xa2a2a2);
//    [self.contentView addSubview:_sallerName];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 0, 30 * BILI_WIDTH, 30 * BILI_WIDTH)];
    [self.contentView addSubview:_iconImageView];
    
    _billName = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.viewRightEdge + 10*BILI_WIDTH, 10 * BILI_WIDTH, SCREEN_WIDTH - 110*BILI_WIDTH, 20 * BILI_WIDTH)];
    _billName.backgroundColor = [UIColor clearColor];
    _billName.textAlignment = NSTextAlignmentLeft;
    _billName.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:14 sixPlus:16]];
    _billName.textColor = [UIColor blackColor];
    [self.contentView addSubview:_billName];
    
    _amount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90*BILI_WIDTH, _sallerName.viewHeight+(kBillCellHeight- _sallerName.viewHeight - 30 * BILI_WIDTH)/2.0, 80*BILI_WIDTH, 20 * BILI_WIDTH)];
    _amount.backgroundColor = [UIColor clearColor];
    _amount.textAlignment = NSTextAlignmentRight;
    _amount.font = [UIFont systemFontOfSize:14 * BILI_WIDTH];
    _amount.textColor = [UIColor blackColor];
    [self.contentView addSubview:_amount];
    
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10*BILI_WIDTH, 40*BILI_WIDTH, SCREEN_WIDTH-10*BILI_WIDTH, 0.5)];
    line.backgroundColor = UIColor_GrayLine;
    [self.contentView addSubview:line];
    
    _date = [[UILabel alloc] initWithFrame:CGRectMake(_billName.viewX, line.viewBottomEdge + 5*BILI_WIDTH, SCREEN_WIDTH - 105*BILI_WIDTH, 15 * BILI_WIDTH)];
    _date.backgroundColor = [UIColor clearColor];
    _date.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    _date.textColor = UIColorFromRGB(0xa2a2a2);
    [self.contentView addSubview:_date];
    
    //项目状态
    _status = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90*BILI_WIDTH, _date.viewY-17*BILI_WIDTH, 80*BILI_WIDTH, 33 * BILI_WIDTH)];
    _status.backgroundColor = [UIColor clearColor];
    _status.textAlignment = NSTextAlignmentRight;
    _status.font = [UIFont systemFontOfSize:11 * BILI_WIDTH];
    //        _status.textColor = UIColorFromRGB(0xa8a8a8);
    _status.textColor = [UIColor blackColor];
    [self.contentView addSubview:_status];
    
}

































@end
