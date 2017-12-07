//
//  BNCollectFeesResultViewController.h
//  
//
//  Created by crx on 15/9/2.
//
//

#import <UIKit/UIKit.h>
#import "BNBaseViewController.h"
typedef NS_ENUM(NSInteger, CollectFeesResultUseType) {
    CollectFeesResultUseTypeFromDetail,  //从详情界面过来
    CollectFeesResultUseTypeFromBillCenter  // 从订单中心过来
};


@interface BNCollectFeesResultViewController : BNBaseViewController

@property (copy, nonatomic) NSString *projectName;
@property (copy, nonatomic) NSString *receiptTime;
@property (copy, nonatomic) NSString *receiptWay;
@property (copy, nonatomic) NSString *amount;
@property (assign, nonatomic) BOOL isSucceed;
@property (copy, nonatomic) NSString *errorMessage;

@property (nonatomic, assign) CollectFeesResultUseType useType;

@end
