//
//  AddressCell.h
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "AddressModel.h"

@interface AddressCell : YJTableViewCell

@property (nonatomic, strong) AddressModel *model;
@property (nonatomic,   copy) void (^myBlock)();

@end
