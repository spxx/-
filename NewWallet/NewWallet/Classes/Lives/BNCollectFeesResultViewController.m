//
//  BNCollectFeesResultViewController.m
//  
//
//  Created by crx on 15/9/2.
//
//

#import "BNCollectFeesResultViewController.h"
#import <CoreText/CoreText.h>
#import "BNCollectFeesListVC.h"
#import "BNResultView.h"

@interface BNCollectFeesResultViewController ()<BNResultViewDataSource,BNResultViewDelegate>

@property (strong, nonatomic) UIButton *resultButton;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UILabel *projectNameLabel;
@property (strong, nonatomic) UILabel *gotTimeLabel;
@property (strong, nonatomic) UILabel *wayLabel;
@property (strong, nonatomic) UILabel *amountLabel;

@end

@implementation BNCollectFeesResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationTitle = @"交易结果";
    [self setupViews];
}

- (void)setupViews {
    BNResultView *resultView = [[BNResultView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge)];
    resultView.delegate = self;
    resultView.dataSource = self;
    resultView.headBtnStr = _isSucceed?@"领取成功":@"领取失败";
    if (!self.isSucceed) {
        if (!_errorMessage || [_errorMessage isEqualToString:@"null"]) {
            resultView.tipsLabelMsg = @"如有疑问，请联系客服：028-61831329";
        } else {
            resultView.tipsLabelMsg = [NSString stringWithFormat:@"[%@]如有疑问，请联系客服：028-61831329", self.errorMessage];
        }
        resultView.status = ResultStatusFailure;
    } else {
        resultView.tipsLabelMsg = @"稍后请查看您的钱包余额或通过交易记录进行查询。";
        resultView.status = ResultStatusSuccesed;
    }
    resultView.hiddenFinshButton = self.useType == CollectFeesResultUseTypeFromBillCenter;
    [self.view addSubview:resultView];
    [resultView reloadData];
    
    self.backButton.hidden = self.useType == CollectFeesResultUseTypeFromDetail;
}

#pragma mark - BNResultViewDataSource
- (NSInteger)numberOfmembersInResultView:(UIView *)resultView
{
    return 4;
}
- (NSArray *)titleForView:(UIView *)resultView
{
    return @[@"发放项目：",@"领取时间：",@"领取方式：",@"领取金额："];
}
- (NSArray *)contentForView:(UIView *)resultView
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:_receiptTime];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return @[self.projectName,dateStr,@"喜付钱包",self.amount];
}

#pragma mark - BNResultViewDelegate
- (void)resultViewFinshButtonAcion:(UIView *)resultView
{
    BOOL isFoundListVC = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"BNCollectFeesListVC")]) {
            isFoundListVC = YES;
            BNCollectFeesListVC *listVC = (BNCollectFeesListVC *)viewController;
            listVC.isPop = YES;
            [self.navigationController popToViewController:listVC animated:YES];
            break;
        }
    }
    if (!isFoundListVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
