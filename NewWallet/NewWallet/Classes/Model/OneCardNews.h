//
//  OneCardNews.h
//  NewWallet
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OneCardNews : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * create_time;
@property (nonatomic, retain) NSString * newsId;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSString * school_id;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * text_abstract;
@property (nonatomic, retain) NSString * text_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unRead;
@property (nonatomic, retain) NSString * full_text_url;

@end
