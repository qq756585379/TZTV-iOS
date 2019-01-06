//
//  CityListVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

@interface CityListVC : YJTableViewController

@property (nonatomic,  copy) void(^selectCityBlock)(NSString *cityName);

@end
