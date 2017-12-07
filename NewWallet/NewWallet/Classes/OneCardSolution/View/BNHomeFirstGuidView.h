//
//  BNHomeFirstGuidView.h
//  Wallet
//
//  Created by mac on 2017/1/5.
//  Copyright © 2017年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HomeGuidViewTapedsBlock)(NSInteger tapTimes);

@interface BNHomeFirstGuidView : UIView

@property (copy, nonatomic) HomeGuidViewTapedsBlock tapedBlock;

@end
