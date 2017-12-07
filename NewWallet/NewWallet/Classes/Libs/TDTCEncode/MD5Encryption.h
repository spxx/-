//
//  MD5Encryption.h
//  encrypt&decrypt
//
//  Created by 刘雲飞 on 16/6/22.
//  Copyright © 2016年 刘雲飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Encryption : NSObject
+ (NSString *)md5by32:(NSString*)input;
- (NSString *)md5:(NSString *)str;
@end
