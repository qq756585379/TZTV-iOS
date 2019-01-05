//
//  CityListCell.h
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

@interface CityListCell : YJTableViewCell

@property (nonatomic, strong) NSArray *cityArray;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end
