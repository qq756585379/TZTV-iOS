//
//  SortButton.h
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SortButtonType) {
    typeAscending   =0, //升序
    typeDescending  =1, //降序
    typeNormal      =2
};

@interface SortButton : UIButton

@property (nonatomic, assign) SortButtonType sortType;

@end
