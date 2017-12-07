//
//  BNCreditBalanceAlertView.h
//  Wallet
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapBlock)(void);

@interface BNCreditBalanceAlertView : UIView

@property (copy, nonatomic) TapBlock tapBlock;

-(void)setTitle:(NSString *)title iconName:(NSString *)iconName;

- (void)appearAnimation;
- (void)disAppearAnimation;

@end
