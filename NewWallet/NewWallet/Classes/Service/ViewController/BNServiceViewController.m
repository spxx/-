//
//  BNServiceViewController.m
//  NewWallet
//
//  Created by mac1 on 14-10-22.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNServiceViewController.h"

#import "BNNewsListViewController.h"
#import "BNXiFuNewsListViewController.h"

#import "BNNewsTool.h"

#define kServiceCenterIcon @"icon"

#define kServiceCenterTitle @"title"
#define kServiceCenterLatestNewsTitle @"latestNewsTitle"

#define kServiceCenterNewsCount @"count"
#import "CustomButton.h"
#import "BannerApi.h"
#import "BNAllProjectVC.h"
#import "BNServerCardView.h"

@interface BNServiceViewController ()<UIScrollViewDelegate, CardViewDelegate>

@property (strong, nonatomic) NSArray *datasourceArray;
@property (strong, nonatomic) NSArray *schoolProjAry;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *schoolProjectBaseView;
@property (nonatomic) UIView *messageBaseView;

@property (nonatomic) UIImageView *schoolImgView;

@end

@implementation BNServiceViewController
static CGFloat messageViewOriginY;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self loadData];
    [self getSchoolProjectItemList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.showNavigationBar = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToMsgCenterListVC:) name:kNotification_RecievedMessage_AppHaveNotLaunch_PushToMsgCenterList object:nil];
    self.schoolProjAry = [[NSArray alloc]init];
  
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, self.view.frame.size.width - 120, 44)];
    navLabel.tag = 10002;
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    navLabel.font = [UIFont systemFontOfSize:16*BILI_WIDTH];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.text = @"校园广场";
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:navLabel];

    [self addMainView];

    messageViewOriginY = 241*BILI_WIDTH;

}

