//
//  BNNewsTool.m
//  NewWallet
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "BNNewsTool.h"
#import "OneCardnews.h"
#import "XifuNews.h"
#import "OneCardNews.h"

@implementation BNNewsTool

+ (instancetype)sharedInstance
{
    static BNNewsTool * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BNNewsTool alloc] init];
    });
    return sharedInstance;
}

//Xifu
- (NSArray *)getXifuNewsWithUserId:(NSString *)userId
{
    NSArray *xiFuArray = [XifuNews MR_findByAttribute:@"userId" withValue:userId];
    NSArray *resutlArray = [xiFuArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        XifuNews * con1 = (XifuNews *)obj1;
        XifuNews * con2 = (XifuNews *)obj2;
        return [con2.create_time compare:con1.create_time];
    }];
    return resutlArray;
}
- (NSString *)getXiFuLatestNewsTitle
{
    NSArray *ary = [self getXifuNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    XifuNews *latestNews = nil;
    if (ary.count > 0) {
        latestNews = ary[0];
    } else {
        //latestNews = [XifuNews MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        //latestNews.title = @"";
        return @"";
    }
    
    if (latestNews.messageType.integerValue != 3) {
        return latestNews.busiType;
    }
    
    return latestNews.title;
}
- (XifuNews *)getXiFuLatestNewsObject
{
    NSArray *ary = [self getXifuNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    XifuNews *latestNews = nil;
    if (ary.count > 0) {
        latestNews = ary[0];
    } else {
        latestNews = [XifuNews MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        latestNews.desc = @"暂无消息";
        latestNews.create_time = @"";
    }
    return latestNews;
}


- (XifuNews *)searchXifuNewsWithId:(NSString *)newsId inContext:(NSManagedObjectContext *)context
{
    NSString *userId = shareAppDelegateInstance.boenUserInfo.userid;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId == %@ and create_time == %@", userId, newsId];
    XifuNews *xifuNews = [XifuNews MR_findFirstWithPredicate:predicate inContext:context];
    return xifuNews;
}
- (void)saveXifuNewsWithArray:(NSArray *)newsArray
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *message in newsArray) {
            XifuNews *xifuNews = [self searchXifuNewsWithId:message[@"push_message_time"] inContext:localContext];
            if (!xifuNews) {
                xifuNews = [XifuNews MR_createInContext:localContext];
                xifuNews.userId = shareAppDelegateInstance.boenUserInfo.userid;
                xifuNews.create_time = HLStringNotNull(message[@"push_message_time"]);
                //xifuNews.newsId = [NSString stringWithFormat:@"%@",message[@"id"]];
                //xifuNews.school_id = HLStringNotNull(message[@"school_id"]);
                //xifuNews.tag = HLStringNotNull(message[@"tag"]);
                xifuNews.text_url = HLStringNotNull(message[@"full_text_url"]);
                xifuNews.unRead = [NSNumber numberWithBool:NO];
                
                xifuNews.pushType = message[@"push_type"];
                xifuNews.messageType = message[@"message_type"];
                xifuNews.busiType = HLStringNotNull(message[@"busi_type"]);
                xifuNews.subBusiType = HLStringNotNull(message[@"sub_busi_type"]);
                
                NSError *error;
                NSDictionary *msg = [NSJSONSerialization JSONObjectWithData:[message[@"message"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];

                xifuNews.title = HLStringNotNull(msg[@"title"]);
                xifuNews.image_url = HLStringNotNull(msg[@"icon"]);
                xifuNews.desc = HLStringNotNull(msg[@"description"]);
                xifuNews.content = HLStringNotNull(msg[@"content"]);
            }
        }
        
    } completion:^(BOOL success, NSError *error) {
        //BNLog(@"XifuNews-save成功否：%@，%@", success ? @"yes" : @"no", [error description]);
        //NSArray *ary = [self getXifuNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
        //BNLog(@"XifuNews-save成功ary--%@",ary);

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshHomeEventList object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Message_HadLoaded object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
    }];
}

//OneCard ---->
- (NSArray *)getOneCardNewsWithUserId:(NSString *)userId
{
    NSArray *oneCardArray = [OneCardNews MR_findByAttribute:@"userId" withValue:userId];
    NSArray *resutlArray = [oneCardArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        OneCardNews * con1 = (OneCardNews *)obj1;
        OneCardNews * con2 = (OneCardNews *)obj2;
        return [con2.create_time compare:con1.create_time];
    }];
    return resutlArray;
}
- (NSString *)getOneCardLatestNewsTitle
{
    NSArray *ary = [self getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    OneCardNews *latestNews = nil;
    if (ary.count > 0) {
        latestNews = ary[0];
    } else {
        latestNews = [OneCardNews MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        latestNews.title = @"";
    }
    return latestNews.title;
}
- (OneCardNews *)getOneCardLatestNewsObject
{
    NSArray *ary = [self getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    OneCardNews *latestNews = nil;
    if (ary.count > 0) {
        latestNews = ary[0];
    } else {
        latestNews = [OneCardNews MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        latestNews.title = @"暂无消息";
        latestNews.create_time = @"";
    }
    return latestNews;
}
- (OneCardNews *)searchOneCardNewsWithId:(NSString *)newsId inContext:(NSManagedObjectContext *)context
{
    NSString *userId = shareAppDelegateInstance.boenUserInfo.userid;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId == %@ and create_time == %@", userId, newsId];
    OneCardNews *oneCardNews = [OneCardNews MR_findFirstWithPredicate:predicate inContext:context];
    return oneCardNews;
}
- (void)saveOneCardNewsWithArray:(NSArray *)newsArray
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *newsDic in newsArray) {
            OneCardNews *oneCardNews = [self searchOneCardNewsWithId:newsDic[@"create_time"] inContext:localContext];
            if (!oneCardNews) {
                oneCardNews = [OneCardNews MR_createInContext:localContext];
                oneCardNews.userId = shareAppDelegateInstance.boenUserInfo.userid;
                oneCardNews.create_time = HLStringNotNull(newsDic[@"create_time"]);
                oneCardNews.newsId = [NSString stringWithFormat:@"%@",newsDic[@"id"]];
                oneCardNews.image_url = HLStringNotNull(newsDic[@"image_url"]);
                oneCardNews.school_id = HLStringNotNull(newsDic[@"school_id"]);
                oneCardNews.tag = HLStringNotNull(newsDic[@"tag"]);
                oneCardNews.text_abstract = HLStringNotNull(newsDic[@"text_abstract"]);
                oneCardNews.text_url = HLStringNotNull(newsDic[@"text_url"]);
                oneCardNews.title = HLStringNotNull(newsDic[@"title"]);
                oneCardNews.full_text_url = HLStringNotNull(newsDic[@"full_text_url"]);
                oneCardNews.unRead = @NO;
            }
        }

    } completion:^(BOOL success, NSError *error) {
        BNLog(@"OneCardNews-save成功否：%@，%@", success ? @"yes" : @"no", [error description]);
        //NSArray *ary = [self getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
        //BNLog(@"OneCardNews-save成功ary--%@",ary);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshHomeEventList object:nil];

    }];

}
- (NSInteger)getXifuNewsUnReadNumber
{
    NSString *userId = shareAppDelegateInstance.boenUserInfo.userid;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId == %@ and unRead == %@", userId, @NO];
    //NSArray *resutlArray = [XifuNews MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSUInteger count = [XifuNews MR_countOfEntitiesWithPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
//    NSArray *resutlArray = [XifuNews MR_findByAttribute:@"unRead" withValue:@NO];
    return count;
}
- (NSInteger)getOneCardNewsUnReadNumber
{
    NSString *userId = shareAppDelegateInstance.boenUserInfo.userid;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId == %@ and unRead == %@", userId, @NO];
    //NSArray *resutlArray = [OneCardNews MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSUInteger count = [OneCardNews MR_countOfEntitiesWithPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
//    NSArray *resutlArray = [OneCardNews MR_findByAttribute:@"unRead" withValue:@NO];
    return count;
}
- (NSInteger)getTotalUnReadNumber
{
    NSInteger totalInt = [self getXifuNewsUnReadNumber] + [self getOneCardNewsUnReadNumber];
    return totalInt;
}

- (void)setXifuNewsAllHaveRead
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *xifuAry = [self getXifuNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
        for (XifuNews *xifuNews in xifuAry) {
            XifuNews *xifuNews1 = [xifuNews MR_inContext:localContext];
            xifuNews1.unRead = @YES;
        }
    } completion:^(BOOL success, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
    }];
}
- (void)setOneCardNewsAllHaveRead
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *oneCardAry = [self getOneCardNewsWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
        for (OneCardNews *oneCardNews in oneCardAry) {
            OneCardNews *oneCardNews1 = [oneCardNews MR_inContext:localContext];
            oneCardNews1.unRead = @YES;
        }
    } completion:^(BOOL success, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUnReadNumber object:nil];
    }];
}
@end
