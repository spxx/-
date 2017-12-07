//
//  BNSelectSchoolViewController.h
//  Wallet
//
//  Created by mac1 on 15/1/23.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"

#import "XJYSearchBar.h"

#import "HLBaseSearchViewController.h"
@interface BNSelectSchoolViewController : HLBaseSearchViewController
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *indexArray;

@property (copy, nonatomic)   NSString *verifycode;
@property (copy, nonatomic)   NSString *registPhone;
@property (copy, nonatomic)   NSString *passwrod;

@end
