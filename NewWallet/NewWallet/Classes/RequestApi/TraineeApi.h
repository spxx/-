//
//  TraineeApi.h
//  Wallet
//
//  Created by mac1 on 15/12/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TraineeApi : NSObject

/**
 *  查询实习生信息
 *
 *  @param successMethod
 *  @param errorMethod
 */
+ (void)queryInternStudentInfoSuccess:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod;

/**
 *  查询任务列表
 *
 *  @param successMethod
 *  @param errorMethod
 */
+ (void)queryTaskListSuccess:(void (^)(NSDictionary *returnData))successMethod
                              failure:(void (^)(NSError *error))errorMethod;


/**
 *  确认任务
 *
 *  @param task_key      传入的任务key
 *  @param successMethod
 *  @param errorMethod
 */
+ (void)confirmTaskWithTask_key:(NSString *)task_key
                      Success:(void (^)(NSDictionary *returnData))successMethod
                      failure:(void (^)(NSError *error))errorMethod;


@end
