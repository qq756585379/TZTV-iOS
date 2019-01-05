//
//  OTSDataNaviBtn.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "OTSDataNaviBtn.h"

static const CGFloat OTSUpdownLayoutNaviBtnImgWidth     = 24.0;
static const CGFloat OTSUpdownLayoutNaviBtnTitleHeight  = 14.0;

@implementation OTSDataNaviBtn

@end




@implementation OTSUpdownLayoutNaviBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width/2-OTSUpdownLayoutNaviBtnImgWidth/2, contentRect.size.height/2-(OTSUpdownLayoutNaviBtnImgWidth+OTSUpdownLayoutNaviBtnTitleHeight)/2, OTSUpdownLayoutNaviBtnImgWidth, OTSUpdownLayoutNaviBtnImgWidth);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height/2-(OTSUpdownLayoutNaviBtnImgWidth+OTSUpdownLayoutNaviBtnTitleHeight)/2+OTSUpdownLayoutNaviBtnImgWidth, contentRect.size.width, OTSUpdownLayoutNaviBtnTitleHeight);
}

@end
