//
//  NSObject+JsonToVO.m
//  OneStore
//
//  Created by Luosa on 2017/2/14.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "NSObject+JsonToVO.h"
#import "NSString+safe.h"

@implementation NSObject (JsonToVO)

/**
 *  获取类名  voName是dictionary中标记实体类的类名的
 */
+ (NSString *)classNameWithDictionary:(NSDictionary*)dic{
    if (!dic) {
        return nil;
    }
    NSString *voName = nil;
    //根据dictinary中的key（datatype）获取到该dictionary对应的实体类名的描述
    NSString *dataTyepStr = [dic objectForKey:@"@datatype"];
    //判断类名描述存在则说明该dictionary是一个自定义的实体VO对象，否则就是一个dictionary类型类名返回nil不用映射
    if (dataTyepStr) {
        NSRange range = [dataTyepStr safeRangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            voName = [dataTyepStr safeSubstringFromIndex:range.location + 1];
        }
    }
    return voName;
}

/**
 *  获取参数class类的所有属性
 */
//- (NSMutableArray *)getPropertyList:(Class)class{
//    if ([ NSStringFromClass(class) isEqualToString:NSStringFromClass([NSObject class])]
//        ||[ NSStringFromClass(class) isEqualToString:NSStringFromClass([JSONModel class])]) {
//        return nil;
//    }
//    u_int count;
//    objc_property_t *properties = class_copyPropertyList(class, &count);
//    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
//    
//    for (int i = 0; i < count ; i++) {
//        const char *propertyName = property_getName(properties[i]);
//        const char *propertyType = property_getAttributes(properties[i]);
//        NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:0];
//        [propertyDic safeSetObject:[NSString stringWithUTF8String: propertyName] forKey:@"propertyName"];
//        [propertyDic safeSetObject:[NSString stringWithUTF8String: propertyType] forKey:@"propertyType"];
//        [propertyArray safeAddObject:propertyDic];
//    }
//    free(properties);
//    NSArray * superArray = [self getPropertyList:[class superclass]];
//    if (superArray != nil) {
//        [propertyArray addObjectsFromArray:superArray];
//    }
//    return propertyArray;
//}

/**
 *  功能:是否是基础类
 */
- (BOOL)isBaseClass:(NSString *)className{
    NSArray *baseClassNames = [NSArray arrayWithObjects:
                                 @"NSString"
                               , @"NSNumber"
                               , @"NSDate"
                               , @"long"
                               , @"string"
                               , @"int"
                               , @"double"
                               , nil];
    
    if (className && [baseClassNames indexOfObject:className] != NSNotFound){
        return YES;
    }
    return NO;
}

@end
