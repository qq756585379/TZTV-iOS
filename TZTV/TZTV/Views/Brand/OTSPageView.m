//
//  OTSPageView.m
//  OneStore
//
//  Created by huang jiming on 13-1-4.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//
#import "OTSPageView.h"
#import "UIScrollView+DeliverTouch.h"
#import "NSMutableArray+safe.h"
#import "NSArray+safe.h"

@interface OTSPageView ()
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger sleepTime;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) YJPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *contentViewArray;
@end

@implementation OTSPageView

- (id)initWithFrame:(CGRect)frame delegate:(id<OTSPageViewDelegate>)aDelegate
{
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        self.continuous = YES;
        self.delegate = aDelegate;
        //scroll view
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.deliverTouchEvent = YES;
        
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setDelegate:self];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<OTSPageViewDelegate>)aDelegate sleepTime:(NSInteger)aSleepTime
{
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        self.continuous = YES;
        self.delegate = aDelegate;
        self.sleepTime = aSleepTime;
        
        //scroll view
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //         self.scrollView.deliverTouchEvent = YES;
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setScrollsToTop:NO];
        [self.scrollView setDelegate:self];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.scrollView];
        
        [self reloadPageView];
    }
    return self;
}

-(YJPageControl *)getPageControl
{
    return self.pageControl;
}

- (void)setPageControlWithActiveColor:(UIColor *)activeColor withInactiveColor:(UIColor *)inactiveColor
{
    YJPageControl *pageControl = [[YJPageControl alloc] init];
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    pageControl.borderColor = [UIColor lightGrayColor];
    pageControl.fillColor = activeColor;
    pageControl.pageFillColor = inactiveColor;
    self.pageControl = pageControl;
    [self addSubview:self.pageControl];
    //
    [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.pageControl autoSetDimension:ALDimensionWidth toSize:ScreenW];
    
    [self reloadPageControl];
}

- (void)setPageControlWithActiveImage:(UIImage *)activeImage withInactiveImage:(UIImage *)inactiveImage{
    
    YJPageControl *pageControl = [[YJPageControl alloc] init];
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    pageControl.activeImage = activeImage;
    pageControl.inactiveImage = inactiveImage;
    
    self.pageControl = pageControl;
    [self addSubview:self.pageControl];
    [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [self.pageControl autoSetDimension:ALDimensionWidth toSize:ScreenW];
    
    [self reloadPageControl];
}

- (UIView *)viewForIndex:(NSInteger )aIndex
{
    return [self.contentViewArray safeObjectAtIndex:aIndex];
}

- (void)dealloc{
    self.scrollView.delegate = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    [self fireTimer];
    self.delegate = nil;
}

- (void)startTimer{
    if (self.pageCount > 1 && self.sleepTime > 0) {
        [self fireTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.sleepTime target:self selector:@selector(autoCyclePageView:) userInfo:nil repeats:YES];
    }
}

- (void)fireTimer{
    if (self.timer != nil) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.pageControl) {
        [self.pageControl sizeToFit];
        //		self.pageControl.centerX = self.width / 2.0f ;
        //		self.pageControl.bottom = self.height - 10;
    }
}

- (void)autoCyclePageView:(NSTimer *)timer{
    int frameWidth = self.frame.size.width;
    NSInteger totalPage = self.pageCount;
    if (totalPage <= 1) {
        return;
    }
    self.currentScrollPage ++;
    if (self.continuous) {
        if (self.currentScrollPage == totalPage) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.currentScrollPage = 0;
        }
    }
    if (_mode == KOTSPageViewLandscape) {
        [self.scrollView setContentOffset:CGPointMake(frameWidth * self.currentScrollPage, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, self.height * self.currentScrollPage) animated:YES];
    }
    NSInteger index = self.currentScrollPage;
    if (totalPage <= index) {
        index = 0;
    }
    if (self.pageControl != nil) {
        self.pageControl.currentPage = index;
    }
    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
        [self.delegate pageView:self didChangeToIndex:index];
    }
}

