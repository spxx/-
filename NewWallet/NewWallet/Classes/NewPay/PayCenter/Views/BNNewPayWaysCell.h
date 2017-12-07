//
//  BNNewPayWaysCell.h
//  NewWallet
//
//  Created by mac1 on 14-11-7.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNNewPayWaysCell : UITableViewCell

- (void)drawDataWithInfo:(NSDictionary *)bankCardInfo selectedDict:(NSDictionary *)selectedDict payWayStatus:(NSDictionary *)pay_type_list;
@end
