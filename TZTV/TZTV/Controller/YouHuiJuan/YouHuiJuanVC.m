//
//  YouHuiJuanVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "YouHuiJuanVC.h"
#import "YouHuiJuanSubVC.h"
#import "OTSBorder.h"

@interface YouHuiJuanVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *indicatorView;
/** 标题栏 */
@property (nonatomic,   weak) UIView        *titlesView;
@property (nonatomic,   weak) UIButton      *selectedTitleButton;
@end

@implementation YouHuiJuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的优惠券";
    [self setupChildViewControllers];
    [self setupScrollView];
    [self setupTitlesView];
    // 默认添加子控制器的view
    [self addChildVcView];
}

- (void)setupChildViewControllers{
    YouHuiJuanSubVC *vc1=[[YouHuiJuanSubVC alloc] init];
    vc1.type=YouHuiJuanTypeXianShang;
    
    YouHuiJuanSubVC *vc2=[[YouHuiJuanSubVC alloc] init];
    vc2.type=YouHuiJuanTypeXianXia;
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
}

- (void)setupScrollView{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kF5F5F5;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = kF5F5F5;
    titlesView.frame = CGRectMake(0, 0, self.view.width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    // 添加标题
    NSUInteger count = 2;
    CGFloat titleButtonW = (titlesView.width-1)/ count;
    CGFloat titleButtonH = titlesView.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [titleButton setTitle:i==0?@"线上代金券":@"线下优惠卷" forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(i * (titleButtonW+1), 0, titleButtonW, titleButtonH);
    }
    UIButton *firstTitleButton = titlesView.subviews.firstObject;
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = YJNaviColor;
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height - 1;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.width = firstTitleButton.titleLabel.width;
    indicatorView.centerX = firstTitleButton.centerX;
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
    //最后添加border不然会报错
    [OTSBorder addBorderWithView:titlesView type:OTSBorderTypeBottom andColor:[UIColor lightGrayColor]];
}

- (void)addChildVcView{
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

- (void)titleClick:(UIButton *)titleButton{
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = titleButton.titleLabel.width;
        self.indicatorView.centerX = titleButton.centerX;
    }];
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self addChildVcView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    UIButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    [self addChildVcView];
}

@end
