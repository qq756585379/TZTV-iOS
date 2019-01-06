//
//  NetworkInterface.h
//  TZTV
//
//  Created by 杨俊 on 2019/1/6.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkInterface : NSObject

/**
 *  功能:从SEL获取接口名称
 */
+ (NSString *)interfaceNameFromSelector:(SEL)aSelector;

/**
 *    功能:获取类型不匹配的错误
 *
 *    @param aMathType   :需要匹配的数据类型,需要正确返回的数据类
 *    @param aSourceType :真实返回的数据类型
 */
+ (NSError *)typeMismatchErrorWithMatchType:(Class)aMathType sourceType:(Class)aSourceType;

@end

NS_ASSUME_NONNULL_END
