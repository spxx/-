//
//  BNMonthlyBillViewController.m
//  Wallet
//
//  Created by sunpeng on 2017/10/30.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import "BNMonthlyBillViewController.h"
#import "MoneyTableViewCell.h"
#import "JXCircleRatioView.h"
#import "TimePickerView.h"
#import "NewPayOrderCenterApi.h"

@interface BNMonthlyBillViewController ()<UITableViewDelegate,UITableViewDataSource,TimePickerDalegate>
{
    UILabel *_yearLabel;
    UILabel *_monthLabel;
    UILabel *_costLabel;
    UILabel *_revenue;
    NSMutableArray *_numArray;
    NSMutableArray *_nameArray;
    NSMutableArray *_imagesArray;
    NSMutableArray *_dataSource;
    NSString *_year;
    NSString *_month;
    UIImageView *_row;
    UILabel *_costM;
    UILabel *_revenueM;
    BOOL _cksure;//确定按钮
    BOOL _dragging;//滚动过程
}
@property(nonatomic,strong)UIView *tableHeaderV;

@property(nonatomic,strong)UITableView *tableView;


@property(nonatomic,strong)JXCircleRatioView *ratioView;
@property(nonatomic, strong)UIView *bottomV;

@property(nonatomic, strong)TimePickerView *timePickerView;
@property(nonatomic, strong)UIDatePicker *datePickerView; /** 时间选择器*/
@property(nonatomic, strong)UIView *pickerView; /** 选择器View*/
@property(nonatomic, strong)UIView *pickerViewBackgroundView; /** 选择器背景*/

@property (strong, nonatomic) UIView *billNoteView;


@end

@implementation BNMonthlyBillViewController

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
    [self initUserInterface];
}

