//
//  BNReturnMoneyListCell.m
//  Wallet
//
//  Created by mac on 15/4/30.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNReturnMoneyListCell.h"


@interface BNReturnMoneyListCell ()

@property (nonatomic) UIView *whiteView;
@property (nonatomic) UILabel *titleLbl;
@property (nonatomic) UILabel *timeLbl;
@property (nonatomic) UIView *redYuQiBGView;
@property (nonatomic) UILabel *timeOutLbl;
@property (nonatomic) UILabel *moneyTitleLbl;
@property (nonatomic) UILabel *remainMoneyTitleLbl;
@property (nonatomic) UILabel *moneyLbl;
@property (nonatomic) UILabel *remainMoneyLbl;
@property (nonatomic) UIView *redLineView;
@property (nonatomic) UIButton *shouldReturnLbl;
@property (nonatomic) UIButton *remainTimeBtn;
@property (nonatomic) UIButton *returnMoneyBtn;

@property (nonatomic) NSDictionary *cellDict;

@end

@implementation BNReturnMoneyListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor_Gray_BG;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:[self addWhiteViewSubviews:nil]];

    }
    return self;
}

- (UIView *)addWhiteViewSubviews:(NSDictionary *)dict
{
    CGFloat whiteViewOriginY = 8*BILI_WIDTH;
    
    if (!_whiteView) {
        self.whiteView =[[UIView alloc]initWithFrame:CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, 122*BILI_WIDTH)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    
    if (!_titleLbl) {
        self.titleLbl = [[UILabel alloc]init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
        _titleLbl.backgroundColor = [UIColor clearColor];
        [_whiteView addSubview:_titleLbl];
    }
    _titleLbl.frame = CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH-(110+2*14)*BILI_WIDTH, 14*BILI_WIDTH);
    
    if (!_timeLbl) {
        self.timeLbl = [[UILabel alloc]init];
        _timeLbl.textColor = UIColorFromRGB(0xbcbcbc);
        _timeLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.backgroundColor = [UIColor clearColor];
        [_whiteView addSubview:_timeLbl];
    }
    _timeLbl.frame = CGRectMake(SCREEN_WIDTH-(110+14)*BILI_WIDTH, whiteViewOriginY+2, 110*BILI_WIDTH, 11*BILI_WIDTH);
    
    whiteViewOriginY += _titleLbl.frame.size.height + 14*BILI_WIDTH;
    
    //111---->>>>>
//    float overduedAmount = [[dict valueNotNullForKey:@"overdued_amount"] floatValue];
//
////    NSString *yuqiStr = @"本期还款已逾期3天，罚息12元!若逾期30天未还款将记入征信系统，影响个人信用记录！请尽快还款！";
//    NSString *yuqiStr = [NSString stringWithFormat:@"本期还款已逾期，逾期会产生罚息，你总共需要还款%.2f元，若逾期30天未还款将记入征信系统，影响个人信用记录。",overduedAmount];
//
//    if (overduedAmount > 0) {
//        CGFloat redTitleHeight = [Tools caleNewsCellHeightWithTitle:yuqiStr font:[UIFont systemFontOfSize:13*BILI_WIDTH] width:SCREEN_WIDTH-2*10*BILI_WIDTH];
//        
//        if (!_redYuQiBGView) {
//            self.redYuQiBGView =[[UIView alloc]initWithFrame:CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 10)];
//            _redYuQiBGView.backgroundColor = UIColor_RedButtonBGHighLight;
//            [_whiteView addSubview:_redYuQiBGView];
//            
//            self.timeOutLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*BILI_WIDTH, 7*BILI_WIDTH, SCREEN_WIDTH-2*14*BILI_WIDTH, redTitleHeight)];
//            _timeOutLbl.backgroundColor = [UIColor clearColor];
//            _timeOutLbl.textColor = [UIColor whiteColor];
//            _timeOutLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
//            _timeOutLbl.numberOfLines = 0;
//            _timeOutLbl.text = yuqiStr;
//            [_redYuQiBGView addSubview:_timeOutLbl];
//        }
//        
//        _timeOutLbl.frame = CGRectMake(14*BILI_WIDTH, 7*BILI_WIDTH, SCREEN_WIDTH-2*14*BILI_WIDTH, redTitleHeight);
//        _redYuQiBGView.frame = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 2*7*BILI_WIDTH+redTitleHeight);
//        _redYuQiBGView.hidden = NO;
//
//        whiteViewOriginY += _redYuQiBGView.frame.size.height;
//        whiteViewOriginY += 2*14*BILI_WIDTH;
//
//    } else {
//        _redYuQiBGView.frame = CGRectMake(0, whiteViewOriginY, 0, 0);
//        whiteViewOriginY += 14*BILI_WIDTH;
//        _redYuQiBGView.hidden = YES;
//    }
    //<<<-----111
    
    //---->>>>222  //222是临时不显示红色逾期内容，要显示就打开111，不要222
    _redYuQiBGView.frame = CGRectMake(0, whiteViewOriginY, 0, 0);
    whiteViewOriginY += 14*BILI_WIDTH;
    _redYuQiBGView.hidden = YES;
    //<<<<----222
    
    if (!_moneyTitleLbl) {
        self.moneyTitleLbl = [[UILabel alloc]init];
        _moneyTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
        _moneyTitleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _moneyTitleLbl.backgroundColor = [UIColor clearColor];
        [_whiteView addSubview:_moneyTitleLbl];
        _moneyTitleLbl.text = @"借款金额(元)";
    }
    _moneyTitleLbl.frame = CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 13*BILI_WIDTH);
    
    if (!_remainMoneyTitleLbl) {
        self.remainMoneyTitleLbl = [[UILabel alloc]init];
        _remainMoneyTitleLbl.textColor = UIColorFromRGB(0xbcbcbc);
        _remainMoneyTitleLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        _remainMoneyTitleLbl.backgroundColor = [UIColor clearColor];
        _remainMoneyTitleLbl.textAlignment = NSTextAlignmentRight;
        [_whiteView addSubview:_remainMoneyTitleLbl];
        _remainMoneyTitleLbl.text = @"余额加利息剩余未还(元)";
    }
    _remainMoneyTitleLbl.frame = CGRectMake(SCREEN_WIDTH - (145+14)*BILI_WIDTH, whiteViewOriginY, 145*BILI_WIDTH, 13*BILI_WIDTH);
    
    if (!_redLineView) {
        self.redLineView = [[UIView alloc] init];
        _redLineView.backgroundColor = UIColor_Gray_BG;
        [_whiteView addSubview:_redLineView];
    }
    _redLineView.frame = CGRectMake(SCREEN_WIDTH/2, whiteViewOriginY, 0.5, 47*BILI_WIDTH);
    
    whiteViewOriginY += _moneyTitleLbl.frame.size.height + 10*BILI_WIDTH;
    
    if (!_moneyLbl) {
        self.moneyLbl = [[UILabel alloc]init];
        _moneyLbl.textColor = [UIColor blackColor];
        _moneyLbl.font = [UIFont systemFontOfSize:22*BILI_WIDTH];
        _moneyLbl.backgroundColor = [UIColor clearColor];
        [_whiteView addSubview:_moneyLbl];
        
    }
    _moneyLbl.frame = CGRectMake(14*BILI_WIDTH, whiteViewOriginY, SCREEN_WIDTH/2, 22*BILI_WIDTH);
    
    if (!_remainMoneyLbl) {
        self.remainMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (115+14)*BILI_WIDTH, whiteViewOriginY, 115*BILI_WIDTH, 22*BILI_WIDTH)];
        _remainMoneyLbl.textColor = UIColor_RedButtonBGNormal;
        _remainMoneyLbl.font = [UIFont systemFontOfSize:22*BILI_WIDTH];
        _remainMoneyLbl.backgroundColor = [UIColor clearColor];
        _remainMoneyLbl.textAlignment = NSTextAlignmentRight;
        [_whiteView addSubview:_remainMoneyLbl];
    }
    _remainMoneyLbl.frame = CGRectMake(SCREEN_WIDTH - (115+14)*BILI_WIDTH, whiteViewOriginY, 115*BILI_WIDTH, 22*BILI_WIDTH);
    
    whiteViewOriginY += _moneyLbl.frame.size.height + 22*BILI_WIDTH;
    
    if (!_shouldReturnLbl) {
        self.shouldReturnLbl = [[UIButton alloc]initWithFrame:CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 35*BILI_WIDTH)];
        [_shouldReturnLbl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _shouldReturnLbl.titleLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        _shouldReturnLbl.backgroundColor = [UIColor whiteColor];
        _shouldReturnLbl.userInteractionEnabled = NO;
        [_shouldReturnLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 10*BILI_WIDTH, 0, 0)];
        _shouldReturnLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _shouldReturnLbl.layer.borderColor = UIColor_Gray_BG.CGColor;
        _shouldReturnLbl.layer.borderWidth = 0.5;
        [_whiteView addSubview:_shouldReturnLbl];
    }
    NSString *repaymentTypeString = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"repayment_type"]];
    if ([repaymentTypeString isEqualToString:@"SCHEDULED"]) {
        _shouldReturnLbl.frame = CGRectMake(0, whiteViewOriginY, 0, 0);
        _shouldReturnLbl.hidden = YES;
    } else {
        _shouldReturnLbl.frame = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH, 35*BILI_WIDTH);
        _shouldReturnLbl.hidden = NO;
    }
    
    whiteViewOriginY += _shouldReturnLbl.frame.size.height;
    
    //还款时间
    if (!_remainTimeBtn) {
        self.remainTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remainTimeBtn setBackgroundColor:UIColor_NavBarBGColor];
        [_remainTimeBtn setTitleColor:UIColorFromRGB(0xbcbcbc) forState:UIControlStateNormal];
        _remainTimeBtn.titleLabel.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        _remainTimeBtn.userInteractionEnabled = NO;
        [_remainTimeBtn setTitle:@"还款时间：" forState:UIControlStateNormal];
        [_remainTimeBtn setImage:[UIImage imageNamed:@"ReturnMoney_timeIcon"] forState:UIControlStateNormal];
        [_remainTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10*BILI_WIDTH, 0, 0)];
        [_remainTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15*BILI_WIDTH, 0, 0)];
        _remainTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_whiteView addSubview:_remainTimeBtn];
    }
    _remainTimeBtn.frame = CGRectMake(0, whiteViewOriginY, SCREEN_WIDTH-110*BILI_WIDTH, 40*BILI_WIDTH);
    
    //立即还款
    if (!_returnMoneyBtn) {
        self.returnMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image1 = [Tools imageWithColor:UIColor_LightBlueButtonBGNormal andSize:CGSizeMake(self.frame.size.width, 40 *BILI_WIDTH)];
        UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:CGSizeMake(self.frame.size.width, 40*BILI_WIDTH)];
        UIImage *image3 = [Tools imageWithColor:UIColor_LightBlueButtonBGHighLight andSize:CGSizeMake(self.frame.size.width, 40 *BILI_WIDTH)];
        [_returnMoneyBtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [_returnMoneyBtn setBackgroundImage:image2 forState:UIControlStateDisabled];
        [_returnMoneyBtn setBackgroundImage:image3 forState:UIControlStateHighlighted];
        [_returnMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _returnMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        [_returnMoneyBtn setTitle:@"立即还款" forState:UIControlStateNormal];
        [_returnMoneyBtn setImage:[UIImage imageNamed:@"ReturnMoney_rightArrow"] forState:UIControlStateNormal];
        [_returnMoneyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 85*BILI_WIDTH, 0, 0)];
        [_returnMoneyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20*BILI_WIDTH, 0, 0)];
        [_returnMoneyBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:_returnMoneyBtn];
    }
    _returnMoneyBtn.frame = CGRectMake(SCREEN_WIDTH-(110+14)*BILI_WIDTH, whiteViewOriginY, 110*BILI_WIDTH, 40*BILI_WIDTH);
    
    whiteViewOriginY += _remainTimeBtn.frame.size.height;
    _whiteView.frame = CGRectMake(0, 8*BILI_WIDTH, SCREEN_WIDTH, whiteViewOriginY);
    return _whiteView;
}
-(void)drawDataWithDict:(NSDictionary *)dict
{
    _cellDict = dict;
    [self addWhiteViewSubviews:dict];
    //随时还是分期   随时还=SCHEDULED, 分期=INSTALLMENT.
    NSString *repaymentTypeString = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"repayment_type"]];
    NSString *next_installment_repay_date = @"";

    if ([repaymentTypeString isEqualToString:@"SCHEDULED"]) {
        repaymentTypeString = @"随时还";
        _titleLbl.text = @"随时还";
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:[dict valueNotNullForKey:@"repay_date"]];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateStr = [dateFormatter stringFromDate:date];
        next_installment_repay_date = [NSString stringWithFormat:@"还款时间：%@前",dateStr];
    }else{
        repaymentTypeString = @"分期还";
        _titleLbl.text = [NSString stringWithFormat:@"分期还（%@期-%@元/期)",[dict valueNotNullForKey:@"installments"],[dict valueNotNullForKey:@"installment_amount"]];
        next_installment_repay_date = [NSString stringWithFormat:@"还款时间：每月%@号之前",[dict valueNotNullForKey:@"current_installment_repay_date"]];
    }
    //创建时间
    _timeLbl.text = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"create_time"]];
    //借款金额
    _moneyLbl.text = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"amount"]];
    //余额加利息剩余未还
    _remainMoneyLbl.text = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"current_installment_amount"]];
    [_remainTimeBtn setTitle:next_installment_repay_date forState:UIControlStateNormal];
    NSString *shouldReturnMoney = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"current_installment_amount"]];

    if ([repaymentTypeString isEqualToString:@"分期还"]) {
        float overduedAmount = [[dict valueNotNullForKey:@"overdued_amount"] floatValue];
        NSString *currentInstallments = [NSString stringWithFormat:@"%@",[dict valueNotNullForKey:@"current_installment"]];

        if (overduedAmount > 0) {
            //有罚息
            NSString *allStr = [NSString stringWithFormat:@"第%@期   本期应还%@元",currentInstallments, shouldReturnMoney];
            [_shouldReturnLbl setTitle:allStr forState:UIControlStateNormal];
        } else {
            //无罚息
            NSString *allStr = [NSString stringWithFormat:@"第%@期   本期应还%@元",currentInstallments,shouldReturnMoney];
            [_shouldReturnLbl setTitle:allStr forState:UIControlStateNormal];
        }

    }
}

- (void)buttonAction
{
    if ([self.delegate respondsToSelector:@selector(BNReturnMoneyListCellDelegateReturnBtnAction:)]) {
        [_delegate BNReturnMoneyListCellDelegateReturnBtnAction:_cellDict];
    }
}
@end
