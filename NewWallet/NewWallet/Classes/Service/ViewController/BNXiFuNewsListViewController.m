//
//  BNXiFuNewsListViewController.m
//  NewWallet
//
//  Created by mac on 15-09-22.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNXiFuNewsListViewController.h"
#import "BNCommonWebViewController.h"
#import "BNNewsTableCell.h"
#import "BNNewsTool.h"
#import "ServiceCenterApi.h"
#import "XifuNews.h"
#import "OneCardNews.h"
#import "BNNotificationTextCell.h"
#import "BNNotificationImageCell.h"
#import "MJRefresh.h"

@interface BNXiFuNewsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) NSMutableArray *newsCellHightAry;

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *cricleView;

@end

@implementation BNXiFuNewsListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_Message_HadLoaded object:nil];
}

#pragma mark - setup loaded view
- (void)setupLoadedView
{    
    self.navigationTitle = self.useStyle == NewsListViewControllerUseStyleXIFU ? @"喜付服务中心" : @"校园信息";
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    footView.backgroundColor = [UIColor clearColor];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = footView;
   // tableView.tableHeaderView = headView;
    tableView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    tableView.backgroundView = [[UIView alloc] initWithFrame:tableView.frame];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[BNNotificationTextCell class] forCellReuseIdentifier:@"TextCell"];
    [tableView registerClass:[BNNotificationImageCell class] forCellReuseIdentifier:@"ImageCell"];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSArray *news = [weakSelf loadNextPage];
        if (news.count > 0) {
            [weakSelf.dataSourceArray addObjectsFromArray:news];
            [weakSelf calcHeights:news];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView.mj_footer endRefreshing];
        });
    }];
    tableView.mj_footer = footer;
    
    self.cricleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3*2, SCREEN_WIDTH/3*2)];
    _cricleView.backgroundColor = [UIColor whiteColor];
    _cricleView.center = _tableView.center;
    _cricleView.layer.cornerRadius = _cricleView.frame.size.width/2;
    _cricleView.layer.masksToBounds = YES;
    [self.view addSubview:_cricleView];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _cricleView.frame.size.width, _cricleView.frame.size.width)];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.text = @"暂时还没有服务消息哦，请下次再来。";
    noteLabel.font = [UIFont systemFontOfSize:12*NEW_BILI];
    noteLabel.textColor = [UIColor lightGrayColor];
    [_cricleView addSubview:noteLabel];
    _cricleView.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sixtyFourPixelsView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);

    // Do any additional setup after loading the view.
    [self setupLoadedView];
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.newsCellHightAry = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeHandler:) name:kNotification_Message_HadLoaded object:nil];
    
    [self loadData];
}


- (void)loadData
{
    [self.newsCellHightAry removeAllObjects];
    switch (self.useStyle) {
        case NewsListViewControllerUseStyleXIFU:
        {
            if (self.enterMode == EnterModeFromVC) {
                [self getNews];
            }
            else if (self.enterMode == EnterModeFromNotificationCenter) {
                [SVProgressHUD showWithStatus:@"请稍候..."];
                [shareAppDelegateInstance getAndRefreshNewsData];
            }
        }
            break;
            
        case NewsListViewControllerUseStyleYKT:
        {
//            [[BNNewsTool sharedInstance] setOneCardNewsAllHaveRead];
//            NSArray *oneCardNewsAry = [[BNNewsTool sharedInstance] getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
//            
//            for(int i = 0; i < [oneCardNewsAry count]; i++)
//            {
//                OneCardNews *obj = [oneCardNewsAry objectAtIndex:i];
//                CGFloat titleHeight = [Tools caleNewsCellHeightWithTitle:obj.title font:[UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:19 sixPlus:21]] width:NewsCardContentWidth];
//                CGFloat subTitleHeight = [Tools caleNewsCellHeightWithTitle:obj.text_abstract font:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:17 sixPlus:19]] width:NewsCardContentWidth] + 20;
//                CGFloat cellHeight = 30 + titleHeight + subTitleHeight + NewsCardContentWidth * (456.0/1080.0) + 30;
//                
//                NSDictionary *heightDic = @{TitleHeight:   @(titleHeight),
//                                            SubTitleHeight:@(subTitleHeight),
//                                            CellHeight:    @(cellHeight)};
//                
//                [self.newsCellHightAry addObject:heightDic];
//
//            }
//
//            [_dataSourceArray removeAllObjects];
//            [_dataSourceArray addObjectsFromArray:oneCardNewsAry];
//            [_tableView reloadData];
//            
//            if (_dataSourceArray.count > 0) {
//                _cricleView.hidden = YES;
//            } else {
//                _cricleView.hidden = NO;
//            }
        }
            break;
        default:
            break;
    }
}

