//
//  PLGoodsView.m
//  TZTV
//
//  Created by Luosa on 2017/2/21.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGoodsView.h"
#import "OTSBorder.h"
#import "PLGoodsTV.h"

@interface PLGoodsView()<UIScrollViewDelegate>
@property (nonatomic,   weak) UIView *topView;
@property (nonatomic,   weak) UIView *indicatorView;

@property (nonatomic,   weak) PLGoodsTV *firstTV;
@property (nonatomic,   weak) PLGoodsTV *secondTV;

@property (nonatomic,   weak) UIButton *selectedTitleButton;
@property (nonatomic, strong) UIScrollView  *scrollView;
@end

@implementation PLGoodsView

+(CGFloat)view_height{
    return 400;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupScrollView];
        [self setUpTableView];
        [self setupTitlesView];
    }
    return self;
}

-(void)setLive_user_id:(NSString *)live_user_id{
    _live_user_id=live_user_id;
    self.firstTV.live_user_id=live_user_id;
    self.secondTV.live_user_id=live_user_id;
    [self.firstTV loadNewData];
    [self.secondTV loadNewData];
}

- (void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kF5F5F5;
    scrollView.frame = CGRectMake(0, 40, ScreenW, 400-40);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(2 * ScreenW, 0);
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, 0,ScreenW, 40);
    titlesView.backgroundColor=kWhiteColor;
    [self addSubview:titlesView];
    self.topView = titlesView;
    
    CGFloat titleButtonW = 70;
    CGFloat titleButtonH = titlesView.height;
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstButton setTitleColor:HEXRGBCOLOR(0x999999) forState:UIControlStateNormal];
    [firstButton setTitleColor:YJNaviColor forState:UIControlStateSelected];
    firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [firstButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [titlesView addSubview:firstButton];
    [firstButton setTitle:@"本期商品" forState:UIControlStateNormal];

    firstButton.frame = CGRectMake(ScreenW/4-titleButtonW/2, 0, titleButtonW, titleButtonH);
    firstButton.tag=0;
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondButton setTitleColor:HEXRGBCOLOR(0x999999) forState:UIControlStateNormal];
    [secondButton setTitleColor:YJNaviColor forState:UIControlStateSelected];
    secondButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [secondButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [titlesView addSubview:secondButton];
    [secondButton setTitle:@"历史商品" forState:UIControlStateNormal];

    secondButton.frame = CGRectMake(ScreenW*3/4-titleButtonW/2, 0, titleButtonW, titleButtonH);
    secondButton.tag=1;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = YJNaviColor;
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height - 1;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    // 立刻根据文字内容计算label的宽度
    [firstButton.titleLabel sizeToFit];
    indicatorView.width = firstButton.titleLabel.width;
    indicatorView.centerX = firstButton.centerX;
    // 默认情况 : 选中最前面的标题按钮
    firstButton.selected = YES;
    self.selectedTitleButton = firstButton;
    [OTSBorder addBorderWithView:titlesView type:OTSBorderTypeBottom andColor:kF5F5F5];
}

-(void)setUpTableView{
    PLGoodsTV *tv1=[[PLGoodsTV alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 400-40) style:UITableViewStylePlain];
    [self.scrollView addSubview:tv1];
    tv1.type=@0;
    self.firstTV=tv1;
    
    PLGoodsTV *tv2=[[PLGoodsTV alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, 400-40) style:UITableViewStylePlain];
    [self.scrollView addSubview:tv2];
    tv2.type=@1;
    self.secondTV=tv2;
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

}
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    UIButton *titleButton = self.topView.subviews[index];
    [self titleClick:titleButton];
}

- (void)titleClick:(UIButton *)titleButton{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
    }
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;

    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = titleButton.titleLabel.width;
        self.indicatorView.centerX = titleButton.centerX;
    }];
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

@end






