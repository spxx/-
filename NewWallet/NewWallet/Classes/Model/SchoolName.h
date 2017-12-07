//
//  SchoolName.h
//  Wallet
//
//  Created by mac1 on 15/1/27.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SchoolName : NSManagedObject

@property (nonatomic, retain) NSString * schoolName_Chinese;
@property (nonatomic, retain) NSString * schoolName_PinYin;
@property (nonatomic, retain) NSString * schoolName_Code;
@property (nonatomic, retain) NSString * schoolName_ID;

@end
