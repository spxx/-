//
//  BNAboutViewController.m
//  NewWallet
//
//  Created by mac1 on 14-11-14.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNAboutViewController.h"
#import "BNAboutVCTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface BNAboutViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
    NSArray *titleArray0;
    NSArray *titleArray1;
    NSArray *titleArray2;
    NSArray *contentArray0;
    NSArray *contentArray1;
    NSArray *contentArray2;
}
@property (weak, nonatomic) UIScrollView *scrollView;


@end

@implementation BNAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLoadedView];
}
#pragma mark - setup loaded view
- (void)setupLoadedView
{
    self.navigationTitle = @"关于我们";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    
   CGFloat contentSizeY = SCREEN_HEIGHT == 480 ? 500 : SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge + 1;
    UIScrollView *theScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT- self.sixtyFourPixelsView.viewBottomEdge)];
    theScollView.contentSize = CGSizeMake(0, contentSizeY);
    theScollView.backgroundColor = UIColor_Gray_BG;
    [self.view addSubview:theScollView];
    self.scrollView = theScollView;
    
    
    UIView *cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195*BILI_WIDTH)];
    cardBackgroundView.backgroundColor = UIColor_Gray_BG;
    [self.scrollView addSubview:cardBackgroundView];
    
    CGRect cardFrame = cardBackgroundView.frame;
    
    UIImageView *shadowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [shadowImgV setImage:[UIImage imageNamed:@"About_logo_shadow"]];
    [cardBackgroundView addSubview:shadowImgV];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((cardFrame.size.width - 80*BILI_WIDTH)/2, 31*BILI_WIDTH, 80*BILI_WIDTH, 80*BILI_WIDTH)];
    [iconImageView setImage:[UIImage imageNamed:@"xifu_icon"]];
    [cardBackgroundView addSubview:iconImageView];
    
    shadowImgV.frame = CGRectMake((cardFrame.size.width - 100*BILI_WIDTH)/2, CGRectGetMaxY(iconImageView.frame)-16*BILI_WIDTH/2, 100*BILI_WIDTH, 16*BILI_WIDTH);
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 35*BILI_WIDTH, cardFrame.size.width, 24)];
    versionLabel.textColor = UIColorFromRGB(0x727272);
    versionLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:13 six:15 sixPlus:17]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: kBundleKey];
    if (thisVersion.length > 0) {
        thisVersion = [NSString stringWithFormat:@"版本号 V %@", thisVersion];
    }
    versionLabel.text = thisVersion;
    [cardBackgroundView addSubview:versionLabel];

    UIView *aboutAppgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, cardFrame.origin.y + cardFrame.size.height, SCREEN_WIDTH, 200)];
    aboutAppgroundView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    aboutAppgroundView.layer.cornerRadius = 5;
    [self.scrollView addSubview:aboutAppgroundView];
    
    titleArray0 = @[@"用户Q群", @"客服QQ", @"客服邮箱"];
    titleArray1 = @[@"客服电话（1）", @"客服电话（2）"];
    titleArray2 = @[@"微信公众号"];

    contentArray0 = @[@"242363034", @"2425839277", @"kefu@bionictech.cn"];
    contentArray1 = @[@"400-998-0880", @"028-61831329"];
    contentArray2 = @[@"xifushoujiqianbao"];
    
    
    CGFloat tableViewH = SCREEN_HEIGHT == 480 ? 294 : CGRectGetHeight(_scrollView.frame) -195*BILI_WIDTH;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 195*BILI_WIDTH, SCREEN_WIDTH, tableViewH) style:UITableViewStylePlain];
    tableView.tag = 100;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44 * BILI_WIDTH;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    [self.scrollView addSubview:tableView];
    
}

#pragma mark - table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return titleArray0.count;
            break;
        case 1:
            return titleArray1.count;
            break;
        case 2:
            return titleArray2.count;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BNAboutVCTableViewCell";
    BNAboutVCTableViewCell *cell = (BNAboutVCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BNAboutVCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.section) {
        case 0:
            [cell drawtitleStr:titleArray0[indexPath.row] contentStr:contentArray0[indexPath.row]];
            if (([titleArray0 count] - 1) == indexPath.row) {
                cell.sepLine.hidden = YES;
            }else{
                cell.sepLine.hidden = NO;
            }
            break;
        case 1:
            [cell drawtitleStr:titleArray1[indexPath.row] contentStr:contentArray1[indexPath.row]];
            if (([titleArray1 count] - 1) == indexPath.row) {
                cell.sepLine.hidden = YES;
            }else{
                cell.sepLine.hidden = NO;
            }
            break;
        case 2:
            [cell drawtitleStr:titleArray2[indexPath.row] contentStr:contentArray2[indexPath.row]];
            if (([titleArray2 count] - 1) == indexPath.row) {
                cell.sepLine.hidden = YES;
            }else{
                cell.sepLine.hidden = NO;
            }
            break;
    }    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSectionHeight)];
    headView.backgroundColor = UIColor_Gray_BG;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight - 1.0, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = UIColor_GrayLine;
    [headView addSubview:line];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = UIColor_GrayLine;
    return line;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 2:
                        shareAppDelegateInstance.alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"给我们发邮件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        shareAppDelegateInstance.alertView.tag = 101;
                        [shareAppDelegateInstance.alertView show];
                        break;
                }
            }
                break;
                
            case 1: {
                switch (indexPath.row) {
                    case 0: {
                        UIWebView*callWebview =[[UIWebView alloc] init];
                        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",contentArray1[0]];
                        NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
                        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                        [self.view addSubview:callWebview];
                        
                        break;
                    }
                    case 1: {
                        UIWebView*callWebview =[[UIWebView alloc] init];
                        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",contentArray1[1]];
                        NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
                        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                        [self.view addSubview:callWebview];
                        
                        break;
                    }
                }
                
            }
                break;
        }
        
}

- (void)sendEmail
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if (!picker)
    {
        return;
    }
    picker.mailComposeDelegate = self;
    
    //            [picker setSubject:@"Enter Your Subject!"];
    NSArray *toRecipients = [NSArray arrayWithObject:@"kefu@bionictech.cn"];
    
    [picker setToRecipients:toRecipients];
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            [self sendEmail];
        }
    }
   
}

@end
