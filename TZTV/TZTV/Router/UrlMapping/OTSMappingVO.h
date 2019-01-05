//
//  OTSMappingVO.h
//  OneStore
//
//  Created by Luosa on 2017/2/14.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OTSMappingClassCreateType){
    OTSMappingClassCreateByCode       = 0,//编码方式创建
    OTSMappingClassCreateByXib        = 1,//xib方式创建
    OTSMappingClassCreateByStoryboard = 2,//storyboard方式创建
};
typedef NS_ENUM(NSUInteger, OTSMappingClassPlatformType){
    OTSMappingClassPlatformTypePhone     = 0,//只在iPhone上load
    OTSMappingClassPlatformTypePad       = 1,//只在iPad上load
    OTSMappingClassPlatformTypeUniversal = 2,//任何平台都load
};

@interface OTSMappingVO : NSObject
/**
 *  创建的类名
 */
@property (nonatomic, strong) NSString *className;
/**
 *  创建的方式
 */
@property (nonatomic) OTSMappingClassCreateType createdType;
/**
 *  load过滤
 */
@property (nonatomic) OTSMappingClassPlatformType loadFilterType;
/**
 *  资源文件存放的bundle名称
 */
@property (nonatomic, strong) NSString *bundleName NS_DEPRECATED_IOS(6_0,7_0,"Pad的资源已经合并到Application Target中，不需要从bundle中取出来");
/**
 *  资源文件名称
 */
@property (nonatomic, strong) NSString *nibName;
/**
 *  storyboard名称
 */
@property (nonatomic, strong) NSString *storyboardName;
/**
 *  storyboard中storyboardID名称
 */
@property (nonatomic, strong) NSString *storyboardID;
/**
 *  进入此界面需要先登陆
 */
@property (nonatomic) BOOL needLogin;

@end