- (void)addMainView
{
    if (!_schoolImgView) {
        self.schoolImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 241*BILI_WIDTH)];
        [_scrollView addSubview:_schoolImgView];
        _schoolImgView.userInteractionEnabled = YES;
    }
    for (UIView *view in _schoolImgView.subviews) {
        [view removeFromSuperview];
    }
    NSString *schoolBgImageURL = [NSString stringWithFormat:@"%@/static/xifu_files/schools/school_%@/school_background.png", BASE_URL, shareAppDelegateInstance.boenUserInfo.schoolId];
    [_schoolImgView sd_setImageWithURL:[NSURL URLWithString:schoolBgImageURL] placeholderImage:[UIImage imageNamed:@"Service_DefaultBgImge"]];

    CGFloat originY = 100*BILI_WIDTH;

    CGFloat nameWidth = 100;
    UILabel *schoolNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*BILI_WIDTH, originY, nameWidth, 24*BILI_WIDTH)];
    schoolNameLbl.textColor = [UIColor colorWithRed:((float)((0xffffff & 0xFF0000) >> 16))/255.0 green:((float)((0xffffff & 0xFF00) >> 8))/255.0 blue:((float)(0xffffff & 0xFF))/255.0 alpha:0.60];
    schoolNameLbl.textAlignment = NSTextAlignmentCenter;
    schoolNameLbl.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    schoolNameLbl.layer.cornerRadius = 5;
    schoolNameLbl.layer.borderColor = [UIColor colorWithRed:((float)((0xffffff & 0xFF0000) >> 16))/255.0 green:((float)((0xffffff & 0xFF00) >> 8))/255.0 blue:((float)(0xffffff & 0xFF))/255.0 alpha:0.45].CGColor;
    schoolNameLbl.layer.borderWidth = 1;
    schoolNameLbl.layer.masksToBounds = YES;
    schoolNameLbl.backgroundColor = [UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0xFF00) >> 8))/255.0 blue:((float)(0x000000 & 0xFF))/255.0 alpha:0.12];
    [_schoolImgView addSubview:schoolNameLbl];
    
    schoolNameLbl.text = shareAppDelegateInstance.boenUserInfo.schoolName;

    nameWidth = [Tools getTextWidthWithText:schoolNameLbl.text font:schoolNameLbl.font height:schoolNameLbl.frame.size.height]+20*BILI_WIDTH;
    if (nameWidth > SCREEN_WIDTH-30*BILI_WIDTH) {
        nameWidth = SCREEN_WIDTH-30*BILI_WIDTH;
    }
    schoolNameLbl.frame = CGRectMake(13*BILI_WIDTH, originY, nameWidth, 23*BILI_WIDTH);
    
    originY += CGRectGetHeight(schoolNameLbl.frame) + 15*BILI_WIDTH;
    
    NSMutableArray *hotArray = [@[] mutableCopy];
    NSMutableArray *array = [[Tools getSchoolProjectItemRecordArray] mutableCopy];
    for (NSDictionary *dict in array) {
        if ([[dict valueWithNoDataForKey:@"biz_area"] integerValue] == 3) {
            [hotArray addObject:dict];
        }
    }
    if (hotArray.count > 0) {
        NSDictionary *schoolHotProject = hotArray[0];
        //热门应用
        UIView *lightGrayBaseView = [[UIView alloc]initWithFrame:CGRectMake(13*BILI_WIDTH, originY, SCREEN_WIDTH-2*13*BILI_WIDTH, 81*BILI_WIDTH)];
        lightGrayBaseView.backgroundColor = [UIColor colorWithRed:((float)((0x10131e & 0xFF0000) >> 16))/255.0 green:((float)((0x10131e & 0xFF00) >> 8))/255.0 blue:((float)(0x10131e & 0xFF))/255.0 alpha:0.7];
        lightGrayBaseView.layer.cornerRadius = 7;
        lightGrayBaseView.layer.masksToBounds = YES;
        lightGrayBaseView.userInteractionEnabled = YES;
        [_schoolImgView addSubview:lightGrayBaseView];

        UIImageView *hotView = [[UIImageView alloc]initWithFrame:CGRectMake((82-23)*BILI_WIDTH/2, 22*BILI_WIDTH, 23*BILI_WIDTH, 23*BILI_WIDTH)];
        hotView.image = [UIImage imageNamed:@"Service_HotIcon"];
        [lightGrayBaseView addSubview:hotView];
        
        UILabel *hotLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (82-22-10)*BILI_WIDTH, 82*BILI_WIDTH, 10*BILI_WIDTH)];
        hotLbl.textColor = UIColorFromRGB(0xff9c00);
        hotLbl.font = [UIFont systemFontOfSize:10*BILI_WIDTH];
        hotLbl.textAlignment = NSTextAlignmentCenter;
        hotLbl.text = @"热门应用";
        [lightGrayBaseView addSubview:hotLbl];
        
        UIView *whiteHotView = [[UIView alloc]initWithFrame:CGRectMake((13+82)*BILI_WIDTH, originY, SCREEN_WIDTH-2*13*BILI_WIDTH-82*BILI_WIDTH, 82*BILI_WIDTH)];
        whiteHotView.backgroundColor = [UIColor whiteColor];
        whiteHotView.layer.cornerRadius = 7;
        whiteHotView.layer.masksToBounds = YES;
        whiteHotView.userInteractionEnabled = NO;
        [_schoolImgView addSubview:whiteHotView];
        
        UILabel *projectLbl = [[UILabel alloc]initWithFrame:CGRectMake(16*BILI_WIDTH, 25*BILI_WIDTH, 115*BILI_WIDTH, 15*BILI_WIDTH)];
        projectLbl.textColor = UIColor_NewBlueColor;
        projectLbl.font = [UIFont systemFontOfSize:13*BILI_WIDTH];
        projectLbl.text = [schoolHotProject valueWithNoDataForKey:@"biz_name"];
        [whiteHotView addSubview:projectLbl];

        UILabel *subNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(16*BILI_WIDTH, (82-25-13)*BILI_WIDTH, 115*BILI_WIDTH, 13*BILI_WIDTH)];
        subNameLbl.textColor = UIColorFromRGB(0x90a4ae);
        subNameLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
        subNameLbl.text = [schoolHotProject valueWithNoDataForKey:@"biz_desc"];
        [whiteHotView addSubview:subNameLbl];

        UIImageView *hotProjectIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(whiteHotView.frame)-(25+44)*BILI_WIDTH, (82-44)/2*BILI_WIDTH, 44*BILI_WIDTH, 44*BILI_WIDTH)];
        [whiteHotView addSubview:hotProjectIcon];
        [hotProjectIcon sd_setImageWithURL:[NSURL URLWithString:[schoolHotProject valueWithNoDataForKey:@"biz_icon_url"]] placeholderImage:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotProjectAction)];
        [lightGrayBaseView addGestureRecognizer:tap];
    }
    

    
}
- (void)addSchoolProjectView
{
    NSMutableArray *schoolNormalArray = [@[] mutableCopy];
    NSMutableArray *array = [[Tools getSchoolProjectItemRecordArray] mutableCopy];
    for (NSDictionary *dict in array) {
        if ([[dict valueWithNoDataForKey:@"biz_area"] integerValue] == 4) {
            [schoolNormalArray addObject:dict];
        }
    }
    if (schoolNormalArray && schoolNormalArray.count > 3) {
        schoolNormalArray = [[schoolNormalArray subarrayWithRange:NSMakeRange(0, 3)] mutableCopy];
    } else  if (!schoolNormalArray || schoolNormalArray.count <= 0){
        //校园普通应用只有0，则不加载此模块，去加载messageView;
        messageViewOriginY = 241*BILI_WIDTH;
        [self addMessageView];
        
        return;
    }
    
    if (!_schoolProjectBaseView) {
        self.schoolProjectBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 241*BILI_WIDTH, SCREEN_WIDTH, 120*BILI_WIDTH)];
        _schoolProjectBaseView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_schoolProjectBaseView];
    }
    for (UIView *view in _schoolProjectBaseView.subviews) {
        [view removeFromSuperview];
    }
    UIView *grayBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36*BILI_WIDTH)];
    grayBaseView.backgroundColor = UIColor_Gray_BG;
    [_schoolProjectBaseView addSubview:grayBaseView];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*BILI_WIDTH, 4*BILI_WIDTH, 200*BILI_WIDTH, CGRectGetHeight(grayBaseView.frame))];
    titleLbl.textColor = UIColorFromRGB(0x90a4ae);
    titleLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    titleLbl.text = @"校园应用开放平台";
    [grayBaseView addSubview:titleLbl];

    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(SCREEN_WIDTH-(7+60)*BILI_WIDTH, 4*BILI_WIDTH, 60*BILI_WIDTH, CGRectGetHeight(grayBaseView.frame));
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    [moreBtn setTitleColor:UIColorFromRGB(0x90a4ae) forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"netFees_right_arrow"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 45*BILI_WIDTH, 0, 0)];
    moreBtn.contentMode = UIViewContentModeRight;
    [grayBaseView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
    //校园应用3个
    int cellNumber = 3;  //每行放几个
    
    CGFloat buttonWidth =  (SCREEN_WIDTH-20*BILI_WIDTH-3*15*BILI_WIDTH)/cellNumber;
    
    for (int i = 0; i < schoolNormalArray.count; i++) {
        NSDictionary *itemDict = schoolNormalArray[i];
        
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpWithImgTopY:10*BILI_WIDTH imgHeight:36*BILI_WIDTH textBottomY:10*BILI_WIDTH];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(10*BILI_WIDTH + i%cellNumber*(i%cellNumber == 0 ? 0 : 15*BILI_WIDTH) + i*buttonWidth, 32*BILI_WIDTH+(120-32-75)/2*BILI_WIDTH , buttonWidth, 75*BILI_WIDTH);
        [button addTarget:self action:@selector(suDoKuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_schoolProjectBaseView addSubview:button];
        
        [button setUpButtonData:itemDict];
        
        [button setTitle:[itemDict valueForKey:@"biz_name"] forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:button.biz_icon_url] forState:UIControlStateNormal];
        
    }
    
    messageViewOriginY = CGRectGetMaxY(_schoolProjectBaseView.frame);

    [self addMessageView];
}
- (void)addMessageView
{
    if (!_messageBaseView) {
        self.messageBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, messageViewOriginY, SCREEN_WIDTH, 120*BILI_WIDTH)];
        _messageBaseView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_messageBaseView];
    }

    for (UIView *view in _messageBaseView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat originY = 0;
    
    UIView *grayBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36*BILI_WIDTH)];
    grayBaseView.backgroundColor = UIColor_Gray_BG;
    [_messageBaseView addSubview:grayBaseView];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(13*BILI_WIDTH, 4*BILI_WIDTH, 200*BILI_WIDTH, CGRectGetHeight(grayBaseView.frame))];
    titleLbl.textColor = UIColorFromRGB(0x90a4ae);
    titleLbl.font = [UIFont systemFontOfSize:11*BILI_WIDTH];
    titleLbl.text = @"消息通知";
    [grayBaseView addSubview:titleLbl];
    
    originY += CGRectGetHeight(grayBaseView.frame);
    //暂时维持原状，只有固定两个
    
    CGFloat cardWidth = (SCREEN_WIDTH-15*2-10)/2;
    CGFloat cardHeight = 90*NEW_BILI;
    
    originY += 20;

    CGFloat messageViewHeight = 0;
    
    for (int i=1; i<=self.datasourceArray.count; i++) {
        CGFloat posX = i%2 == 0 ? 15+cardWidth+10 : 15;
        CGFloat posY = floor((i-1)/2.0)*(cardHeight+10);
        
        CardStyle style = CardStyleTitle;
        if (i == 2) {
            style = CardStyleTitleAndSubtitle;
        }
        BNServerCardView *cardView = [[BNServerCardView alloc] initWithFrame:CGRectMake(posX, originY+posY, cardWidth, cardHeight) style:style];
        [cardView setData:self.datasourceArray[(i-1)%2]];
        cardView.delegate = self;
        [_messageBaseView addSubview:cardView];
        
        if (i == self.datasourceArray.count) {
            messageViewHeight = originY+posY+cardHeight+20;
        }
    }

    originY += messageViewHeight;
    
    _messageBaseView.frame = CGRectMake(0, messageViewOriginY, SCREEN_WIDTH, originY);
    _scrollView.contentSize = CGSizeMake(0, messageViewOriginY+originY);
    
}
//获取校园应用
- (void)getSchoolProjectItemList
{
    
    [BannerApi querySchoolBizCodeWithBiz_area:@"3,4"
                                      success:^(NSDictionary *successData) {
        BNLog(@"querySchoolBizCodeWithSuccess222---%@", successData);
        NSString *retCode = [NSString stringWithFormat:@"%@", [successData valueNotNullForKey:kRequestRetCode]];
        if ([retCode isEqualToString:kRequestNewSuccessCode]) {
            [Tools saveSchoolProjectItemRecordArray:[successData valueForKey:kRequestReturnData]];//本地保存列表
            
            [self addMainView];

            [self addSchoolProjectView];
        } else{
            
        }
    } failure:^(NSError *error) {
        BNLog(@"querySchoolBizCodeWith failure---");
        [self addMessageView];
    }];
    
}
//构建数据源
- (void)loadData
{
    NSDictionary *oneCardDic = @{kServiceCenterIcon : @"Service_OneCard_ServiceCenter",
                                kServiceCenterTitle : @"校园信息服务中心",
                            kServiceCenterNewsCount : @([[BNNewsTool sharedInstance] getOneCardNewsUnReadNumber]),
                      kServiceCenterLatestNewsTitle : [[BNNewsTool sharedInstance] getOneCardLatestNewsTitle]};
    
    NSDictionary *xiFuDic = @{kServiceCenterIcon:@"Service_XiFu_ServiceCenter",
                               kServiceCenterTitle:@"喜付说",
                               kServiceCenterNewsCount:@([[BNNewsTool sharedInstance] getXifuNewsUnReadNumber]),
                              kServiceCenterLatestNewsTitle : [[BNNewsTool sharedInstance] getXiFuLatestNewsTitle]};
    self.datasourceArray = @[oneCardDic, xiFuDic];
    
    messageViewOriginY = 241*BILI_WIDTH;

}

