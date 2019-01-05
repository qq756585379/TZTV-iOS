//
//  BrandDetailHeadImageView.h
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OTSPageView;

typedef void(^OTSTouchImageBlock)(NSInteger index);

@interface BrandDetailHeadImageView : UIView

/**
 *  获取OTSPageView
 */
- (OTSPageView *)getPageView;

@property(nonatomic, strong)NSArray *imageUrlArray;

@property(nonatomic,   copy)OTSTouchImageBlock touchImageBlock;

- (void)showItemAtIndex:(NSInteger)aIndex;

@end
