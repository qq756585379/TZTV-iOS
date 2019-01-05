//
//  TuiKuanTableVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/13.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "TuiKuanTableVC.h"
#import "MyOrderHeader.h"
#import "MyOrderCell3.h"
#import "MyOrderCell2.h"
#import "PlaceHoldView.h"

@interface TuiKuanTableVC ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PlaceHoldView *placeHoder;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TuiKuanTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"退款";
    [self.tableView registerNib:[MyOrderCell2 nib] forCellReuseIdentifier:[MyOrderCell2 cellReuseIdentifier]];
    [self.tableView registerNib:[MyOrderCell3 nib] forCellReuseIdentifier:[MyOrderCell3 cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.tableView.mj_footer.automaticallyChangeAlpha=YES;
//    self.tableView.mj_footer.automaticallyHidden=YES;
    [self loadNewData];
}

-(void)loadNewData{
    [MBProgressHUD showMessage:@""];
    Account *account=[AccountTool account];
    NSString *url=[NSString stringWithFormat:getRefundGoodsListURL,account.user_id,1,account.token];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
        [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder"
                              buttonTitle:@"" show:(self.dataArray.count==0)];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    [self.tableView reloadData];
    if (show) {
        [self.placeHoder setInfo:info ImgName:img buttonTitle:title];
    }else{
        if (self.placeHoder) {
            [self.placeHoder removeFromSuperview];
            self.placeHoder=nil;
        }
    }
}

-(void)loadMoreData{
//    [MBProgressHUD showMessage:@""];
//    Account *account=[AccountTool account];
//    NSString *url=[NSString stringWithFormat:getRefundGoodsListURL,account.user_id,1,account.token];
//    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
//        [MBProgressHUD hideHUD];
//        [self.tableView.mj_header endRefreshing];
//        YJLog(@"%@",json);
//        
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        [self.tableView.mj_header endRefreshing];
//    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        MyOrderCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[MyOrderCell2 cellReuseIdentifier] forIndexPath:indexPath];
        return cell2;
    }else{
        MyOrderCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:[MyOrderCell3 cellReuseIdentifier] forIndexPath:indexPath];
        cell3.bottomView.hidden=YES;
        return cell3;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyOrderHeader *header=[MyOrderHeader tableHeaderWithTableView:tableView];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row==0?94:40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(PlaceHoldView *)placeHoder
{
    if (!_placeHoder) {
        _placeHoder=[PlaceHoldView autolayoutView];
        WEAK_SELF
        _placeHoder.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf loadNewData];
        };
        [self.view addSubview:self.placeHoder];
        [self.placeHoder autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.placeHoder autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-64];
        [self.placeHoder autoSetDimension:ALDimensionWidth toSize:ScreenW];
        [self.placeHoder autoSetDimension:ALDimensionHeight toSize:ScreenH];
    }
    return _placeHoder;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