-(void)initUserInterface{
    self.showNavigationBar = NO;
    
    UIView *sixtyFourPixelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+NAVIGATION_STATUSBAR_HEIGHT)];
    sixtyFourPixelsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    sixtyFourPixelsView.backgroundColor =  UIColorFromRGB(0x8c9bd3);
    [self.view addSubview:sixtyFourPixelsView];
    //init custom navigation bar
    UIImageView *customNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT, self.view.frame.size.width, 44)];
    customNavigationBar.userInteractionEnabled = YES;
    customNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [sixtyFourPixelsView addSubview:customNavigationBar];
    
    //title
    
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 120, 44)];
    navigationLabel.tag = 10002;
    navigationLabel.backgroundColor = [UIColor clearColor];
    navigationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin;
    navigationLabel.font = [UIFont boldSystemFontOfSize:16*NEW_BILI];
    navigationLabel.textColor = UIColorFromRGB(0xffffff);
    navigationLabel.text = @"记账本";
    navigationLabel.backgroundColor = [UIColor clearColor];
    navigationLabel.textAlignment = NSTextAlignmentCenter;
    navigationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [customNavigationBar addSubview:navigationLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
    [customNavigationBar addSubview:backButton];

    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_STATUSBAR_HEIGHT+44, SCREEN_WIDTH, 140*NEW_BILI-NAVIGATION_STATUSBAR_HEIGHT-44)];
    topView.backgroundColor = UIColorFromRGB(0x8c9bd3);
    [self.view addSubview:topView];
    CGFloat with = SCREEN_WIDTH/3.0;
    CGFloat hegit = (140*NEW_BILI-NAVIGATION_STATUSBAR_HEIGHT-44-60*NEW_BILI)/2;
    
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(with+with*i, hegit, 1, 60*NEW_BILI)];
        line.backgroundColor =UIColorFromRGB(0xffffff);
        line.alpha = 0.6;
        [topView addSubview:line];
    }
    
    _monthLabel = [UILabel new];
    _monthLabel.viewSize = CGSizeMake(with, 24*NEW_BILI);
    [_monthLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, topView.viewHeight - hegit)];
    _monthLabel.font = [UIFont boldSystemFontOfSize:24];
    _monthLabel.text = [NSString stringWithFormat:@"%@月",_month];
    _monthLabel.textColor = UIColorFromRGB(0xffffff);
    [_monthLabel sizeToFit];
    [_monthLabel align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(with/2, topView.viewHeight - hegit - (60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2)];
    [topView addSubview:_monthLabel];
    
    _row = [UIImageView new];
    _row.viewSize = CGSizeMake(15, 15);
    [_row align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_monthLabel.viewRightEdge + 5, _monthLabel.center.y)];
    _row.image = [UIImage imageNamed:@"rowchoose.png"];
    [topView addSubview:_row];
    
    
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(_monthLabel.viewX, hegit+(60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2, with, 12*NEW_BILI)];
    _yearLabel.text = [NSString stringWithFormat:@"%@年",_year];
    _yearLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    _yearLabel.textColor =UIColorFromRGB(0xffffff);
    [_yearLabel sizeToFit];
    _yearLabel.viewX = _monthLabel.viewX;
    [topView addSubview:_yearLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, with, topView.viewHeight)];
    [btn addTarget:self action:@selector(timeCheck) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
    _costLabel = [UILabel new];
    _costLabel.viewSize = CGSizeMake(with, 24*NEW_BILI);
    [_costLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, topView.viewHeight - hegit)];
    _costLabel.font = [UIFont boldSystemFontOfSize:24*NEW_BILI];
    _costLabel.text = @"0.00";
    _costLabel.textColor = UIColorFromRGB(0xffffff);
    [_costLabel sizeToFit];
    [_costLabel align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(with/2+with, _monthLabel.viewBottomEdge)];
    [topView addSubview:_costLabel];
    
    _costM = [[UILabel alloc] initWithFrame:CGRectMake(_costLabel.viewX, hegit+(60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2, with, 12*NEW_BILI)];
    _costM.text = @"支出";
    _costM.font = [UIFont systemFontOfSize:12*NEW_BILI];
    _costM.textColor =UIColorFromRGB(0xffffff);
    [_costM sizeToFit];
    _costM.viewX = _costLabel.viewX;
    [topView addSubview:_costM];
    
    UIButton *costBtn = [[UIButton alloc] initWithFrame:CGRectMake(with, 0, with, topView.viewHeight)];
    [costBtn addTarget:self action:@selector(costRecord) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:costBtn];
    
    _revenue = [UILabel new];
    _revenue.viewSize = CGSizeMake(with, 24*NEW_BILI);
    [_revenue align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, topView.viewHeight - hegit)];
    _revenue.font = [UIFont boldSystemFontOfSize:24*NEW_BILI];
    _revenue.text = @"0.00";
    _revenue.textColor = UIColorFromRGB(0xffffff);
    [_revenue sizeToFit];
    [_revenue align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(with/2+with*2, _monthLabel.viewBottomEdge)];
    [topView addSubview:_revenue];
    
    _revenueM = [[UILabel alloc] initWithFrame:CGRectMake(_revenue.viewX, hegit + (60*NEW_BILI - 20*NEW_BILI - _monthLabel.viewHeight)/2, with, 12*NEW_BILI)];
    _revenueM.text = @"收入";
    _revenueM.font = [UIFont systemFontOfSize:12*NEW_BILI];
    _revenueM.textColor =UIColorFromRGB(0xffffff);
    [_revenueM sizeToFit];
    _revenueM.viewX = _revenue.viewX;
    [topView addSubview:_revenueM];
    
    UIButton *revenueBtn = [[UIButton alloc] initWithFrame:CGRectMake(with * 2,0, with, topView.viewHeight)];
    [revenueBtn addTarget:self action:@selector(revenueRecord) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:revenueBtn];

    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - topView.viewBottomEdge)];
    _tableView.backgroundColor = UIColorFromRGB(0xffffff);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MoneyTableViewCell class] forCellReuseIdentifier:@"moneyCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 1, 20);
    _tableView.tableHeaderView = self.tableHeaderV;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullView)];
    
    [self.view addSubview:_tableView];
    
    
    _billNoteView = [UIView new];
    _billNoteView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-topView.viewBottomEdge);
    [_billNoteView align:ViewAlignmentCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - topView.viewBottomEdge)/2+topView.viewBottomEdge)];
    _billNoteView.backgroundColor = [UIColor clearColor];
    
    UIImageView *noteImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, (_billNoteView.viewHeight-160)/2-20, 160, 160)];
    noteImg.tag = 10;
    [noteImg setImage:[UIImage imageNamed:@"view_null"]];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noteImg.viewBottomEdge+10, SCREEN_WIDTH, 24)];
    noteLabel.tag = 11;
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:17]];
    noteLabel.textColor = [UIColor lightGrayColor];
    
    [_billNoteView addSubview:noteImg];
    [_billNoteView addSubview:noteLabel];
    _billNoteView.hidden = YES;
    [self.view addSubview:_billNoteView];
    
    [self.view addSubview:self.pickerViewBackgroundView];
    [self.view addSubview:self.pickerView];
}

- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        //防止多次连续点击崩溃
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadData{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyyMM"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    _year = [NSString stringWithFormat:@"%@",[currentDateString substringToIndex:4]];
    _month = [NSString stringWithFormat:@"%@",[currentDateString substringFromIndex:4]];

    _numArray = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    _imagesArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    [self refreshDataWithYear:_year andMonth:_month];
}

-(void)pullView{
    [MobClick event:@"1007"];
    [UIView animateWithDuration:3 animations:^{
    }completion:^(BOOL finished) {
        [_tableView.mj_header endRefreshing];
    }];
    
}

-(void)refreshDataWithYear:(NSString *)year andMonth:(NSString *)month{
    [_numArray removeAllObjects];
    [_nameArray removeAllObjects];
    [_imagesArray removeAllObjects];
    _billNoteView.hidden = YES;
    _tableView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    __block BOOL topBool = NO;
    __block BOOL botoomBool = NO;
    
    [NewPayOrderCenterApi newPay_StatisticsWithSchool_id:shareAppDelegateInstance.boenUserInfo.schoolId student_no:shareAppDelegateInstance.boenUserInfo.studentno year_month:[NSString stringWithFormat:@"%@-%@",year,month] success:^(NSDictionary *data) {
        BNLog(@"%@",data);
        if ([data[@"retcode"] floatValue] == 000000) {
            topBool = YES;
            if (botoomBool) {
                [SVProgressHUD dismiss];
            }
            NSMutableArray *countM = [NSMutableArray array];
            NSArray *countArray = data[@"data"][@"consume_statistics"];
            [self layoutSizeWith:data];
            
            [countArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    if (!([dic[@"total_amount"] floatValue]==0)) {
                        [_numArray addObject:dic[@"total_amount"]];
                        [_nameArray addObject:dic[@"name"]];
                        [_imagesArray addObject:dic[@"img_address"]];
                        NSString *colorStr = [NSString stringWithFormat:@"0x%@",dic[@"color"]];
                        UIColor *color = [UIColor string2Color:colorStr];
                        [countM addObject:color];
                    }
                }
            }];
            _tableHeaderV.hidden = NO;
            if (!(_numArray.count==0)) {
                _ratioView.nameArray = _nameArray;
                _ratioView.imagesArray = _imagesArray;
                _ratioView.colorArray = countM;
                _ratioView.numArray = _numArray;
                [_ratioView stroke];
                [_ratioView refeshCostL:_costLabel.text];
                [weakSelf drawViewWithArray:_numArray];
                _tableView.tableHeaderView = self.tableHeaderV;
                _billNoteView.hidden = YES;
            }else{
                if ([_revenue.text floatValue]>0) {
                    _billNoteView.hidden = YES;
                    _ratioView.numArray = @[];
                    [_ratioView stroke];
                    [_ratioView refeshCostL:_costLabel.text];
                    [weakSelf drawViewWithArray:@[]];
                }else{
                    _tableHeaderV.hidden = YES;
                    _billNoteView.hidden = NO;
                    UILabel *noteLabel = (UILabel *)[_billNoteView viewWithTag:11];
                    noteLabel.text = [NSString stringWithFormat:@"%@月还没有消费记录哦",month];
                }
            }
        }else{
            _tableHeaderV.hidden = YES;
            _tableView.hidden = YES;
            _billNoteView.hidden = NO;
            [self layoutSizeWith:nil];
            UILabel *noteLabel = (UILabel *)[_billNoteView viewWithTag:11];
            noteLabel.text = [NSString stringWithFormat:@"%@",data[@"retmsg"]];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",data[@"retmsg"]]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        BNLog(@"%@",error);
    }];
    
    [NewPayOrderCenterApi newPay_queryTransWithyear:year month:month card_no:shareAppDelegateInstance.boenUserInfo.studentno success:^(NSDictionary *data) {
        BNLog(@"%@",data);
        [_dataSource removeAllObjects];
        if ([data[@"retcode"] floatValue] == 000000) {
            botoomBool= YES;
            if (topBool) {
                [SVProgressHUD dismiss];
            }
            [_dataSource addObjectsFromArray:data[@"data"]];
        }else{
            UILabel *noteLabel = (UILabel *)[_billNoteView viewWithTag:11];
            noteLabel.text = [NSString stringWithFormat:@"%@",data[@"retmsg"]];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",data[@"retmsg"]]];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        BNLog(@"%@",error);
    }];
}
-(void)layoutSizeWith:(NSDictionary *)data{
    if (data) {
        _costLabel.text = [NSString stringWithFormat:@"%.2f",fabsf([data[@"data"][@"total_consume_amount"] floatValue])];
        [_costLabel sizeToFit];
        [_costLabel align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/3.0/2+SCREEN_WIDTH/3.0, _monthLabel.viewBottomEdge)];
        _costM.viewX = _costLabel.viewX;
        _revenue.text = [NSString stringWithFormat:@"%.2f",[data[@"data"][@"total_deposit_amount"] floatValue]];
        [_revenue sizeToFit];
        [_revenue align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/3.0/2+SCREEN_WIDTH/3.0*2, _monthLabel.viewBottomEdge)];
        _revenueM.viewX = _revenue.viewX;
    }else{
        _costLabel.text = @"0.00";
        _revenue.text = @"0.00";
    }
}



