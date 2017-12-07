//
//  DrivingSchoolModel.h
//  Wallet
//
//  Created by mac1 on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrivingSchoolModel : NSObject

@property (nonatomic, copy) NSString *driving_school_name;//驾校名称
@property (nonatomic, copy) NSString *driving_school_key;//驾校key，获取场地和课程使用
@property (nonatomic, copy) NSString *apply_amount;//已报名人数
@property (nonatomic, copy) NSString *default_total_amount;//默认课程金额
@property (nonatomic, copy) NSString *first_amount;//分段首付金额
@property (nonatomic, copy) NSString *support_installment;//是否支持分段,不支持则不显示可首付这一行字
@property (nonatomic, copy) NSString *market_amount;//市场价格
@property (nonatomic, copy) NSString *driving_school_logo;//驾校logo
@property (nonatomic, copy) NSString *driving_school_advantage;//驾校优势
@property (nonatomic, copy) NSString *nearest_train_name;//最近训练场名称
@property (nonatomic, copy) NSString *nearest_train_distance;//最近训练场距离
@property (nonatomic, copy) NSString *nearest_train_area_name;//最近训练场区域名称
@property (nonatomic, copy) NSString *driving_school_introduction;


@end
