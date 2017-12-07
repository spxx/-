//
//  BNMobileRechargeResaultVC.m
//  Wallet
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNMobileRechargeResaultVC.h"

#import "BNSyncMapViewController.h"

@interface BNMobileRechargeResaultVC ()

@property (nonatomic) UIButton *resultBtn;
@property (nonatomic) UILabel *nameLbl;
@property (nonatomic) UILabel *timeLbl;
@property (nonatomic) UILabel *bankLbl;
@property (nonatomic) UILabel *amountLbl;

@end

@implementation BNMobileRechargeResaultVC
//0xda8f0d //orange
//0xfe6362 //red
//0x00c135 //green
//0x9d9d9d //gray
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor_Gray_BG;
    if (_resultControllerType == ResultControllerTypeDetailVC) {
        self.navigationTitle = @"交易详情";
    } else {
        if (_payProjectType == PayProjectTypeLoveDenote) {
            self.navigationTitle = @"捐助结果";
        } else if (_payProjectType == PayProjectTypeMobileRecharge || _payProjectType == PayProjectTypeMobileFlowRecharge){
            self.navigationTitle = @"充值结果";
        } else if (_payProjectType == PayProjectTypeSchoolPay){
            self.navigationTitle = @"缴费结果";
        }else {
            self.navigationTitle = @"充值结果";
        }

    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    CGFloat originY = self.sixtyFourPixelsView.viewBottomEdge;
    CGFloat contentSizeY = SCREEN_HEIGHT == 480 ? 500 : SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1;
    UIScrollView *theScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY)];
    theScollView.contentSize = CGSizeMake(0, contentSizeY);
    theScollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:theScollView];

    
    
    UIView *grayBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [BNTools sizeFit:90 six:110 sixPlus:120])];
    grayBGView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [theScollView addSubview:grayBGView];
    
    self.resultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resultBtn.frame = CGRectMake(0, 0, grayBGView.frame.size.width, [BNTools sizeFit:90 six:110 sixPlus:120]);
    _resultBtn.userInteractionEnabled = NO;
    [_resultBtn setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
    _resultBtn.titleLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:20 six:22 sixPlus:24]];
    [_resultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [grayBGView addSubview:_resultBtn];
    if (_payResaultType == PayResaultTypeSuccess) {
        [_resultBtn setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
        if (_payProjectType == PayProjectTypeLoveDenote) {
            [_resultBtn setTitle:@"捐助成功" forState:UIControlStateNormal];
        } else if (_payProjectType == PayProjectTypeMobileRecharge || _payProjectType == PayProjectTypeMobileFlowRecharge || _payProjectType == PayProjectTypeSchoolPay ){
            [_resultBtn setTitle:@"支付成功" forState:UIControlStateNormal];
        } else {
            [_resultBtn setTitle:@"充值成功" forState:UIControlStateNormal];
        }
    } else if (_payResaultType == PayResaultTypeDepositingButSuccess) {
        [_resultBtn setImage:[UIImage imageNamed:@"submit_fee_success"] forState:UIControlStateNormal];
        if (_payProjectType == PayProjectTypeMobileRecharge || _payProjectType == PayProjectTypeMobileFlowRecharge || _payProjectType == PayProjectTypeSchoolPay){
            [_resultBtn setTitle:@"支付成功" forState:UIControlStateNormal];
        }
    } else {
        [_resultBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Faile"] forState:UIControlStateNormal];
        if (_payProjectType == PayProjectTypeLoveDenote) {
            [_resultBtn setTitle:@"捐助失败" forState:UIControlStateNormal];
        } else {
            [_resultBtn setTitle:@"充值失败" forState:UIControlStateNormal];
        }
    }
    
    originY = grayBGView.frame.size.height;
    
    UIView *whiteBGView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(grayBGView.frame), SCREEN_WIDTH, CGRectGetHeight(theScollView.frame)-CGRectGetHeight(grayBGView.frame))];
    whiteBGView2.backgroundColor = [UIColor whiteColor];
    whiteBGView2.layer.masksToBounds = YES;
    whiteBGView2.layer.cornerRadius = 3;
    [theScollView addSubview:whiteBGView2];
    originY = 20*BILI_WIDTH;
    CGFloat seperateWidth = 20;
    CGFloat btnSeperateWidth = 20+5;
    NSString *msgStr = @"";

    switch (_payResaultType) {
        case PayResaultTypeSuccess: {
            //充值成功 #3、支付成功 #4
            if (_payProjectType == PayProjectTypeMobileRecharge || _payProjectType == PayProjectTypeMobileFlowRecharge) {
                //手机话费充值
                UILabel *lineLabel = [[UILabel alloc]init];
                lineLabel.backgroundColor = UIColorFromRGB(0xffe2e4);
                [whiteBGView2 addSubview:lineLabel];
                
                UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
                button1.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                button1.userInteractionEnabled = NO;
                [button1 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                button1.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                [button1 setTitleColor:UIColorFromRGB(0x00c135) forState:UIControlStateNormal];
                [button1 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Green"] forState:UIControlStateNormal];
                button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                if (_payWayType == PayWayTypeBalance) {
                    [button1 setTitle:@"钱包扣款成功" forState:UIControlStateNormal];
                } else {
                    [button1 setTitle:@"银行扣款成功" forState:UIControlStateNormal];
                }
                [whiteBGView2 addSubview:button1];
                
                originY += button1.frame.size.height+20*BILI_WIDTH;
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                button2.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                button2.userInteractionEnabled = NO;
                [button2 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                button2.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                [button2 setTitleColor:UIColorFromRGB(0xda8f0d) forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Orange"] forState:UIControlStateNormal];
                button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                    [button2 setTitle:@"流量预计十分钟到账，请注意查收短信" forState:UIControlStateNormal];
                } else {
                    [button2 setTitle:@"话费预计十分钟到账，请注意查收短信" forState:UIControlStateNormal];
                }
                [whiteBGView2 addSubview:button2];
                
                lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button2.center.y-button1.center.y);
                
                originY += button2.frame.size.height+30*BILI_WIDTH;
                
                ////////////////////
                self.nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _nameLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _nameLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_nameLbl];
                
                NSMutableAttributedString *nameLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易商品：%@元手机话费--%@",_resultInfo.displayMoneyStr, _resultInfo.mobileNumber]];
                if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                    nameLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易商品：%@手机流量--%@",_resultInfo.productName, _resultInfo.mobileNumber]];
                }
                [nameLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _nameLbl.attributedText = nameLblAttributeStr;
                originY += _nameLbl.frame.size.height+[BNTools sizeFit:10 six:12 sixPlus:14];
                
                self.timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _timeLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _timeLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_timeLbl];
                
                NSString *dateStr;
                if (_resultInfo.time && ![_resultInfo.time isEqualToString:@"null"]) {
                    dateStr = _resultInfo.time;
                } else {
                    //直接获取当前时间为充值时间
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                    [dateformatter setLocale:cnLocale];
                    dateStr = [dateformatter stringFromDate:date];
                }
                
                NSMutableAttributedString *timeLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易时间：%@", dateStr]];
                [timeLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _timeLbl.attributedText = timeLblAttributeStr;
                originY += _timeLbl.frame.size.height+[BNTools sizeFit:10 six:12 sixPlus:14];
                
                self.bankLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _bankLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _bankLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_bankLbl];
                NSString *bankName;
                if (_payWayType == PayWayTypeBalance) {
                    bankName = @"喜付钱包";
                } else {
                    bankName = _resultInfo.bankName;
                }
                NSMutableAttributedString *bankLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付渠道：%@", bankName]];
                [bankLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _bankLbl.attributedText = bankLblAttributeStr;
                originY += _bankLbl.frame.size.height+[BNTools sizeFit:10 six:12 sixPlus:14];
                
                self.amountLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _amountLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _amountLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_amountLbl];
                NSMutableAttributedString *amountLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易金额：%@元", _resultInfo.moneyStr]];
                [amountLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _amountLbl.attributedText = amountLblAttributeStr;
                
                originY += _amountLbl.frame.size.height;
                
            } else if (_payProjectType == PayProjectTypeSchoolPay) {
                //校园缴费
                msgStr = [NSString stringWithFormat:@""];
            } else if (_payProjectType == PayProjectTypeLoveDenote) {
                //爱心捐助
                msgStr = [NSString stringWithFormat:@"感谢您的爱心，因为您的捐助将有更多的人得到帮助，祝您幸福！"];
            } else if (_payProjectType == PayProjectTypeOneCard) {
                //一卡通
                UILabel *lineLabel = [[UILabel alloc]init];
                lineLabel.backgroundColor = UIColorFromRGB(0xffe2e4);
                [whiteBGView2 addSubview:lineLabel];
                
                UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
                button1.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                button1.userInteractionEnabled = NO;
                [button1 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                button1.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                [button1 setTitleColor:UIColorFromRGB(0x00c135) forState:UIControlStateNormal];
                [button1 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Green"] forState:UIControlStateNormal];
                button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                if (_payWayType == PayWayTypeBankCard) {
                    [button1 setTitle:@"银行扣款成功" forState:UIControlStateNormal];
                } else {
                    [button1 setTitle:@"钱包扣款成功" forState:UIControlStateNormal];
                }

                [whiteBGView2 addSubview:button1];

                originY += button1.frame.size.height+20*BILI_WIDTH;
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                button2.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                button2.userInteractionEnabled = NO;
                [button2 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                button2.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                [button2 setTitleColor:UIColorFromRGB(0x00c135) forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Green"] forState:UIControlStateNormal];
                button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button2 setTitle:@"一卡通在线充值成功" forState:UIControlStateNormal];
                [whiteBGView2 addSubview:button2];
                
                originY += button2.frame.size.height+20*BILI_WIDTH;

                if ([shareAppDelegateInstance.boenUserInfo.schoolId isEqualToString:@"13"]) {
                    //schoolId==13是重庆大学 不显示同步地图。
                    lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button2.center.y-button1.center.y);
                    
                } else {

                    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
                    button3.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                    button3.userInteractionEnabled = NO;
                    [button3 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                    button3.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                    [button3 setTitleColor:UIColorFromRGB(0xda8f0d) forState:UIControlStateNormal];
                    [button3 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Orange"] forState:UIControlStateNormal];
                    button3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [button3 setTitle:@"请到线下多媒体机同步金额" forState:UIControlStateNormal];
                    [whiteBGView2 addSubview:button3];

                    lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button3.center.y-button1.center.y);
                    originY += button3.frame.size.height+30*BILI_WIDTH;
                    
                    UILabel *msgTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18])];
                    msgTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                    msgTitleLabel.backgroundColor = [UIColor clearColor];
                    msgTitleLabel.contentMode = UIViewContentModeTopLeft;
                    msgTitleLabel.textColor = [UIColor blackColor];
                    [whiteBGView2 addSubview:msgTitleLabel];
                    msgTitleLabel.text = @"多媒体机分布";
                    
                    originY += msgTitleLabel.frame.size.height + 3;
                    msgStr = @"";
                    
                    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    mapBtn.frame = CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 330/(1020/320)*BILI_WIDTH);
                    [mapBtn setBackgroundImage:[UIImage imageNamed:@"Lives_Mobile_Map"] forState:UIControlStateNormal];
                    [mapBtn addTarget:self action:@selector(mapButtonAcion:) forControlEvents:UIControlEventTouchUpInside];
                    [whiteBGView2 addSubview:mapBtn];
                    
                    originY += mapBtn.frame.size.height;
                }

            }
            break;
        }
            
        case PayResaultTypeDepositingButSuccess: {
            //（话费）充值中，预计10分钟到账。#5
            {
                //手机话费充值---下面的代码和 PayResaultTypeSuccess里的if (_payProjectType == PayProjectTypeMobileRecharge)里面的代码一模一样
                UILabel *lineLabel = [[UILabel alloc]init];
                lineLabel.backgroundColor = UIColorFromRGB(0xffe2e4);
                [whiteBGView2 addSubview:lineLabel];
                
                UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
                button1.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                button1.userInteractionEnabled = NO;
                [button1 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                button1.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                [button1 setTitleColor:UIColorFromRGB(0x00c135) forState:UIControlStateNormal];
                [button1 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Green"] forState:UIControlStateNormal];
                button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                if (_payWayType == PayWayTypeBalance) {
                    [button1 setTitle:@"钱包扣款成功" forState:UIControlStateNormal];
                } else {
                    [button1 setTitle:@"银行扣款成功" forState:UIControlStateNormal];
                }
                [whiteBGView2 addSubview:button1];
                
                originY += button1.frame.size.height+20*BILI_WIDTH;
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                button2.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
                button2.userInteractionEnabled = NO;
                [button2 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
                button2.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                [button2 setTitleColor:UIColorFromRGB(0xda8f0d) forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Orange"] forState:UIControlStateNormal];
                button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                    [button2 setTitle:@"流量预计十分钟到账，请注意查收短信" forState:UIControlStateNormal];
                } else {
                    [button2 setTitle:@"话费预计十分钟到账，请注意查收短信" forState:UIControlStateNormal];
                }
                [whiteBGView2 addSubview:button2];
                
                lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button2.center.y-button1.center.y);
                
                originY += button2.frame.size.height+30*BILI_WIDTH;
                
                ////////////////////
                self.nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _nameLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _nameLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_nameLbl];
                
                
                NSMutableAttributedString *nameLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易商品：%@元手机话费--%@",_resultInfo.displayMoneyStr, _resultInfo.mobileNumber]];
                if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                    nameLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易商品：%@手机流量--%@",_resultInfo.productName, _resultInfo.mobileNumber]];
                }
                [nameLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _nameLbl.attributedText = nameLblAttributeStr;
                originY += _nameLbl.frame.size.height+[BNTools sizeFit:10 six:12 sixPlus:14];
                
                self.timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _timeLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _timeLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_timeLbl];
                
                //直接获取当前时间为充值时间
                NSDate *date = [NSDate date];
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                [dateformatter setLocale:cnLocale];
                NSString *dateStr = [dateformatter stringFromDate:date];
                
                NSMutableAttributedString *timeLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易时间：%@", dateStr]];
                [timeLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _timeLbl.attributedText = timeLblAttributeStr;
                originY += _timeLbl.frame.size.height+[BNTools sizeFit:10 six:12 sixPlus:14];
                
                self.bankLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _bankLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _bankLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_bankLbl];
                NSString *bankName;
                if (_payWayType == PayWayTypeBalance) {
                    bankName = @"喜付钱包";
                } else {
                    bankName = _resultInfo.bankName;
                }
                NSMutableAttributedString *bankLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付渠道：%@", bankName]];
                [bankLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _bankLbl.attributedText = bankLblAttributeStr;
                originY += _bankLbl.frame.size.height+[BNTools sizeFit:10 six:12 sixPlus:14];
                
                self.amountLbl = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 20)];
                _amountLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
                _amountLbl.backgroundColor = [UIColor clearColor];
                [whiteBGView2 addSubview:_amountLbl];
                NSMutableAttributedString *amountLblAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"交易金额：%@", _resultInfo.moneyStr]];
                [amountLblAttributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xa0a0a0) range:NSMakeRange(0, 5)];
                _amountLbl.attributedText = amountLblAttributeStr;
                
                originY += _amountLbl.frame.size.height;
                
            }
            break;
        }
        case PayResaultTypeDepositSuccessButFailed: {//用来展示银行代扣成功， 充值失败得情况
            //银行扣款成功，但充值失败 #2

            UILabel *lineLabel = [[UILabel alloc]init];
            lineLabel.backgroundColor = UIColorFromRGB(0xffe2e4);
            [whiteBGView2 addSubview:lineLabel];
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
            button1.userInteractionEnabled = NO;
            [button1 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
            button1.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
            [button1 setTitleColor:UIColorFromRGB(0x00c135) forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Green"] forState:UIControlStateNormal];
            button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button1 setTitle:@"银行扣款成功" forState:UIControlStateNormal];
            //                [button1 setTitle:[NSString stringWithFormat:@"%@", _resultInfo.depositMsg] forState:UIControlStateNormal];

            [whiteBGView2 addSubview:button1];
            
            originY += button1.frame.size.height+20*BILI_WIDTH;
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
            button2.userInteractionEnabled = NO;
            [button2 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
            button2.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
            [button2 setTitleColor:UIColorFromRGB(0xfe6362) forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Red"] forState:UIControlStateNormal];
            button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (_payProjectType == PayProjectTypeMobileRecharge) {
                [button2 setTitle:@"话费充值失败" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                [button2 setTitle:@"流量充值失败" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeOneCard){
                [button2 setTitle:@"一卡通在线充值失败" forState:UIControlStateNormal];
            } else {
                [button2 setTitle:@"捐助失败" forState:UIControlStateNormal];
            }
            [whiteBGView2 addSubview:button2];
            
            lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button2.center.y-button1.center.y);
            
            originY += button2.frame.size.height+30*BILI_WIDTH;
            
            msgStr = [NSString stringWithFormat:@"%@银行扣款已转入喜付钱包余额，下次支付可直接使用钱包余额付款。",_resultInfo.retmsg];
            
            break;
        }

        case PayResaultTypeDepositingButFailed: {//用来展示银行处理中， 充值失败得情况
            //银行扣款处理中，但充值失败 #7
            if (_payProjectType == PayProjectTypeLoveDenote) {
                [_resultBtn setTitle:@"捐助中" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeMobileRecharge || _payProjectType == PayProjectTypeMobileFlowRecharge){
                [_resultBtn setTitle:@"支付中" forState:UIControlStateNormal];
            } else {
                [_resultBtn setTitle:@"充值中" forState:UIControlStateNormal];
            }
            [_resultBtn setImage:[UIImage imageNamed:@"Lives_Mobile_Pay_Depositing"] forState:UIControlStateNormal];

            UILabel *lineLabel = [[UILabel alloc]init];
            lineLabel.backgroundColor = UIColorFromRGB(0xffe2e4);
            [whiteBGView2 addSubview:lineLabel];
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
            button1.userInteractionEnabled = NO;
            [button1 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
            button1.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
            [button1 setTitleColor:UIColorFromRGB(0xda8f0d) forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Orange"] forState:UIControlStateNormal];
            button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button1 setTitle:@"银行扣款处理中" forState:UIControlStateNormal];
            //                [button1 setTitle:[NSString stringWithFormat:@"%@", _resultInfo.depositMsg] forState:UIControlStateNormal];
            
            [whiteBGView2 addSubview:button1];
            
            originY += button1.frame.size.height+20*BILI_WIDTH;
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
            button2.userInteractionEnabled = NO;
            [button2 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
            button2.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
            [button2 setTitleColor:UIColorFromRGB(0xfe6362) forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Red"] forState:UIControlStateNormal];
            button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (_payProjectType == PayProjectTypeMobileRecharge) {
                [button2 setTitle:@"话费充值暂未进行" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                [button2 setTitle:@"流量充值暂未进行" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeOneCard){
                [button2 setTitle:@"一卡通在线充值暂未进行" forState:UIControlStateNormal];
            } else {
                [button2 setTitle:@"捐助支付暂未进行" forState:UIControlStateNormal];
            }
            [whiteBGView2 addSubview:button2];
            
            lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button2.center.y-button1.center.y);
            
            originY += button2.frame.size.height+30*BILI_WIDTH;
            
            msgStr = @"由于银行系统繁忙，扣款还在处理中，若确认扣款则会第一时间将金额充进钱包余额中，并用消息推送的方式通知您扣款结果，下次充值选择余额支付即可付款。如有疑问，请联系客服：028-61831329";
            break;
        }
            
        case PayResaultTypeDepositFailed: {
            //银行扣款失败，充值失败 #1
            if (_payProjectType == PayProjectTypeMobileRecharge){
                [_resultBtn setTitle:@"支付失败" forState:UIControlStateNormal];
            }
            UILabel *lineLabel = [[UILabel alloc]init];
            lineLabel.backgroundColor = UIColorFromRGB(0xffe2e4);
            [whiteBGView2 addSubview:lineLabel];
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
            button1.userInteractionEnabled = NO;
            [button1 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
            button1.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
            [button1 setTitleColor:UIColorFromRGB(0xfe6362) forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Red"] forState:UIControlStateNormal];
            button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button1 setTitle:@"银行扣款失败" forState:UIControlStateNormal];
            //                [button1 setTitle:[NSString stringWithFormat:@"%@", _resultInfo.depositMsg] forState:UIControlStateNormal];
            
            [whiteBGView2 addSubview:button1];
            
            originY += button1.frame.size.height+20*BILI_WIDTH;
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(btnSeperateWidth, originY, grayBGView.frame.size.width-btnSeperateWidth*2, [BNTools sizeFit:14 six:16 sixPlus:18]);
            button2.userInteractionEnabled = NO;
            [button2 setImageEdgeInsets:UIEdgeInsetsMake(-3, -5, -3, 0)];
            button2.titleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
            [button2 setTitleColor:UIColorFromRGB(0xfe6362) forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"Lives_Mobile_Circle_Red"] forState:UIControlStateNormal];
            button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (_payProjectType == PayProjectTypeMobileRecharge) {
                [button2 setTitle:@"话费充值失败" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeMobileFlowRecharge) {
                [button2 setTitle:@"流量充值失败" forState:UIControlStateNormal];
            } else if (_payProjectType == PayProjectTypeOneCard){
                [button2 setTitle:@"一卡通在线充值失败" forState:UIControlStateNormal];
            } else {
                [button2 setTitle:@"捐助失败" forState:UIControlStateNormal];
            }
            [whiteBGView2 addSubview:button2];
            
            lineLabel.frame = CGRectMake(btnSeperateWidth, button1.center.y, 1, button2.center.y-button1.center.y);
            
            originY += button2.frame.size.height+30*BILI_WIDTH;
            
            msgStr = [NSString stringWithFormat:@"%@",_resultInfo.retmsg];
            break;
        }
        case PayResaultTypeFailed: {
            //充值失败（钱包余额） #1
            msgStr = [NSString stringWithFormat:@"%@如有疑问，请联系客服：028-61831329",_resultInfo.retmsg];
            break;
        }
    }
//    if (_payProjectType != PayProjectTypeMobileRecharge) {
//        //除手机充值外，都有msgLabel
        UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, 0)];
        msgLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.contentMode = UIViewContentModeTopLeft;
        msgLabel.textColor = UIColorFromRGB(0x9d9d9d);
        [whiteBGView2 addSubview:msgLabel];
        msgLabel.numberOfLines = 0;
        msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
        msgLabel.text = msgStr;
        if (msgStr.length > 0) {
             msgLabel.frame = CGRectMake(seperateWidth, originY, whiteBGView2.frame.size.width-seperateWidth*2, [Tools caleNewsCellHeightWithTitle:msgStr font:msgLabel.font width:msgLabel.frame.size.width]);
        }else {
            msgLabel.frame = CGRectMake(0, originY, 0, 0);
        }
       
        
     originY = SCREEN_HEIGHT == 480 ? CGRectGetMaxY(msgLabel.frame)+10 : CGRectGetMaxY(msgLabel.frame)+40;
//    }
    
    if (_resultControllerType == ResultControllerTypeResultVC) {
        //结果页面才显示确定按钮
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okButton.frame = CGRectMake(seperateWidth, originY, SCREEN_WIDTH - seperateWidth *2, 40);
        [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okButton setTitle:@"确  定" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image1 = [Tools imageWithColor:UIColor_Button_Normal andSize:CGSizeMake(okButton.frame.size.width-60, 42)];
        UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:CGSizeMake(okButton.frame.size.width-60, 42)];
        UIImage *image3 = [Tools imageWithColor:UIColor_Button_HighLight andSize:CGSizeMake(okButton.frame.size.width-60, 42)];
        [okButton setBackgroundImage:image1 forState:UIControlStateNormal];
        [okButton setBackgroundImage:image2 forState:UIControlStateDisabled];
        [okButton setBackgroundImage:image3 forState:UIControlStateHighlighted];
        [okButton.titleLabel setFont:[UIFont systemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:19]]];
        okButton.layer.cornerRadius = 3;
        okButton.layer.masksToBounds = YES;
        
        [whiteBGView2 addSubview:okButton];
    }
    
}
- (void)okButtonClicked:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)mapButtonAcion:(UIButton *)button
{
    //多媒体机地图页面
    BNSyncMapViewController *yktMap = [[BNSyncMapViewController alloc] init];
    [self pushViewController:yktMap animated:YES];
}

-(void)setResultInfo:(BNMobileRechargeRasultInfo *)resultInfo
{
    _resultInfo = resultInfo;
    if(_resultInfo.retmsg.length > 0)//银行卡余额不够，服务器返回的也是执行成功，此时传过来的retmesg为空。所以加此判断。。。
    {
        _resultInfo.retmsg = [_resultInfo.retmsg isEqualToString:@"null"] ? @"" : ([NSString stringWithFormat:@"[%@]。",_resultInfo.retmsg]);
        
    }else{
        _resultInfo.retmsg = @"";
    }
    

    [self setStatusType:[resultInfo.status integerValue]];
}
-(void)setOrderDetials:(NSDictionary *)orderDetials
{
    //数据组装入口

    _orderDetials = orderDetials;
    _resultInfo = [[BNMobileRechargeRasultInfo alloc]init];
    _resultInfo.retmsg = [[orderDetials valueNotNullForKey:@"retmsg"] isEqualToString:@"null"] ? @"" : ([NSString stringWithFormat:@"[%@]。",[orderDetials valueNotNullForKey:@"retmsg"]]);
    _resultInfo.time = [orderDetials valueNotNullForKey:@"create_time"];
    _resultInfo.mobileNumber = [orderDetials valueNotNullForKey:@"recharge_mobile"];
    _resultInfo.bankName = [orderDetials valueNotNullForKey:@"bank_name"];
    _resultInfo.displayMoneyStr = [orderDetials valueNotNullForKey:@"amount"];
    _resultInfo.moneyStr = [orderDetials valueNotNullForKey:@"sale_amount"];
    _resultInfo.productName = [orderDetials valueNotNullForKey:@"prj_name"];

    //PayWayType
    NSInteger paywaytype = [[orderDetials valueNotNullForKey:@"recharge_type"] integerValue];
    _payWayType = (paywaytype == 0) ? PayWayTypeBankCard : PayWayTypeBalance;//充值方式

    [self setStatusType:[[orderDetials valueNotNullForKey:@"status"] integerValue]];

    //PayProjectType
    NSInteger payProjectType = [[orderDetials valueNotNullForKey:@"busi_type"] integerValue];
    switch (payProjectType) {
        case 1: {
            _payProjectType = PayProjectTypeOneCard;//一卡通
            break;
        }
        case 2: {
            _payProjectType = PayProjectTypeLoveDenote;//爱心捐助
            break;
        }
        case 3: {
            _payProjectType = PayProjectTypeMobileRecharge;//手机话费充值
            break;
        }
        case 8:
        {
            _payProjectType = PayProjectTypeMobileFlowRecharge;//流量充值
            break;
        }
    }
    
    _resultControllerType = ResultControllerTypeDetailVC;
}

- (void)setStatusType:(NSInteger)status
{
//    STATUS_INIT = 1     # 创建
//    STATUS_DEPOSIT = 2   # 代扣成功
//    STATUS_RCHARGE = 3   # 充值成功(转账失败不用客户端考虑)
//    STATUS_PAY = 4      # 支付成功
//    STATUS_PENDING = 5  # 充值中
//    STATUS_REFUND = 6  # 应返还用户资金
//    STATUS_DEPOSITING = 7 #扣款处理中
//    STATUS_BALANCE_TRANSTATION = 8 #过渡余额中
//    12 = 扣款成功，充值失败

    switch (status) {
        case 0: {
            self.payResaultType = PayResaultTypeFailed;//充值失败
            break;
        }
        case 1: {
            if (_payWayType == PayWayTypeBankCard) {//充值方式，银行卡/钱包
                
                self.payResaultType = PayResaultTypeDepositFailed;//银行扣款失败，充值失败
            } else {
                self.payResaultType = PayResaultTypeFailed;//充值失败
            }
            break;
        }
        case 2: {
            self.payResaultType = PayResaultTypeDepositSuccessButFailed;//用来展示银行代扣成功， 充值失败得情况 //银行扣款成功，但充值失败
            break;
        }
        case 6: {
            self.payResaultType = PayResaultTypeDepositSuccessButFailed;//用来展示银行代扣成功， 充值失败得情况 //银行扣款成功，但充值失败
            break;
        }
        case 3: {
            self.payResaultType = PayResaultTypeSuccess;//充值成功
            break;
        }
        case 4: {
            self.payResaultType = PayResaultTypeSuccess;//支付成功
            break;
        }
        case 5: {
            self.payResaultType = PayResaultTypeDepositingButSuccess;//（话费）充值中，预计10分钟到账。
            break;
        }
            
        case 7:
        case 8: {
            self.payResaultType = PayResaultTypeDepositingButFailed;//用来展示银行处理中， 充值失败得情况 //银行扣款处理中，但充值失败

            break;
        case 12:
            self.payResaultType = PayResaultTypeDepositSuccessButFailed;
            break;
        }
    }

}

- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"BNSetNewPayPwdViewController")]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
    }
    [super backButtonClicked:sender];
}

@end
