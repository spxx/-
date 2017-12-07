//
//  LCSchoolDeatilVC.m
//  Wallet
//
//  Created by mac1 on 16/5/30.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDSchoolDetailVC.h"
#import "LDClassCell.h"
#import "LearnDrivingApi.h"
#import "MJExtension.h"
#import "LDTrainFieldViewController.h"
#import "BNUploadImgPreView.h"
#import "LDConfirmViewController.h"
#import "TrainArea.h"
#import "LDMapViewController.h"
#import "LDSchoolDetailNextVC.h"

@interface LDSchoolDetailVC ()<UITableViewDelegate, UITableViewDataSource, LDClassCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, strong) NSMutableArray *trainField;
@property (nonatomic, weak) UIView *trainAreaBGView;
@property (nonatomic, strong) NSMutableDictionary *rowCache;

@property (nonatomic, assign) BOOL getTrainFieldComplish;
@property (nonatomic, assign) BOOL getClassComplish;

@end


@implementation LDSchoolDetailVC

static NSString *const kLDLastFieldPicKey = @"kLDLastFieldPicKey";

NSString *const LDSchoolDetailCellID = @"LDSchoolDetailCellID";


- (NSMutableDictionary *)rowCache
{
    if (!_rowCache) {
        _rowCache = [[NSMutableDictionary alloc] init];
    }
    return _rowCache;
}

- (NSMutableArray *)trainField{
    if (!_trainField) {
        _trainField = [[NSMutableArray alloc] init];
    }
    return _trainField;
}

- (NSMutableArray *)classes
{
    if (!_classes) {
        _classes = [[NSMutableArray alloc] init];
    }
    return _classes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"驾校详情";
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [self setupLoadedView];
    [self getTrainFieldList];
    [self getDrivingClass];
    
}


- (void)setupLoadedView
{
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 70*BILI_WIDTH, 0, 70*BILI_WIDTH, 44);
    [rightItem setTitle:@"客服咨询" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14*NEW_BILI];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*BILI_WIDTH)];
    [rightItem addTarget:self action:@selector(rightItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 453 * NEW_BILI)];
    headerView.backgroundColor = BNColorRGB(238, 241, 243);
    
    
    //驾校详情
    CGFloat originY = 10 * NEW_BILI;
    UIView *detailBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 130 * NEW_BILI)];
    detailBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:detailBGView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDetailNext)];
    [detailBGView addGestureRecognizer:tapGes];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * BILI_WIDTH, 22 * BILI_WIDTH, 85*NEW_BILI, 85*NEW_BILI)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.schoolModel.driving_school_logo]];
    [headerView addSubview:imageView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 13 * NEW_BILI, 25 * NEW_BILI, 120 * NEW_BILI, 16 * NEW_BILI)];
    nameLabel.text = self.schoolModel.driving_school_name;
    nameLabel.font = [UIFont systemFontOfSize:16*NEW_BILI];
    nameLabel.textColor = [UIColor blackColor];
    [headerView addSubview:nameLabel];
    
    UIColor *temColor = BNColorRGB(155, 174, 183);
    UILabel *applyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165 * NEW_BILI, 27 * NEW_BILI, 150 * NEW_BILI, 14 * NEW_BILI)];
//    applyNumLabel.text = @"已报名50人";
    applyNumLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    applyNumLabel.textColor = temColor;
    applyNumLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:applyNumLabel];
    
    NSString *applyNumStr = [NSString stringWithFormat:@"已报名%@人",self.schoolModel.apply_amount];
    NSMutableAttributedString *matts = [[NSMutableAttributedString alloc] initWithString:applyNumStr];
    [matts setAttributes:@{NSForegroundColorAttributeName:UIColor_Blue_BarItemText} range:NSMakeRange(3, self.schoolModel.apply_amount.length)];
    applyNumLabel.attributedText = matts;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame),CGRectGetMaxY(nameLabel.frame) + 11 * NEW_BILI, 247 * NEW_BILI, 50 * NEW_BILI)];
    detailLabel.text = self.schoolModel.driving_school_introduction;
