//
//  BNRealNameInfo.m
//  Wallet
//
//  Created by mac1 on 15/5/20.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "BNRealNameInfo.h"

#import <objc/runtime.h>



@implementation BNRealNameInfo

static BNRealNameInfo *realNameInfo = nil;

static NSDictionary   *gradeMap = nil;

static NSArray        *gradesChineseStr = nil;

+ (BNRealNameInfo *)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        realNameInfo = [[BNRealNameInfo alloc] init];
        gradesChineseStr = @[@"大一",@"大二",@"大三",@"大四",@"研一",
                            @"研二",@"研三",@"博一",@"博二",@"博三",@"博四",@"博五"];
        
        NSArray *gradeNO = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
        
        gradeMap = [NSDictionary dictionaryWithObjects:gradeNO forKeys:gradesChineseStr];
    });
    return realNameInfo;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        realNameInfo = [super allocWithZone:zone];
    });
    return realNameInfo;
}

- (BOOL)checkXiaoDaiRealNameInfoCanSubmit
{
//    BOOL canSubmit = YES;
//    
//    unsigned int outCount = 0;
//    
//    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
//    
//    for (int i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        
//        const char *propertyChar = property_getName(property);
//        
//        NSString *propertyName = [NSString stringWithUTF8String:propertyChar];
//        
//        NSString *propertyValue = [self valueForKey:propertyName];
//        
//        if (propertyValue.length <= 0) {//属性有值
//            canSubmit = NO;
//            break;
//        }
//    }
//    
//    return canSubmit;
    
    // 8 要素
    if (self.realNameInfoOfName.length >0 && self.realNameInfoOfIdentity.length > 0 && self.realNameInfoOfValidate && self.realNameInfoOfFrontImgPath.length > 0 && self.realNameInfoOfBackImgPath.length > 0 && self.realNameInfoOfGrade.length > 0 && self.realNameInfoOfEmail.length > 0 && self.realNameInfoOfHoldImgPath.length > 0)
    {
        return YES;
    }
    return NO;
}


- (BOOL)checkTiXianRealNameInfoCanSubmit
{
    // 5 要素
    if (self.realNameInfoOfName.length >0 && self.realNameInfoOfIdentity.length > 0 && self.realNameInfoOfValidate && self.tiXianFrontImgPath.length > 0 && self.tiXianBackImgPath.length > 0)
    {
        return YES;
    }
    return NO;

}
- (BOOL)clearRealNameInfo{
    
    BOOL isClearAll = YES;
    unsigned int outCount = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        const char *propertyChar = property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:propertyChar];
        
        [self setValue:nil forKey:propertyName];
        
        NSString *propertyValue = [self valueForKey:propertyName];
        
        if (propertyValue.length > 0) {//属性有值
            isClearAll = NO;
            break;
        }
    }
    return isClearAll;

}
#pragma mark - getter and setter

#pragma mark setter
- (void)setRealNameInfoOfName:(NSString *)name
{
    _realNameInfoOfName = [name copy];
}

- (void)setRealNameInfoOfGrade:(NSString *)grade
{
    if ([gradesChineseStr containsObject:grade]) {
        _realNameInfoOfGrade = [gradeMap valueForKey:grade];
    }
    
    if ([[gradeMap allValues] containsObject:grade]) {
        _realNameInfoOfGrade = grade;
    }
    if(grade.length == 0 || grade == nil){
        _realNameInfoOfGrade = nil;
    }
}

- (void)setRealNameInfoOfEmail:(NSString *)email
{
    _realNameInfoOfEmail = [email copy];
}

- (void)setRealNameInfoOfIdentity:(NSString *)identity
{
    _realNameInfoOfIdentity = [identity copy];
}

- (void)setRealNameInfoOfValidate:(NSString *)validate
{
    _realNameInfoOfValidate = [validate copy];
}

- (void)setRealNameInfoOfFrontImgPath:(NSString *)frontImgPath
{
    _realNameInfoOfFrontImgPath = [frontImgPath copy];
}
- (void)setRealNameInfoOfBackImgPath:(NSString *)backImgPath
{
    _realNameInfoOfBackImgPath = [backImgPath copy];
    
}
- (void)setRealNameInfoOfHoldImgPath:(NSString *)holdImgPath
{
    _realNameInfoOfHoldImgPath = [holdImgPath copy];
}



#pragma mark getter
- (NSString *)getRealNameInfoOfGradeWithChineseString
{
    NSString *gradeNO = _realNameInfoOfGrade;
    if (gradeNO.length <= 0) {
        return nil;
    }
    
    NSString *gradeChinese = nil;
    for (NSString *obj in gradesChineseStr) {
        if ([[gradeMap valueForKey:obj] isEqualToString:gradeNO]) {
            gradeChinese = obj;
        }
    }
    return gradeChinese;
}

- (NSString *)getRealNameInfoOfGradeWithNOString
{
    NSString *gradeNO = _realNameInfoOfGrade;
    return gradeNO;
}

- (NSArray *)getGradesList
{
    NSArray *gradesList = [NSArray arrayWithArray:gradesChineseStr];
    return gradesList;
}

- (NSString *)getRealNameInfoOfValidateHasPoint
{
    NSString *validate = _realNameInfoOfValidate;
    return validate;
}

- (NSString *)getRealNameInfoOfValidateHasNotPoint
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"]];
    NSDate *selectedDate = [dateFormatter dateFromString:_realNameInfoOfValidate];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    return dateString;
}


@end
