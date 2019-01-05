//
//  NSArray+safe.m
//  OneStore
//
//  Created by huang jiming on 13-1-17.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "NSArray+safe.h"
#import "NSObject+swizzle.h"

@implementation NSArray (Safe)

+ (void)load{
    [self overrideMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safeObjectAtIndexedSubscript:)];
}

- (id)safeObjectAtIndexedSubscript:(NSUInteger)index{
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

+ (instancetype)safeArrayWithObject:(id)object{
    if (object == nil) {
        return [self array];
    } else {
        return [self arrayWithObject:object];
    }
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range{
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
		//超过了边界,就获取从loction开始所有的item
		if ((location + length) > self.count) {
			length = (self.count - location);
			return [self safeSubarrayWithRange:NSMakeRange(location, length)];
		}
        return nil;
    }else{
        return [self subarrayWithRange:range];
    }
}

- (NSUInteger)safeIndexOfObject:(id)anObject{
    if (anObject == nil) {
        return NSNotFound;
    } else {
        return [self indexOfObject:anObject];
    }
}

@end
