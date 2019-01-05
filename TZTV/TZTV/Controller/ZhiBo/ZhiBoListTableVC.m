//
//  ZhiBoListTableVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ZhiBoListTableVC.h"
#import "PlaceHoldView.h"
#import "LiveListViewModel.h"
#import "HomePageCellTableViewCell.h"
#import "KRVideoPlayerController.h"
#import "LiveListModel.h"

@interface ZhiBoListTableVC ()
@property (nonatomic, strong) LiveListViewModel *liveVM;
@property (nonatomic, strong) PlaceHoldView     *placeHoder;
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation ZhiBoListTableVC

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
    self.title=@"直播列表";
    self.tableView.backgroundColor=kF5F5F5;
    [self.tableView registerNib:[HomePageCellTableViewCell nib] forCellReuseIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
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
    return self.liveVM.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
    cell.homeModel2=[self.liveVM.modelArray safeObjectAtIndex:indexPath.section];
    cell.scrollCollectionView.hidden=YES;
    cell.block=^(HomeModel2 *homeModel2){
        NSURL *playerUrl = [NSURL URLWithString:homeModel2.live_rtmp_play_url];
        [self playVideoWithURL:playerUrl];
//        [self.videoController fullScreenButtonClick];//全屏
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 + ScreenW * 420/750;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
//在plist文件中，加入View controller-based status bar appearance项，并设置为NO。这样，就能通过代码来显示&隐藏电量条。
- (void)playVideoWithURL:(NSURL *)url{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController dismiss];
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
}


@end
