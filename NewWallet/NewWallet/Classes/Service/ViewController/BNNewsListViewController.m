//
//  BNNewsListViewController.m
//  NewWallet
//
//  Created by mac1 on 14-11-11.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNNewsListViewController.h"
#import "BNCommonWebViewController.h"
#import "BNNewsTableCell.h"
#import "BNNewsTool.h"
#import "ServiceCenterApi.h"
#import "XifuNews.h"
#import "OneCardNews.h"
#import "BNNotificationImageCell.h"
#import "MJRefresh.h"

@interface BNNewsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) NSMutableArray *newsCellHightAry;

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *cricleView;

@end

@implementation BNNewsListViewController

#pragma mark - setup loaded view
- (void)setupLoadedView
{
    
    self.navigationTitle = self.useStyle == NewsListViewControllerUseStyleXIFU ? @"喜付服务中心" : @"校园信息";
    
    self.sixtyFourPixelsView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    UILabel *lineLbl = (UILabel *)[self.customNavigationBar viewWithTag:10001];
    lineLbl.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    
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
    [tableView registerClass:[BNNotificationImageCell class] forCellReuseIdentifier:@"ImageCell"];
    [self.view addSubview:tableView];
    
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
    // Do any additional setup after loading the view.
    [self setupLoadedView];
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.newsCellHightAry = [[NSMutableArray alloc] init];
    [self loadData];
}


- (void)loadData
{
    [self.newsCellHightAry removeAllObjects];
    switch (self.useStyle) {
        case NewsListViewControllerUseStyleXIFU:
        {
//            [[BNNewsTool sharedInstance] setXifuNewsAllHaveRead];
//            NSArray *xifuNewsAry = [[BNNewsTool sharedInstance] getXifuNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
//            [_dataSourceArray removeAllObjects];
//            
//            for(int i = 0; i < [xifuNewsAry count]; i++)
//            {
//                OneCardNews *obj = [xifuNewsAry objectAtIndex:i];
//                CGFloat dateHeight = 20+18*BILI_WIDTH+10;
//                CGFloat titleHeight = [Tools caleNewsCellHeightWithTitle:obj.title font:[UIFont boldSystemFontOfSize:[BNTools sizeFit:16 six:18 sixPlus:20]] width:NewsCardContentWidth];
//                CGFloat subTitleHeight = [Tools caleNewsCellHeightWithTitle:obj.text_abstract font:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:17 sixPlus:19]] width:NewsCardContentWidth] + 20;
//                CGFloat cellHeight = dateHeight + titleHeight + subTitleHeight + NewsCardContentWidth * (456.0/1080.0) + 30;
//                
//                NSDictionary *heightDic = @{TitleHeight:   @(titleHeight),
//                                            SubTitleHeight:@(subTitleHeight),
//                                            CellHeight:    @(cellHeight)};
//                
//                [self.newsCellHightAry addObject:heightDic];
//            }
//            [_dataSourceArray addObjectsFromArray:xifuNewsAry];
//            [_tableView reloadData];
        }
            break;
            
        case NewsListViewControllerUseStyleYKT:
        {
            [[BNNewsTool sharedInstance] setOneCardNewsAllHaveRead];
            //NSArray *oneCardNewsAry = [[BNNewsTool sharedInstance] getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
            NSArray *oneCardNewsAry = [self loadNextPage];

            [self calcHeights:oneCardNewsAry];
            
            [_dataSourceArray removeAllObjects];
            [_dataSourceArray addObjectsFromArray:oneCardNewsAry];
            [_tableView reloadData];
        }
            break;
        default:
            break;
    }
    if (_dataSourceArray.count > 0) {
        _cricleView.hidden = YES;
    } else {
        _cricleView.hidden = NO;
    }
}

- (void)calcHeights:(NSArray *)news {
    for(int i = 0; i < [news count]; i++)
    {
        OneCardNews *obj = [news objectAtIndex:i];
        CGFloat dateHeight = 18;
        CGFloat subTitleHeight = [Tools caleNewsCellHeightWithTitle:obj.text_abstract font:[UIFont systemFontOfSize:[BNTools sizeFit:14 six:14 sixPlus:16]] width:SCREEN_WIDTH-15*2-14*2] + 36;
        CGFloat cellHeight = 20+dateHeight+10+58+subTitleHeight+0.5+54+(168/640.0)*(SCREEN_WIDTH-15*2-13*2);
        
        if (!obj.full_text_url || [obj.full_text_url isEqualToString:@""]) {
            cellHeight -= 54;
        }
        
        NSDictionary *heightDic = @{TitleHeight:   @(dateHeight),
                                    SubTitleHeight:@(subTitleHeight),
                                    CellHeight:    @(cellHeight)};
        
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
    
    NSFetchRequest *request = [OneCardNews MR_requestAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    [request setPredicate:searchTerm];
    [request setFetchBatchSize:[OneCardNews MR_defaultBatchSize]];
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create_time" ascending:NO];
    [sortDescriptors addObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    request.fetchLimit = MCItemsPerPage;
    NSArray *sortArray = [OneCardNews MR_executeFetchRequest:request];
    
    return sortArray;
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
    OneCardNews *data = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    static NSString *cellID = @"ImageCell";
    BNNotificationImageCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
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
//    XifuNews *newInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
//    NSString *urlStr = newInfo.text_url;
//    BNCommonWebViewController *newsDetial = [[BNCommonWebViewController alloc] init];
//    newsDetial.urlString = urlStr;
//    newsDetial.navTitle = @"新闻";
//    [self pushViewController:newsDetial animated:YES];
    
    OneCardNews *newInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *urlStr = newInfo.full_text_url;
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