//    detailLabel.text = @"成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校成都泰来驾校是一所牛叉的驾校";
    detailLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    detailLabel.textColor = temColor;
    detailLabel.numberOfLines = 3;
    [detailLabel sizeToFit];
    [headerView addSubview:detailLabel];
    
    //训练场地
    originY = CGRectGetMaxY(detailBGView.frame) + 10 * NEW_BILI;
    UIView *trainAreaBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 158 * NEW_BILI)];
    trainAreaBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:trainAreaBGView];
    _trainAreaBGView = trainAreaBGView;
    
    UIButton *recentlyArea = [UIButton buttonWithType:UIButtonTypeCustom];
    recentlyArea.frame = CGRectMake(15 * NEW_BILI, 15 * NEW_BILI, SCREEN_WIDTH - 15 * NEW_BILI, 15 * NEW_BILI);
    recentlyArea.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    recentlyArea.titleLabel.font = [UIFont systemFontOfSize:13 * NEW_BILI];
    [recentlyArea setImage:[UIImage imageNamed:@"ld_main_location"] forState:UIControlStateNormal];
    [recentlyArea setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [recentlyArea setTitle:@"离学校最近的训练场" forState:UIControlStateNormal];
    [recentlyArea addTarget:self action:@selector(recentlyAreaButtonAcion) forControlEvents:UIControlEventTouchUpInside];
    [recentlyArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [trainAreaBGView addSubview:recentlyArea];

    UILabel *areaName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 230 * NEW_BILI, 17 * NEW_BILI, 200 * NEW_BILI, 14 * NEW_BILI)];
    areaName.text = [NSString stringWithFormat:@"%@  %@",self.schoolModel.nearest_train_name, self.schoolModel.nearest_train_distance];
    areaName.font = [UIFont systemFontOfSize:12*NEW_BILI];
    areaName.textColor = temColor;
    areaName.textAlignment = NSTextAlignmentRight;
    [trainAreaBGView addSubview:areaName];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(areaName.frame) + 7 * NEW_BILI, 17 * NEW_BILI, 16 * NEW_BILI, 16 * NEW_BILI)];
    arrow.image = [UIImage imageNamed:@"right_arrow"];
    [trainAreaBGView addSubview:arrow];
    
    NSArray *sandboxImages = [kUserDefaults objectForKey:kLDLastFieldPicKey];
    if (!sandboxImages || sandboxImages.count == 0) {
        sandboxImages = @[@"loc2",@"loc2",@"loc2",@"loc2"];//临时图片
    }
    
    CGFloat imageMargin = 5 * NEW_BILI;
    CGFloat imageWidth = (SCREEN_WIDTH - 28 * NEW_BILI - imageMargin * 3) * 0.25;
    
    for (int i = 0; i < sandboxImages.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14 * NEW_BILI + (imageWidth + imageMargin) * i, CGRectGetMaxY(recentlyArea.frame) + 18 * NEW_BILI,imageWidth, imageWidth)];
        imageView.image = [UIImage imageNamed:sandboxImages[i]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picClicked:)];
        
        [imageView addGestureRecognizer:tapGesture];
        imageView.tag = i+1;
        [trainAreaBGView addSubview:imageView];
    }
    
    originY = CGRectGetMaxY(trainAreaBGView.frame) + 10 * NEW_BILI;
    
    
    //优势
    UIView *advantageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 129 * NEW_BILI)];
    advantageBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:advantageBGView];
    
    UIButton *advantageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    advantageBtn.frame = CGRectMake(15 * NEW_BILI, 15 * NEW_BILI, 150 * NEW_BILI, 15 * NEW_BILI);
    advantageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    advantageBtn.titleLabel.font = [UIFont systemFontOfSize:13 * NEW_BILI];
    [advantageBtn setImage:[UIImage imageNamed:@"ld_detail_support"] forState:UIControlStateNormal];
    [advantageBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [advantageBtn setTitle:@"我们的优势" forState:UIControlStateNormal];
    [advantageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [advantageBGView addSubview:advantageBtn];
    

//    NSString *text1 = @"5次考试不合格注销学籍的情况下，还可以免费提供一次全新的培训服务。";
//    NSString *text2 = @"一人一车一教练，对教练不满意可以申请更换，刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试刘春测试测试";
//    NSString *text3 = @"学车过程中，不再收取任何费用。";
//    NSArray *textArr = @[text2,text3,text1];
    NSArray *textArr = [self.schoolModel.driving_school_advantage componentsSeparatedByString:@"\n"];
    NSMutableArray *newArr = [[NSMutableArray alloc] initWithCapacity:textArr.count];
    [textArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *text = obj;
            text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉首尾换行符和空白
            [newArr addObject:text];
        }
    }];
    CGFloat lastLabelMaxY = 0.0, startY = CGRectGetMaxY(advantageBtn.frame) + 14 * NEW_BILI;
    for (int i = 0; i < newArr.count; i ++) {
        CGFloat marginTop = i == 0 ? 0 : 10 * NEW_BILI;
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(17 * NEW_BILI, startY + marginTop + lastLabelMaxY, 8 * NEW_BILI, 8 * NEW_BILI)];
        point.backgroundColor = temColor;
        point.layer.cornerRadius = 4*NEW_BILI;
