//
//  BNAllProjectVC.h
//  Wallet
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 BNDK. All rights reserved.
//

#import "BNSuDoKuBaseVC.h"

typedef NS_ENUM(NSInteger, UseTypes) {
    UseTypeHomeProject,
    UseTypeSchoolProject
};

@interface BNAllProjectVC : BNSuDoKuBaseVC
@property (nonatomic) UseTypes useTypes;

@end
