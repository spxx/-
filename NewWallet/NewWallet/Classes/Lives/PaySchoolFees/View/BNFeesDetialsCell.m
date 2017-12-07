//
//  BNFeesDetialsCell.m
//  Wallet
//
//  Created by mac1 on 15/3/17.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNFeesDetialsCell.h"

#import "BNBKView.h"

@interface BNFeesDetialsCell ()

@end

@implementation BNFeesDetialsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = UIColor_Gray_BG;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 1, kFeesCellHeight)];
        vLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
        [self.contentView addSubview:vLine];
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(4.5, kBKSubViewHeight + (kFeesCellHeight - kBKSubViewHeight * 2) / 2 - 6, 12, 12)];
        circleView.layer.cornerRadius = 6;
        circleView.backgroundColor = UIColorFromRGB(0xd9d9d9);
        [self.contentView addSubview:circleView];
        
        UILabel *feesDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, SCREEN_WIDTH - 25 - 8, kBKSubViewHeight)];
        feesDateLabel.backgroundColor = [UIColor clearColor];
        feesDateLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:12 sixPlus:15]];
        feesDateLabel.textColor = UIColorFromRGB(0xc8c8c8);
        [self.contentView addSubview:feesDateLabel];
        
        BNBKView *bkView = [[BNBKView alloc] initWithFrame:CGRectMake(20, kBKSubViewHeight, SCREEN_WIDTH - 8 - 20, kFeesCellHeight - kBKSubViewHeight)];
        bkView.backgroundColor = [UIColor clearColor];
        
        UILabel *feeAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(bkView.frame.size.width - 120 -10, ((kFeesCellHeight - kBKSubViewHeight * 2) - 40)/2, 120, 40)];
        feeAmountLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:17]];
        feeAmountLabel.textAlignment = NSTextAlignmentRight;
        [bkView addSubview:feeAmountLabel];
        
        UILabel *feeLevelsPayLbl = [[UILabel alloc] initWithFrame:CGRectMake(bkView.frame.size.width -50*BILI_WIDTH -10, ((kFeesCellHeight - kBKSubViewHeight * 2) - 17*BILI_WIDTH)/2, 50*BILI_WIDTH, 17*BILI_WIDTH)];
        feeLevelsPayLbl.layer.cornerRadius = 3;
        feeLevelsPayLbl.layer.masksToBounds = YES;
        feeLevelsPayLbl.layer.borderColor = UIColorFromRGB(0x0084ff).CGColor;
        feeLevelsPayLbl.layer.borderWidth = 1;
        feeLevelsPayLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:10 six:11 sixPlus:12]];
        feeLevelsPayLbl.textColor = UIColorFromRGB(0x0084ff);
        feeLevelsPayLbl.textAlignment = NSTextAlignmentCenter;
        [bkView addSubview:feeLevelsPayLbl];
        feeLevelsPayLbl.text = @"自主缴费";
        feeLevelsPayLbl.hidden = YES;

        UILabel *feeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kArrowWidth + 10, ((kFeesCellHeight - kBKSubViewHeight * 2) - 40)/2, bkView.frame.size.width - kArrowWidth - 10 - 120, 40)];
        feeNameLabel.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:15 six:16 sixPlus:17]];
        feeNameLabel.textAlignment = NSTextAlignmentLeft;
        [bkView addSubview:feeNameLabel];
       
        CGFloat statusWidth = [BNTools sizeFit:58 six:65 sixPlus:75];
        
        UILabel *submitFeeDate = [[UILabel alloc] initWithFrame:CGRectMake(kArrowWidth + 10, kFeesCellHeight - kBKSubViewHeight * 2, bkView.frame.size.width - kArrowWidth - 10 - statusWidth, kBKSubViewHeight)];
        submitFeeDate.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:12 sixPlus:15]];
        submitFeeDate.textAlignment = NSTextAlignmentLeft;
        submitFeeDate.textColor = UIColorFromRGB(0x9e9e9e);
        [bkView addSubview:submitFeeDate];
        
        
        UILabel *feeStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(bkView.frame.size.width - statusWidth - 10, kFeesCellHeight - kBKSubViewHeight * 2+(kBKSubViewHeight - 20)/2, statusWidth, 20)];
        feeStatusLabel.layer.cornerRadius = 10;
        feeStatusLabel.layer.masksToBounds = YES;
        feeStatusLabel.textColor = [UIColor redColor];
        feeStatusLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:13 sixPlus:14]];
        feeStatusLabel.textColor = [UIColor whiteColor];
        feeStatusLabel.textAlignment = NSTextAlignmentCenter;
        feeStatusLabel.backgroundColor = [UIColor greenColor];
        [bkView addSubview:feeStatusLabel];
        
        [self.contentView addSubview:bkView];
        
        _feesDateLab       = feesDateLabel;
        _feesNameLab       = feeNameLabel;
        _feesAmountLab     = feeAmountLabel;
        _feeLevelsPayLbl   = feeLevelsPayLbl;
        _feesSubmitDateLab = submitFeeDate;
        _feesStatusLab     = feeStatusLabel;
      
    }

    return self;
}


