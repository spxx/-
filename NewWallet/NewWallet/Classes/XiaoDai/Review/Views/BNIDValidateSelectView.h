//
//  BNIDValidateSelectView.h
//  Wallet
//
//  Created by mac1 on 15/4/29.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNIDValidateSelectDelegate <NSObject>

- (void)selectedIDValidate:(NSString *)str;

@end

@interface BNIDValidateSelectView : UIView

@property (assign, nonatomic) BOOL pickIsShow;

@property (weak, nonatomic) id<BNIDValidateSelectDelegate> delegate;

- (id)initWithDelegate:(id)theDelegate;

- (void)show;

- (void)dismiss;
@end