-(UIView *)pickerViewBackgroundView{
    if (!_pickerViewBackgroundView) {
        _pickerViewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerViewBackgroundView.backgroundColor = [UIColor blackColor];
        _pickerViewBackgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CkCancleButton)];
        [_pickerViewBackgroundView addGestureRecognizer:tap];
        _pickerViewBackgroundView.alpha = 0.0;
    }
    return _pickerViewBackgroundView;
}

-(UIView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 218)];
        _pickerView.alpha = 0.0;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 0, 50, 44)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [sureButton addTarget:self action:@selector(CkSureButton) forControlEvents:UIControlEventTouchUpInside];
        sureButton.tag = 9090;
        [_pickerView addSubview:sureButton];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 44)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancleBtn addTarget:self action:@selector(CkCancleButton) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:cancleBtn];
        [_pickerView addSubview:self.timePickerView];
        
        
    }
    return _pickerView;
}

-(TimePickerView *)timePickerView{
    if (!_timePickerView) {
        _timePickerView = [[TimePickerView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 188)];
        _timePickerView.delegate = self;
    }
    return _timePickerView;
}

-(UIView *)tableHeaderV{
    if (!_tableHeaderV) {
        _tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 281)];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
        titleL.text = @"消费报表";
        titleL.textColor = UIColorFromRGB(0x494d4f);
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textAlignment = NSTextAlignmentCenter;
        [titleL sizeToFit];
        titleL.viewWidth = SCREEN_WIDTH;
        titleL.viewHeight = 15;
        [_tableHeaderV addSubview:titleL];
        _ratioView = [[JXCircleRatioView alloc] initWithFrame:CGRectMake(0, titleL.viewBottomEdge + 15, SCREEN_WIDTH, 180+31) andCircleRadius:180/2];
        _ratioView.backgroundColor = [UIColor whiteColor];
        [_tableHeaderV addSubview:_ratioView];
        
        _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, _ratioView.viewBottomEdge, SCREEN_WIDTH, 0)];
        _bottomV.backgroundColor = [UIColor whiteColor];
        [_tableHeaderV addSubview:_bottomV];
        _tableHeaderV.clipsToBounds = YES;
        
    }
    return _tableHeaderV;
}
-(void)timeCheck{
    //记账本 - 月份
    [MobClick event:@"1002"];
    _pickerView.alpha = 1.0;
    _dragging = NO;
    _cksure = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _pickerViewBackgroundView.alpha = 0.3;
        _pickerView.frame =CGRectMake(0, SCREEN_HEIGHT-218, SCREEN_WIDTH, 218);
    } completion:^(BOOL finished) {
    }];
}

-(void)costRecord{
    //记账本 - 支出
    [MobClick event:@"1003"];
    BNLog(@"记账本 -  支出");
}

-(void)revenueRecord{
   //记账本 - 收入
    [MobClick event:@"1004"];
    BNLog(@"记账本 - 收入");
}

-(void)CkSureButton{
    _cksure = YES;
    if (_cksure&&_dragging) {
        [self CkCancleButton];
        _yearLabel.text = [NSString stringWithFormat:@"%@年",_year];
        [_yearLabel sizeToFit];
        _monthLabel.text = [NSString stringWithFormat:@"%@月",_month];
        [_monthLabel sizeToFit];
        [_row align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_monthLabel.viewRightEdge + 5, _monthLabel.center.y)];
        //数据请求
        NSString *monthS = _month.length>1 ? _month : [NSString stringWithFormat:@"0%@",_month];
        [self refreshDataWithYear:_year andMonth:monthS];
    }
}

/**
 *  时间选择器的消失动画
 */
-(void)CkCancleButton{
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 218);
    } completion:^(BOOL finished) {
        _pickerView.alpha = 0.0;
        _pickerViewBackgroundView.alpha = 0;
    }];
    
}


