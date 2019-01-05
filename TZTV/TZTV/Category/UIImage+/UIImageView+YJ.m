//
//  UIImageView+YJ.m
//  klxc
//
//  Created by sctto on 16/4/28.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "UIImageView+YJ.h"
#import "UIImage+YJ.h"

@implementation UIImageView (YJ)

- (void)setCircleImage:(NSString *)url andPlaceHolderImg:(NSString *)placeholdImg{
    UIImage *placeholder = [[UIImage imageNamed:placeholdImg] circleImage];
    WEAK_SELF
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.image = image ? [image circleImage] : placeholder;
    }];
}

@end