- (void)pushToMsgCenterListVC:(NSNotification *)notification
{
    BNXiFuNewsListViewController *xiFuNewsListVC = [[BNXiFuNewsListViewController alloc] init];
    xiFuNewsListVC.useStyle = NewsListViewControllerUseStyleXIFU;
    xiFuNewsListVC.enterMode = EnterModeFromNotificationCenter;
    [self pushViewController:xiFuNewsListVC animated:YES];

}

- (void)moreBtnAction:(UIButton *)button
{
    //友盟事件点击
    [MobClick event:@"school_moreBtn"];
    
    //更多-所有应用
    BNAllProjectVC *allProjectVC = [[BNAllProjectVC alloc]init];
    allProjectVC.useTypes = UseTypeSchoolProject;
    [self pushViewController:allProjectVC animated:YES];
}

- (void)suDoKuButtonAction:(CustomButton *)button
{
    [super suDoKuButtonAction:button];
}

- (void)hotProjectAction
{
    NSArray *array = [[Tools getSchoolProjectItemRecordArray] mutableCopy];
    if (array.count > 0) {
        NSDictionary *schoolHotProject = array[0];
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setUpButtonData:schoolHotProject];
        [self suDoKuButtonAction:button];
    }
}

#pragma mark - CardViewDelegate

