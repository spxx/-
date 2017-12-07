//
//  TraineeHomeViewController.m
//  Wallet
//
//  Created by mac1 on 15/12/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "TraineeHomeViewController.h"
#import "TraineeHomeHeaderView.h"
#import "TraineeHomeProgressView.h"
#import "BNTaskListTableViewCell.h"
#import "BNLaoDaiXinViewController.h"
#import "BNFeesWebViewExplainVC.h"
#import "TraineeApi.h"

@interface TraineeHomeViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) TraineeHomeHeaderView *headerView;
@property (weak, nonatomic) TraineeHomeProgressView *progressView;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UILabel *downLabel;

@property (strong, nonatomic) NSMutableArray *taskInfos;

@end

@implementation TraineeHomeViewController

static NSString *const reuseIdentifier = @"taskCell";

- (NSMutableArray *)taskInfos
{
    if (!_taskInfos) {
        _taskInfos = [[NSMutableArray alloc] init];
    }
    return _taskInfos;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"喜付实习生";
    
    [self setupSubViews];
    [self startRequest];
}

- (void)setupSubViews
{
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 44);
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info_HeighLight"] forState:UIControlStateHighlighted];
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(TrainneExplainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    scrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    TraineeHomeHeaderView *headerView = [[TraineeHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150 * NEW_BILI) name:@"--" joinDays:@"--" empiricalValue:@"---" level:@"--"];
    headerView.backgroundColor = UIColorFromRGB(0xfc6e8f);
    [scrollView addSubview:headerView];
    _headerView = headerView;
    
    TraineeHomeProgressView *progressView = [[TraineeHomeProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), SCREEN_WIDTH, 80 * NEW_BILI) currentLevel:@"--" currentMonthValue:@"---" currentValue:@"---" needValue:@"---"];
    progressView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:progressView];
    _progressView = progressView;
    
    UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(scrollView.frame) - 40 * NEW_BILI , SCREEN_WIDTH, 13.5 * NEW_BILI)];
    downLabel.text = @"一大波任务来袭...敬请期待";
    downLabel.font = [UIFont systemFontOfSize:13];
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.textColor = UIColorFromRGB(0xb0bec5);
    [scrollView addSubview:downLabel];
    _downLabel = downLabel;
}

- (void)startRequest
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [TraineeApi queryInternStudentInfoSuccess:^(NSDictionary *returnData) {
        if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            BNLog(@"实习生信息查询---->>>> %@",datas);
            NSDictionary *infos = [datas valueNotNullForKey:@"intern_info"];
            _headerView.level = [infos valueNotNullForKey:@"current_level"];
            _headerView.daysCount = [infos valueNotNullForKey:@"join_days"];
            _headerView.name = [infos valueNotNullForKey:@"student_name"];
            _headerView.value = [infos valueNotNullForKey:@"total_exp"];
            
            _progressView.currentLevel = [infos valueNotNullForKey:@"current_level"];
            _progressView.mothValue = [infos valueNotNullForKey:@"month_exp"];
            _progressView.currentValue = [infos valueNotNullForKey:@"current_exp"];
            _progressView.needValue = [infos valueNotNullForKey:@"up_level_need_exp"];
            [_progressView startAnimation];
        }else{
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
    [TraineeApi queryTaskListSuccess:^(NSDictionary *returnData) {
        if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            BNLog(@"任务列表查询---->>>> %@",datas);
            NSArray *tasks = [datas valueNotNullForKey:@"task_info"];
            [weakSelf setupTaskViewsWithTasks:tasks];
            
        }else{
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

- (void)setupTaskViewsWithTasks:(NSArray *)tasks
{
    [self.taskInfos addObjectsFromArray:tasks];
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37 * NEW_BILI)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * NEW_BILI, 15 * NEW_BILI, 100 * NEW_BILI, 17 * NEW_BILI)];
    taskLabel.text = @"任务列表";
    taskLabel.font = [UIFont systemFontOfSize:14 * NEW_BILI];
    taskLabel.textColor = UIColorFromRGB(0x546e7a);
    taskLabel.textAlignment = NSTextAlignmentLeft;
    [tableHeaderView addSubview:taskLabel];
    
   
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progressView.frame) + 10 * NEW_BILI, SCREEN_WIDTH, CGRectGetHeight(_scrollView.frame) - CGRectGetMaxY(_progressView.frame) - 10 * NEW_BILI) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = kCell_Height;
    tableView.scrollEnabled = NO;
    tableView.tableHeaderView = tableHeaderView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[BNTaskListTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [_scrollView insertSubview:tableView belowSubview:_downLabel];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_progressView.frame) + CGRectGetHeight(tableView.frame) + 11 * NEW_BILI);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskInfos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier ];
    if(!cell){
        cell = [[BNTaskListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [cell drawCellDataWithDictionary:self.taskInfos[indexPath.row]];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *taskInfo = [self.taskInfos objectAtIndex:indexPath.row];
    NSString *task_key = [taskInfo valueNotNullForKey:@"task_key"];
    
    [TraineeApi confirmTaskWithTask_key:task_key Success:^(NSDictionary *returnData) {
        if ([returnData[kRequestRetCode] isEqualToString:kRequestSuccessCode]) {
            NSDictionary *datas = [returnData valueNotNullForKey:kRequestReturnData];
            BNLog(@"确认任务信息---->>>> %@",datas);
            NSDictionary *infos = [datas valueNotNullForKey:@"task_info"];
            BNLaoDaiXinViewController *lVC = [[BNLaoDaiXinViewController alloc] init];
            lVC.task_url = [infos valueNotNullForKey:@"task_url"];
            [self pushViewController:lVC animated:YES];
            
            //友盟事件点击
            [MobClick event:@"XifuTrainee_TaskInfo" label:[infos valueNotNullForKey:@"task_url"]];

        }else{
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint contentOffset = scrollView.contentOffset;
    if (contentOffset.y < 0)
    {
         [_progressView startAnimation];
    }else{
       
    }

}

- (void)TrainneExplainAction:(UIButton *)button
{
    //友盟事件点击
    [MobClick event:@"XifuTrainee_RuleButton"];
    
    BNFeesWebViewExplainVC *explainVC = [[BNFeesWebViewExplainVC alloc] init];
    explainVC.useType = ExpainUseTypeXiFuTrainee;
    [self pushViewController:explainVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
