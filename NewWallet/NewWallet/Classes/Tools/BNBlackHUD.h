//
//  BNBlackHUD.h
//  LCHUD
//
//  Created by mac1 on 15/8/28.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNBlackHUD : NSObject

/**
 *  显示text 相当于安卓toast
 *
 *  @param msg   要显示的文字
 *  @param aView 显示到哪个view上
 */
+ (void)showMessage:(NSString *)msg toView:(UIView *)aView;
@end
