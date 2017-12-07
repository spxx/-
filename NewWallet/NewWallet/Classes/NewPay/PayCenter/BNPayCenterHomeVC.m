//
//  BNPayCenterHomeVC.m
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNPayCenterHomeVC.h"
#import "Password.h"
#import "CardApi.h"
#import "DenoteApi.h"
#import "MobileRechargeApi.h"
#import "BNMobileRechargeResaultVC.h"
#import "BNMobileRechargeRasultInfo.h"
#import "RechargePhoneNumer.h"
#import "SchoolFeesClient.h"
#import "XiaoDaiApi.h"
#import "BNReturnAndBorrowMoneyResultVC.h"
#import "BNElectricChargeResultInfo.h"
#import "BNPasswordView.h"
#import "BNNewPayWaysCell.h"
#import "BNPayResultVC.h"
#import "BNPublicHtml5BusinessVC.h"
#import "BNPayResultShareH5VC.h"
#import "BNCouponModel.h"
#import <sys/utsname.h>
#import "WXApi.h"
//#import "UPPaymentControl.h"
#import "UnionPayHttpTools.h"
#import "BNCCBISWebViewController.h"

#import "TYEncrypt.h"

#define KEYSTR @"F5139DD561F02519793765234601BE29954CC34A891C1160" //商户key文档14页
#define MERID @"02510202068256000"
#define PSWD @"139560"


@interface BNPayCenterHomeVC ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, YJPayDelegate>
{
    BOOL havePayType;
    BOOL haveCoupon;
}
@property (nonatomic) UIView *grayBGViewView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UILabel *payWayLbl;
@property (nonatomic) UILabel *payMoneyLbl;
@property (nonatomic) UILabel *couponNameLbl;
@property (nonatomic) UIButton *okButton;
//@property (nonatomic) UILabel *noPswTips;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *payWaysAry;
@property (nonatomic) NSDictionary *selectDict;
@property (nonatomic) NSString *xiFuSelectCardNoStr;
@property (nonatomic) NSString *couponNumber;
@property (nonatomic) BNCouponModel *couponModel;
@property (nonatomic) UIButton *couponBtn;

//@property (nonatomic) NSString *bank_card_no;
//@property (nonatomic) NSString *bank_code;
//@property (nonatomic) BOOL open_noPassword;
//@property (nonatomic) BOOL isFromPayWayVC;   //标记是否从本界面返回
//@property (nonatomic) BNMobileRechargeRasultInfo *resultInfo;
//@property (nonatomic) UILabel *bankUnAvailableLbl;
//@property (nonatomic) BOOL bankUnAvailable;  //yes=银行维护中，

//@property (nonatomic) BNElectricChargeResultInfo *electricResultInfo;

//翼支付
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy)   NSString *encodeOrderStr;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLConnection *connection;


