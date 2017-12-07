//
//  BNCouponModel.m
//  Wallet
//
//  Created by jiayong Xu on 15-12-15.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNCouponModel.h"

@implementation BNCouponModel
@synthesize coupon_no;          //优惠券number
@synthesize coupon_name;        //优惠券名称
@synthesize discount_amount;    //优惠金额

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        coupon_no = @"";
        coupon_name = @"";
        discount_amount = @"";
    }
    return self;
}
- (void)drawData:(NSDictionary *)dict
{
    self.coupon_no = [NSString stringWithFormat:@"%@",[dict valueWithNoDataForKey:@"coupon_no"]];
    self.coupon_name = [NSString stringWithFormat:@"%@",[dict valueWithNoDataForKey:@"coupon_name"]];
    self.discount_amount = [NSString stringWithFormat:@"%@",[dict valueWithNoDataForKey:@"discount_amount"]];
}
@end
