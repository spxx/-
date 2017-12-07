//
//  TraineeApi.m
//  Wallet
//
//  Created by mac1 on 15/12/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "TraineeApi.h"

@implementation TraineeApi

static NSString *const query_intern_student_info = @"/app/intern_student/v1/query_intern_student_info";

static NSString *const query_task_list = @"/app/intern_student/v1/query_task_list";

static NSString *const confirm_task = @"/app/intern_student/v1/confirm_task";


static  HttpTools *tool;

+(void)initialize
{
    tool = [HttpTools shareInstance];
}

+ (void)queryInternStudentInfoSuccess:(void (^)(NSDictionary *returnData))successMethod
                              failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:query_intern_student_info parameters:@{} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}
+ (void)queryTaskListSuccess:(void (^)(NSDictionary *returnData))successMethod
                     failure:(void (^)(NSError *error))errorMethod
{
    [tool JsonPostRequst:query_task_list parameters:@{} success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

+ (void)confirmTaskWithTask_key:(NSString *)task_key
                        Success:(void (^)(NSDictionary *returnData))successMethod
                        failure:(void (^)(NSError *error))errorMethod
{
    NSDictionary *parameters = @{@"task_key":task_key};
    [tool JsonPostRequst:confirm_task parameters:parameters success:^(id responseObject) {
        successMethod(responseObject);
    } failure:^(NSError *error) {
        errorMethod(error);
    }];
}

@end
