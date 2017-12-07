//
//  DrivingClass.h
//  Wallet
//
//  Created by mac1 on 16/5/31.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrivingClass : NSObject

@property (nonatomic, copy) NSString *class_name;//培训班名称
@property (nonatomic, copy) NSString *class_key;//培训班key
@property (nonatomic, copy) NSString *class_desc;//培训班描述
@property (nonatomic, copy) NSString *driving_school_name;//驾校名称
@property (nonatomic, copy) NSString *class_total_fee;//费用总额
@property (nonatomic, copy) NSString *first_pay_fee; //首付金额
@property (nonatomic, copy) NSString *support_installment;//是否支持分段,不支持则不显示可首付这一行字


@property (nonatomic, assign) NSInteger classId; //自己加的属性，用来标记是哪个cell


//'class_name': 'C1型驾照(手动挡)培训班',
//'class_key': 'ASDSADSA123231KJK',
//'class_desc': '一人一车一教练，教练接送\n周一至周日，指定场地',
//'driving_school_name': '成都泰来驾校',
//'class_total_fee': '3860',
//'first_pay_fee': '1250',
//'support_installment': '1',

@end
