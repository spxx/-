//
//  YJExtraParams.h
//  YJPaySDK
//
//  Created by iXcoder on 16/6/13.
//  Copyright © 2016年 YIJI.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - YJExtraObject define
@interface YJExtraObject : NSObject<NSCopying>

/*!
 * @brief 扩展参数值
 */
@property (nonatomic, copy) NSString *value;

/*!
 * @brief 该值可否修改(YES:不可修改[默认], NO:可修改)
 */
@property (nonatomic, assign) BOOL stable;

+ (instancetype)extObjWith:(NSString *)value stable:(BOOL)stable;

@end

#pragma mark - YJExtraParams define

@interface YJExtraParams : NSObject<NSCopying>

/*!
 * @brief realName 真实姓名
 */
@property (nonatomic, strong) YJExtraObject *realName;

/*!
 * @brief certNo 身份证号
 */
@property (nonatomic, strong) YJExtraObject *certNo;

/*!
 * @brief cardNo 银行卡号
 */
@property (nonatomic, strong) YJExtraObject *cardNo;

/*!
 * @brief mobileNo 手机号
 */
@property (nonatomic, strong) YJExtraObject *mobileNo;

@end
