//
//  XifuNews.h
//  
//
//  Created by mac on 15/9/29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XifuNews : NSManagedObject

@property (nonatomic, retain) NSString * busiType;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * create_time;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSString * newsId;
@property (nonatomic, retain) NSNumber * pushType;
@property (nonatomic, retain) NSString * school_id;
@property (nonatomic, retain) NSString * subBusiType;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * text_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unRead;
@property (nonatomic, retain) NSString * userId;

@end