@end
@implementation BNPayCenterHomeVC
static CGFloat beginX;
static CGFloat cellHeight;
static CGFloat scrollViewHeight;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addResponseKeyboardAction];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //友盟统计
     [MobClick event:@"PayCenter_page" label:@"收银台页面"];

    [self.view setBackgroundColor:[UIColor clearColor]];

    self.selectDict = [[NSDictionary alloc]init];

    self.showNavigationBar = NO;
    self.xiFuSelectCardNoStr = @"";
    self.couponModel = [[BNCouponModel alloc]init];
    self.payWaysAry = [@[] mutableCopy];
    
    scrollViewHeight = 394*BILI_WIDTH;

    self.grayBGViewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _grayBGViewView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_grayBGViewView];
    



    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, scrollViewHeight)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.frame.size.height);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    UIView *navWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*BILI_WIDTH)];
    navWhiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:navWhiteView];
    
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(55*BILI_WIDTH, 0, SCREEN_WIDTH-2*55*BILI_WIDTH, 44*BILI_WIDTH)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor blackColor];
    [navWhiteView addSubview:titleLbl];
    titleLbl.font = [UIFont systemFontOfSize:17*BILI_WIDTH];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"订单付款";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 55*BILI_WIDTH, 44*BILI_WIDTH);
    backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [backButton addTarget:self action:@selector(disAppearAnimation) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"PayCenter_CancelBtn"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
    [navWhiteView addSubview:backButton];
    
    CGFloat beginY = 44*BILI_WIDTH;
    beginX = 15*BILI_WIDTH;
    cellHeight = 40*BILI_WIDTH;
    
    UIView *lineView0 = [[UIView alloc]initWithFrame: CGRectMake(0, CGRectGetHeight(navWhiteView.frame)-0.5, SCREEN_WIDTH, 0.5)];
    lineView0.backgroundColor = UIColor_GrayLine;
    [navWhiteView addSubview:lineView0];
    
    beginY += (cellHeight-14*BILI_WIDTH)/2;
    
    UILabel *leftLbl0 = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, 14*BILI_WIDTH)];
    leftLbl0.backgroundColor = [UIColor clearColor];
    leftLbl0.textColor = UIColorFromRGB(0x90a4ae);
    leftLbl0.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:leftLbl0];
    leftLbl0.text = @"商品名";
    
    UILabel *goodsNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(74*BILI_WIDTH, beginY, SCREEN_WIDTH-(74+15)*BILI_WIDTH, cellHeight)];
    goodsNumberLbl.backgroundColor = [UIColor clearColor];
    goodsNumberLbl.textColor = [UIColor blackColor];
    goodsNumberLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:goodsNumberLbl];
    goodsNumberLbl.numberOfLines = 0;
    NSString *goodsName = [NSString stringWithFormat:@"%@",_payModel.goodsName];
    goodsNumberLbl.text = goodsName;
    CGFloat lblHeight = [Tools caleNewsCellHeightWithTitle:goodsName font:goodsNumberLbl.font width:goodsNumberLbl.frame.size.width];
    goodsNumberLbl.size = CGSizeMake(goodsNumberLbl.size.width, lblHeight);
    
    beginY += lblHeight + (cellHeight-14*BILI_WIDTH)/2;

    UIView *lineView1 = [[UIView alloc]initWithFrame: CGRectMake(beginX, beginY-0.5, SCREEN_WIDTH-2*beginX, 0.5)];
    lineView1.backgroundColor = UIColor_GrayLine;
    [_scrollView addSubview:lineView1];
    
    UILabel *leftLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    leftLbl1.backgroundColor = [UIColor clearColor];
    leftLbl1.textColor = UIColorFromRGB(0x90a4ae);
    leftLbl1.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:leftLbl1];
    leftLbl1.text = @"收款方";
    
    UILabel *sellerNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(74*BILI_WIDTH, beginY, SCREEN_WIDTH-74*BILI_WIDTH, cellHeight)];
    sellerNameLbl.backgroundColor = [UIColor clearColor];
    sellerNameLbl.textColor = [UIColor blackColor];
    sellerNameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:sellerNameLbl];
    sellerNameLbl.text = [NSString stringWithFormat:@"%@",_payModel.sellerName];

    beginY += sellerNameLbl.frame.size.height;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame: CGRectMake(beginX, beginY-0.5, SCREEN_WIDTH-2*beginX, 0.5)];
    lineView2.backgroundColor = UIColor_GrayLine;
    [_scrollView addSubview:lineView2];

    UILabel *leftLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    leftLbl2.backgroundColor = [UIColor clearColor];
    leftLbl2.textColor = UIColorFromRGB(0x90a4ae);
    leftLbl2.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:leftLbl2];
    leftLbl2.text = @"优惠券";
    
    NSString *payType = [NSString stringWithFormat:@"%@", _payModel.pay_type];
    havePayType = (payType && payType.length > 0 && [payType integerValue] > 0);
    haveCoupon = (_payModel.discount_amount && [_payModel.discount_amount floatValue] > 0);
                        
    self.couponNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(74*BILI_WIDTH, beginY, SCREEN_WIDTH-(74+20)*BILI_WIDTH, cellHeight)];
    _couponNameLbl.backgroundColor = [UIColor clearColor];
    _couponNameLbl.textColor = [UIColor blackColor];
    _couponNameLbl.numberOfLines = 2;
    _couponNameLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:_couponNameLbl];
    _couponNumber = @"0";

    self.couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _couponBtn.frame = CGRectMake(0, beginY, SCREEN_WIDTH, cellHeight);
    [_couponBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    [_couponBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];

    [_couponBtn setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH-30*BILI_WIDTH, 0, 0)];
    [_scrollView addSubview:_couponBtn];
    [_couponBtn addTarget:self action:@selector(couponBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    beginY += _couponNameLbl.frame.size.height;

    UIView *lineView3 = [[UIView alloc]initWithFrame: CGRectMake(beginX, beginY-0.5, SCREEN_WIDTH-2*beginX, 0.5)];
    lineView3.backgroundColor = UIColor_GrayLine;
    [_scrollView addSubview:lineView3];
    
    UILabel *payWayLbl = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    payWayLbl.backgroundColor = [UIColor clearColor];
    payWayLbl.textColor = UIColorFromRGB(0x90a4ae);
    payWayLbl.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
    [_scrollView addSubview:payWayLbl];
    payWayLbl.text = @"付款方式";
    
    beginY += payWayLbl.frame.size.height;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, beginY, SCREEN_WIDTH, cellHeight*3) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = cellHeight;
    [_tableView registerClass:[BNNewPayWaysCell class] forCellReuseIdentifier:@"BNNewPayWaysCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [_scrollView addSubview:_tableView];
    
    beginY += _tableView.frame.size.height;
    
    UILabel *payMoneyLeftLbl = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, 100*BILI_WIDTH, cellHeight)];
    payMoneyLeftLbl.backgroundColor = [UIColor clearColor];
    payMoneyLeftLbl.textColor = UIColorFromRGB(0x90a4ae);
    payMoneyLeftLbl.font = [UIFont systemFontOfSize:14*BILI_WIDTH];
    [_scrollView addSubview:payMoneyLeftLbl];
    payMoneyLeftLbl.text = @"支付金额";
    
    self.payMoneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(80*BILI_WIDTH, beginY, SCREEN_WIDTH-(80+15)*BILI_WIDTH, cellHeight)];
    _payMoneyLbl.font = [UIFont boldSystemFontOfSize:14*BILI_WIDTH];
    _payMoneyLbl.textColor = UIColorFromRGB(0xff5252);
    _payMoneyLbl.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_payMoneyLbl];
    
    beginY += payMoneyLeftLbl.frame.size.height;
    
    
