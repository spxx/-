//
//  BNHomeMessageModel.h
//  NewWallet
//
//  Created by mac on 16-12-26.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNHomeMessageModel : NSObject

@property (strong, nonatomic) NSString *title;       //标题
@property (strong, nonatomic) NSString *subTitle;    //内容
@property (strong, nonatomic) NSString *time;        //日期
@property (nonatomic) NSInteger count;       //计数
@property (strong, nonatomic) NSString *icon;        //icon名字


@end
