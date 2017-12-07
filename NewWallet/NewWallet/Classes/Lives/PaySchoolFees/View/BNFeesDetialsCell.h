//
//  BNFeesDetialsCell.h
//  Wallet
//
//  Created by mac1 on 15/3/17.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFeesCellHeight 150

@interface BNFeesDetialsCell : UITableViewCell

@property(nonatomic, weak) UILabel *feesDateLab;
@property(nonatomic, weak) UILabel *feesAmountLab;
@property(nonatomic, weak) UILabel *feesNameLab;
@property(nonatomic, weak) UILabel *feesSubmitDateLab;
@property(nonatomic, weak) UILabel *feesStatusLab;
@property(nonatomic, weak) UILabel *feeLevelsPayLbl;


- (void)setupCellWithFeesInfo:(NSDictionary *)info;
@end
