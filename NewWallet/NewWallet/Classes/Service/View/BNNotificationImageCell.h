//
//  BNNotificationImageCell.h
//  Wallet
//
//  Created by crx on 9/22/15.
//  Copyright © 2015 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNNotificationImageCell : UITableViewCell

- (void)drawDataWithInfo:(NSManagedObject *)newInfo withHeightDic:(NSDictionary *)heightInfo;

@end
