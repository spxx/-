//
//  LDMainViewController.m
//  Wallet
//
//  Created by mac1 on 16/5/30.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "LDMainViewController.h"
#import "JCTopic.h"
#import "LDRecordListViewController.h"
#import "BNCommonWebViewController.h"
#import "CustomButton.h"
#import "LDSchoolDetailVC.h"
#import "LDSchoolTableViewCell.h"
#import "LearnDrivingApi.h"
#import "MJExtension.h"
#import "DrivingSchoolModel.h"

@interface LDMainViewController ()<JCTopicDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, weak) JCTopic *jcTopicView;
@property (nonatomic, strong) NSMutableArray *recommendSchools;
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL bannerRequesComplished;
@property (nonatomic, assign) BOOL schoolListRequesComplished;
@end

@implementation LDMainViewController

static NSString *const LDSchoolCellID = @"LDSchoolCellID";
static NSString *const kLDBannerCache = @"kLDBannerCache";

- (NSMutableArray *)banners
{
    if (!_banners) {
        _banners = [[NSMutableArray alloc] init];
    }
    return _banners;
}

- (NSMutableArray *)recommendSchools
{
    if (!_recommendSchools) {
        _recommendSchools = [[NSMutableArray alloc] init];
    }
    return _recommendSchools;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"喜付学车";
    
    [SVProgressHUD showWithStatus:@"请稍候..."];
    self.view.backgroundColor = BNColorRGB(238, 241, 243);
    [self setupLoadedView];
    [self getBannerData];
    [self getRecommendSchoolList];
    
}

- (void)setupLoadedView
{
    // rightBarButtonIte
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 70*NEW_BILI, 0, 70*NEW_BILI, 44);
    [rightItem setTitle:@"学车进度" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14*NEW_BILI];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12*NEW_BILI)];
    [rightItem addTarget:self action:@selector(rightItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];
    
 
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 284 * NEW_BILI)];
    headerView.backgroundColor = BNColorRGB(238, 241, 243);
    
    CGFloat originY = 0.0;
    CGFloat jcTopicViewHeight = 150*NEW_BILI;
    JCTopic *jcTopicView = [[JCTopic alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, jcTopicViewHeight)];
    jcTopicView.JCdelegate = self;
    jcTopicView.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, jcTopicViewHeight-30, 60,30)];
    jcTopicView.pageControl.hidesForSinglePage = YES;
    [headerView addSubview:jcTopicView];
     _jcTopicView = jcTopicView;
    
    NSArray *ads = [[NSUserDefaults standardUserDefaults] objectForKey:kLDBannerCache];
    if (ads.count == 0 || ads == nil) {
        ads = @[@{@"pic": [UIImage imageNamed:@"ld_ banner_default"], @"isLoc": @YES, @"url": @""}];
    }
    
    [self reloadJCTopicView:ads];

    [jcTopicView upDate];
   
    
    originY += jcTopicViewHeight;
    UIView *whiteBGView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 124 * NEW_BILI)];
    whiteBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteBGView];
    
    //4个按钮
    NSArray *buttonTitle = @[@"报名须知",@"服务保障",@"喜付特权",@"电话咨询"];
    NSArray *imageNames = @[@"ld_main_applyNotice",@"ld_main_serviceEnsure",@"ld_main_privilege",@"ld_main_ contactMethod"];
    CGFloat buttonWidth = SCREEN_WIDTH/4.0;
    for (int i = 0; i < 4; i++) {
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:25 * NEW_BILI imgHeight:45*NEW_BILI textBottomY:0];
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, buttonWidth);
        button.tag = 100 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(smallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBGView addSubview:button];

    }
    
    UITableView *recommendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    recommendTableView.delegate = self;
    recommendTableView.dataSource = self;
    recommendTableView.rowHeight = 123 * NEW_BILI;
    recommendTableView.backgroundColor = BNColorRGB(238, 241, 243);
    [self.view addSubview:recommendTableView];
    _tableView = recommendTableView;
    
    [recommendTableView registerClass:[LDSchoolTableViewCell class] forCellReuseIdentifier:LDSchoolCellID];
    recommendTableView.tableHeaderView = headerView;
    recommendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
}


