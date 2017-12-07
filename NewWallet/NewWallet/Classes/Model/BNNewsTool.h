//
//  BNNewsTool.h
//  NewWallet
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneCardNews.h"
#import "XifuNews.h"


@interface BNNewsTool : NSObject

@property (nonatomic) NSInteger unReadNumber;

//创建单例
+ (instancetype)sharedInstance;

//Xifu ---->
- (NSArray *)getXifuNewsWithUserId:(NSString *)userId;
- (NSString *)getXiFuLatestNewsTitle;     //获取最新那条news的标题
- (XifuNews *)getXiFuLatestNewsObject;//获取最新那条news

- (XifuNews *)searchXifuNewsWithId:(NSString *)newsId inContext:(NSManagedObjectContext *)context;
- (void)saveXifuNewsWithArray:(NSArray *)newsArray;

//OneCard ---->
- (NSArray *)getOneCardNewsWithUserId:(NSString *)userId;
- (NSString *)getOneCardLatestNewsTitle;   //获取最新那条news的标题
- (OneCardNews *)getOneCardLatestNewsObject;//获取最新那条news

- (OneCardNews *)searchOneCardNewsWithId:(NSString *)newsId inContext:(NSManagedObjectContext *)context;
- (void)saveOneCardNewsWithArray:(NSArray *)newsArray;

//获取未读服务消息条数
- (NSInteger)getXifuNewsUnReadNumber;
- (NSInteger)getOneCardNewsUnReadNumber;
- (NSInteger)getTotalUnReadNumber;

//标记未读服务消息为已读
- (void)setXifuNewsAllHaveRead;
- (void)setOneCardNewsAllHaveRead;

@end
