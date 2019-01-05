//
//  MyOrderSonVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderSonVC.h"
#import "MyOrderCell2.h"
#import "MyOrderCell3.h"
#import "BrandDetailItem.h"
#import "MyOrderNilHeader.h"
#import "MyOrderViewModel.h"
#import "MyOrder.h"
#import "MyOrderDetailVC.h"
#import "MyOrderHeader.h"

@interface MyOrderSonVC ()
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) MyOrderViewModel  *orderViewModel;
@property (nonatomic, strong) PlaceHoldView     *placeHoder;
@end

@implementation MyOrderSonVC

-(MyOrderViewModel *)orderViewModel{
    if (!_orderViewModel) {
        _orderViewModel=[MyOrderViewModel new];
    }
    return _orderViewModel;
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
    self.tableView.contentInset=UIEdgeInsetsMake(35, 0, 49+64, 0);
    [self.tableView registerNib:[MyOrderCell2 nib] forCellReuseIdentifier:[MyOrderCell2 cellReuseIdentifier]];
    [self.tableView registerNib:[MyOrderCell3 nib] forCellReuseIdentifier:[MyOrderCell3 cellReuseIdentifier]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyChangeAlpha=YES;
    self.tableView.mj_footer.automaticallyHidden=YES;
    [self loadNewData];
}

-(void)loadNewData{
    [self.tableView.mj_footer endRefreshing];
    [self.orderViewModel loadDataFromNetworkWithType:_type IsNewData:YES];
    RACSignal *signal = [self.orderViewModel.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder"
                              buttonTitle:@"" show:self.orderViewModel.modelArray.count==0];
        
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络不太好" imageName:@"placeholder"
                              buttonTitle:@"刷新" show:self.orderViewModel.modelArray.count==0];
    } completed:^{
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:self.orderViewModel.msg imageName:@"placeholder"
                              buttonTitle:@"刷新" show:self.orderViewModel.modelArray.count==0];
    }];
}

-(void)loadMoreData{
    [self.orderViewModel loadDataFromNetworkWithType:_type IsNewData:NO];
    RACSignal *signal = [self.orderViewModel.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
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

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderViewModel.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyOrder *order=[self.orderViewModel.modelArray safeObjectAtIndex:section];
    return order.goodsList.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrder *order=[self.orderViewModel.modelArray safeObjectAtIndex:indexPath.section];
    if (indexPath.row < order.goodsList.count) {
        MyOrderCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[MyOrderCell2 cellReuseIdentifier] forIndexPath:indexPath];
        cell2.orderSon=[order.goodsList safeObjectAtIndex:indexPath.row];
        return cell2;
    }else{
        MyOrderCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:[MyOrderCell3 cellReuseIdentifier] forIndexPath:indexPath];
        cell3.order=order;
        cell3.block=^(){
            [self.tableView.mj_header beginRefreshing];
        };
        return cell3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrder *order=[self.orderViewModel.modelArray safeObjectAtIndex:indexPath.section];
    if (indexPath.row < order.goodsList.count) {
        return [MyOrderCell2 heightForCellData:nil];
    }
    return [MyOrderCell3 heightForCellData:order];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyOrder *order=[self.orderViewModel.modelArray safeObjectAtIndex:section];
    MyOrderHeader *header=[MyOrderHeader tableHeaderWithTableView:tableView];
    header.order=order;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrder *order=[self.orderViewModel.modelArray safeObjectAtIndex:indexPath.section];
    if (indexPath.row == order.goodsList.count) return;
    MyOrderDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"MyOrderDetailVC"];
    vc.order=order;
    [self.navigationController pushViewController:vc animated:YES];
}
















//[self.tableView addSubview:self.collectionView];
//[self.tableView bringSubviewToFront:self.collectionView];
//self.tableView.scrollEnabled=NO;

//#pragma mark - collectionView Delegate/DataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 5;
//}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    BrandDetailItem *item=[collectionView dequeueReusableCellWithReuseIdentifier:[BrandDetailItem cellReuseIdentifier] forIndexPath:indexPath];
//    item.backgroundColor=[UIColor redColor];
//    return item;
//}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    YJLog(@"%ld",indexPath.row);
//}
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        MyOrderNilHeader *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MyOrderNilHeader cellReuseIdentifier] forIndexPath:indexPath];
//        [header.placeHoldView setInfo:@"您没有相关的订单" ImgName:@"order_not" buttonTitle:@"再去逛逛"];
//        header.backgroundColor=[UIColor redColor];
//        return header;
//    }
//    return nil;
//}
//
////暂时不用
//-(UICollectionView *)collectionView{
//    if (!_collectionView) {
//        
//        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//        CGFloat width=(ScreenW-1)/2;
//        flowLayout.itemSize = CGSizeMake(width,300);
//        flowLayout.minimumInteritemSpacing = 1;
//        flowLayout.minimumLineSpacing = 1;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.headerReferenceSize = CGSizeMake(ScreenW, 300);
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) collectionViewLayout:flowLayout];
//        _collectionView.dataSource = self;
//        _collectionView.backgroundColor=kF5F5F5;
//        _collectionView.delegate = self;
//        _collectionView.pagingEnabled = YES;
//        _collectionView.scrollsToTop = NO;
//        _collectionView.bounces = YES;
//        _collectionView.alwaysBounceVertical = YES;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.contentInset=UIEdgeInsetsMake(0,0,35+64,0);
//        [_collectionView registerClass:[MyOrderNilHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MyOrderNilHeader cellReuseIdentifier]];
//        [_collectionView registerClass:[BrandDetailItem class] forCellWithReuseIdentifier:[BrandDetailItem cellReuseIdentifier]];
//    }
//    return _collectionView;
//}

@end
