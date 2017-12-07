//
//  TestApi.m
//  Wallet
//
//  Created by Lcyu on 14-7-16.
//  Copyright (c) 2014年 BoEn. All rights reserved.
//

#import "TestApi.h"
#import "FirstHttpTools.h"

@implementation TestApi


static FirstHttpTools *tool;

+(void)initialize
{
    tool = [FirstHttpTools shareInstance];
}

@end
