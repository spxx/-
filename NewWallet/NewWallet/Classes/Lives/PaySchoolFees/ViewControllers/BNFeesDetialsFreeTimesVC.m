//
//  BNFeesDetialsFreeTimesVC.m
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNFeesDetialsFreeTimesVC.h"
#import "BNFeesDetialsFreeTimesCell.h"
#import "NewSchoolFeesApi.h"

@interface BNFeesDetialsFreeTimesVC ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *schoolImg;
@property (nonatomic) UILabel *projectTitleNameLbl;
@property (nonatomic) UILabel *moneyLeftLbl;
@property (nonatomic) UILabel *moneyLbl;

@property (nonatomic) UILabel *remarkNameLbl;
@property (nonatomic) UILabel *shouldPayLbl;
@property (nonatomic) UILabel *hadPayLbl;

@property (nonatomic) UILabel *payTimeRangeLbl;
//@property (nonatomic) UILabel *payTimeLbl;
@property (nonatomic) UILabel *feesStatusLab;
@property (nonatomic) UILabel *payInfoLbl;
@property (nonatomic) UIButton *nextStepButton;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;

@end

@implementation BNFeesDetialsFreeTimesVC

static BOOL payCompleted;
static BOOL projectAvailable;

- (void)setupLoadedView
{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge)];
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    _scrollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:_scrollView];
    
    CGFloat originX1 = 15*BILI_WIDTH;
    CGFloat originX2 = 89*BILI_WIDTH;
    
    if (!payCompleted && projectAvailable) {
        //底部立即支付按钮
        _scrollView.frame = CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-self.sixtyFourPixelsView.viewBottomEdge-100*BILI_WIDTH+23*BILI_WIDTH);
        
        UIImageView *bottomWhiteView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100*BILI_WIDTH, SCREEN_WIDTH, 50*BILI_WIDTH)];
        
        UIImage *bgImg = [[UIImage imageNamed:@"BNFeesDetials_bgLine"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 1*BILI_WIDTH, 1)];
        bottomWhiteView.image = bgImg;
        bottomWhiteView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bottomWhiteView];
        
        self.payInfoLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX1, 25*BILI_WIDTH, SCREEN_WIDTH - 2*originX1, 14*BILI_WIDTH)];
        _payInfoLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        _payInfoLbl.textColor = UIColorFromRGB(0xb0bec5);
        _payInfoLbl.backgroundColor = [UIColor clearColor];
        [bottomWhiteView addSubview: _payInfoLbl];
        if ([[_detailDict valueNotNullForKey:@"multiplePay"] integerValue] == 1) {
            //1：多次缴费项目
            _payInfoLbl.text = @"若您的银行卡有支付限额，可选择分次支付";
        } else {
            //0：一次性缴清项目
            _payInfoLbl.text = @"该费用项必须一次性全额缴付";
        }

        self.nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.frame = CGRectMake(30, SCREEN_HEIGHT-50 * BILI_WIDTH, SCREEN_WIDTH-2*30, 40 * BILI_WIDTH);
        [_nextStepButton setupTitle:@"立即支付" enable:YES];
        _nextStepButton.layer.cornerRadius = 0;
        [_nextStepButton addTarget:self action:@selector(nextStepButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextStepButton];
    }
    
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteView];
    
    CGFloat fontSizeSmall = 14*BILI_WIDTH;
    self.schoolImg = [[UIImageView alloc]initWithFrame:CGRectMake(12*BILI_WIDTH, (134-53)*BILI_WIDTH/2, 53*BILI_WIDTH, 53*BILI_WIDTH)];
    _schoolImg.layer.cornerRadius = _schoolImg.frame.size.width/2;
    _schoolImg.layer.masksToBounds = YES;
    [_schoolImg sd_setImageWithURL:[NSURL URLWithString:shareAppDelegateInstance.boenUserInfo.schoolIcon]];
    [whiteView addSubview:_schoolImg];
    
    self.projectTitleNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, 22*BILI_WIDTH , SCREEN_WIDTH - originX2 - 20*BILI_WIDTH, fontSizeSmall)];
    _projectTitleNameLbl.font = [UIFont boldSystemFontOfSize:fontSizeSmall];
    _projectTitleNameLbl.textColor = UIColor_Black_Text;
    _projectTitleNameLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _projectTitleNameLbl];
    _projectTitleNameLbl.text = [_detailDict valueNotNullForKey:@"prj_name"];
    
    CGFloat originY = 58*BILI_WIDTH;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(90*BILI_WIDTH, originY, SCREEN_WIDTH-90*BILI_WIDTH, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [whiteView addSubview:lineView];
    
    originY += (76*BILI_WIDTH-fontSizeSmall)/2 + lineView.frame.size.height;
    
    self.moneyLeftLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY, SCREEN_WIDTH - originX2 - 20*BILI_WIDTH, fontSizeSmall)];
    _moneyLeftLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _moneyLeftLbl.textColor = UIColor_Black_Text;
    _moneyLeftLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _moneyLeftLbl];
    
    _moneyLeftLbl.text = @"已缴费";
    
    self.moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2+77*BILI_WIDTH, originY-((27-1.8)*BILI_WIDTH-fontSizeSmall) , SCREEN_WIDTH - originX2- (20+77)*BILI_WIDTH, 27*BILI_WIDTH)];
    _moneyLbl.font = [UIFont systemFontOfSize:27*BILI_WIDTH];
    _moneyLbl.textColor = UIColor_Black_Text;
    _moneyLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _moneyLbl];
    
    originY = 134*BILI_WIDTH;
    
    UIView *grayLineView0 = [[UIView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 10*BILI_WIDTH)];
    grayLineView0.backgroundColor = UIColor_Gray_BG;
    [whiteView addSubview:grayLineView0];
    
    originY += 15*BILI_WIDTH + grayLineView0.frame.size.height;