-(void)getdatepicker:(NSString *)year andMonth:(NSString *)month{
    _year = year;
    _month = month;
    _dragging = YES;
}

-(void)drawViewWithArray:(NSArray *)numCount{
    
    for (UIView *subs in _bottomV.subviews) {
        [subs removeFromSuperview];
    }
    if (numCount.count == 0) {
        _bottomV.viewSize = CGSizeMake(SCREEN_WIDTH,20*NEW_BILI);
    }else{
        NSUInteger count = numCount.count%5>0?numCount.count/5+1:numCount.count/5;
        _bottomV.viewSize = CGSizeMake(SCREEN_WIDTH, count*20*NEW_BILI);
        CGFloat withS = 0;
        for (int x = 0; x<numCount.count; x++) {
            UIView *staticView = [[UIView alloc] initWithFrame:CGRectMake(20 * NEW_BILI+withS, (x/5)*20*NEW_BILI, withS, 12*NEW_BILI)];
            [_bottomV addSubview:staticView];
            
            UIView *colorV = [[UIView alloc] initWithFrame:CGRectMake(0, 1*NEW_BILI, 10*NEW_BILI, 10*NEW_BILI)];
            colorV.backgroundColor = _ratioView.colorArray[x];
            [staticView addSubview:colorV];
            
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colorV.frame)+7*NEW_BILI, 0, 0, 12*NEW_BILI)];
            nameL.text = _ratioView.nameArray[x];
            nameL.textColor = UIColorFromRGB(0x8398a3);
            nameL.font = [UIFont systemFontOfSize:12*NEW_BILI];
            [nameL sizeToFit];
            nameL.viewHeight = 12*NEW_BILI;
            withS = withS + 20*NEW_BILI + nameL.viewRightEdge;
            staticView.viewWidth = withS;
            [staticView addSubview:nameL];
        }
    }
    
    _tableHeaderV.viewSize = CGSizeMake(SCREEN_WIDTH, _bottomV.viewBottomEdge+12*NEW_BILI);
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *time = _dataSource[section][@"time"];
    return [_dataSource[section][time] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34*NEW_BILI;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*NEW_BILI;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
    NSString *time = _dataSource[indexPath.section][@"time"];
    NSArray *dataArray = _dataSource[indexPath.section][time];
    NSDictionary *dic  = dataArray[indexPath.row];
    [cell dicWithData:dic];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor =UIColorFromRGB(0xf4f4f4);
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15*NEW_BILI, SCREEN_WIDTH, 34*NEW_BILI)];
    timeL.text = [NSString stringWithFormat:@"%@",_dataSource[section][@"time"]];
    timeL.textColor = UIColorFromRGB(0x494d4f);
    timeL.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [timeL sizeToFit];
    timeL.viewHeight = 10*NEW_BILI;
    timeL.viewX = 20*NEW_BILI;
    [headerV addSubview:timeL];
    
    NSString *incomeSTR = [NSString stringWithFormat:@"%@",_dataSource[section][@"income"]];
    UILabel *income = [UILabel new];
    income.text = [NSString stringWithFormat:@"收入：%.2f",[incomeSTR floatValue]];
    income.textColor = UIColorFromRGB(0x494d4f);
    income.viewSize = CGSizeMake(SCREEN_WIDTH, 34*NEW_BILI);
    income.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [income sizeToFit];
    income.viewHeight = 10*NEW_BILI;
    [income align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-20*NEW_BILI, 15*NEW_BILI)];
    if ([_dataSource[section][@"income"] floatValue]==0) {
        income.viewWidth = 0;
    }
    [headerV addSubview:income];
    
    NSString *costStr = [NSString stringWithFormat:@"%@",_dataSource[section][@"pay"]];
    UILabel *costL = [UILabel new];
    costL.text = [NSString stringWithFormat:@"支出：%.2f",[costStr floatValue]];
    costL.textColor = UIColorFromRGB(0x494d4f);
    costL.viewSize = CGSizeMake(SCREEN_WIDTH, 34*NEW_BILI);
    costL.font = [UIFont systemFontOfSize:10*NEW_BILI];
    [costL sizeToFit];
    costL.viewHeight = 10*NEW_BILI;
    [costL align:ViewAlignmentTopRight relativeToPoint:CGPointMake(income.viewWidth>0?income.viewX-10:SCREEN_WIDTH-20*NEW_BILI, 15*NEW_BILI)];
    if([_dataSource[section][@"pay"] floatValue]==0){
        costL.viewWidth = 0;
    }
    [headerV addSubview:costL];
    
    return headerV;
}



@end







