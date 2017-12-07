//
//  BNGradeSelectView.h
//  Wallet
//
//  Created by mac1 on 15/5/13.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BNGradeSelectDelegate <NSObject>

- (void)selectedGradeNO:(NSString *)gradeStr;

@end

@interface BNGradeSelectView : UIView

@property (strong, nonatomic) NSArray *datasource;

@property (assign, nonatomic) BOOL pickIsShow;

@property (weak, nonatomic) id<BNGradeSelectDelegate> delegate;

- (id)initWithDataSource:(NSArray *)grades;

- (void)show;

- (void)dismiss;

@end