//    self.noPswTips = [[UILabel alloc]initWithFrame:CGRectMake(beginX, beginY, SCREEN_WIDTH-2*beginX, 12*BILI_WIDTH)];
//    _noPswTips.backgroundColor = [UIColor clearColor];
//    _noPswTips.textAlignment = NSTextAlignmentCenter;
//    _noPswTips.textColor = [UIColor blackColor];
//    _noPswTips.font = [UIFont systemFontOfSize:12*BILI_WIDTH];
//    [_scrollView addSubview:_noPswTips];
//    _noPswTips.text = @"您已开启小额免密,本次支付无需输入支付密码";
//    beginY += _noPswTips.frame.size.height+10*BILI_WIDTH;
//    _noPswTips.hidden = YES;
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.tag = 102;
    [_okButton setupTitle:@"确 定" enable:NO];
    _okButton.frame = CGRectMake(15*BILI_WIDTH, beginY, SCREEN_WIDTH-2*15*BILI_WIDTH, 42*BILI_WIDTH);
//    _okButton.layer.cornerRadius = 2;
//    _okButton.layer.masksToBounds = YES;
//    UIImage *image1 = [Tools imageWithColor:UIColor_Button_Normal andSize:CGSizeMake(SCREEN_WIDTH-2*10*BILI_WIDTH, 42)];
//    UIImage *image2 = [Tools imageWithColor:UIColor_Button_Disable andSize:CGSizeMake(SCREEN_WIDTH-2*10*BILI_WIDTH, 42)];
//    UIImage *image3 = [Tools imageWithColor:UIColor_Button_HighLight andSize:CGSizeMake(SCREEN_WIDTH-2*10*BILI_WIDTH, 42)];
//    [_okButton setBackgroundImage:image1 forState:UIControlStateNormal];
//    [_okButton setBackgroundImage:image2 forState:UIControlStateDisabled];
//    [_okButton setBackgroundImage:image3 forState:UIControlStateHighlighted];
//    [_okButton setTitle:@"确 定" forState:UIControlStateNormal];
//    [_okButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    _okButton.titleLabel.font = [UIFont systemFontOfSize:15*BILI_WIDTH];
    [_okButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_okButton];
    [self refreshOKBtn];
    
    beginY += _okButton.frame.size.height+20*BILI_WIDTH;
    
    scrollViewHeight = beginY;
    _scrollView.size = CGSizeMake(SCREEN_WIDTH, scrollViewHeight);
    
    [self appearAnimation];
    
    if (_payModel.fromHistoryBillCouponDisable){
        //从订单详情过来
        if (havePayType && !haveCoupon) {
            //有支付方式，且未选优惠券---不能再选优惠券
            _couponBtn.enabled = NO;
            _couponNameLbl.textColor = [UIColor blackColor];
            _couponNameLbl.text = @"未选用优惠券";

            _payMoneyLbl.text = [NSString stringWithFormat:@"￥%@", _payModel.salePrice];
        } else if (havePayType && haveCoupon) {
            //有支付方式，且有选优惠券---不能再选优惠券
            _couponBtn.enabled = NO;
            _couponNameLbl.textColor = UIColorFromRGB(0xff5252);
            _couponNameLbl.text = [NSString stringWithFormat:@"已减免￥%@", _payModel.discount_amount];

//            _payMoneyLbl.text = [NSString stringWithFormat:@"%@元(已减免%@元)", _payModel.salePrice, _payModel.discount_amount];
            _payMoneyLbl.text = [NSString stringWithFormat:@"￥%@", _payModel.salePrice];

        } else {
            //无支付方式，可以选优惠券。（因为只创建了业务订单，还未创建支付订单）无支付方式，则肯定未选优惠券。
            _couponBtn.enabled = YES;
            _couponNameLbl.textColor = [UIColor blackColor];
            _couponNameLbl.text = @"未选用优惠券";

            _payMoneyLbl.text = [NSString stringWithFormat:@"￥%@", _payModel.salePrice];
            
            [self getAvailableCoupons];  //获取优惠券列表
        }
    } else {
        //新建订单直接支付
        _couponBtn.enabled = YES;
        _couponNameLbl.textColor = [UIColor blackColor];
        _couponNameLbl.text = @"未选用优惠券";
        _payMoneyLbl.text = [NSString stringWithFormat:@"￥%@", _payModel.salePrice];

        [self getAvailableCoupons];  //获取优惠券列表

    }
    
    [self performSelector:@selector(getPayWaysList) withObject:nil afterDelay:0.2];  //获取支付方式列表

}
- (void)appearAnimation
{
    _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    [_grayBGViewView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    [UIView animateWithDuration:0.4 animations:^{
        [_grayBGViewView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        _scrollView.transform = CGAffineTransformMakeTranslation(0, -scrollViewHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)disAppearAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        [_grayBGViewView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self cancelButtonClicked];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.payWaysAry count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame: CGRectMake(beginX, 0, SCREEN_WIDTH-2*beginX, 0.5)];
    footView.backgroundColor = UIColor_GrayLine;
    //    [footView addSubview:lineView2];
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BNNewPayWaysCell";
    BNNewPayWaysCell *bankCardCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    [bankCardCell drawDataWithInfo:_payWaysAry[indexPath.row] selectedDict:_selectDict payWayStatus:_payModel.pay_type_list];
    
    return bankCardCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _selectDict = _payWaysAry[indexPath.row];
    NSInteger payID = [[_selectDict valueWithNoDataForKey:@"id"] integerValue];
    switch (payID) {
        case 6: {//易极付支付
            //喜付支付
            NSInteger unionSystemStatus = [[_payModel.pay_type_list valueNotNullForKey:@"xfp_status"] integerValue];
            if (_payModel.pay_type_list && [[_payModel.pay_type_list allKeys] containsObject:@"xfp_status"] && unionSystemStatus == 0) {
                return;
            }
            break;
        }
        case 7: {//银联支付
            //中国银联支付
            NSInteger unionSystemStatus = [[_payModel.pay_type_list valueNotNullForKey:@"xfunion_status"] integerValue];
            if (_payModel.pay_type_list && [[_payModel.pay_type_list allKeys] containsObject:@"xfunion_status"] && unionSystemStatus == 0) {
                return;
            }
            break;
        }
        case 15: {
            //微信支付
            NSInteger weixinSystemStatus = [[_payModel.pay_type_list valueNotNullForKey:@"wxsdk_status"] integerValue];
            if (_payModel.pay_type_list && [[_payModel.pay_type_list allKeys] containsObject:@"wxsdk_status"] && weixinSystemStatus == 0) {
                return;
            }
            break;
        }
        case 12: {
            //一卡通支付
            NSInteger unionSystemStatus = [[_payModel.pay_type_list valueNotNullForKey:@"xfykt_status"] integerValue];
            if (_payModel.pay_type_list && [[_payModel.pay_type_list allKeys] containsObject:@"xfykt_status"] && unionSystemStatus == 0) {
                return;
            }
            break;
        }
    }
    [tableView reloadData];
    [self refreshOKBtn];
    
}

- (void)refreshOKBtn
{
    if (_selectDict.allKeys.count > 0) {
        _okButton.enabled = YES;
    } else {
        _okButton.enabled = NO;
    }
}
/**
 *  支付方式按钮、确认支付按钮点击事件
 */
- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 101: {
            //付款方式按钮
            [self creatPayTrade];

            break;
        }
            
        case 102: {
            //确定付款按钮
            [self creatPayTrade];
            
            break;
        }

    }
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)networkErrorStoped
{
    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsgWhenPay];
}
- (void)cancelButtonClicked
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)getAvailableCoupons
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi newpay_GetAvailableCouponsWithCount_only:@"0"
                                                    biz_type:_payModel.biz_type
                                                          pay_amount:_payModel.salePrice
                                                     success:^(NSDictionary *successData) {
                                                         BNLog(@"获取可用优惠券数量--%@", successData);
                                                         NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
                                                         
                                                         if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                             [SVProgressHUD dismiss];

                                                             NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                                                             _couponNumber = [NSString stringWithFormat:@"%@",[dataDict valueNotNullForKey:@"total_count"]];
//                                                             _couponNameLbl.text = [NSString stringWithFormat:@"%@张优惠券", _couponNumber];
                                                             _couponNameLbl.text = @"暂无优惠券";

                                                             NSArray *dataAry = [dataDict valueForKey:@"coupon_info"];
                                                             if ([dataAry isKindOfClass:[NSArray class]] && dataAry.count > 0){
                                                                 if (_payModel.fromHistoryBillCouponDisable){
                                                                     //从订单详情过来
                                                                     if (havePayType && !haveCoupon) {
                                                                         //有支付方式，且未选优惠券---不能再选优惠券
                                                                         return ;
                                                                     } else if (havePayType && haveCoupon) {
                                                                         //有支付方式，且有选优惠券---不能再选优惠券
                                                                         return ;
                                                                     } else {
                                                                         //无支付方式，可以选优惠券。（因为只创建了业务订单，还未创建支付订单）无支付方式，则肯定未选优惠券。
                                                                         //自动选择可用的优惠券
                                                                         NSDictionary *firstCouponDict = dataAry[0];
                                                                         [self refreshDisplayCouponData:firstCouponDict];
                                                                     }
                                                                 } else {
                                                                     //自动选择可用的优惠券
                                                                     NSDictionary *firstCouponDict = dataAry[0];
                                                                     [self refreshDisplayCouponData:firstCouponDict];
                                                                 }
                                                             }
                                                             
                                                         }else{
                                                             NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                             [SVProgressHUD showErrorWithStatus:retMsg];
                                                         }
                                                     } failure:^(NSError *error) {
                                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                     }];

}