- (void)cardSelected:(NSDictionary *)data {
    switch ([self.datasourceArray indexOfObject:data]) {
        case 0:
        {
            //友盟事件点击
            [MobClick event:@"school_SchoolNewsCenter"];
            
            BNNewsListViewController *newsListVC = [[BNNewsListViewController alloc] init];
            newsListVC.useStyle = NewsListViewControllerUseStyleYKT;
            [self pushViewController:newsListVC animated:YES];
        }
            break;
            
        case 1:
        {
            //友盟事件点击
            [MobClick event:@"school_XifuNewsCenter"];

            BNXiFuNewsListViewController *xiFuNewsListVC = [[BNXiFuNewsListViewController alloc] init];
            xiFuNewsListVC.useStyle = NewsListViewControllerUseStyleXIFU;
            xiFuNewsListVC.enterMode = EnterModeFromVC;
            [self pushViewController:xiFuNewsListVC animated:YES];
        }
            break;
        default:
            break;
    }
}

////创建cell
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"serviceCenterCell";
//    BNServerCenterCell *cell = (BNServerCenterCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        cell = [[BNServerCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    NSDictionary *info = [self.datasourceArray objectAtIndex:indexPath.row];
//    UIImage *icon = [UIImage imageNamed:[info objectForKey:kServiceCenterIcon]];
//    [cell drawDataWithIcon:icon
//                     title:[info objectForKey:kServiceCenterTitle]
//           latestNewsTitle:[info objectForKey:kServiceCenterLatestNewsTitle]
//                 countNews:[[info objectForKey:kServiceCenterNewsCount] intValue]];
//    return cell;
//}
//
////用户选择了某行
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.row) {
//        case 0:
//        {
//            BNNewsListViewController *newsListVC = [[BNNewsListViewController alloc] init];
//            newsListVC.useStyle = NewsListViewControllerUseStyleYKT;
//            [self pushViewController:newsListVC animated:YES];
//        }
//            break;
//
//        case 1:
//        {
//            BNXiFuNewsListViewController *xiFuNewsListVC = [[BNXiFuNewsListViewController alloc] init];
//            xiFuNewsListVC.useStyle = NewsListViewControllerUseStyleXIFU;
//            xiFuNewsListVC.enterMode = EnterModeFromVC;
//            [self pushViewController:xiFuNewsListVC animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
//}

@end
