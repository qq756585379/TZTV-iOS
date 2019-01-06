//
//  BrandDetailVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandCategoryModel.h"
#import "BrandRecommendModel.h"

@interface BrandDetailVC : YJViewController

//0表示为你推荐里的品牌馆点击进入 brandModel        1表示为你推荐下面的分类点击进入 subModel   不同进入需请求的url不同
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) BrandModel    *brandModel;
@property (nonatomic, strong) BrandSubModel *subModel;


@end
