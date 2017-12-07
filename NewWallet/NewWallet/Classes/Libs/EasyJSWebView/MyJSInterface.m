//
//  MyJSInterface.m
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "MyJSInterface.h"
#import "ViewControllers.h"

@implementation MyJSInterface

- (void) test{
	BNLog(@"test called");
}

- (void) testWithParam: (NSString*) param{
	BNLog(@"test with param: %@", param);
}

- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2{
	BNLog(@"test with param: %@ and param2: %@", param, param2);
}

- (void) testWithFuncParam: (EasyJSDataFunction*) param{
	BNLog(@"test with func");
	
	param.removeAfterExecute = YES;
	NSString* ret = [param executeWithParam:@"blabla:\"bla"];
	
	BNLog(@"Return value from callback: %@", ret);
}

- (void) testWithFuncParam2: (EasyJSDataFunction*) param{
	BNLog(@"test with func 2 but not removing callback after invocation");
	
	param.removeAfterExecute = NO;
	[param executeWithParam:@"data 1"];
	[param executeWithParam:@"data 2"];
}

- (NSString*) testWithRet{
	NSString* ret = @"js";
	return ret;
}
- (NSString*)tdtc_decode:(NSString *)string{
    ViewControllers *vc = [[ViewControllers alloc ]init];
    NSString * ret = [vc decryptWithText:string];

    return ret;
}

- (NSString *)jsGetAppCouponParams
{
    if (!_params) {
        return @"";
    }
    return [Tools dictionaryToJson:_params];
}
- (void)jsGiveCouponParamsToApp:(NSString *)params
{
    NSDictionary *result = [Tools jsonToDictionary:params];
    
    [self.delegate MyJSInterfaceGetParams:result];
}

@end
