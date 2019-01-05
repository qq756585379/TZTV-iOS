//
//  FenLeiTableVC.m
//  TZTV
//
//  Created by Luosa on 2017/2/23.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "FenLeiTableVC.h"
#import "PYSearch.h"
#import "HomepageTitleView.h"
#import "FenLeiTableCell.h"
#import "PlaceHoldView.h"
#import "FenLeiModel.h"
#import "FenLeiSearchVC.h"
#import "YJNav.h"

@interface FenLeiTableVC ()
@property (nonatomic, strong) PlaceHoldView *placeHoder;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation FenLeiTableVC

-(PlaceHoldView *)placeHoder{
    if (!_placeHoder) {
        _placeHoder=[PlaceHoldView autolayoutView];
        WEAK_SELF
        _placeHoder.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf initData];
        };
    }
    return _placeHoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomepageTitleView *titleView=[[HomepageTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-40, 32)];
    titleView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    [titleView doBorderWidth:1 color:kF5F5F5 cornerRadius:4];
    titleView.searchBar.userInteractionEnabled=NO;
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSearchVC)]];
    self.navigationItem.titleView = titleView;
    
    [self.tableView registerClass:[FenLeiTableCell class] forCellReuseIdentifier:[FenLeiTableCell cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    [self initData];
}

-(void)initData{
    [MBProgressHUD showMessage:@""];
    [[YJHttpRequest sharedManager] get:FenLei_URL params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        YJLog(@"%@",json);
        [self.tableView.mj_header endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in json[@"data"]) {
                FenLeiModel *model=[[FenLeiModel alloc] initWithJson:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FenLeiTableCell *cell=[tableView dequeueReusableCellWithIdentifier:[FenLeiTableCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.bigModel=[self.dataArray safeObjectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FenLeiModel *bigModel=[self.dataArray safeObjectAtIndex:indexPath.row];
    return [FenLeiTableCell heightForCellData:bigModel.brandList];
}

-(void)goToSearchVC{
    FenLeiSearchVC *vc=[FenLeiSearchVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
//    YJNav *nvc = [[YJNav alloc] initWithRootViewController:vc];
//    [self presentViewController:nvc animated:YES completion:nil];
//    [self.navigationController presentViewController:nvc animated:YES completion:nil];
    
//    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
//    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索编程语言" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        // 如：跳转到指定控制器
//    }];
//    [self presentViewController:nav  animated:NO completion:nil];
    
 
    
//        [self.navigationController pushViewController:vc animated:YES];
    //
    //    YJNav *nav=[[YJNav alloc] initWithRootViewController:vc];
    //    CATransition *animation=[CATransition animation];
    //    animation.duration=0.5;
    /**  type：动画类型
     *  pageCurl       向上翻一页
     *  pageUnCurl     向下翻一页
     *  rippleEffect   水滴
     *  suckEffect     收缩
     *  cube           方块
     *  oglFlip        上下翻转
     */
    /**  type：页面转换类型
     *  kCATransitionFade       淡出
     *  kCATransitionMoveIn     覆盖
     *  kCATransitionReveal     底部显示
     *  kCATransitionPush       推出
     */
    //    animation.type = kCATransitionFade;
    /**  subtype：出现的方向
     *  kCATransitionFromRight       右
     *  kCATransitionFromLeft        左
     *  kCATransitionFromTop         上
     *  kCATransitionFromBottom      下
     */
    //animation.subtype = kCATransitionFromRight;
    //    [self.view.window.layer addAnimation:animation forKey:nil];//  添加动作
    //    [self presentViewController:nav animated:YES completion:nil];
}


@end