// 生产
#define releaseURL @"https://webpaywg.bestpay.com.cn/order.action"
// 准生产
#define debugURL @"http://wapchargewg.bestpay.com.cn/order.action"

- (void)creatPayTrade
{
    //友盟事件点击
    [MobClick event:@"PayCenter" label:@"收银台_确定支付按钮"];
    
    NSString *payType = [NSString stringWithFormat:@"%@", [_selectDict valueWithNoDataForKey:@"id"]];
    //易极付支付6  银联支付7  微信支付15  一卡通支付12
          
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi newPay_StartPayTerraceWithOrder_no:_payModel.order_no
                                                   pay_type:payType
                                                   coupon_no:_couponModel.coupon_no
                                                    success:^(NSDictionary *successData) {
                                                      BNLog(@"获取启动支付平台-支付数据 --%@", successData);
                                                      NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
                                                      
                                                      if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                          NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                                                          _payModel.trade_no = [NSString stringWithFormat:@"%@",[dataDict valueNotNullForKey:@"trade_no"]];

                                                          _payModel.sellerName = [dataDict valueNotNullForKey:@"seller_name"];
                                                          _payModel.goodsName= [dataDict valueNotNullForKey:@"goods_name"];
                                                          _payModel.pay_type = payType;
                                                          [SVProgressHUD dismiss];
                                                          
                                                          if ([payType integerValue]==16) {
                                                              NSString *HtUrl = [dataDict valueNotNullForKey:@"full_get_url"];
                                                              BNCCBISWebViewController *ccbisVC = [[BNCCBISWebViewController alloc] init];
                                                              ccbisVC.navigationController.navigationBar.hidden = NO;
                                                              ccbisVC.htmlUrl = HtUrl;
                                                              ccbisVC.backBtnBlock = ^(PayVCJumpType jumpType){
                                                                  NSString *code = @"";
                                                                  if (jumpType == PayVCJumpType_PayCompletedBackHomeVC) {
                                                                      code = @"success";
                                                                      [self dismissViewControllerAnimated:NO completion:^{
                                                                          self.returnBlock(jumpType, nil);
                                                                      }];
                                                                  }else{
                                                                      code = @"cancel";
                                                                  }
                                                                  [NewYJFPayApi unloadYJFPayStatusWithOrder_no:_payModel.order_no
                                                                                                      pay_type:_payModel.pay_type
                                                                                                sdk_pay_status:[NSString stringWithFormat:@"%@", code]
                                                                                                       success:^(NSDictionary *successData) {
                                                                                                           BNLog(@"unloadYJFPayStatusWithOrder_no -- %@", successData);
                                                                                                       } failure:^(NSError *error) {
                                                                                                       }];
                                                              };
                                                              [self.navigationController pushViewController:ccbisVC animated:YES];
                                                              
                                                          }else if ([payType integerValue]==17){
                                                              
                                                              _params = [[NSMutableDictionary alloc] init];
                                                              
                                                              [_params setObject:[dataDict valueNotNullForKey:@"pay_no"]            forKey:@"ORDERSEQ"];
                                                              [_params setObject:[dataDict valueNotNullForKey:@"request_no"]        forKey:@"ORDERREQTRNSEQ"];
                                                              [_params setObject:[dataDict valueNotNullForKey:@"ORDERREQTIME"]      forKey:@"ORDERREQTIME"];
                                                              [_params setObject:[dataDict valueNotNullForKey:@"notify_url"]        forKey:@"BACKMERCHANTURL"];
                                                              [self doOrder];

                                                          }
                                                          else{
                                                              [self goToPay:[payType integerValue]];
                                                          }
                                                      }else{
                                                          NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                          [SVProgressHUD showErrorWithStatus:retMsg];
                                                      }
                                                    } failure:^(NSError *error) {
                                                        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                    }];
}

