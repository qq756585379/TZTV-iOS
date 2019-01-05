//
//  UIImage+YJ.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YJ)

//圆形图片
- (UIImage *)circleImage;


/**根据传入的宽度，按原先的宽高比进行压缩*/
- (UIImage *)yj_imageWithScale:(CGFloat)width;

/**返回指定尺寸的图片*/
- (UIImage *)yp_imageWithScaleSize:(CGSize)scaleSize;
/**返回指定尺寸的图片  等比例压缩*/
- (UIImage *)yp_imageCompressForSize:(CGSize)size;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

//水印二维码
+ (UIImage *)createImagewithBgImage:(UIImage *)bgImg andForeImage:(UIImage *)foreImg;

+ (UIImage*)imageWithColor:(UIColor *)color forSize:(CGSize)size;

@end
