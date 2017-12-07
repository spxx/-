//
//  Base64Util.h
//  encrypt&decrypt
//
//  Created by 刘雲飞 on 16/6/22.
//  Copyright © 2016年 刘雲飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface Base64Util : NSObject

+ (NSString*)encodeBase64:(NSString*)input;
+ (NSString*)decodeBase64:(NSString*)input;

@end
