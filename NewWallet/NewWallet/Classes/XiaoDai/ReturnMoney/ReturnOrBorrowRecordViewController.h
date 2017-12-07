//
//  ReturnOrBorrowRecordViewController.h
//  Wallet
//
//  Created by cyjjkz1 on 15/5/6.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNBaseViewController.h"
//typedef enum {
//    Return,
//    Borrow,
//} ReturnOrBorrow;

@interface ReturnOrBorrowRecordViewController : BNBaseViewController

//YES表示还钱 NO表示借钱
@property (assign,nonatomic) BOOL returnOrBorrow;
@property (strong,nonatomic) NSMutableArray *borrowArray;

- (id)initWithReturnOrBorrow:(BOOL)returnOrBorrow;

@end
