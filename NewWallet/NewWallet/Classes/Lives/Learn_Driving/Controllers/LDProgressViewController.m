//
//  LDProgressViewController.m
//  Wallet
//
//  Created by 陈荣雄 on 5/30/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import "LDProgressViewController.h"
#import "LDProgressCell.h"
#import "LDConfirmViewController.h"
#import "LearnDrivingApi.h"
#import "BNCommonWebViewController.h"

@interface LDProgressViewController () <UITableViewDataSource, UITableViewDelegate, PayFeeDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *items;



@end

@implementation LDProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
//    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.navigationTitle = @"学车进度";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DrivingItem" ofType:@"plist"];
    self.items = [NSArray arrayWithContentsOfFile:filePath];
    

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[LDProgressCell class] forCellReuseIdentifier:progressCellIdentifier];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    

}

- (void)loadData {
    __weak __typeof(self) weakSelf = self;
    [LearnDrivingApi getDrivingRecord:^(NSDictionary *returnData) {
        
        NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
        if ([retCode isEqualToString:@"000000"]) {
            weakSelf.recordInfo = returnData[kRequestReturnData];
            
            /*NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:weakSelf.recordInfo];
            d[@"installment_serial"] = @"2";
            weakSelf.recordInfo = d;*/
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } else {
            NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
}

#pragma mark UITableViewDatasource&&UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.items[indexPath.row];
    CGFloat height = [Tools caleNewsCellHeightWithTitle:data[@"description"] font:[UIFont systemFontOfSize:13] width:SCREEN_WIDTH-50];
    return 31+10+height+10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:progressCellIdentifier forIndexPath:indexPath];
    cell.payDelegate = self;
    NSDictionary *data = self.items[indexPath.row];
    [cell setData:data];
    NSInteger serial = [self.recordInfo[@"installment_serial"] integerValue];
    NSInteger status = [self.recordInfo[@"status"] integerValue];
    if (status == 1) {
        switch ([data[@"no"] integerValue]) {
            case 2:
            {
                if (serial == 1) {
                    [cell setPayState:YES];
                } else {
                    [cell setPayState:NO];
                }
            }
                break;
            case 3:
            {
                if (serial == 2) {
                    [cell setPayState:YES];
                } else {
                    [cell setPayState:NO];
                }
            }
                break;
            /*case 4:
            {
                if (serial > 3) {
                    [cell setPayState:NO];
                } else {
                    [cell setPayState:YES];
                }
            }
                break;*/
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *url;
    switch (indexPath.row) {
        case 0:
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/stage1.html";
            break;
        case 1:
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/stage2.html";
            break;
        case 2:
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/stage3.html";
            break;
        case 3:
            url = @"http://api.bionictech.cn/static/xifu_files/schools/car/stage4.html";
            break;
        default:
            break;
    }
    
    BNCommonWebViewController *webView = [[BNCommonWebViewController alloc] init];
    webView.urlString = url;
    [self pushViewController:webView animated:YES];
}

#pragma mark - PayFeeDelegate

- (void)pay {
    if (self.recordInfo) {
        [SVProgressHUD show];
        
        __weak typeof(self) weakSelf = self;
        [LearnDrivingApi continuePay:[self.recordInfo valueNotNullForKey:@"apply_record_key"]  installmentSerial:[self.recordInfo valueNotNullForKey:@"installment_serial"] installmentFee:[self.recordInfo valueNotNullForKey:@"installment_fee"] succeed:^(NSDictionary *returnData) {
            
            NSString *retCode = [returnData valueNotNullForKey:kRequestRetCode];
            if ([retCode isEqualToString:@"000000"]) {
                [SVProgressHUD dismiss];
                
                NSDictionary *data = [returnData valueForKey:kRequestReturnData];
                
                BNPayModel *payModel = [[BNPayModel alloc]init];
                payModel.order_no = [data valueNotNullForKey:@"order_no"];
                payModel.biz_no = [data valueNotNullForKey:@"biz_no"];
                [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeScanToPay
                                                 payModel:payModel
                                              returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                  if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                  }
                                              }];
                
            } else {
                NSString *retMsg = [returnData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        }];
    }
}

@end
