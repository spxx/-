//
//  LDSubmitViewController.h
//  Wallet
//
//  Created by 陈荣雄 on 5/30/16.
//  Copyright © 2016 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNBusinessFinishedBaseVC.h"

@interface LDSubmitViewController : BNBusinessFinishedBaseVC

@property (strong, nonatomic) NSDictionary *classInfo;
@property (strong, nonatomic) NSNumber *payType;

@end
