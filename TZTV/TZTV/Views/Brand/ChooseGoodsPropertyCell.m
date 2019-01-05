//
//  ChooseGoodsPropertyCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/19.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChooseGoodsPropertyCell.h"
#import "NSArray+safe.h"

@implementation ChooseGoodsPropertyCell

-(void)configColorWith:(NSArray *)arr withIdx:(NSInteger)idx0
{
    self.topLabel.text=@"颜色分类";
    
    [self.containerView removeAllTags];
    // 这东西非常关键
    self.containerView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40;
    self.containerView.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    self.containerView.lineSpacing = 20;
    self.containerView.interitemSpacing = 11;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
        tag.font = [UIFont boldSystemFontOfSize:13];
        tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        tag.cornerRadius = 5;
        tag.borderWidth = 0;
        if (idx0==idx) {
            tag.textColor = [UIColor whiteColor];
            tag.bgColor = YJNaviColor;
        }else{
            tag.textColor = HEXRGBCOLOR(0x333333);
            tag.bgColor = kF5F5F5;
        }
        [self.containerView addTag:tag];
    }];
}

-(void)configSizeWith:(NSArray *)arr withIdx:(NSInteger)idx1
{
    self.topLabel.text=@"尺码";
    [self.containerView removeAllTags];
    // 这东西非常关键
    self.containerView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40;
    self.containerView.padding = UIEdgeInsetsMake(5, 10, 5, 10);
    self.containerView.lineSpacing = 20;
    self.containerView.interitemSpacing = 11;
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [[SKTag alloc] initWithText:arr[idx][@"product_size"]];
        tag.font = [UIFont boldSystemFontOfSize:13];
        tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        tag.cornerRadius = 5;
        tag.borderWidth = 0;
        if (idx1==idx) {
            tag.textColor = [UIColor whiteColor];
            tag.bgColor = YJNaviColor;
        }else{
            tag.textColor = HEXRGBCOLOR(0x333333);
            tag.bgColor = kF5F5F5;
        }
        [self.containerView addTag:tag];
    }];
}

@end