- (void)calcHeights:(NSArray *)news {
    for(int i = 0; i < [news count]; i++)
    {
        XifuNews *obj = [news objectAtIndex:i];
        CGFloat dateHeight = 18;
        CGFloat subTitleHeight = [Tools caleNewsCellHeightWithTitle:obj.desc font:[UIFont systemFontOfSize:[BNTools sizeFit:13 six:13 sixPlus:14]] width:SCREEN_WIDTH-15*2-14*2] + 36;
        CGFloat cellHeight = 20+dateHeight+10+58+subTitleHeight+0.5+54;
        
        if (!obj.text_url || [obj.text_url isEqualToString:@""]) {
            cellHeight -= 54;
        }
        if (obj.messageType.integerValue == 3) {
            cellHeight += (168/640.0)*(SCREEN_WIDTH-15*2-13*2);
        }
        NSDictionary *heightDic = @{TitleHeight:   @(dateHeight),
                                    SubTitleHeight:@(subTitleHeight),
                                    CellHeight:    @(cellHeight)};

        
//        CGFloat dateHeight = 18;
//        CGFloat subTitleHeight = [Tools caleNewsCellHeightWithTitle:obj.desc font:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:14 sixPlus:16]] width:SCREEN_WIDTH-50];
//        CGFloat cellHeight = 20+dateHeight+10+40+55+subTitleHeight+15+0.5+40;
//        
//        if (obj.messageType.integerValue == 3) {
//            if (!obj.text_url || [obj.text_url isEqualToString:@""]) {
//                subTitleHeight += 30;
//            } else {
//                subTitleHeight = 60;
//            }
//            cellHeight = 20+dateHeight+10+55+subTitleHeight+0.5+40 + (456.0/1080)*(SCREEN_WIDTH-15*2-10*2);
//        }
//        
//        if (!obj.text_url || [obj.text_url isEqualToString:@""]) {
//            cellHeight -= 40;
//        }
//        
//        NSDictionary *heightDic = @{TitleHeight:   @(dateHeight),
//                                    SubTitleHeight:@(subTitleHeight),
//                                    CellHeight:    @(cellHeight)};
        
        [self.newsCellHightAry addObject:heightDic];
    }
}

- (NSArray *)loadNextPage {
    
    NSString *lastTime = [self.dataSourceArray.lastObject create_time];
    NSPredicate *searchTerm;
    if (lastTime) {
        searchTerm = [NSPredicate predicateWithFormat:@"%K = %@ AND create_time < %@", @"userId", shareAppDelegateInstance.boenUserInfo.userid, lastTime];
    } else {
        searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", @"userId", shareAppDelegateInstance.boenUserInfo.userid];
    }
    
    NSFetchRequest *request = [XifuNews MR_requestAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    [request setPredicate:searchTerm];
    [request setFetchBatchSize:[XifuNews MR_defaultBatchSize]];
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create_time" ascending:NO];
    [sortDescriptors addObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    request.fetchLimit = MCItemsPerPage;
    NSArray *sortArray = [XifuNews MR_executeFetchRequest:request];
    
    return sortArray;
}

- (void)observeHandler:(NSNotification *)notification {
    if ([notification.name isEqualToString:kNotification_Message_HadLoaded]) {
        [SVProgressHUD dismiss];
        
        [self getNews];
    }
}

- (void)getNews {
    [[BNNewsTool sharedInstance] setXifuNewsAllHaveRead];
    
    [_dataSourceArray removeAllObjects];
    [self.newsCellHightAry removeAllObjects];
    
    NSArray *xifuNewsAry = [self loadNextPage];
    
    [self calcHeights:xifuNewsAry];
    
    [_dataSourceArray addObjectsFromArray:xifuNewsAry];
    [_tableView reloadData];
    
    if (_dataSourceArray.count > 0) {
        _cricleView.hidden = YES;
        [_tableView.mj_footer setHidden:NO];
    } else {
        _cricleView.hidden = NO;
        [_tableView.mj_footer setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XifuNews *data = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    BNNotificationTextCell *cell = nil;
    if ((data.messageType.integerValue == 1) || (data.messageType.integerValue == 2)) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
    }
    
    [cell drawDataWithInfo:data withHeightDic:[self.newsCellHightAry objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *heightDict = [self.newsCellHightAry objectAtIndex:indexPath.row];
    return [[heightDict objectForKey:@"cellHeight"] doubleValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XifuNews *newInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *urlStr = newInfo.text_url;
    if (urlStr && (urlStr.length > 0)) {
        BNCommonWebViewController *newsDetial = [[BNCommonWebViewController alloc] init];
        newsDetial.urlString = urlStr;
        [self pushViewController:newsDetial animated:YES];
    }
}

- (void)backButtonClicked:(UIButton *)sender {
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [super backButtonClicked:sender];
    }
}

@end
