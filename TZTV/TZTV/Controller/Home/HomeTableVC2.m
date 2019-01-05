//
//  HomeTableVC2.m
//  TZTV
//
//  Created by Luosa on 2017/2/27.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "HomeTableVC2.h"
#import "PlaceHoldView.h"
#import "HomePageCellTableViewCell.h"
#import "HomeBannerCell.h"
#import "HomeModel2.h"
#import "KRVideoPlayerController.h"
#import "HomeViewModel2.h"
#import "HomeButtomCell.h"
#import "YJWebViewController.h"
#import "FenLeiSearchVC.h"
#import "YJNav.h"

@interface HomeTableVC2 ()
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@property (nonatomic, strong) HomeViewModel2 *viewModel;
@property (nonatomic, assign) int page;
@end

@implementation HomeTableVC2

-(HomeViewModel2 *)viewModel{
    if (!_viewModel) {
        _viewModel=[HomeViewModel2 new];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarHidden = NO;
    self.tableView.backgroundColor=kF5F5F5;
    [self.tableView registerNib:[HomePageCellTableViewCell nib]
         forCellReuseIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
    [self.tableView registerNib:[HomeButtomCell nib] forCellReuseIdentifier:[HomeButtomCell cellReuseIdentifier]];
    [self.tableView registerClass:[HomeBannerCell class] forCellReuseIdentifier:[HomeBannerCell cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuzi_word"]];
    UIImage *image = [UIImage imageNamed:@"search"];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithImage:image
                                                                highImage:image
                                                                   target:self
                                                                   action:@selector(rightClicked)];
    [self loadNewData];
}

-(void)rightClicked{
    FenLeiSearchVC *vc=[FenLeiSearchVC new];
    YJNav *nvc = [[YJNav alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

-(void)loadNewData{
    [MBProgressHUD showMessage:@""];
    [self.tableView.mj_footer endRefreshing];
    [[self.viewModel getDataWithJson:@{}] subscribeNext:^(id x) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showToast:@"网络不太好"];
        [self.tableView reloadData];
    }];
}

-(void)loadMoreData{
    [MBProgressHUD showMessage:@""];
    [[self.viewModel getMoreDataWithJson:@{}] subscribeNext:^(id x) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showToast:@"网络不太好"];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.viewModel.topArray.count+self.viewModel.buttomArray.count+1;
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HomeBannerCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomeBannerCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
//    }else if (indexPath.section>self.viewModel.topArray.count){
    } else if (indexPath.section<3) {
        HomeButtomCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomeButtomCell cellReuseIdentifier] forIndexPath:indexPath];
//        cell.buttomModel=[self.viewModel.buttomArray safeObjectAtIndex:indexPath.section-self.viewModel.topArray.count-1];
        return cell;
    }else{
        HomePageCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomePageCellTableViewCell cellReuseIdentifier]];
//        cell.homeModel2=[self.viewModel.topArray safeObjectAtIndex:indexPath.section-1];

        WEAK_SELF
        cell.block=^(HomeModel2 *homeModel){
            NSURL *playerUrl = [NSURL URLWithString:homeModel.live_rtmp_play_url];
            [weakSelf playVideoWithURL:playerUrl];
//            [weakSelf.videoController fullScreenButtonClick];//全屏
        };
        return cell;
    }
}

- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        WEAK_SELF
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController dismiss];
            weakSelf.videoController=nil;
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel2 *homeModel2=[self.viewModel.topArray safeObjectAtIndex:indexPath.section-1];
    if (indexPath.section==0) {
        return [HomeBannerCell heightForCellData:nil];
    }else if (indexPath.section>self.viewModel.topArray.count){
        return 350;
    }else{
        return [HomePageCellTableViewCell heightForCellData:homeModel2];
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>self.viewModel.topArray.count) {
        HomeButtomModel *detail=[self.viewModel.buttomArray safeObjectAtIndex:indexPath.section - 1 - self.viewModel.topArray.count];
        YJWebViewController *web=[YJWebViewController new];
        web.title=@"";
        web.htmlUrl=[NSString stringWithFormat:@"http://web.tuzicity.com/app/html/single_product.html?id=%@&brand_id=%@",detail.ID,detail.brand_id];
        YJLog(@"%ld---%@",indexPath.section - 1 - self.viewModel.topArray.count,detail.remark);
        [self.navigationController pushViewController:web animated:YES];
    }
}

@end