//        [advantageBGView addSubview:point]; 罗璇说不要加这个点
        
        NSString *labelText = newArr[i];
        CGFloat textHeight = [Tools caleNewsCellHeightWithTitle:labelText font:[UIFont systemFontOfSize:14 * NEW_BILI] width:330 * NEW_BILI];
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(point.frame) , CGRectGetMinY(point.frame) - 5 * NEW_BILI, 330 * NEW_BILI, textHeight + 1)];
        label.text = labelText;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14 * NEW_BILI];
        label.textColor = temColor;
        [advantageBGView addSubview:label];
        
        lastLabelMaxY = CGRectGetMaxY(label.frame);
        startY = 0;
    }
    advantageBGView.heightValue = lastLabelMaxY + 15 * NEW_BILI;
    originY += advantageBGView.heightValue;
    headerView.heightValue = originY + 10 * NEW_BILI;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.estimatedRowHeight = 105 * NEW_BILI;
    tableView.backgroundColor = BNColorRGB(238, 241, 243);
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerClass:[LDClassCell class] forCellReuseIdentifier:LDSchoolDetailCellID];
    
}

- (void)goDetailNext
{
    LDSchoolDetailNextVC *nextVc = [[LDSchoolDetailNextVC alloc] init];
    nextVc.school = self.schoolModel;
    [self pushViewController:nextVc animated:YES];
}

- (void)picClicked:(UITapGestureRecognizer *)tap
{
    if (self.trainField.count == 0) return;
    UIImageView *tapImageView = (UIImageView *)tap.view;
    CGRect rect = tapImageView.frame;
    rect.origin.y = rect.origin.y + 150 * NEW_BILI  - _tableView.contentOffset.y + self.sixtyFourPixelsView.viewBottomEdge; //此处150为了算出convertRect相对于父视图的坐标
    CGRect convertRect = rect;
    
    UIImage *image = tapImageView.image;
    
    BNUploadImgPreView *preView = [[BNUploadImgPreView alloc] initWithFrame:[UIScreen mainScreen].bounds image:image thubImgFrame:convertRect thubImge:nil];
    [preView previewShow:self.view];
}

//更新训练场图片
- (void)updateFieldImageViewWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i ++) {
        UIImageView *imageView = [_trainAreaBGView viewWithTag:i + 1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]]];
    }
    
    //顺便持久化一下
    [kUserDefaults setObject:array forKey:kLDLastFieldPicKey];
    [kUserDefaults synchronize];
}

#pragma mark
// 获取培训班信息
- (void)getDrivingClass
{
    __weak typeof(self) weakSelf = self;
    [LearnDrivingApi get_driving_class_list:self.schoolModel.driving_school_key
                                    succeed:^(NSDictionary *returnData) {
                                        BNLog(@"获取培训班信息--->>>%@",returnData);
                                        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:@"000000"]) {
                                            weakSelf.getClassComplish = YES;
                                            [weakSelf cheakCanDismissHud];
                                            NSDictionary *data = [returnData valueNotNullForKey:@"data"];
                                            NSArray *classList = [DrivingClass mj_objectArrayWithKeyValuesArray:data[@"driving_class_list"]];
                                            [weakSelf.classes addObjectsFromArray:classList];
                                            [weakSelf.tableView reloadData];
                                            
                                        }else{
                                            NSString *errorMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                            [SVProgressHUD showErrorWithStatus:errorMsg];
                                        }
                                    }
                                    failure:^(NSError *error) {
                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                    }];
}

