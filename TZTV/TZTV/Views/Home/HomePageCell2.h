//
//  HomePageCell2.h
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

@interface HomePageCell2 : YJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (nonatomic, strong) LiveListModel *listModel;

@property (nonatomic,   copy) void(^block)(LiveListModel *listModel);

@end