- (void)doOrder{
    
    //获取订单信息
    NSString *orderStr = [self orderInfos];
    
    /////////////////////////////////
    BNLog(@"跳转支付页面带入信息：%@", orderStr);
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = orderStr;
    order.launchType = launchTypePay1;
    order.scheme = [[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] firstObject];
    
    [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
        BNLog(@"result == %@", resultDic);
        NSString *code = @"";
        if ([resultDic[@"resultCode"] isEqualToString:@"00"]) {
            code = @"success";
            [self dismissViewControllerAnimated:NO completion:^{
                self.returnBlock(PayVCJumpType_PayCompletedBackHomeVC, nil);
            }];

        }else if ([resultDic[@"resultCode"] isEqualToString:@"02"]){
            code = @"cancel";
            [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
        }
        [NewYJFPayApi unloadYJFPayStatusWithOrder_no:_payModel.order_no
                                            pay_type:_payModel.pay_type
                                      sdk_pay_status:[NSString stringWithFormat:@"%@",code]
                                             success:^(NSDictionary *successData) {
                                                 BNLog(@"unloadYJFPayStatusWithOrder_no -- %@", successData);
                                             } failure:^(NSError *error) {
                                             }];
        
    }];
    
}
- (NSString *)orderInfos{
    
    NSMutableString * orderDes = [NSMutableString string];
    
    // 签名参数
    //1. 接口名称
    NSString *service = @"mobile.securitypay.pay";
    [orderDes appendFormat:@"SERVICE=%@", service];
    //2. 商户号
    [orderDes appendFormat:@"&MERCHANTID=%@", MERID];
    //3. 商户密码 由翼支付网关平台统一分配给各接入商户
    [orderDes appendFormat:@"&MERCHANTPWD=%@", PSWD];
    //4. 子商户号
    [orderDes appendFormat:@"&SUBMERCHANTID=%@", @""];
    //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
    [orderDes appendFormat:@"&BACKMERCHANTURL=%@", [_params[@"BACKMERCHANTURL"] length]>5?_params[@"BACKMERCHANTURL"]:@"http://api.bionictech.cn/yi_pay/external/v1/pay_notify"];
    //    [orderDes appendFormat:@"&NOTIFYURL=%@", @"http://127.0.0.1:8040/wapBgNotice.action"];
    //6. 订单号
    [orderDes appendFormat:@"&ORDERSEQ=%@", [_params objectForKey:@"ORDERSEQ"]];
    //7. 订单请求流水号，唯一
    [orderDes appendFormat:@"&ORDERREQTRANSEQ=%@", [_params objectForKey:@"ORDERREQTRNSEQ"]];
    //8. 订单请求时间 格式：yyyyMMddHHmmss
    [orderDes appendFormat:@"&ORDERTIME=%@", [_params objectForKey:@"ORDERREQTIME"]];
    //9. 订单有效截至日期
    [orderDes appendFormat:@"&ORDERVALIDITYTIME=%@", @""];
    //10. 币种, 默认RMB
    [orderDes appendFormat:@"&CURTYPE=%@", @"RMB"];
    //11. 订单金额/积分扣减
    [orderDes appendFormat:@"&ORDERAMOUNT=%@", _payModel.salePrice];
    //12.商品简称
    [orderDes appendFormat:@"&SUBJECT=%@", _payModel.goodsName];
    //13. 业务标识 optional
    [orderDes appendFormat:@"&PRODUCTID=%@", @"04"];
    //14. 产品描述 optional
    [orderDes appendFormat:@"&PRODUCTDESC=%@", _payModel.goodsNumber];
    //15. 客户标识 在商户系统的登录名 optional
    [orderDes appendFormat:@"&CUSTOMERID=%@", @"15982383959"];
    //16.切换账号标识
    [orderDes appendFormat:@"&SWTICHACC=%@", @""];
    NSString *SignStr =[NSString stringWithFormat:@"%@&KEY=%@",orderDes,KEYSTR];
    //17. 签名信息 采用MD5加密
    NSString *signStr = [TYEncrypt MD5:SignStr];
    [orderDes appendFormat:@"&SIGN=%@", signStr];
    
    
    //18. 产品金额
    [orderDes appendFormat:@"&PRODUCTAMOUNT=%@", _payModel.salePrice];
    //19. 附加金额 单位元，小数点后2位
    [orderDes appendFormat:@"&ATTACHAMOUNT=%@",@"0.00"];
    //20. 附加信息 optional
    [orderDes appendFormat:@"&ATTACH=%@", @"88888"];
    //21. 分账描述 optional
    //    [orderDes appendFormat:@"&DIVDETAILS=%@", @""];
    //22. 翼支付账户号
    [orderDes appendFormat:@"&ACCOUNTID=%@", @""];
    
    //23. 用户IP 主要作为风控参数 optional
    [orderDes appendFormat:@"&USERIP=%@", @"228.112.116.118"];
    //24. 业务类型标识
    [orderDes appendFormat:@"&BUSITYPE=%@", @"04"];
    
    //25.授权令牌
    [orderDes appendFormat:@"&EXTERNTOKEN=%@", @"NO"];
 
    //27. 签名方式
    [orderDes appendFormat:@"&SIGNTYPE=%@", @"MD5"];
    
    return orderDes;
}

