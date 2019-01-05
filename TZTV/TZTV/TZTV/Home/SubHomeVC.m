//
//  SubHomeVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SubHomeVC.h"
#import "OTSCyclePageView.h"
#import "OTSPlaceholderImageView.h"
#import "OTSPageControl.h"
#import "HomePageCellTableViewCell.h"
#import "PLPlayerVC.h"

@interface SubHomeVC ()<OTSCyclePageViewDataSource, OTSCyclePageViewDelegate>
@property(nonatomic, strong) OTSCyclePageView *dynamicLaunchView;
//@property(nonatomic, assign) NSInteger  currentPage;
@end

@implementation SubHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=YJGlobalBg;
    self.tableView.contentInset=UIEdgeInsetsMake(35, 0, 49+64, 0);
    self.tableView.tableHeaderView=self.dynamicLaunchView;
    [self.dynamicLaunchView reloadData];
    [self.tableView registerNib:[HomePageCellTableViewCell nib] forCellReuseIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData{
    [self.tableView.mj_header endRefreshing];
}

#pragma mark- Property
- (OTSCyclePageView *)dynamicLaunchView{
    if (_dynamicLaunchView == nil) {
        _dynamicLaunchView = [[OTSCyclePageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*360/750)];
        _dynamicLaunchView.backgroundColor = [UIColor whiteColor];
        _dynamicLaunchView.delegate = self;
        _dynamicLaunchView.dataSource = self;
        _dynamicLaunchView.disableCycle = NO;//禁止循环
        _dynamicLaunchView.autoRunPage = YES;
        _dynamicLaunchView.interval = 3.f;
        _dynamicLaunchView.disableClickEffect = YES;

        OTSPageControl *pageControl = [[OTSPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dynamicLaunchView.frame)-20,CGRectGetWidth(_dynamicLaunchView.frame), 20)];
        pageControl.hidesForSinglePage = YES;
        _dynamicLaunchView.pageControl = pageControl;
        [_dynamicLaunchView addSubview:pageControl];
    }
    return _dynamicLaunchView;
}

#pragma mark - OTSCyclePageViewDataSource
- (NSUInteger)numberOfPagesInPageView:(OTSCyclePageView *)aPageView{
    return 6;
}
- (UIView *)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex{
    OTSPlaceholderImageView *imageView = [[OTSPlaceholderImageView alloc] initWithFrame:aPageView.bounds];
    imageView.image=[UIImage imageNamed:@"banner"];
    return imageView;
}
#pragma mark - OTSCyclePageViewDelegate
- (void)pageView:(OTSCyclePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex{
    YJLog(@"didSelectedPageAtIndex");
}
//功能:从当前页 切换另一页时,此方法会被调用
- (void)pageView:(OTSCyclePageView *)pageView didChangeToIndex:(NSUInteger)aIndex{
    
}
//功能:滑动到最后一页继续往后滑动
- (void)pageViewScrollEndOfPage:(OTSCyclePageView *)aPageView{
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomePageCellTableViewCell cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"PLPlayerVC"] animated:YES];
    
}

@end
