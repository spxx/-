//
//  BNCouponModel.h
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCouponModel : NSObject    /*****优惠券信息*****/

@property (strong, nonatomic) NSString *coupon_no;          //优惠券number
@property (strong, nonatomic) NSString *coupon_name;        //优惠券名称
@property (strong, nonatomic) NSString *discount_amount;    //优惠金额

- (void)drawData:(NSDictionary *)dict;

@end