- (void)getPayWaysList
{
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewPayOrderCenterApi newpay_GetPayWaysListWithSchoolID:shareAppDelegateInstance.boenUserInfo.schoolId success:^(NSDictionary *successData) {
                                                         BNLog(@"获取支付方式列表 --%@", successData);
                                                         NSString *retCode = [NSString stringWithFormat:@"%@",[successData valueNotNullForKey:kRequestRetCode]];
                                                         
                                                         if ([retCode isEqualToString:kRequestNewSuccessCode]) {
                                                             [SVProgressHUD dismiss];

                                                             NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
                                                             NSArray *payWayList = [dataDict valueForKey:@"pay_way"];
                                                             self.payWaysAry = [payWayList mutableCopy];
                                                             
                                                             [self.tableView reloadData];
                                                         }else{
                                                             NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
                                                             [SVProgressHUD showErrorWithStatus:retMsg];
                                                         }
                                                     } failure:^(NSError *error) {
                                                         [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
                                                     }];

}
#pragma - YJPay
- (void)goToPay:(NSInteger)payType
{
    
    
    
    NSString * payTypeStr = @"";
    NSString *paySchemeStr = @"";
    
    switch (payType) {
        case 6: {
            //喜付支付
            payTypeStr = [NSString stringWithFormat:@"%ld", (long)YJPayWayYiji];
            paySchemeStr = @"";
            break;
        }
        case 7: {
            //银联支付
            payTypeStr = [NSString stringWithFormat:@"%ld", (long)YJPayWayUPMP];
            paySchemeStr = @"com.xifu.Wallet";
            break;
        }
        case 12: {
            //一卡通支付
            
            
            return ;
        }
        case 15: {
            //微信支付
            payTypeStr = [NSString stringWithFormat:@"%ld", (long)YJPayWayWechat];
            paySchemeStr = @"wxf280e6eda3f76c92";
            break;
        }
            
        default:
            break;
    }
    [SVProgressHUD showWithStatus:@"请稍候..."];
    [NewYJFPayApi getYJFBindidWithSuccess:^(NSDictionary *successData) {
        BNLog(@"getYJFBindidWithSuccess -- %@", successData);
        NSString *retCode = [successData valueNotNullForKey:kRequestRetCode];
        NSString *retMsg = [successData valueNotNullForKey:kRequestRetMessage];
        if ([retCode isEqualToString:kRequestSuccessCode]) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = [successData valueNotNullForKey:kRequestReturnData];
            NSString *realName = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"real_name"]];
            NSString *yjf_bind_id = [NSString stringWithFormat:@"%@", [dataDict valueWithNoDataForKey:@"yjf_bind_id"]];
            
            NSString *userid = yjf_bind_id;
            NSDictionary *init = @{kYJPayServer:YJPayServerType, kYJPayPartnerId:YJPayPartnerid, kYJPaySecurityKey: YJPaySecKey};
            [YJPayService initEnvironment:init error:nil];
            NSMutableDictionary *info;
            if (realName && realName.length > 0) {
                YJExtraParams *extraParams = [[YJExtraParams alloc] init];
                YJExtraObject *realNmae = [YJExtraObject extObjWith:realName stable:YES];//(YES:不可修改[默认], NO:可修改)
                extraParams.realName = realNmae;
                
                info = [@{kYJPayUserId: userid,
                         kYJPayUserType: MEMBER_TYPE_YIJI,
                         kYJPayTradeNo: _payModel.trade_no,
                         kYJPayWay: payTypeStr,
                         kYJPayWXAppId:paySchemeStr,
                         kYJPayExtraParams:extraParams,//额外参数，非必传
                         } mutableCopy];
            } else {
                info = [@{kYJPayUserId: userid,
                         kYJPayUserType: MEMBER_TYPE_YIJI,
                         kYJPayTradeNo: _payModel.trade_no,
                         kYJPayWay: payTypeStr,
                         kYJPayWXAppId:paySchemeStr,
                         } mutableCopy];
            }
            [info setObject:@(YES) forKey:kYJPayCancelResult];

            [YJPayService startPayment:info delegate:self error:nil];
            
        } else {
            [SVProgressHUD showErrorWithStatus:retMsg];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    }];
    
}
#pragma - YJPayDelegate
- (void)payEngineDidBegin
{
}
- (void)payEngineDidFinish:(NSString *)type code:(id)codes extInfo:(NSDictionary *)info
{
    NSString *statusStr = @"SUCCESS";
    NSString *msg = @"处理中...";
    NSString *code = [NSString stringWithFormat:@"%@", codes];
    msg = [NSString stringWithFormat:@"%@",[info valueWithNoDataForKey:@"msg"]];
    BNLog(@"%@", msg);

    if ([type integerValue] == -1) {
        return;
    }
    if ([type integerValue] == YJPayWayYiji) {
        //喜付支付
//        if ([code integerValue] == -1) {
//            return;
//        }
        if ([code integerValue] == YJPayErrorCodeSuccess || [code integerValue] == YJPayErrorCodeProcessing) {
            statusStr = @"SUCCESS";
//            msg = @"支付成功";
        } else if ([code integerValue] == YJPayErrorCodeCancel) {
            statusStr = @"CANCEL";
//            msg = @"支付取消";
        } else {
            statusStr = @"FAIL";
//            msg = @"支付失败";
        }
    } else if ([type integerValue] == YJPayWayUPMP) {
        //银联支付
        if ([code isEqualToString:@"Success"] || [code isEqualToString:@"success"]) {
            statusStr = @"SUCCESS";
//            msg = @"支付成功";
        } else if ([code isEqualToString:@"Cancel"] || [code isEqualToString:@"cancel"]) {
            statusStr = @"CANCEL";
            if (!msg || msg.length <= 0 || [msg isEqualToString:@"(null)"]) {
                msg = @"用户取消支付";
            }
        } else {
            statusStr = @"FAIL";
//            msg = @"支付失败";
        }

    }
    else if ([type integerValue] == YJPayWayWechat) {
        //微信支付
        if ([code longLongValue] == WXSuccess) {
            statusStr = @"SUCCESS";
            //            msg = @"支付成功";
        } else if ([code longLongValue] == WXErrCodeUserCancel){
            statusStr = @"CANCEL";
//            if (!msg || msg.length <= 0 || [msg isEqualToString:@"(null)"]) {
                msg = @"用户取消支付";
//            }
        }else {
        }
    }
    else if ([type integerValue] == YJPayWaySuper) {
        //聚合支付
    }

    //向喜付后台上传支付返回码
    [NewYJFPayApi unloadYJFPayStatusWithOrder_no:_payModel.order_no
                                        pay_type:_payModel.pay_type
                                  sdk_pay_status:[NSString stringWithFormat:@"%@", code]
                                         success:^(NSDictionary *successData) {
                                             BNLog(@"unloadYJFPayStatusWithOrder_no -- %@", successData);
                                         } failure:^(NSError *error) {
                                         }];
    
    

    NSDictionary *dict = @{@"memo" : msg,
                           @"pay_status" : statusStr,
                           };//这个字典，创建得和我们的pay_trade接口返回的data字段里面结构一样，以便进入支付结果页面好显示。
    if (([statusStr isEqualToString:@"CANCEL"])) {
        NSString *retMsg = [dict valueNotNullForKey:@"memo"];
        [SVProgressHUD showErrorWithStatus:retMsg];
        
    } else {
        [self payCompleted:dict];
    }
}

