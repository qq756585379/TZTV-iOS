//
//  SubHomeVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SubHomeVC.h"
#import "HomePageCellTableViewCell.h"
#import "PLPlayerVC.h"
#import "YJTOOL.h"
#import "LiveListModel.h"
#import "NSArray+safe.h"
#import "HomeBannerCell.h"
#import "LiveListViewModel.h"
#import "PlaceHoldView.h"
#import "StartZhiBoTableVC.h"
#import "PLPlayerVC.h"

@interface SubHomeVC ()
@property (nonatomic, strong) LiveListViewModel *liveVM;
@property (nonatomic, strong) PlaceHoldView     *placeHoder;
@end

@implementation SubHomeVC

-(LiveListViewModel *)liveVM{
    if (!_liveVM) {
        _liveVM=[LiveListViewModel new];
    }
    return _liveVM;
}

-(PlaceHoldView *)placeHoder{
    if (!_placeHoder) {
        _placeHoder=[PlaceHoldView autolayoutView];
        WEAK_SELF
        _placeHoder.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf loadNewData];
        };
    }
    return _placeHoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=kF5F5F5;
    self.tableView.contentInset=UIEdgeInsetsMake(35, 0, 49+64, 0);
    [self.tableView registerNib:[HomePageCellTableViewCell nib] forCellReuseIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
    [self.tableView registerClass:[HomeBannerCell class] forCellReuseIdentifier:[HomeBannerCell cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyChangeAlpha=YES;
    self.tableView.mj_footer.automaticallyHidden=YES;
    [self loadNewData];
}

-(void)loadNewData{
    self.tableView.mj_footer.hidden=YES;
    [self.liveVM loadDataFromNetworkIsNewData:YES];
    RACSignal *signal = [self.liveVM.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        [self.tableView.mj_header endRefreshing];
        if (self.liveVM.modelArray.count==0) {
            [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder" buttonTitle:@"" show:YES];
        }else{
            [self showPlaceHolderViewWithInfo:nil imageName:nil buttonTitle:nil show:NO];
        }
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络似乎不通"
                                imageName:@"placeholder"
                              buttonTitle:@"刷新"
                                     show:(self.liveVM.modelArray.count==0)];
    } completed:^{
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:self.liveVM.msg
                                imageName:@"placeholder"
                              buttonTitle:@""
                                     show:(self.liveVM.modelArray.count==0)];
    }];
}

-(void)loadMoreData{
    [self.liveVM loadDataFromNetworkIsNewData:NO];
    RACSignal *signal = [self.liveVM.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        NSArray *arr=x;
        if (arr.count==0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } error:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    } completed:^{
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    [self.tableView reloadData];
    if (show) {
        [self.tableView addSubview:self.placeHoder];
        [self.placeHoder setInfo:info ImgName:img buttonTitle:title];
        [self.placeHoder autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.placeHoder autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-64];
        [self.placeHoder autoSetDimension:ALDimensionWidth toSize:ScreenW];
        [self.placeHoder autoSetDimension:ALDimensionHeight toSize:ScreenH];
    }else{
        if (self.placeHoder) {
            [self.placeHoder removeFromSuperview];
            self.placeHoder=nil;
        }
    }
}

#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.liveVM.modelArray.count?self.liveVM.modelArray.count+1:0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HomeBannerCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomeBannerCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
    }
    HomePageCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
//    cell.liveM=[self.liveVM.modelArray safeObjectAtIndex:indexPath.section-1];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [HomeBannerCell heightForCellData:nil];
    }
    return [HomePageCellTableViewCell heightForCellData:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0 || section==1) {
        return 0.1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end





