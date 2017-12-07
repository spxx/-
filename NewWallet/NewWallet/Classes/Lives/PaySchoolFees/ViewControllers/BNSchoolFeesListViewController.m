//
//  BNSchoolFeesListViewController.m
//  Wallet
//
//  Created by mac1 on 15/3/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNSchoolFeesListViewController.h"
#import "BNFeesDetialsCell.h"
#import "SchoolFeesClient.h"

#import "BNFeesDetialsNormalVC.h"
#import "BNFeesDetialsFreeLevelsVC.h"
#import "BNFeesDetialsFreeTimesVC.h"

#import "BNFeesWebViewExplainVC.h"
#import "NewSchoolFeesApi.h"
#import "HttpTools.h"
#import "JavaHttpTools.h"

@interface BNSchoolFeesListViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * datasource;

@property (nonatomic, weak) UITableView *listTableView;

@property (nonatomic, weak) UIView *noteView;

@property (nonatomic, strong) NSDictionary *tempFeesInfo;
@end
@implementation BNSchoolFeesListViewController

- (void)setupLoadedView
{
    self.navigationTitle = @"教育缴费";
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 44);
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info_HeighLight"] forState:UIControlStateHighlighted];
    [rightItem setImage:[UIImage imageNamed:@"SchoolFees_info"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(feesExplainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:rightItem];

    self.view.backgroundColor = UIColor_Gray_BG;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sixtyFourPixelsView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kFeesCellHeight;
    tableView.backgroundColor = UIColor_Gray_BG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _listTableView = tableView;
    
    CGFloat noteViewWidth = 300;
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - noteViewWidth)/2, self.sixtyFourPixelsView.viewBottomEdge + (SCREEN_HEIGHT - self.sixtyFourPixelsView.viewBottomEdge - noteViewWidth)/2.0, noteViewWidth, noteViewWidth)];
    noteView.backgroundColor = [UIColor clearColor];
    noteView.hidden = YES;
    _noteView = noteView;
    
    UIView *cricleView = [[UIView alloc] initWithFrame:CGRectMake(40, 40, 220, 220)];
    cricleView.backgroundColor = [UIColor whiteColor];
    cricleView.layer.cornerRadius = 110;
    cricleView.layer.masksToBounds = YES;
    cricleView.tag = 10;
    
    UIImageView *noteImg = [[UIImageView alloc] initWithFrame:CGRectMake((noteViewWidth-200)/2,15, 200, 200)];
    noteImg.tag = 11;
    noteImg.hidden = YES;
    [noteImg setImage:[UIImage imageNamed:@"network_error"]];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (noteViewWidth - 24)/2.0, noteViewWidth, 24)];
    noteLabel.tag = 12;
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.text = @"您暂时还没有缴费项目";
    noteLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:14 six:16 sixPlus:18]];
    noteLabel.textColor = [UIColor lightGrayColor];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.tag = 13;
    reloadButton.hidden = YES;
    reloadButton.frame = CGRectMake((noteViewWidth-100)/2, noteLabel.frame.size.height + noteLabel.frame.origin.y + 10, 100, 35);
    
    NSMutableAttributedString *addTitle = [[NSMutableAttributedString alloc] initWithString:@"重新加载"];
    NSRange titleRange = NSMakeRange(0, [addTitle length]);
    [addTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [addTitle addAttribute:NSForegroundColorAttributeName value:UIColor_Blue_BarItemText range:titleRange];
    [reloadButton setAttributedTitle:addTitle forState:UIControlStateNormal];
    
    [reloadButton addTarget:self action:@selector(codeStringIsInSandbox) forControlEvents:UIControlEventTouchUpInside];
    
    [noteView addSubview:cricleView];
    [noteView addSubview:noteImg];
    [noteView addSubview:noteLabel];
    [noteView addSubview:reloadButton];
    
    [self.view addSubview:noteView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _datasource = [[NSMutableArray alloc] init];
    [self setupLoadedView];
    [self codeStringIsInSandbox];
}

//从python端请求code 将code存入UserDefaults,再去java端请求费用列表
- (void)getCodeFromPythonServer
{
    [[HttpTools shareInstance] JsonPostRequst:@"/openapi/version_1.0/auth/auth_code" parameters:@{@"code":@"code"} success:^(id responseObject) {
        NSDictionary *successData = responseObject;
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            NSDictionary *data = [successData valueNotNullForKey:@"data"];
            NSString *code = data[@"code"];
            BNLog(@"get-code--->>>%@",code);

            [self getSchoolFeesListWithCode:code];
        }else{
            [SVProgressHUD showErrorWithStatus:successData[kRequestRetMessage]];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        [self configShowLoadedViewWithIsNetworkError:YES];
    }];
}

//从java获取缴费列表
- (void)getSchoolFeesListWithCode:(NSString *)code
{

    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewSchoolFeesApi shoolFeesListWithCode:code success:^(NSURLSessionDataTask *task,NSDictionary *successData) {
        BNLog(@"缴费列表--->>>%@",successData);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        BNLog(@"allHeaders-->>>%@",allHeaders);
        if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
            [SVProgressHUD dismiss];
            NSArray *userFessInfo = [successData valueNotNullForKey:kRequestReturnData];
            [_datasource removeAllObjects];
            [_datasource addObjectsFromArray:userFessInfo];
            [self.listTableView reloadData];
        }else{
            if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:@"000001"]) {
                [self getCodeFromPythonServer];
            }else{
                NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                [SVProgressHUD showErrorWithStatus:retMsg];
            }
        }
        [self configShowLoadedViewWithIsNetworkError:NO];
        
    } failure:^(NSURLSessionDataTask *task,NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
        [self configShowLoadedViewWithIsNetworkError:YES];
    }];
}

