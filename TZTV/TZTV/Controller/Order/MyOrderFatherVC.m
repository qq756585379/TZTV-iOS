//
//  MyOrderFatherVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderFatherVC.h"
#import "MyOrderSonVC.h"
#import "OTSBorder.h"
#import "UIBarButtonItem+Create.h"

@interface MyOrderFatherVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic,   weak) UIButton       *selectedTitleButton;
@property (nonatomic, strong) UIView        *indicatorView;
@property (nonatomic, strong) UIView        *titlesView;
@end

@implementation MyOrderFatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的订单";
    [self addChildViewControllers];
    [self setupScrollView];
    [self setupTitlesView];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"return" highImage:@"return" target:self action:@selector(back)];
}

-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSArray *)titlesArray
{
    return @[@"全部",@"待支付",@"待发货",@"待收货",@"已完成"];
}

- (void)addChildViewControllers
{
    for (int i=0; i<[self titlesArray].count; i++) {
        MyOrderSonVC *sub = [[MyOrderSonVC alloc] init];
        sub.type=i;
        [self addChildViewController:sub];
    }
}

- (void)setupScrollView{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kFAFAFA;
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
    self.titlesView = [[UIView alloc] init];
    self.titlesView.backgroundColor = kF5F5F5;
    self.titlesView.frame = CGRectMake(0, 0, self.view.width, 35);
    [self.view addSubview:self.titlesView];
    // 添加标题
    NSUInteger count = 5;
    CGFloat titleButtonW = self.titlesView.width / count;
    CGFloat titleButtonH = self.titlesView.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateDisabled];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:[self titlesArray][i] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton.titleLabel sizeToFit];
        [self.titlesView addSubview:titleButton];
    }
    
    [OTSBorder addBorderWithView:self.titlesView type:OTSBorderTypeBottom andColor:kEDEDED];

    // 底部的指示器
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = YJNaviColor;
    self.indicatorView.height = 2;
    self.indicatorView.y = self.titlesView.height - self.indicatorView.height;
    [self.titlesView addSubview:self.indicatorView];
    
    UIButton *titleButton = self.titlesView.subviews[_type];
    titleButton.enabled=NO;
    self.selectedTitleButton=titleButton;
    [self titleClick:titleButton];
    //如果是第一个按钮的话scrollView的setContentOffset:0并没有滚动，所以没有进入代理方法，需要自己[self addChildVcView];
    [self addChildVcView];
}

- (void)titleClick:(UIButton *)titleButton{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
    }
    // 控制按钮状态
    self.selectedTitleButton.enabled = YES;
    titleButton.enabled = NO;
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

- (void)addChildVcView{
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    UIButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    [self addChildVcView];
}

@end
