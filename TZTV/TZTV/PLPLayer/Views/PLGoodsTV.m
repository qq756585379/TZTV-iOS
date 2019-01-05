//
//  PLGoodsTV.m
//  TZTV
//
//  Created by Luosa on 2017/2/21.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGoodsTV.h"
#import "PLGoodsModel.h"
#import "PlaceHoldView.h"
#import "PLGoodsCell.h"

@interface PLGoodsTV () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PlaceHoldView  *placeHoder;
@end

@implementation PLGoodsTV

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
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

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self=[super initWithFrame:frame style:style]) {
        self.page=1;
        self.backgroundColor=kF5F5F5;
        self.delegate=self;
        self.dataSource=self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.mj_footer.automaticallyChangeAlpha=YES;
        self.mj_footer.automaticallyHidden=YES;
        [self registerNib:[PLGoodsCell nib] forCellReuseIdentifier:[PLGoodsCell cellReuseIdentifier]];
        self.tableFooterView=[UIView new];
    }
    return self;
}

-(void)loadNewData{
    self.mj_footer.hidden=YES;
    NSString *url=[NSString stringWithFormat:@"http://114.55.234.142:8080/tztvapi/goods/getGoodsListByLUid?live_user_id=%@&type=%@&page=%d&pageSize=10",_live_user_id,_type,1];
    YJLog(@"=====%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [self.mj_header endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            NSLog(@"=====%@",json);
            if ([json[@"data"] count]==0) {
                [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder" buttonTitle:@"" show:YES];
            }else{
                [self showPlaceHolderViewWithInfo:nil imageName:nil buttonTitle:nil show:NO];
                self.dataArray=[PLGoodsModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [self reloadData];
            }
        }else{
            [self showPlaceHolderViewWithInfo:json[@"data"][@"msg"]
                                    imageName:@"placeholder" buttonTitle:@"刷新" show:(self.dataArray.count==0)];
        }
    } failure:^(NSError *error) {
        [self.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络似乎不通"
                                imageName:@"placeholder" buttonTitle:@"刷新" show:(self.dataArray.count==0)];
    }];
}

-(void)loadMoreData{
    int page = self.page+1;
    NSString *url=[NSString stringWithFormat:@"http://114.55.234.142:8080/tztvapi/goods/getGoodsListByLUid?live_user_id=%@&type=%@&page=%d&pageSize=10",_live_user_id,_type,page];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [self.mj_footer endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            if ([json[@"data"] count]==0) {
                [self.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=page;
                NSArray *arr=[PLGoodsModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [self.dataArray addObjectsFromArray:arr];
                [self reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self.mj_footer endRefreshing];
    }];
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    [self reloadData];
    if (show) {
        [self addSubview:self.placeHoder];
        [self.placeHoder autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.placeHoder autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.placeHoder setInfo:info ImgName:img buttonTitle:title];
    }else{
        if (self.placeHoder) {
            [self.placeHoder removeFromSuperview];
            self.placeHoder=nil;
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:[PLGoodsCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.goodModel=[self.dataArray safeObjectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

@end
