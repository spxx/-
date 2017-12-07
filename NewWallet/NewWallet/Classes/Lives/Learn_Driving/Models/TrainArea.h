//
//  TrainArea.h
//  Wallet
//
//  Created by mac1 on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainArea : NSObject

@property (nonatomic, copy) NSString *field_name;//训练场名称
@property (nonatomic, copy) NSString *field_area_name;//训练场区域名称
@property (nonatomic, copy) NSString *field_longitude;//训练场经度
@property (nonatomic, copy) NSString *field_latitude;//训练场纬度
@property (nonatomic, copy) NSString *field_distance;///到大学距离
@property (nonatomic, copy) NSString *field_position_name;//地址
@property (nonatomic, copy) NSString *operate_time_desc;//运营时间描述
@property (nonatomic, strong) NSArray *pic_list;// 训练场地展示图

@end
