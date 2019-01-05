//
//  AppTabItemVO.h
//  YJMall
//
//  Created by 杨俊 on 2019/1/4.
//  Copyright © 2019年 杨俊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppTabItemVO : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *redPoint;

@property (nonatomic, strong) NSString *iconOff;    //url
@property (nonatomic, strong) NSString *iconOn;     //url

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSNumber *viewed;
@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, assign) BOOL showWord;

@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) UIImage  *selectedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *hostString;
@property (nonatomic, strong) NSString *selectHexColor;

@end

NS_ASSUME_NONNULL_END
