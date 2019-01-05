//
//  NSObject+category.m
//  OneStore
//
//  Created by Aimy on 14-3-23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "NSObject+category.h"

@implementation NSObject (category)

static char associatedObjectNamesKey;

- (void)setAssociatedObjectNames:(NSMutableArray *)associatedObjectNames{
    objc_setAssociatedObject(self, &associatedObjectNamesKey, associatedObjectNames,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)associatedObjectNames{
    NSMutableArray *array = objc_getAssociatedObject(self, &associatedObjectNamesKey);
    if (!array) {
        array = [NSMutableArray array];
        [self setAssociatedObjectNames:array];
    }
    return array;
}

- (void)objc_setAssociatedObject:(NSString *)propertyName value:(id)value policy:(objc_AssociationPolicy)policy{
    objc_setAssociatedObject(self, (__bridge objc_objectptr_t)propertyName, value, policy);
    [self.associatedObjectNames addObject:propertyName];
}

- (id)objc_getAssociatedObject:(NSString *)propertyName{
    return objc_getAssociatedObject(self, (__bridge objc_objectptr_t)propertyName);
}

- (void)objc_removeAssociatedObjects{
    [self.associatedObjectNames removeAllObjects];
    objc_removeAssociatedObjects(self);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    YJLog(@"setValue %@ forUndefinedKey %@",value,key);
}

- (void)setNilValueForKey:(NSString *)key{
    YJLog(@"setNilValue forKey %@",key);
}

@end
