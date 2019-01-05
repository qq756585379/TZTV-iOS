//
//  YJTOOL.h
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJTOOL : NSObject

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatusInView:(id)vc;
/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatusInView:(id)vc;

+(UINavigationController *)getRootControllerSelectedVc;

//冒星星效果
+ (void)showMoreLoveAnimateFromView:(UIView *)fromView addToView:(UIView *)addToView;

@end
