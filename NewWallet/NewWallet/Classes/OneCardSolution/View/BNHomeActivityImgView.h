//
//  BNHomeActivityImgView.h
//  Wallet
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNHomeActivityImgView : UIImageView

@property (nonatomic) NSString *jumpURL;

- (void)addTarget:(id)target withAction:(SEL)action;


@end