//获取训练场地列表
- (void)getTrainFieldList
{
    __weak typeof(self) weakSelf = self;
    [LearnDrivingApi get_train_field_list:self.schoolModel.driving_school_key
                                  succeed:^(NSDictionary *returnData) {
                                      BNLog(@"获取训练场地列表--->>>%@",returnData);
                                      if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:@"000000"]) {
                                          weakSelf.getTrainFieldComplish = YES;
                                          [weakSelf cheakCanDismissHud];
                                          NSDictionary *data = [returnData valueNotNullForKey:@"data"];
                                          NSArray *fieldList = [TrainArea mj_objectArrayWithKeyValuesArray:data[@"train_field_list"]];
                                          
                                          [weakSelf.trainField addObjectsFromArray:fieldList];
                                          
                                          NSArray *train_field_list = data[@"train_field_list"];
                                          
                                          if ( train_field_list.count > 0) {
                                              NSDictionary *nearestField = train_field_list[0];
                                              NSArray *pic_list = [nearestField valueNotNullForKey:@"pic_list"];
                                              NSMutableArray *picArr = [[NSMutableArray alloc] init];
                                              
                                              //有且仅有4张图片，防止服务器返回多张
                                              for(int i = 0; i < pic_list.count; i ++){
                                                  if (i < 4) {
                                                      NSDictionary *dic = pic_list[i];
                                                      [picArr addObject:[dic valueNotNullForKey:@"pic_url"]];
                                                  }
                                              }
                                              [weakSelf updateFieldImageViewWithArray:picArr];
                                          }
                                          
                                      }else{
                                          NSString *errorMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                                          [SVProgressHUD showErrorWithStatus:errorMsg];
                                      }
                                      
                                  }
                                  failure:^(NSError *error) {
                                      [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                  }];
}

- (void)cheakCanDismissHud
{
    if (self.getClassComplish && self.getTrainFieldComplish) {
        [SVProgressHUD dismiss];
    }
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDClassCell *cell = [tableView dequeueReusableCellWithIdentifier:LDSchoolDetailCellID forIndexPath:indexPath];
    cell.delegate = self;
    DrivingClass *model = self.classes[indexPath.row];
//    model.class_desc = @"我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行高我是测试行";
    model.classId = indexPath.row + 100;
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DrivingClass *classModel = self.classes[indexPath.row];
    LDConfirmViewController *confirmVC = [[LDConfirmViewController alloc] init];
    confirmVC.classKey = classModel.class_key;
    [self pushViewController:confirmVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27 * NEW_BILI;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 27 * NEW_BILI)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    
    UIView *verticlLine = [[UIView alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 6 * NEW_BILI, 4 * NEW_BILI, 15 * NEW_BILI)];
    verticlLine.backgroundColor = BNColorRGB(78, 149, 255);
    [sectionHeader addSubview:verticlLine];
    
    UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(verticlLine.frame) + 5 * NEW_BILI, 6 * NEW_BILI, 140, 15 * NEW_BILI)];
    recommendLabel.text = @"培训报名";
    recommendLabel.font = [UIFont systemFontOfSize:14 * NEW_BILI];
    recommendLabel.textColor = [UIColor blackColor];
    [sectionHeader addSubview:recommendLabel];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sectionHeader.frame) - 1, SCREEN_WIDTH, 1)];
    hLine.backgroundColor = UIColor_GrayLine;
    [sectionHeader addSubview:hLine];
    
    return  sectionHeader;
}

//动态返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出对应的模型
    DrivingClass *model = self.classes[indexPath.row];
    
    NSString *classId = [NSString stringWithFormat:@"%ld",(long)model.classId];
    //判断字典里面有没有值
    NSString *height = self.rowCache[classId];
    
    BNLog(@"cellHeight--->>>%@",height);
    if (height) {
        return height.floatValue;
    }else{
        //计算cell的高度
        CGFloat height = [self caculateRowHeightWithModel:model];
        //缓存行高
        [self.rowCache setValue:[NSString stringWithFormat:@"%f",height] forKey:classId];
        return  height;
    }

}


//客服咨询
- (void)rightItemBtnClick
{
    NSString *url = @"telprompt:028-61831329";
    NSURL *theUrl = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:theUrl];
}

//离学校最近的训练场
- (void)recentlyAreaButtonAcion
{
    if (self.trainField.count == 0) return;
    if (self.trainField.count > 1) {
        LDTrainFieldViewController *fieldVC = [LDTrainFieldViewController new];
        fieldVC.fields = self.trainField;
        [self pushViewController:fieldVC animated:YES];
    }else{
        LDMapViewController *mapVC = [[LDMapViewController alloc] init];
        mapVC.areaModel = self.trainField[0];
        [self pushViewController:mapVC animated:YES];
    }
 
}

//现在报名按钮
- (void)applyButtonClick:(UIButton *)button
{
   
}

//计算cell行高
- (CGFloat)caculateRowHeightWithModel:(DrivingClass *)model
{
    NSString *desText  = model.class_desc;
    CGFloat desLabelH = [Tools caleNewsCellHeightWithTitle:desText font:[UIFont systemFontOfSize:12 * NEW_BILI] width:SCREEN_WIDTH - 30 * NEW_BILI];
    return (desLabelH + 93 * NEW_BILI);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.rowCache removeAllObjects];
}





@end