//    状态    备注      截止日期    应交  （已交 ）
    UILabel *statusL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, 15*BILI_WIDTH)];
    statusL.font = [UIFont systemFontOfSize:fontSizeSmall];
    statusL.textColor = UIColorFromRGB(0x90a4ae);
    statusL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: statusL];
    statusL.text = @"状态";
    
    NSString *statusName = [_detailDict valueNotNullForKey:@"status"];
    NSAttributedString *statusNameAttString = [[NSAttributedString alloc] initWithString:statusName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeSmall]}]; //为了适配iOS6，所以改用下面的方法
    CGFloat statusNameTextHeight = [statusNameAttString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - originX2- 20*BILI_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    self.feesStatusLab = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, statusNameTextHeight + 2)];
    _feesStatusLab.font = [UIFont systemFontOfSize:fontSizeSmall];
    _feesStatusLab.numberOfLines = 0;
    _feesStatusLab.textColor = UIColor_Black_Text;
    _feesStatusLab.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _feesStatusLab];
    
    originY += statusNameTextHeight + 15*BILI_WIDTH;
    
    UIView *lineView001 = [[UIView alloc]initWithFrame:CGRectMake(originX1, originY, SCREEN_WIDTH-originX1, 1)];
    lineView001.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [whiteView addSubview:lineView001];
    
    originY += 15*BILI_WIDTH;
    
    UILabel *remarkL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, 15*BILI_WIDTH)];
    remarkL.font = [UIFont systemFontOfSize:fontSizeSmall];
    remarkL.textColor = UIColorFromRGB(0x90a4ae);
    remarkL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: remarkL];
    remarkL.text = @"备注";
    
    NSString *remarkName = [_detailDict valueNotNullForKey:@"prj_remark"];
    NSAttributedString *remarkNameAttString = [[NSAttributedString alloc] initWithString:remarkName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeSmall]}]; //为了适配iOS6，所以改用下面的方法
    CGFloat remarkNameTextHeight = [remarkNameAttString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - originX2- 20*BILI_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    self.remarkNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, remarkNameTextHeight + 2)];
    _remarkNameLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _remarkNameLbl.numberOfLines = 0;
    _remarkNameLbl.textColor = UIColor_Black_Text;
    _remarkNameLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _remarkNameLbl];
    
    originY += remarkNameTextHeight + 15*BILI_WIDTH;
    
    UIView *lineView00 = [[UIView alloc]initWithFrame:CGRectMake(originX1, originY, SCREEN_WIDTH-originX1, 1)];
    lineView00.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [whiteView addSubview:lineView00];
    
    originY += 15*BILI_WIDTH;
    
    UILabel *payTimeRangeL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    payTimeRangeL.font = [UIFont systemFontOfSize:fontSizeSmall];
    payTimeRangeL.textColor = UIColorFromRGB(0x90a4ae);
    payTimeRangeL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: payTimeRangeL];
    payTimeRangeL.text = @"截止日期";
    
    self.payTimeRangeLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, fontSizeSmall)];
    _payTimeRangeLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _payTimeRangeLbl.textColor = UIColor_Black_Text;
    _payTimeRangeLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _payTimeRangeLbl];
    
    originY += _payTimeRangeLbl.frame.size.height + 15*BILI_WIDTH;
    
    UIView *lineView01 = [[UIView alloc]initWithFrame:CGRectMake(originX1, originY, SCREEN_WIDTH-originX1, 1)];
    lineView01.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [whiteView addSubview:lineView01];
    
    originY += 15*BILI_WIDTH;

    UILabel *projectIntroL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
    projectIntroL.font = [UIFont systemFontOfSize:fontSizeSmall];
    projectIntroL.textColor = UIColorFromRGB(0x90a4ae);
    projectIntroL.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: projectIntroL];
    projectIntroL.text = @"应缴金额";
    
    NSString *prjIntro = [NSString stringWithFormat:@"%.2f",[[_detailDict valueNotNullForKey:@"amount"] floatValue]];
    NSAttributedString *prjIntoAttString = [[NSAttributedString alloc] initWithString:prjIntro attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeSmall]}];
    CGFloat prjIntroTextHeight = [prjIntoAttString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - originX2- 20*BILI_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    self.shouldPayLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, prjIntroTextHeight+2)];
    _shouldPayLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
    _shouldPayLbl.numberOfLines = 0;
    _shouldPayLbl.textColor = UIColor_Black_Text;
    _shouldPayLbl.backgroundColor = [UIColor clearColor];
    [whiteView addSubview: _shouldPayLbl];
    
    originY += prjIntroTextHeight + 15*BILI_WIDTH;
    
    if (([[_detailDict valueNotNullForKey:@"status"] integerValue] == 5) || ([[_detailDict valueNotNullForKey:@"status"] integerValue] == 2)) {
        UIView *lineView02 = [[UIView alloc]initWithFrame:CGRectMake(originX1, originY, SCREEN_WIDTH-originX1, 1)];
        lineView02.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [whiteView addSubview:lineView02];
        originY += 15*BILI_WIDTH;

        UILabel *projectIntroL = [[UILabel alloc]initWithFrame:CGRectMake(originX1, originY, 60*BILI_WIDTH, fontSizeSmall)];
        projectIntroL.font = [UIFont systemFontOfSize:fontSizeSmall];
        projectIntroL.textColor = UIColorFromRGB(0x90a4ae);
        projectIntroL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview: projectIntroL];
        projectIntroL.text = @"已缴金额";
        
        NSString *prjIntro = [NSString stringWithFormat:@"%.2f",[[_detailDict valueNotNullForKey:@"payed_ammount"] floatValue]];
        NSAttributedString *prjIntoAttString = [[NSAttributedString alloc] initWithString:prjIntro attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSizeSmall]}];
        CGFloat prjIntroTextHeight = [prjIntoAttString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - originX2- 20*BILI_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        self.hadPayLbl = [[UILabel alloc]initWithFrame:CGRectMake(originX2, originY-2, SCREEN_WIDTH - originX2- 20*BILI_WIDTH, prjIntroTextHeight+2)];
        _hadPayLbl.font = [UIFont systemFontOfSize:fontSizeSmall];
        _hadPayLbl.numberOfLines = 0;
        _hadPayLbl.textColor = UIColor_Black_Text;
        _hadPayLbl.backgroundColor = [UIColor clearColor];
        [whiteView addSubview: _hadPayLbl];
        
        originY += prjIntroTextHeight + 15*BILI_WIDTH;
        
        UIView *lineView01 = [[UIView alloc]initWithFrame:CGRectMake(originX1, originY, SCREEN_WIDTH-originX1, 1)];
        lineView01.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [whiteView addSubview:lineView01];
        
        originY += 1;
    }
    whiteView.frame = CGRectMake(0, 10*BILI_WIDTH, SCREEN_WIDTH, originY);
    originY += 10*BILI_WIDTH;
    
    if (_dataArray.count > 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55*BILI_WIDTH)];
        headView.backgroundColor = [UIColor whiteColor];
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*BILI_WIDTH)];
        grayView.backgroundColor = UIColor_Gray_BG;
        [headView addSubview:grayView];
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX1, 10*BILI_WIDTH, SCREEN_WIDTH - originX1 * 2, 45*BILI_WIDTH)];
        headLabel.backgroundColor = [UIColor clearColor];
        headLabel.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
        headLabel.text = @"子项目信息";
        headLabel.textColor = UIColor_Black_Text;
        [headView addSubview:headLabel];
        
        UIView *lineView01 = [[UIView alloc]initWithFrame:CGRectMake(originX1, 55*BILI_WIDTH-1, SCREEN_WIDTH-originX1, 1)];
        lineView01.backgroundColor = UIColorFromRGB(0xe7e7e7);
        [headView addSubview:lineView01];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 45*BILI_WIDTH+kFreeTimesCellHeight*_dataArray.count+2*7*BILI_WIDTH) style:UITableViewStylePlain];
        tableView.tableHeaderView = headView;
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[BNFeesDetialsFreeTimesCell class]    forCellReuseIdentifier:@"BNFeesDetialsFreeTimesCell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview: tableView];
        self.tableView = tableView;
        
        originY += 45*BILI_WIDTH + kFreeTimesCellHeight*_dataArray.count+2*7*BILI_WIDTH+23*BILI_WIDTH;
    }