- (void)setupCellWithFeesInfo:(NSDictionary *)info
{
    if ([[info valueNotNullForKey:@"type"] integerValue] == 2) {
        //自主缴费
        _feeLevelsPayLbl.hidden = NO;
        _feesAmountLab.hidden = YES;
    } else {
        _feeLevelsPayLbl.hidden = YES;
        _feesAmountLab.hidden = NO;
        id amount = [info valueForKey:@"amount"];
        if (amount) {
            _feesAmountLab.text = [NSString stringWithFormat:@"%@元", amount];
        }
    }
    
    NSString *feesName = [info valueNotNullForKey:@"prj_name"];
    if (feesName.length > 0 && [feesName isEqualToString:@"null"] != YES) {
        _feesNameLab.text = feesName;
    }
    
    
    NSString *createTime = [info valueNotNullForKey:@"create_time"];
    if (createTime.length > 0 && [createTime isEqualToString:@"null"] != YES) {
        _feesDateLab.text = createTime;
    }
    
    NSString *startTime = [info valueNotNullForKey:@"valid_start_time"];
    NSString *endTime = [info valueNotNullForKey:@"valid_end_time"];
    if (startTime.length > 0 && [startTime isEqualToString:@"null"] != YES && endTime.length > 0 && [endTime isEqualToString:@"null"] != YES) {
        NSDateFormatter *dateFormatter1= [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy.MM.dd"];
        NSDate *startDate = [dateFormatter1 dateFromString:startTime];
        startTime = [dateFormatter2 stringFromDate:startDate];
        NSDate *endDate = [dateFormatter1 dateFromString:endTime];
        endTime = [dateFormatter2 stringFromDate:endDate];
//        _feesSubmitDateLab.text = [NSString stringWithFormat:@"缴费周期:%@ ~ %@", startTime, endTime];
        _feesSubmitDateLab.text = [NSString stringWithFormat:@"截止日期 %@", endTime];//现在只显示截止日期了

    }
    NSString *prjStatus = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"prj_status"]];
    NSString *status = [NSString stringWithFormat:@"%@", [info valueNotNullForKey:@"status"]];
    switch ([prjStatus intValue]) {
        case 1:
        {
            switch ([status intValue]) {
                case 0:
                    _feesStatusLab.text = @"未缴纳";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴纳";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);
                    break;
                    
                case 3:
                    _feesStatusLab.text = @"已退费";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);
                    break;
                case 4:
                    _feesStatusLab.text = @"缴纳失败";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);//黄色
                    break;
                case 5:
                    _feesStatusLab.text = @"未缴清";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 2:
        {
            switch ([status intValue]) {
                case 0:
                case 4:
                case 5:
                    _feesStatusLab.text = @"已暂停";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xbcbcbc);
                    break;
                case 3:
                    _feesStatusLab.text = @"已退费";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);
                    break;
                    
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴纳";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        case 3:
            switch ([status intValue]) {
                case 0:
                case 2:
                case 4:
                case 5:
                    _feesStatusLab.text = @"已取消";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xbcbcbc);
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);
                    break;
                    
                case 3:
                    _feesStatusLab.text = @"已退费";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);
                    break;
                default:
                    break;
            }
            
            break;
        case 4:
            switch ([status intValue]) {
                case 0:
                case 4:
                case 5:
                    _feesStatusLab.text = @"已过期";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xbcbcbc);//灰色
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0xfab600);//黄色
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴纳";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);//蓝色
                    break;
                case 3:
                    _feesStatusLab.text = @"已退费";
                    _feesStatusLab.backgroundColor = UIColorFromRGB(0x2387f8);
                    break;
                    
                default:
                    break;
            }
            
            break;
        default:
            break;
    }
    if ([_feesStatusLab.text isEqualToString:@"缴纳失败"] || [_feesStatusLab.text isEqualToString:@"未缴纳"] || [_feesStatusLab.text isEqualToString:@"已缴纳"] || [_feesStatusLab.text isEqualToString:@"已退费"]) {
        _feesNameLab.textColor = [UIColor blackColor];
    } else {
        _feesNameLab.textColor = UIColorFromRGB(0x9e9e9e);
    }

}
@end
