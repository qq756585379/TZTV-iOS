//
//  HomeVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomeVC.h"
#import "UISearchBar+YJ.h"
#import "SearchVC.h"
#import "YJNav.h"
#import "UIButton+LayoutStyle.h"
#import "SubHomeVC.h"
#import "OTSBorder.h"
#import "CityListVC.h"
#import "YJTOOL.h"
#import "YJWebViewController.h"

@interface HomeVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic,   weak) UIButton      *selectedTitleButton;
@property (nonatomic, strong) UIView        *indicatorView;
/** 标题栏 */
@property (nonatomic,   weak) UIView *titlesView;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupChildViewControllers];
    [self setupScrollView];
    [self setupTitlesView];
    // 默认添加子控制器的view
    [self addChildVcView];
}

-(void)setupNav{
    self.title=@"首页";
    NSString *city = [YJUserDefault getValueForKey:CurrentCityKey];
    UIButton *btn=[UIButton createButtonWithFrame:CGRectMake(-10, 0, 60, 30) text:city.length?city:@"上海"
                                        textColor:HEXRGBCOLOR(0x333333) font:YJFont(14) image:@"drop_down" bgImage:nil superView:nil];
    [btn setLayout:OTSTitleLeftImageRightStyle spacing:3];
    [btn addTarget:self action:@selector(goToSelectCityVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cityChooseBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=cityChooseBtn;
}

#pragma mark - 去选择城市
-(void)goToSelectCityVC:(UIButton *)sender{
    CityListVC *cityVC=[[CityListVC alloc] init];
    [self.navigationController pushViewController:cityVC animated:YES];
    WEAK_SELF
    cityVC.selectCityBlock=^(NSString *cityName){
        if (cityName.length) {
            [sender setTitle:cityName forState:UIControlStateNormal];
            NSUInteger index = weakSelf.scrollView.contentOffset.x / weakSelf.scrollView.width;
            UITableViewController *childVc = weakSelf.childViewControllers[index];
            [childVc.tableView.mj_header beginRefreshing];
        }
    };
}

-(NSArray *)titlesArray
{
    return @[@"推荐",@"活动",@"大牌",@"品质生活",@"首发",@"值得买"];
}

- (void)setupChildViewControllers{
    for (int i=0; i<[self titlesArray].count; i++) {
        SubHomeVC *sub = [[SubHomeVC alloc] init];
        sub.type=i+1;
        [self addChildViewController:sub];
    }
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
    titlesView.backgroundColor = kFAFAFA;
    titlesView.frame = CGRectMake(0, 0, self.view.width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    // 添加标题
    NSUInteger count = [self titlesArray].count;
    CGFloat titleButtonW = titlesView.width / count;
    CGFloat titleButtonH = titlesView.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [titleButton setTitle:[self titlesArray][i] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    UIButton *firstTitleButton = titlesView.subviews.firstObject;
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = YJNaviColor;
    //indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
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

- (void)titleClick:(UIButton *)titleButton{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
    }
    // 控制按钮状态
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