#pragma mark - Request
- (void)getBannerData
{
    __weak typeof(self) weakSelf = self;
    [LearnDrivingApi getBanner:^(NSDictionary *returnData) {
        BNLog(@"学车banner --->>>>> %@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:@"000000"]) {
            weakSelf.bannerRequesComplished = YES;
            [weakSelf canDismissHud];
            NSDictionary *datas = [returnData valueNotNullForKey:@"data"];
            NSArray *ads = [datas valueForKey:@"ad_infos"];
            NSMutableArray *construct = [NSMutableArray arrayWithCapacity:ads.count];
            for (NSDictionary *ad in ads) {
                NSString *imageURLKey = @"img_url_m";
                if (SCREEN_WIDTH > 375) {
                    imageURLKey = @"img_url_m";
                }
                NSString *imageURL = [ad valueNotNullForKey: imageURLKey];
                NSString *linkURL = [ad valueNotNullForKey: @"redirect_url"];
                [construct addObject:@{@"pic": imageURL, @"isLoc": @NO, @"url": linkURL}];
                
                if (construct.count) {
                    [weakSelf reloadJCTopicView:construct];
                } else {
                    [weakSelf reloadJCTopicView:@[@{@"pic": [UIImage imageNamed:@"Home_TopBaner"], @"isLoc": @YES, @"url": @""}]];
                }
                [[NSUserDefaults standardUserDefaults] setObject:construct forKey:kLDBannerCache];
            }
        }else{
            NSString *errorMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

- (void)getRecommendSchoolList
{
    __weak typeof(self) weakSelf = self;
    [LearnDrivingApi get_driving_school_list:^(NSDictionary *returnData) {
        BNLog(@"获取推荐驾校列表 --->>>>> %@",returnData);
        if ([[returnData valueNotNullForKey:kRequestRetCode] isEqualToString:@"000000"]) {
            weakSelf.schoolListRequesComplished = YES;
            [weakSelf canDismissHud];
            NSDictionary *data = [returnData valueNotNullForKey:@"data"];
            NSArray *schools = [DrivingSchoolModel mj_objectArrayWithKeyValuesArray:data[@"driving_school_list"]];
            
            
            [self.recommendSchools addObjectsFromArray:schools];
            [_tableView reloadData];
        }else{
            NSString *errorMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

- (void)reloadJCTopicView:(NSArray *)tempImgArray
{
    CGSize pageControlSize = [self.jcTopicView.pageControl sizeForNumberOfPages:tempImgArray.count];
    self.jcTopicView.pageControl.frame = CGRectMake((SCREEN_WIDTH-pageControlSize.width)/2, self.jcTopicView.pageControl.frame.origin.y, pageControlSize.width,40);
    
    _jcTopicView.pics = tempImgArray;
    [_jcTopicView upDate];
}

- (void)canDismissHud
{
    if (_bannerRequesComplished && _schoolListRequesComplished) {
        [SVProgressHUD dismiss];
    }
}

#pragma mark - buttonAcion
//学车进度
- (void)rightItemBtnClick
{
    //友盟事件点击
    [MobClick event:@"LearnDrive_Progress"];

    LDRecordListViewController *viewController = [[LDRecordListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

//报名须知 服务保障 喜付特权 电话咨询
- (void)smallButtonAction:(UIButton *)button
{
    
    NSString *url;
    switch (button.tag) {
        case 100:
        {
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/registrationNotice.html";
            //友盟事件点击
            [MobClick event:@"LearnDrive_4Button" label:@"报名须知"];
        }
            break;
        case 101:
        {
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/serviceGuarantee.html";
            //友盟事件点击
            [MobClick event:@"LearnDrive_4Button" label:@"服务保障"];
        }
            break;
        case 102:
        {
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/advantage.html";
            //友盟事件点击
            [MobClick event:@"LearnDrive_4Button" label:@"喜付特权"];
        }
            break;
        case 103:
        {
            url = @"telprompt:028-61831329";
            NSURL *theUrl = [NSURL URLWithString:url];
            [[UIApplication sharedApplication] openURL:theUrl];
            //友盟事件点击
            [MobClick event:@"LearnDrive_4Button" label:@"电话咨询"];
        }
            return;
            
        default:
            break;
    }
    BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
    webViewController.navTitle = button.titleLabel.text;
    [webViewController setUrlString:url];
    [self pushViewController:webViewController animated:YES];
}

#pragma mark - JCTopicDelegate
-(void)didClick:(id)data
{
    NSString *url = [data valueNotNullForKey:@"url"];
    BNCommonWebViewController *webViewController = [[BNCommonWebViewController alloc] init];
    webViewController.navTitle = @"喜付";
    [webViewController setUrlString:url];
    [self pushViewController:webViewController animated:YES];

    //友盟事件点击
    [MobClick event:@"LearnDrive_Banner" label:url];

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.recommendSchools.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LDSchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LDSchoolCellID forIndexPath:indexPath];
    DrivingSchoolModel *model = self.recommendSchools[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
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
    recommendLabel.text = @"推荐驾校";
    recommendLabel.font = [UIFont systemFontOfSize:14 * NEW_BILI];
    recommendLabel.textColor = [UIColor blackColor];
    [sectionHeader addSubview:recommendLabel];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sectionHeader.frame) - 1, SCREEN_WIDTH, 1)];
    hLine.backgroundColor = UIColor_GrayLine;
    [sectionHeader addSubview:hLine];
    
    return  sectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LDSchoolDetailVC *detailVC = [[LDSchoolDetailVC alloc] init];
    detailVC.schoolModel = self.recommendSchools[indexPath.row];
    [self pushViewController:detailVC animated:YES];
    
    NSString *schoolName = [NSString stringWithFormat:@"%@", detailVC.schoolModel.driving_school_name];
    //友盟事件点击
    [MobClick event:@"LearnDrive_RecommendDrivingSchool" label:schoolName];

    
    return;
}



@end
