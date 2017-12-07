//
//  BNFeesDetialsNormalVC.m
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNFeesDetialsNormalVC.h"

@interface BNFeesDetialsNormalVC ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *schoolImg;
@property (nonatomic) UILabel *schoolNameLbl;
@property (nonatomic) UILabel *moneyLbl;
@property (nonatomic) UILabel *projectNameLbl;
@property (nonatomic) UILabel *projectIntroLbl;
@property (nonatomic) UILabel *payTimeRangeLbl;
//@property (nonatomic) UILabel *payTimeLbl;
@property (nonatomic) UILabel *feesStatusLab;



@end

@implementation BNFeesDetialsNormalVC

- (void)setupLoadedView
{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    _scrollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:_scrollView];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteView];
    
    CGFloat originX1 = 16*BILI_WIDTH;
    CGFloat originX2 = 95*BILI_WIDTH;
    CGFloat fontSizeSmall = [BNTools sizeFit:12 six:14 sixPlus:16];
    self.schoolImg = [[UIImageView alloc]initWithFrame:CGRectMake(12*BILI_WIDTH, 9*BILI_WIDTH, 56*BILI_WIDTH, 56*BILI_WIDTH)];
    _schoolImg.layer.cornerRadius = _schoolImg.frame.size.width/2;
    _schoolImg.layer.masksToBounds = YES;
    [_schoolImg sd_setImageWithURL:[NSURL URLWithString:shareAppDelegateInstance.boenUserInfo.schoolIcon]];
    [whiteView addSubview:_schoolImg];
    
    self.schoolNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, 28*BILI_WIDTH, SCREEN_WIDTH - originX2 - 20*BILI_WIDTH, [BNTools sizeFit:16 six:18 sixPlus:20])];
    _schoolNameLbl.font = [UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]];
    _schoolNameLbl.textColor = [UIColor blackColor];
    _schoolNameLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _schoolNameLbl];
    _schoolNameLbl.text = shareAppDelegateInstance.boenUserInfo.schoolName;
    
    CGFloat originY = 75*BILI_WIDTH;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(90*BILI_WIDTH, originY, SCREEN_WIDTH-90*BILI_WIDTH, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [whiteView addSubview:lineView];
    
    originY += 15*BILI_WIDTH + lineView.frame.size.height;
    
    UILabel *moneyL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    moneyL.font = [UIFont systemFontOfSize:fontSizeSmall];
    moneyL.textColor = UIColorFromRGB(0x919191);
    moneyL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: moneyL];
    moneyL.text = @"缴费金额";

    self.moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, [BNTools sizeFit:25 six:27 sixPlus:29])];
    _moneyLbl.font = [UIFont systemFontOfSize:[BNTools sizeFit:25 six:27 sixPlus:29]];
    _moneyLbl.textColor = [UIColor blackColor];
    _moneyLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _moneyLbl];

    originY = 145*BILI_WIDTH ;

    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(90*BILI_WIDTH, originY, SCREEN_WIDTH-90*BILI_WIDTH, 1)];
    lineView2.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [whiteView addSubview:lineView2];
    
    originY += 19*BILI_WIDTH + lineView2.frame.size.height;

    UILabel *projectL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    projectL.font = [UIFont systemFontOfSize:fontSizeSmall];
    projectL.textColor = UIColorFromRGB(0x919191);
    projectL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: projectL];
    projectL.text = @"缴费项目";
    

    NSString *prjName = [_detailDict valueNotNullForKey:@"prj_name"];
    NSAttributedString *prjNameAttString = [[NSAttributedString alloc] initWithString:prjName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeSmall]}]; //为了适配iOS6，所以改用下面的方法
    CGFloat prjNameTextHeight = [prjNameAttString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - originX2- 20*BILI_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    self.projectNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, prjNameTextHeight + 2)];
    _projectNameLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _projectNameLbl.numberOfLines = 0;
    _projectNameLbl.textColor = [UIColor blackColor];
    _projectNameLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _projectNameLbl];

    originY += _projectNameLbl.frame.size.height + 19*BILI_WIDTH;
    
    UILabel *projectIntroL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    projectIntroL.font = [UIFont systemFontOfSize:fontSizeSmall];
    projectIntroL.textColor = UIColorFromRGB(0x919191);
    projectIntroL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: projectIntroL];
    projectIntroL.text = @"项目简介";
    
    NSString *prjIntro = [_detailDict valueNotNullForKey:@"prj_introduction"];
    NSAttributedString *prjIntoAttString = [[NSAttributedString alloc] initWithString:prjIntro attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeSmall]}];
    CGFloat prjIntroTextHeight = [prjIntoAttString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - originX2- 20*BILI_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    self.projectIntroLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, prjIntroTextHeight+2)];
    _projectIntroLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _projectIntroLbl.numberOfLines = 0;
    _projectIntroLbl.textColor = [UIColor blackColor];
    _projectIntroLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _projectIntroLbl];

    originY += _projectIntroLbl.frame.size.height + 19*BILI_WIDTH;

    UILabel *payTimeRangeL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    payTimeRangeL.font = [UIFont systemFontOfSize:fontSizeSmall];
    payTimeRangeL.textColor = UIColorFromRGB(0x919191);
    payTimeRangeL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: payTimeRangeL];
    payTimeRangeL.text = @"缴费周期";
    
    self.payTimeRangeLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, fontSizeSmall)];
    _payTimeRangeLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _payTimeRangeLbl.textColor = [UIColor blackColor];
    _payTimeRangeLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _payTimeRangeLbl];
    
    originY += _payTimeRangeLbl.frame.size.height + 19*BILI_WIDTH;

    //屏蔽缴费时间--->>>>(ru)
