//
//  BNBusinessFinishedBaseVC.h
//  Wallet
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
typedef void (^YJPayEngineDidFinishBlock)(NSString *type, id code, NSDictionary *info);

@interface BNBusinessFinishedBaseVC : BNBaseViewController

@property (copy, nonatomic) YJPayEngineDidFinishBlock returnBlock;

//注意传入BNPayModel的时候，biz_no和order_no必须先赋值。
- (void)goToPayCenterWithPayProjectType:(PayProjectType)payProjectType payModel:(BNPayModel *)payModel returnBlockone:(ReturnBlock)returnBlock;


@end
