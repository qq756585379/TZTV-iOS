//
//  BrandDetailCell2.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandDetailCell2.h"

@interface BrandDetailCell2()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@end

@implementation BrandDetailCell2

+ (CGFloat)heightForCellData:(id)aData
{
    CGSize size = [@"2131311" sizeWithFont:YJFont(14) maxW:ScreenW-40];
    return size.height+90;
}

@end
