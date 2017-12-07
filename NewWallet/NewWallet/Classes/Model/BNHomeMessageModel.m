//
//  BNHomeMessageModel.m
//  NewWallet
//
//  Created by mac on 16-12-26.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNHomeMessageModel.h"

@implementation BNHomeMessageModel

@synthesize title;       //标题
@synthesize subTitle;    //内容
@synthesize time;        //日期
@synthesize count;       //计数
@synthesize icon;        //icon名字

-(instancetype)init
{
    self = [super init];
    if (self) {
        title = @"";
        subTitle = @"";
        time = @"";
        count = 0; //接口修改，getP
        icon = @"";
    }
    return self;
}
@end
