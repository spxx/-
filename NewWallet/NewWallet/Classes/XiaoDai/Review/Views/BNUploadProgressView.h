//
//  BNUploadProgressView.h
//  Wallet
//
//  Created by mac1 on 15/4/28.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNUploadProgressView : UIView


- (void)changeProgressWithDataSize:(long long)changeSize  amountSize:(long long) amountSize;


@end