//判断沙盒中是否有code,如果有code直接向java端请求缴费列表(如果过期--000001重新调python接口获取code),如果没有则向python端请求code
- (void)codeStringIsInSandbox
{
    [self getCodeFromPythonServer];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (_isPopFromAddBankCard) {
//        _isPopFromAddBankCard = NO;//要设为NO，否则下次viewWillAppear会再调用。
//        [self goToPayWithInfo:_tempFeesInfo];
//    } else {
//        [self codeStringIsInSandbox];
//    }
//}

- (void)configShowLoadedViewWithIsNetworkError:(BOOL) isNetworkError
{
    UIImageView *noteImg = (UIImageView *)[_noteView viewWithTag:11];
    UILabel *noteLab = (UILabel *)[_noteView viewWithTag:12];
    UIButton *btn = (UIButton *)[_noteView viewWithTag:13];
    if (isNetworkError == YES) {
        _listTableView.hidden = YES;
        _noteView.hidden = NO;
        noteImg.hidden = NO;
        noteLab.text = @"世界上最远的距离就是没有网";
        btn.hidden = NO;
    }else{
        if ([_datasource count] > 0) {
            _noteView.hidden = YES;
            _listTableView.hidden = NO;
        }else{
            _listTableView.hidden = YES;
            _noteView.hidden = NO;
            noteImg.hidden = YES;
            noteLab.text = @"您暂时还没有需要缴费的项目";
            btn.hidden = YES;
        }
    }
    
}
/*
- (void)loadDataFromServer
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [SchoolFeesClient checkFeesPrijectListWithUserid:shareAppDelegateInstance.boenUserInfo.userid
                                             success:^(NSDictionary *returnData) {
                                                   BNLog(@"fees list--%@", returnData);
                                                   
                                                   NSString *retCode = [returnData valueNotNullForKey:@"rep_code"];
                                                   if ([retCode isEqualToString:@"0000"]) {
                                                       [SVProgressHUD dismiss];
                                                       NSString *responseString = [returnData valueForKey:@"user_fees_info"];
                                                       
                                                       NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
                                                       
                                                       NSError *error = nil;
                                                       
                                                       id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                                       
                                                       if ([jsonObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary *dictionary = (NSDictionary *)data;
                                                           
                                                       }else if ([jsonObject isKindOfClass:[NSArray class]]){
                                                           
                                                           NSArray *nsArray = (NSArray *)jsonObject;
                                                           if ([nsArray count] > 0) {
                                                               [weakSelf.datasource removeAllObjects];
                                                               [weakSelf.datasource addObjectsFromArray:nsArray];
                                                               [weakSelf.listTableView reloadData];
                                                               
                                                           }else{
                                                               [weakSelf.datasource removeAllObjects];
                                                               [weakSelf.listTableView reloadData];
                                                           }
                                                           
                                                           
                                                       } else {
                                                           BNLog(@"An error happened while deserializing the JSON data.");
                                                       }
                                                       
                                                   }else{
                                                       [weakSelf.datasource removeAllObjects];
                                                       [weakSelf.listTableView reloadData];
                                                       NSString *retMsg = [returnData valueNotNullForKey:@"rep_msg"];
                                                       [SVProgressHUD showErrorWithStatus:retMsg];
                                                   }
                                                   [weakSelf configShowLoadedViewWithIsNetworkError:NO];
                                               }
                                               failure:^(NSError *error) {
                                                   [weakSelf configShowLoadedViewWithIsNetworkError:YES];
                                                   [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                               }];
}
*/


#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
//    return 6;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"feesCell";
    
    BNFeesDetialsCell *cell = (BNFeesDetialsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BNFeesDetialsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setupCellWithFeesInfo:[_datasource objectAtIndex:indexPath.row]];
//    [cell setupCellWithFeesInfo:@{}];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *feeInfo = [_datasource objectAtIndex:indexPath.row];
    _tempFeesInfo = feeInfo;

    if ([[feeInfo valueNotNullForKey:@"type"] integerValue] == 1) {
        //多次缴费
        BNFeesDetialsFreeTimesVC *detials = [[BNFeesDetialsFreeTimesVC alloc] init];
        detials.detailDict = [NSDictionary dictionaryWithDictionary:feeInfo];
        [self pushViewController:detials animated:YES];
        return;
    } else if ([[feeInfo valueNotNullForKey:@"type"] integerValue] == 2) {
        //自主缴费-多档
        BNFeesDetialsFreeLevelsVC *detials = [[BNFeesDetialsFreeLevelsVC alloc] init];
        detials.detailDict = [NSDictionary dictionaryWithDictionary:feeInfo];
        [self pushViewController:detials animated:YES];
        return;
    }
    
    NSString *prjStatus = [NSString stringWithFormat:@"%@", [feeInfo valueNotNullForKey:@"prj_status"]];
    NSString *status = [NSString stringWithFormat:@"%@", [feeInfo valueNotNullForKey:@"status"]];
    
    switch ([prjStatus intValue]) {
        case 1:
            switch ([status intValue]) {
                case 0:
                    [self goToPayWithInfo:[NSDictionary dictionaryWithDictionary:feeInfo]];
                    break;
                case 4:
                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否重新缴费？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新缴费", nil];
                    shareAppDelegateInstance.alertView.tag = 999;
                    [shareAppDelegateInstance.alertView show];
                    break;
                case 1:
                case 2:
                case 3:
                    [self goFeesDetialVCWithInfo:feeInfo];
                    break;
                default:
                    break;
            }
            break;
        
        case 2:
        {
            switch ([status intValue]) {
                case 0:
                case 4:
                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"该收费项目已经被学校暂停。详情请联系%@相关人员",shareAppDelegateInstance.boenUserInfo.schoolName] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [shareAppDelegateInstance.alertView show];
                    break;
                case 1:
                case 2:
                case 3:
                    [self goFeesDetialVCWithInfo:feeInfo];
                    break;
                default:
                    break;
            }
          
        }
            break;
        case 3:
            [self goFeesDetialVCWithInfo:feeInfo];
            break;

        case 4:
            switch ([status intValue]) {
                case 0:
                case 4:
                    shareAppDelegateInstance.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该收费项目已经过期。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [shareAppDelegateInstance.alertView show];
                    break;
                case 1:
                case 2:
                case 3:
                    [self goFeesDetialVCWithInfo:feeInfo];
                    break;
                default:
                    break;
            }
        default:
            break;
    }

}