//        BOOL haveLevels = YES;
//        if (haveLevels) {
//            <#statements#>
//        }
    _scrollView.contentSize = CGSizeMake(0, originY+23*BILI_WIDTH);
}
-(void)setDetailDict:(NSDictionary *)detailDict
{
    _detailDict = detailDict;
    self.dataArray = [[NSArray alloc]init];
    NSDictionary *prjChildrenDict = [_detailDict valueNotNullForKey:@"prj_children"];
    if ([prjChildrenDict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [prjChildrenDict valueNotNullForKey:@"prj_fees_list"];
        if ([array isKindOfClass:[NSArray class]]) {
            _dataArray = [prjChildrenDict valueNotNullForKey:@"prj_fees_list"];
        }
    }
    
    NSString *prjStatus = [NSString stringWithFormat:@"%@", [detailDict valueNotNullForKey:@"prj_status"]];
    if ([prjStatus integerValue] == 1) {
        //1：项目有效
        projectAvailable = YES;
    } else {
        //2：项目暂停,3：项目取消,4：项目过期
        projectAvailable = NO;
    }
    payCompleted = NO;
    if (([[_detailDict valueNotNullForKey:@"status"] integerValue] == 2)) {
        //2：已缴纳
        payCompleted = YES;
    }
    [self setupLoadedView];
    [self drawData:_detailDict];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationTitle = @"教育缴费";

}

- (void)drawData:(NSDictionary *)dict
{
    
    if ([[dict valueNotNullForKey:@"status"] integerValue] == 2) {
        _projectTitleNameLbl.text = [dict valueNotNullForKey:@"prj_name"];
        _moneyLeftLbl.text = @"已缴金额";
        _feesStatusLab.text = @"已缴清";
        _remarkNameLbl.text = [dict valueNotNullForKey:@"prj_remark"];
        _moneyLbl.text = [NSString stringWithFormat:@"-%.2f",[[dict valueNotNullForKey:@"payed_ammount"] floatValue]];
        _shouldPayLbl.text = [NSString stringWithFormat:@"%.2f",[[dict valueNotNullForKey:@"amount"] floatValue]];
        _hadPayLbl.text = [NSString stringWithFormat:@"%.2f",[[dict valueNotNullForKey:@"payed_ammount"] floatValue]];

    } else if ([[dict valueNotNullForKey:@"status"] integerValue] == 5){
        //未缴清
        _moneyLeftLbl.text = @"待缴金额";
        _remarkNameLbl.text = [dict valueNotNullForKey:@"prj_remark"];
        _feesStatusLab.text = @"未缴清";
        _moneyLbl.text = [NSString stringWithFormat:@"-%.2f",[[dict valueNotNullForKey:@"amount"] floatValue]-[[dict valueNotNullForKey:@"payed_ammount"] floatValue]];

        _shouldPayLbl.text = [NSString stringWithFormat:@"%.2f",[[dict valueNotNullForKey:@"amount"] floatValue]];
        _hadPayLbl.text = [NSString stringWithFormat:@"%.2f",[[dict valueNotNullForKey:@"payed_ammount"] floatValue]];
    } else {
        _moneyLeftLbl.text = @"应缴金额";
        _remarkNameLbl.text = [dict valueNotNullForKey:@"prj_remark"];
        _feesStatusLab.text = @"待缴纳";
        _moneyLbl.text = [NSString stringWithFormat:@"-%.2f",[[dict valueNotNullForKey:@"amount"] floatValue]];
        _shouldPayLbl.text = [NSString stringWithFormat:@"%.2f",[[dict valueNotNullForKey:@"amount"] floatValue]];

    }

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
//        _payTimeRangeLbl.text = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
        _payTimeRangeLbl.text = [NSString stringWithFormat:@"%@", endTime];//现在只显示截止日期了

    }
    
    
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
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴清";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);
                    break;
                    
                case 3:
                    _feesStatusLab.text = @"已退费";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);
                    break;
                case 4:
                    _feesStatusLab.text = @"缴纳失败";
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);//黄色
                    break;
                case 5:
                    _feesStatusLab.text = @"未缴清";
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);
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
                    _feesStatusLab.textColor = UIColorFromRGB(0xbcbcbc);
                    break;
                case 3:
                    _feesStatusLab.text = @"已退费，费用已退还到喜付钱包。";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);
                    break;
                    
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴清";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);
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
                    _feesStatusLab.textColor = UIColorFromRGB(0xbcbcbc);
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);
                    break;
                case 2:
                case 3:
                    _feesStatusLab.text = @"已取消，费用已退还到喜付钱包。";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);
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
                    _feesStatusLab.textColor = UIColorFromRGB(0xbcbcbc);//灰色
                    break;
                case 1:
                    _feesStatusLab.text = @"处理中";
                    _feesStatusLab.textColor = UIColorFromRGB(0xfab600);//黄色
                    break;
                    
                case 2:
                    _feesStatusLab.text = @"已缴清";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);//蓝色
                    break;
                case 3:
                    _feesStatusLab.text = @"已过期，费用已退还到喜付钱包。";
                    _feesStatusLab.textColor = UIColorFromRGB(0x2387f8);
                    break;

                default:
                    break;
            }
            
            break;
        default:
            break;
    }
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFreeTimesCellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BNFeesDetialsFreeTimesCell";
    BNFeesDetialsFreeTimesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *bankDict = [_dataArray objectAtIndex:indexPath.row];
    
    [cell drawData:bankDict];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7*BILI_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7*BILI_WIDTH)];
    views.backgroundColor = [UIColor whiteColor];
    return views;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1*BILI_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1*BILI_WIDTH)];
    views.backgroundColor = [UIColor whiteColor];
    return views;
}

