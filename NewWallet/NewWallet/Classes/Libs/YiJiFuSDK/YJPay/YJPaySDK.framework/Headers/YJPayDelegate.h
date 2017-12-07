//
//  YJBasePayDelegate.h
//  YJUnionPay
//
//  Created by iXcoder on 16/5/16.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJPaySDKDefine.h"

@protocol YJPayDelegate <NSObject>

- (void)payEngineDidBegin;
- (void)payEngineDidFinish:(NSString *)type code:(id)code extInfo:(NSDictionary *)info;

@end
