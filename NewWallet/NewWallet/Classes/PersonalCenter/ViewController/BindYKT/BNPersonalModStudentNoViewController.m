//
//  BNPersonalModStudentNoViewController.m
//  
//
//  Created by crx on 15/8/13.
//
//

#import "BNPersonalModStudentNoViewController.h"
#import "BNPersonalInputStudentNoViewController.h"

@interface BNPersonalModStudentNoViewController ()

@end

@implementation BNPersonalModStudentNoViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLoadedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)setupLoadedView {
    [super setupLoadedView];
    
    self.navigationTitle = @"修改学号";
    
    self.view.backgroundColor = UIColor_Gray_BG;
    
    UIView *studentNoBGView = [[UIView alloc] initWithFrame:CGRectMake(0, kSectionHeight, SCREEN_WIDTH, 45 *BILI_WIDTH)];
    studentNoBGView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = UIColor_GrayLine;
    [studentNoBGView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, studentNoBGView.bounds.size.height-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = UIColor_GrayLine;
    [studentNoBGView addSubview:bottomLine];
    
    UILabel *studentNoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 45 *BILI_WIDTH)];
    studentNoTitleLabel.textColor = [UIColor blackColor];
    studentNoTitleLabel.textAlignment = NSTextAlignmentLeft;
    studentNoTitleLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    studentNoTitleLabel.text = @"学工号";
    [studentNoBGView addSubview:studentNoTitleLabel];
    
    UILabel *studentNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(studentNoBGView.bounds.size.width-160, 0, 150, 45 *BILI_WIDTH)];
    studentNoLabel.textColor = [UIColor lightGrayColor];
    studentNoLabel.textAlignment = NSTextAlignmentRight;
    studentNoLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:17 sixPlus:19]];
    studentNoLabel.text = shareAppDelegateInstance.boenUserInfo.studentno;
    [studentNoBGView addSubview:studentNoLabel];
    
    [self.baseScrollView addSubview:studentNoBGView];
    
    UIButton *modButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modButton.frame = CGRectMake(10, studentNoBGView.frame.origin.y + studentNoBGView.frame.size.height + 30 * BILI_WIDTH, SCREEN_WIDTH - 20, 40 * BILI_WIDTH);
    [modButton setupTitle:@"修改学号" enable:YES];
    [modButton addTarget:self action:@selector(modAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:modButton];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, modButton.frame.origin.y+modButton.frame.size.height+20, SCREEN_WIDTH-20, 20)];
    tipsLabel.textColor = [UIColor colorWithRed:203/255.0 green:53/255.0 blue:44/255.0 alpha:1];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:12 six:14 sixPlus:16]];
    tipsLabel.text = @"鉴于安全因素，学工号仅有两次修改机会，请谨慎修改";
    [self.baseScrollView addSubview:tipsLabel];
}

#pragma mark - event response

- (void)modAction:(UIButton *)sender {
    if (![shareAppDelegateInstance.boenUserInfo.isCert isEqualToString:@"yes"]) {
        [Tools showMessageWithTitle:@"为了账户安全，你必须绑定过银行卡确定身份信息后才能修改学号！" message:@""];
        return;
    }
    
    BNPersonalInputStudentNoViewController *inputVC = [[BNPersonalInputStudentNoViewController alloc] init];
    [self pushViewController:inputVC animated:YES];
}

@end
