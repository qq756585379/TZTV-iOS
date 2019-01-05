//
//  UIViewController+router.h
//  OneStoreBase
//
//  Created by huangjiming on 11/9/15.
//  Copyright © 2015 OneStoreBase. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OTSMappingVO;

@interface UIViewController (router)
/**
 *  OTS创建的时候的参数,如果不为nil，则标识是从router创建的,其中会传递OTSRouterCallbackKey的block用来回调
 */
@property (nonatomic, strong) NSDictionary *extraData;
/**
 *  通过mappingvo的key创建vc
 */
+ (instancetype)createWithMappingVOKey:(NSString *)aKey extraData:(NSDictionary *)aParam;
/**
 *  vc创建
 */
+ (instancetype)createWithMappingVO:(OTSMappingVO *)aMappingVO extraData:(NSDictionary *)aParam;

@end
