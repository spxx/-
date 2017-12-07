//
//  BNNewXiaodaiRealNameInfo.h
//  Wallet
//
//  Created by mac1 on 15/10/27.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface BNNewXiaodaiRealNameInfo : NSObject

@property (copy, nonatomic) NSString *realNameInfoOfName;
@property (copy, nonatomic) NSString *realNameInfoOfIdentity;//身份证号
@property (copy, nonatomic) NSString *realNameInfoOfGradeCode;//学历和年级code
@property (copy, nonatomic) NSString *realNameInfoOfGradeString;//学历和年级中文
@property (copy, nonatomic) NSString *realNameInfoOfEnrollYear; //入学年份
@property (copy, nonatomic) NSString *realNameInfoOfFrontImgPath;

singleton_interface(BNNewXiaodaiRealNameInfo);


//清除个人信息
- (BOOL)clearRealNameInfo;

- (BOOL)checkAllPropertyValues;

@end
