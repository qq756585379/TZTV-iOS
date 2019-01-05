//
//  NSDictionary+router.h
//  OneStoreFramework
//
//  Created by Aimy on 14/11/10.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (router)

/**
 *  忽略key大小写查询字典
 */
- (id)objectForCaseInsensitiveKey:(NSString *)aKey;

@end
