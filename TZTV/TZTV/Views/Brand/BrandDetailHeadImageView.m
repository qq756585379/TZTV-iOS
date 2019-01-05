//
//  BrandDetailHeadImageView.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandDetailHeadImageView.h"
#import "OTSPageView.h"
#import "NSArray+safe.h"

@interface BrandDetailHeadImageView()<OTSPageViewDelegate>
@property(nonatomic, strong)OTSPageView *imagePageView;
@end

@implementation BrandDetailHeadImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.imagePageView];
    }
    return self;
}

- (OTSPageView *)imagePageView{
    if (_imagePageView == nil) {
        _imagePageView = [[OTSPageView alloc] initWithFrame:self.bounds delegate:self];
        _imagePageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_imagePageView setPageControlWithActiveColor:[UIColor whiteColor] withInactiveColor:[UIColor lightGrayColor]];
        _imagePageView.continuous = NO;
    }
    return _imagePageView;
}

-(OTSPageView *)getPageView{
    return self.imagePageView;
}

-(void)setImageUrlArray:(NSArray *)imageUrlArray{
    _imageUrlArray=imageUrlArray;
    [self.imagePageView reloadPageView];
}

#pragma mark- OTSPageDelegate
- (UIView *)pageView:(OTSPageView *)pageView pageAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:pageView.bounds];
    NSString *picUrl = [self.imageUrlArray safeObjectAtIndex:indexPath.row];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:picUrl]
                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
    imageView.image=[UIImage imageNamed:@"placeholder"];
    return imageView;
}

- (NSInteger)numberOfPagesInPageView:(OTSPageView *)pageView{
    return self.imageUrlArray.count;
}

- (void)pageView:(OTSPageView *)pageView didTouchOnPage:(NSIndexPath *)indexPath{
    if (self.touchImageBlock) {
        self.touchImageBlock(indexPath.row);
    }
}

- (void)pageView:(OTSPageView *)pageView didChangeToIndex:(NSInteger)aIndex{
    //把当前展示的view置于front，用于放大显示。
    UIView *superV = [pageView.contentViewArray objectAtIndex:aIndex];
    [superV.superview bringSubviewToFront:superV];
}

- (void)showItemAtIndex:(NSInteger)aIndex{
    [self.imagePageView scroolToPageIndex:aIndex];
}

//- (void)handleNotification:(NSNotification *)notification{
//    self.imagePageView.frame = self.bounds;
//    [self.imagePageView reloadPageView];
//}

@end
