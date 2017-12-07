//
//  EasyJSWebView.h
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyJSWebViewProxyDelegate.h"

@interface EasyJSWebView : UIWebView

// All the events will pass through this proxy delegate first
@property (nonatomic, retain) EasyJSWebViewProxyDelegate* proxyDelegate;

- (void) initEasyJS;
- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name;

@end


//JS调用本地OC代码
//这个类优点是，可传参并且返回值。相关资料 http://blog.csdn.net/cnsxhza985/article/details/20053839
//如果不需要返回值，用iOS系统自带的JSContext也可以。JSContext好像不能返回值。 相关资料 http://blog.csdn.net/j_akill/article/details/44463301