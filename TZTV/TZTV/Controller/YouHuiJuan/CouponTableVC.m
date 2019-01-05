//
//  CouponTableVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CouponTableVC.h"
#import "YouHuiJuanCell.h"
#import "CouponModel.h"
#import "PlaceHoldView.h"

@interface CouponTableVC ()
@property (nonatomic, strong) PlaceHoldView *placeHoder;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation CouponTableVC

-(PlaceHoldView *)placeHoder
{
    if (!_placeHoder) {
        _placeHoder=[PlaceHoldView autolayoutView];
        WEAK_SELF
        _placeHoder.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf requestData];
        };
    }
    return _placeHoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"优惠券";
    [self.tableView registerNib:[YouHuiJuanCell nib] forCellReuseIdentifier:[YouHuiJuanCell cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self requestData];
}

-(void)requestData{
    [MBProgressHUD showMessage:@""];
    NSString *url=[NSString stringWithFormat:getCouponListURL,[[AccountTool account] user_id]];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.dataArray=[CouponModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self showPlaceHolderViewWithInfo:@"暂无数据"
                                    imageName:@"placeholder"
                                  buttonTitle:@""
                                         show:(self.dataArray.count==0)];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
            [self showPlaceHolderViewWithInfo:json[@"msg"]
                                    imageName:@"placeholder"
                                  buttonTitle:@"刷新"
                                         show:(self.dataArray.count==0)];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络似乎不通"
                                imageName:@"placeholder"
                              buttonTitle:@"刷新"
                                     show:(self.dataArray.count==0)];
    }];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count?1:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YouHuiJuanCell *cell=[tableView dequeueReusableCellWithIdentifier:[YouHuiJuanCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.coupon=[self.dataArray safeObjectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
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

@end