- (void)goFeesDetialVCWithInfo:(NSDictionary *)info
{
    BNFeesDetialsNormalVC *detials = [[BNFeesDetialsNormalVC alloc] init];
    detials.detailDict = [NSDictionary dictionaryWithDictionary:info];
    [self pushViewController:detials animated:YES];
}


#pragma mark - pay
- (void)goToPayWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    NSString *amount = [NSString stringWithFormat:@"%@",[info valueNotNullForKey:@"amount"]];
    NSString *prj_key = [info valueNotNullForKey:@"prj_key"];
    [NewSchoolFeesApi create_OrderWithPrj_key:prj_key
                                       amount:amount
                                prj_child_key:@""
                                     level_id:@""
                                      success:^(NSURLSessionDataTask *task,NSDictionary *successData) {
                                          BNLog(@"创建学校费用订单--->>>>%@",successData);
                                          if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:kRequestNewSuccessCode]) {
                                              NSDictionary *dataDic = [successData valueForKey:kRequestReturnData];
                                              
                                              BNPayModel *payModel = [[BNPayModel alloc]init];
                                              payModel.order_no = [dataDic valueNotNullForKey:@"order_no"];
                                              payModel.biz_no = [dataDic valueNotNullForKey:@"biz_no"];
                                              
                                              [weakSelf goToPayCenterWithPayProjectType:PayProjectTypeSchoolPay
                                                                               payModel:payModel
                                                                            returnBlockone:^(PayVCJumpType jumpType, id params) {
                                                                                if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                }
                                                                            }];
                                              
                                          }else{
                                              if ([[successData valueNotNullForKey:kRequestRetCode] isEqualToString:@"000001"]) {
                                                  [SVProgressHUD showErrorWithStatus:@"当前界面停留太久,正在重新获取缴费列表"];
                                                  [self getCodeFromPythonServer];
                                              }else{
                                                  NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                  [SVProgressHUD showErrorWithStatus:retMsg];
                                              }
                                          }
                                      }
                                      failure:^(NSURLSessionDataTask *task,NSError *error) {
                                          [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                      }];
    
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999 && buttonIndex == 1) {
        //确定重新缴费吗？
        [self goToPayWithInfo:[NSDictionary dictionaryWithDictionary:_tempFeesInfo]];

    }
}

- (void)feesExplainAction:(UIButton *)btn
{
    BNFeesWebViewExplainVC *webVC = [[BNFeesWebViewExplainVC alloc] init];
    webVC.useType = ExpainUseTypeSchoolFees;
    [self pushViewController:webVC animated:YES];
}

- (void)backButtonClicked:(UIButton *)sender;
{
    if (self.navigationController.viewControllers.count > 1) {
        //防止多次连续点击崩溃
        [self.navigationController popViewControllerAnimated:YES];
        [shareAppDelegateInstance refreshPersonProfile];
    }
}

@end
