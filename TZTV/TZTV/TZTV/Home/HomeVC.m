//
//  HomeVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomeVC.h"
#import "UISearchBar+YJ.h"
#import "BaseBtn.h"
#import "SearchVC.h"
#import "YJNav.h"
#import "HomepageTitleView.h"
#import "UIButton+LayoutStyle.h"
#import "SubHomeVC.h"
#import "OTSBorder.h"
#import "CityListVC.h"

@interface HomeVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic,   weak) BaseBtn       *selectedTitleButton;
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
    HomepageTitleView *titleView=[[HomepageTitleView alloc] initWithFrame:CGRectMake(0, 7, 220, 30)];
    titleView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    [titleView doBorderWidth:1 color:[UIColor whiteColor] cornerRadius:4];
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSearchVC)]];
    self.navigationItem.titleView = titleView;
    
    BaseBtn *btn=(BaseBtn *)[BaseBtn createButtonWithFrame:CGRectMake(0, 0, 50, 30) text:@"上海" textColor:HEXRGBCOLOR(0x333333) font:YJFont(15) image:@"drop_down" bgImage:nil superView:nil];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setLayout:OTSTitleLeftImageRightStyle spacing:3];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[CityListVC alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
     }];
    UIBarButtonItem *cityChooseBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=cityChooseBtn;
}

-(NSArray *)titlesArray{
    return @[@"推荐",@"活动",@"大牌",@"品质生活",@"首发",@"值得买"];
}

- (void)setupChildViewControllers{
    for (int i=0; i<[self titlesArray].count; i++) {
        SubHomeVC *sub=[[SubHomeVC alloc] initWithStyle:UITableViewStyleGrouped];
        sub.type=i+1;
        [self addChildViewController:sub];
    }
}

- (void)setupScrollView{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = YJGlobalBg;
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
    titlesView.backgroundColor = HEXRGBCOLOR(0xededed);
    titlesView.frame = CGRectMake(0, 0, self.view.width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    // 添加标题
    NSUInteger count = [self titlesArray].count;
    CGFloat titleButtonW = titlesView.width / count;
    CGFloat titleButtonH = titlesView.height;
    for (NSUInteger i = 0; i < count; i++) {
        BaseBtn *titleButton = [BaseBtn buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
        [titleButton setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [titleButton setTitle:[self titlesArray][i] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    BaseBtn *firstTitleButton = titlesView.subviews.firstObject;
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

- (void)titleClick:(BaseBtn *)titleButton{
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
    BaseBtn *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    // 添加子控制器的view
    [self addChildVcView];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    [self goToSearchVC];
    return NO;
}

-(void)goToSearchVC{
//    SearchVC *vc=[SearchVC new];
//    YJNav *searchNav=[[YJNav alloc] initWithRootViewController:vc];
//    [self.navigationController presentViewController:searchNav animated:NO completion:nil];
}

//- (UISearchBar *)mySearchBar{
//    if (!_mySearchBar) {
//        _mySearchBar = [[MainSearchBar alloc] initWithFrame:CGRectMake(60,0, ScreenW-115, 31)];
//        [_mySearchBar setContentMode:UIViewContentModeLeft];
//        [_mySearchBar setPlaceholder:@"快搜我，有惊喜"];
//        _mySearchBar.delegate = self;
//        _mySearchBar.layer.cornerRadius=15;
//        _mySearchBar.layer.masksToBounds=TRUE;
//        [_mySearchBar.layer setBorderWidth:8];
//        [_mySearchBar.layer setBorderColor:[UIColor whiteColor].CGColor];//设置边框为白色
//        [_mySearchBar sizeToFit];
//        [_mySearchBar setHeight:30];
//        //[_mySearchBar setTintColor:[UIColor whiteColor]];
//        [_mySearchBar insertBGColor:[UIColor colorWithWhite:1 alpha:0.9]];
//        //[_mySearchBar.scanBtn addTarget:self action:@selector(scanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _mySearchBar;
//}


@end