- (void)payCompleted:(NSDictionary *)dataDict
{
    if (_payProjectType == PayProjectTypeOneCard) {
        //保存充值成功的一卡通号
        [Tools addIdToRecordArray:_payModel.goodsNumber withUserId:shareAppDelegateInstance.boenUserInfo.userid];
    }
    //充值完成，刷新消息中心列表
    [shareAppDelegateInstance getAndRefreshNewsData];
    [shareAppDelegateInstance refreshServiceCenterAfter10Seconds];//10s后再刷一次，因为有时候服务端还没更新数据。
    
    if (IOS_VERSION < 8.0) {
        //王科的iPhone4，iOS7.1.1无法自动跳转，估作此特殊处理，不走self.returnBlock。
        //跳转H5结果页面
        NSString *resultUrl = [NSString stringWithFormat:@"%@?order_no=%@", kPayResultH5Url, _payModel.order_no];
        BNPayResultShareH5VC *webViewController = [[BNPayResultShareH5VC alloc] init];
        webViewController.url = resultUrl;
        webViewController.backBtnBlock = ^(PayVCJumpType jumpType){

            [self dismissViewControllerAnimated:NO completion:nil];
            self.returnBlock(jumpType, @{});

        };
        [self pushViewController:webViewController animated:NO];

    } else {
        PayVCJumpType jumpType = PayVCJumpType_PayCompletedGoToResultVC;
        self.returnBlock(jumpType, dataDict);
    }


    return;  //支付完成，直接返回主页面。不再跳转支付结果页面了。

}

