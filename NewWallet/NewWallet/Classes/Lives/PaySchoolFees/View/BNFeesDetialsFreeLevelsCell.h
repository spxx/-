//
//  BNFeesDetialsFreeLevelsCell.h
//  Wallet
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLevelsCellHeight 50*BILI_WIDTH

@interface BNFeesDetialsFreeLevelsCell : UITableViewCell

- (void)drawData:(NSDictionary *)info selectCell:(NSDictionary *)dict;

@end
