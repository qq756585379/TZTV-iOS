//
//  BrandCategoryModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandSubModel : NSObject
@property (nonatomic, assign) NSNumber *catalog_label_id;
@property (nonatomic,   copy) NSString *catalog_pic;
@property (nonatomic, assign) NSNumber *ID;
@property (nonatomic,   copy) NSString *label_name;
@property (nonatomic,   copy) NSString *name;
@end

@interface BrandRightModel : NSObject
@property (nonatomic,   copy) NSString          *catalog_label;
@property (nonatomic, strong) NSMutableArray    *sub_list;
@end

@interface BrandCategoryModel : NSObject
@property (nonatomic, assign) NSNumber *ID;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic, strong) NSArray  *rightArr;
@end

/*
 {
 id = 88,
 name = 推荐
 },
 */