//    if (!([[_detailDict valueNotNullForKey:@"prj_status"] integerValue] == 3 && [[_detailDict valueNotNullForKey:@"status"] integerValue] == 0)) {
//        UILabel *payTimeL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
//        payTimeL.font = [UIFont systemFontOfSize:fontSizeSmall];
//        payTimeL.textColor = UIColorFromRGB(0x919191);
//        payTimeL.backgroundColor = [UIColor clearColor];
//        [whiteView addSubview: payTimeL];
//        payTimeL.text = @"缴费时间";
        
//        self.payTimeLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, fontSizeSmall)];
//        _payTimeLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
//        _payTimeLbl.textColor = [UIColor blackColor];
//        _payTimeLbl.backgroundColor = [UIColor clearColor];
//        [whiteView addSubview: _payTimeLbl];
//        
//        originY += _payTimeLbl.frame.size.height + 19*BILI_WIDTH;
//    }<<<<<<-------------
   
    UILabel *payStatusL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    payStatusL.font = [UIFont systemFontOfSize:fontSizeSmall];
    payStatusL.textColor = UIColorFromRGB(0x919191);
    payStatusL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: payStatusL];
    payStatusL.text = @"缴费状态";
    
    self.feesStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2.5*BILI_WIDTH, SCREEN_WIDTH-originX2-20*BILI_WIDTH, fontSizeSmall+5*BILI_WIDTH)];
    _feesStatusLab.font = [UIFont systemFontOfSize:fontSizeSmall];
    _feesStatusLab.textColor = [UIColor blackColor];
    _feesStatusLab.backgroundColor = [UIColor clearColor];
    _feesStatusLab.layer.cornerRadius = _feesStatusLab.frame.size.height/2;
    _feesStatusLab.layer.masksToBounds = YES;
    [whiteView addSubview: _feesStatusLab];

    originY += _feesStatusLab.frame.size.height + 45*BILI_WIDTH;

    whiteView.frame = CGRectMake(0, 10*BILI_WIDTH, SCREEN_WIDTH, originY);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLoadedView];
    
    [self drawData:_detailDict];
}

- (void)drawData:(NSDictionary *)dict
{
    self.navigationTitle = @"教育缴费";
    _moneyLbl.text = [NSString stringWithFormat:@"%@元",[dict valueNotNullForKey:@"amount"]];
    _projectNameLbl.text = [dict valueNotNullForKey:@"prj_name"];
    _projectIntroLbl.text = [dict valueNotNullForKey:@"prj_introduction"];
    
    NSString *startTime = [dict valueNotNullForKey:@"valid_start_time"];
    NSString *endTime = [dict valueNotNullForKey:@"valid_end_time"];
    if (startTime.length > 0 && [startTime isEqualToString:@"null"] != YES && endTime.length > 0 && [endTime isEqualToString:@"null"] != YES) {
        NSDateFormatter *dateFormatter1= [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter1 dateFromString:startTime];
        startTime = [dateFormatter2 stringFromDate:startDate];
        NSDate *endDate = [dateFormatter1 dateFromString:endTime];
        endTime = [dateFormatter2 stringFromDate:endDate];
        _payTimeRangeLbl.text = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
    }
    
//    _payTimeLbl.text = [dict valueNotNullForKey:@"create_time"];
    
//    NSString *statusStr = @"";
//            用户状态status       0：未缴费 1: 缴费进行中 2：缴费成功 3: 退款 4: 交费失败
//            项目状态prj_status   1:项目有效 2:项目暂停 3:项目撤销 4:项目过期

    NSString *prjStatus = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"prj_status"]];
    NSString *status = [NSString stringWithFormat:@"%@", [dict valueNotNullForKey:@"status"]];
    switch ([prjStatus intValue]) {
        case 1:
        {
            switch ([status intValue]) {
                case 0:
                    _feesStatusLab.text = @"未缴纳";
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴纳";
                    break;
                    
                case 3:
                    _feesStatusLab.text = @"已退费";
                    break;
                case 4:
                    _feesStatusLab.text = @"缴纳失败";
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
                    _feesStatusLab.text = @"已暂停";
                    break;
                case 3:
                    _feesStatusLab.text = @"已退费，费用已退还到喜付钱包。";
                    break;

                case 1:
                    _feesStatusLab.text = @"处理中";
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴纳";
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 3:
            switch ([status intValue]) {
                case 0:
                case 4:
                    _feesStatusLab.text = @"已取消";
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    break;
                case 2:
                case 3:
                    _feesStatusLab.text = @"已取消，费用已退还到喜付钱包。";
                    break;
                default:
                    break;
            }
            
            break;
        case 4:
            switch ([status intValue]) {
                case 0:
                case 4:
                    _feesStatusLab.text = @"已过期";
                    break;
                case 3:
                    _feesStatusLab.text = @"已过期，费用已退还到喜付钱包。";
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴纳";
                    break;
                default:
                    break;
            }
            
            break;
        default:
            break;
    }

}

@end
