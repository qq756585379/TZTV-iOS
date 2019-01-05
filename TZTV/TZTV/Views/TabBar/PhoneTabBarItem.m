//
//  PhoneTabBarItem.m
//  YJMall
//
//  Created by 杨俊 on 2019/1/4.
//  Copyright © 2019年 杨俊. All rights reserved.
//

#import "PhoneTabBarItem.h"

@implementation PhoneTabBarItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textColor = [YJColor colorWithRGB:0x757575];
        self.imageInsets = UIEdgeInsetsMake(0, 0, 6, 0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        if (self.vo.selectHexColor) {
            self.titleLabel.textColor = [YJColor hex:self.vo.selectHexColor];
        }else{
            self.titleLabel.textColor = [YJColor colorWithRGB:0xfede0a];
        }
    }else {
        self.titleLabel.textColor = [YJColor colorWithRGB:0x757575];
    }
}

- (BOOL)shouldUpdateWithItemVO:(AppTabItemVO *)aVO{
    if (!aVO.updateTime) {
        return NO;
    }
    if ([self.vo.updateTime isEqualToString:aVO.updateTime]) {
        return NO;
    }
    return YES;
}

- (void)setShowIndicate:(BOOL)showIndicate{
    if (self.showIndicate && !showIndicate) {
        self.vo.viewed = @1;
        //        [self postNotification:@"updateTabVO" withObject:self];
    }
    [super setShowIndicate:showIndicate];
}

-(void)setVo:(AppTabItemVO *)vo{
    if (!vo) return;
    _vo = vo;
    self.title = vo.title;
    if (self.title.length > 5) {
        self.title = [self.title substringToIndex:5];
    }
    if (!vo.viewed.boolValue && self.showIndicate != vo.redPoint.boolValue) {
        self.showIndicate = vo.redPoint.boolValue;
    }
    self.image = vo.image;
    self.selectedImage = vo.selectedImage;
    self.hostString = vo.hostString;
    self.showWord = vo.showWord;
    
    if (vo.iconOff) {
        WEAK_SELF
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:vo.iconOff] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            STRONG_SELF;
            if ( ! error && finished) {
                self.image = image;
            }
        }];
    }
    
    if (vo.iconOn) {
        WEAK_SELF
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:vo.iconOff] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            STRONG_SELF;
            if ( ! error && finished) {
                self.selectedImage = image;
            }
        }];
    }
}

@end