- (void)scroolToPageIndex:(NSInteger)index{
    if(index < 0 || index >= self.pageCount)
        return;
    float perPageWidth= self.width;
    if (_mode == KOTSPageViewLandscape) {
        [self.scrollView setContentOffset:CGPointMake(perPageWidth * index, 0)];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, self.height * index)];
    }
}

#pragma mark- Load PageView
- (void)unLoadContentViewAtIndex:(NSInteger )aIndex{
    if(aIndex < 0 || aIndex >= self.contentViewArray.count){
        return;
    }
    UIView *contentView = [self.contentViewArray safeObjectAtIndex:aIndex];
    if([contentView isKindOfClass:[UIView class]]){
        [contentView removeFromSuperview];
        [self.contentViewArray replaceObjectAtIndex:aIndex withObject:[NSNull null]];
    }
}

- (void)loadContentViewAtIndex:(NSInteger )aIndex{
    if(aIndex < 0 || aIndex >= self.contentViewArray.count){
        return;
    }
    UIView *contentView = [self.contentViewArray safeObjectAtIndex:aIndex];
    if([contentView isKindOfClass:[UIView class]] == NO){
        NSInteger pageIndex = aIndex;
        if (pageIndex == self.pageCount) {
            pageIndex = 0;
        }
        UIView * pageView = nil;
        if ([self.delegate respondsToSelector:@selector(pageView:pageAtIndexPath:)]) {
            pageView = [self.delegate pageView:self pageAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]];
        }
        if(pageView){
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            //子视图长宽随着父视图的改变而改变
            contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            //
            contentView.clipsToBounds = YES;
            [contentView addSubview:pageView];
            
            CGRect rect = [contentView frame];
            if (_mode == KOTSPageViewLandscape) {
                rect.origin.x = self.width * aIndex;
            } else {
                rect.origin.y = self.height * aIndex;
            }
            [contentView setFrame:rect];
            
            [self.scrollView addSubview:contentView];
            [self.contentViewArray replaceObjectAtIndex:aIndex withObject:contentView];
        }
    }
}

/**
 *	功能:设置某个位置的内容视图。一次只显示自己和相邻两边的视图。并删除上次已经显示完成的视图
 */
- (void)setContentViewAtIndex:(NSInteger)aIndex{
    self.currentScrollPage = aIndex;
    if(aIndex == self.pageCount){
        [self loadContentViewAtIndex:aIndex];
        [self setContentViewAtIndex:0];
        return;
    }
    [self loadContentViewAtIndex:aIndex - 1];
    [self loadContentViewAtIndex:aIndex];
    [self loadContentViewAtIndex:aIndex + 1];
    
    [self unLoadContentViewAtIndex:aIndex - 2];
    [self unLoadContentViewAtIndex:aIndex + 2];
}

- (void)reloadPageView{
    if ([self.delegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        self.pageCount = [self.delegate numberOfPagesInPageView:self];
    }
    self.currentScrollPage = 0;
    NSInteger totalPageCount = self.pageCount;
    if (self.continuous) {
        totalPageCount += 1;
    }
    if (self.pageCount == 1) {
        totalPageCount = 1;
    } else if (self.pageCount == 0) {
        totalPageCount = 0;
    }
    if(totalPageCount == 0){
        return;
    }
    
    //scroll view
    int frameWidth = self.frame.size.width;
    int frameHeight = self.frame.size.height;
    if (_mode == KOTSPageViewLandscape) {
        [self.scrollView setContentSize:CGSizeMake(frameWidth*totalPageCount+1, frameHeight)];
    } else {
        [self.scrollView setContentSize:CGSizeMake(frameWidth, frameHeight * totalPageCount)];
    }
    [self.scrollView setContentOffset:CGPointZero];
    
    for (UIView *contentView in self.contentViewArray) {
        if([contentView isKindOfClass:[UIView class]]){
            [contentView removeFromSuperview];
        }
    }
    self.contentViewArray = [[NSMutableArray alloc] initWithCapacity:totalPageCount];
    for (NSInteger index = 0; index < totalPageCount; index++) {
        [self.contentViewArray safeAddObject:[NSNull null]];
    }
    [self setContentViewAtIndex:0];
    [self reloadPageControl];
    
    //timer
    [self fireTimer];
    [self startTimer];
    
    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
        [self.delegate pageView:self didChangeToIndex:0];
    }
    [self layoutIfNeeded];
}