- (void)nextStepButtonAction:(UIButton *)button
{
    if ([[_detailDict valueNotNullForKey:@"multiplePay"] integerValue] == 1) {
        //1：多次缴费项目
        shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"请输入缴费金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        shareAppDelegateInstance.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        shareAppDelegateInstance.alertView.tag = 999;
        [shareAppDelegateInstance.alertView show];
        
        UITextField *textField = [shareAppDelegateInstance.alertView textFieldAtIndex:0];
        [textField addTarget:self action:@selector(alertViewTFChanged:) forControlEvents:UIControlEventEditingChanged];

    } else {
        //0：一次性缴清项目
        NSString *amount = [NSString stringWithFormat:@"%.2f",[[_detailDict valueNotNullForKey:@"amount"] floatValue]];
        [self gotoPay:amount];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CGFloat payMoney = [[_detailDict valueNotNullForKey:@"amount"] floatValue]-[[_detailDict valueNotNullForKey:@"payed_ammount"] floatValue];
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text floatValue] <= 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的金额！"];
        } else if ([textField.text floatValue] > payMoney) {
            [SVProgressHUD showErrorWithStatus:@"您输入的金额太大！"];
        } else {
            NSString *amount = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
            
            [self gotoPay:amount];
        }
    }

}
- (void)gotoPay:(NSString *)money
{
    __weak typeof(self) weakSelf = self;
    NSString *prj_key = [_detailDict valueNotNullForKey:@"prj_key"];
    [NewSchoolFeesApi create_OrderWithPrj_key:prj_key
                                       amount:money
                                prj_child_key:@""
                                     level_id:@""
                                      success:^(NSURLSessionDataTask *task,NSDictionary *successData) {
                                          BNLog(@"创建学校费用订单--->>>>%@",successData);
                                          if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
                                              NSDictionary *dataDic = [successData valueForKey:kRequestReturnData];
                                              
                                              BNPayModel *payModel = [[BNPayModel alloc]init];
                                              payModel.order_no = [dataDic valueNotNullForKey:@"order_no"];
                                              payModel.biz_no = [dataDic valueNotNullForKey:@"biz_no"];
                                              
                                              [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeSchoolPay
                                                                               payModel:payModel
                                                                            returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                                if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                }
                                                                            }];
                                              
                                          }else{
                                              NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                              [SVProgressHUD showErrorWithStatus:retMsg];
                                          }
                                      }
                                      failure:^(NSURLSessionDataTask *task,NSError *error) {
                                          [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                      }];

}
- (void)alertViewTFChanged:(UITextField *)tf
{
    NSString *str = tf.text;
    if ([str isEqualToString:@"."]) {
        str = @"";
    } else {
        if (str.length > 0){
            str = [[str componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        }
        NSString *findStr = @".";
        NSRange foundObj=[str rangeOfString:findStr options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            if (str.length > foundObj.location + 3) {
                str = [str substringWithRange:NSMakeRange(0, foundObj.location + 3)];
            }
        }
        NSInteger pointCount = [[str componentsSeparatedByString:@"."] count]-1;
        //pointCount为str中“.“的个数。
        if(pointCount > 1) {
            str = [str substringWithRange:NSMakeRange(0, str.length-1)];
        }
    }

    if (str.length > 10) {
        str = [str substringWithRange:NSMakeRange(0, 10)];
    }
   
    tf.text = str;
    
}
@end