- (void)couponBtnAction:(UIButton *)button
{
    
    if ([_couponNumber integerValue] <= 0) {
        return;   //0张优惠券，则不让用户进入H5优惠券列表。
    }
    //H5优惠券
    BNPublicHtml5BusinessVC *h5CouponVC = [[BNPublicHtml5BusinessVC alloc] init];
    h5CouponVC.businessType = Html5BusinessType_NativeBusiness;
    h5CouponVC.url = kH5CouponVCUrl;
    h5CouponVC.params = @{@"biz_type" : _payModel.biz_type,
                          @"pay_amount" : _payModel.salePrice};
    h5CouponVC.backBlock = ^(NSDictionary *dict) {
        BNLog(@"h5CouponVC--backBlock--%@",dict);
        [self refreshDisplayCouponData:dict];

    };
    [self pushViewController:h5CouponVC animated:YES];

}
- (void)refreshDisplayCouponData:(NSDictionary *)dict
{
    [_couponModel drawData:dict];
    
    if (_couponModel.discount_amount && [_couponModel.discount_amount floatValue] > 0) {
        CGFloat newPrice = [_payModel.salePrice floatValue] - [_couponModel.discount_amount floatValue];
//        _payMoneyLbl.text = [NSString stringWithFormat:@"%.2f元(已减免%@元)", newPrice, _couponModel.discount_amount];//去掉已减免
        _payMoneyLbl.text = [NSString stringWithFormat:@"￥%.2f", newPrice];
        _couponNameLbl.text = [NSString stringWithFormat:@"已减免￥%@", _couponModel.discount_amount];
        _couponNameLbl.textColor = UIColorFromRGB(0xff5252);

    } else {
        _payMoneyLbl.text = [NSString stringWithFormat:@"￥%@", _payModel.salePrice];
        _couponNameLbl.text = @"未选用优惠券";
        _couponNameLbl.textColor = [UIColor blackColor];

    }

}
@end