- (void)reloadPageControl{
    if (self.pageControl) {
        self.pageControl.numberOfPages = self.pageCount;
        if (self.pageCount > 1) {
            self.pageControl.hidden = NO;
        }else{
            self.pageControl.hidden = YES;
        }
    }
    self.pageControl.currentPage = 0;
}

#pragma mark- Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    int index = [self.scrollView contentOffset].x/self.scrollView.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(pageView:didTouchOnPage:)]) {
        [self.delegate pageView:self didTouchOnPage:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    [super touchesEnded:touches withEvent:event];
}

#pragma mark- scrollView
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(pageViewWillBeginDecelerating:)]){
        [self.delegate pageViewWillBeginDecelerating:self];
    }
}

- (void)scrollViewWillBeginDragging{
    [self fireTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.pageCount > 1 && self.sleepTime > 0) {
        [self fireTimer];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.sleepTime target:self selector:@selector(autoCyclePageView:) userInfo:nil repeats:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int frameWidth = self.frame.size.width;
    NSInteger totalPage = self.pageCount;
    if (totalPage <= 1) {
        return;
    }
    CGFloat pageWidth = aScrollView.width;
    CGFloat pageHeight = aScrollView.height;
    float fractionalPage  = 0;
    if (_mode == KOTSPageViewLandscape){
        fractionalPage = aScrollView.contentOffset.x / pageWidth;
    }else{
        fractionalPage = aScrollView.contentOffset.y / pageHeight;
    }
    NSInteger page = floor(fractionalPage);
    if (page != self.currentScrollPage) {
        [self setContentViewAtIndex:page];
    }
    
    if (_mode == KOTSPageViewLandscape) {
        if (self.continuous) {
            if (aScrollView.contentOffset.x < 0) {
                [aScrollView setContentOffset:CGPointMake(frameWidth*totalPage, 0)];
                self.currentScrollPage = totalPage;
            }
            if (aScrollView.contentOffset.x > frameWidth*totalPage) {
                self.currentScrollPage = 0;
                [aScrollView setContentOffset:CGPointMake(0, 0)];
            }
        }
    } else {
        if (self.continuous) {
            if (aScrollView.contentOffset.y < 0) {
                [aScrollView setContentOffset:CGPointMake(0, self.height*totalPage)];
                self.currentScrollPage = totalPage;
            }
            if (aScrollView.contentOffset.y > self.height*totalPage) {
                self.currentScrollPage = 0;
                [aScrollView setContentOffset:CGPointMake(0, 0)];
            }
        }
    }
    if (fractionalPage > (self.pageCount - 1) && !self.continuous) {
        if ([self.delegate respondsToSelector:@selector(scrollEndOfPageView:)]) {
            [self.delegate performSelector:@selector(scrollEndOfPageView:) withObject:self];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    int frameWidth = self.frame.size.width;
    NSInteger totalPage = self.pageCount;
    if (totalPage <= 1) {
        return;
    }
    int page = aScrollView.contentOffset.x / frameWidth;
    if (_mode == KOTSPageViewPortrait) {
        page = aScrollView.contentOffset.y / self.height;
    }
    self.currentScrollPage = page;
    if (self.continuous) {
        if (page == totalPage) {
            self.currentScrollPage = 0;
            [aScrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
        [self.delegate pageView:self didChangeToIndex:self.currentScrollPage];
    }
    NSInteger index = self.currentScrollPage;
    
    if (totalPage == 0) {
        return;
    }
    if (totalPage <= index) {
        index = 0;
    }
    if (self.pageControl) {
        self.pageControl.currentPage = index;
    }
}

@end





