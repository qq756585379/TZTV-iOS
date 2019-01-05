//
//  BrandVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/14.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandVC.h"
#import "BrandCategoryCell.h"
#import "BrandCategoryItem.h"
#import "BrandCategoryHeader.h"
#import "BrandDetailVC.h"
#import "SquareVC.h"
#import "NSArray+safe.h"
#import "BrandCategoryModel.h"
#import "BrandRecommendModel.h"
#import "PlaceHoldView.h"
#import "BrandVC+YJ.h"
#import "BrandZipViewModel.h"
#import "YJWebViewController.h"

@interface BrandVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) YJTableView           *tableView;
@property (nonatomic, strong) YJCollectionView      *collectionView;
@property (nonatomic, strong) PlaceHoldView         *leftplaceHoldView;
@property (nonatomic, strong) PlaceHoldView         *rightPlaceholdView;
@property (nonatomic, strong) BrandZipViewModel     *zipModel;
@end

@implementation BrandVC

-(BrandZipViewModel *)zipModel
{
    if (!_zipModel) {
        _zipModel=[BrandZipViewModel new];
    }
    return _zipModel;
}

-(PlaceHoldView *)leftplaceHoldView
{
    if (_leftplaceHoldView == nil) {
        _leftplaceHoldView = [PlaceHoldView autolayoutView];
        WEAK_SELF
        _leftplaceHoldView.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf loadNewData];
        };
    }
    return _leftplaceHoldView;
}

-(PlaceHoldView *)rightPlaceholdView
{
    if (_rightPlaceholdView == nil) {
        _rightPlaceholdView = [PlaceHoldView autolayoutView];
        _rightPlaceholdView.backgroundColor = kF5F5F5;
    }
    return _rightPlaceholdView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"品牌";
    self.tabBarHidden = NO;
    [self initUI];
    [self loadNewData];
}

-(void)loadNewData{
    [MBProgressHUD showMessage:@""];
    [self.zipModel loadNewDataFromNetwork];
    RACSignal *zipSignal = [self.zipModel.requestCommand execute:nil];
    [zipSignal subscribeNext:^(id x) {
        [MBProgressHUD hideHUD];
        YJLog(@"signalA======%@",x[0]);
        YJLog(@"signalB======%@",x[1]);
        if (self.zipModel.leftCategoryArr.count==0) {//请求成功但没数据
            [self showPlaceHolderViewWithInfo:@"暂无数据"
                                    imageName:@"placeholder" buttonTitle:@"" show:YES isLeft:YES];
        }else{
            [self showPlaceHolderViewWithInfo:nil imageName:nil buttonTitle:nil show:NO isLeft:YES];
            // 默认选中首行,这个不会出发tableView的didselected代理方法
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                        animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self showPlaceHolderViewWithInfo:@"网络似乎不通"
                                imageName:@"placeholder" buttonTitle:@"刷新" show:YES isLeft:YES];
    } completed:^{
        [MBProgressHUD hideHUD];
        [self showPlaceHolderViewWithInfo:self.zipModel.leftMsg
                                imageName:@"placeholder" buttonTitle:@"刷新" show:YES isLeft:YES];
    }];
}

-(void)loadRightData:(BrandCategoryModel *)model{
    if (model.rightArr.count) {
        [self showPlaceHolderViewWithInfo:nil imageName:nil buttonTitle:nil show:NO isLeft:NO];
    }else{
        [self.zipModel loadRightDataFromNetWorkWith:model];
        RACSignal *signal = [self.zipModel.requestCommand execute:nil];
        [signal subscribeNext:^(id x) {
            NSArray *arr=x;
            if (arr.count==0) {
                [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder" buttonTitle:nil show:YES isLeft:NO];
            }else{
                [self showPlaceHolderViewWithInfo:nil imageName:nil buttonTitle:nil show:NO isLeft:NO];
            }
        } error:^(NSError *error) {
            //没有数据又没请求成功就现实右边占位图
            [self showPlaceHolderViewWithInfo:@"网络不太好" imageName:@"placeholder" buttonTitle:nil show:YES isLeft:NO];
        } completed:^{
            [self showPlaceHolderViewWithInfo:self.zipModel.rightMsg imageName:@"placeholder" buttonTitle:nil show:YES isLeft:NO];
        }];
    }
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show isLeft:(BOOL)flag
{
    if (flag) {//左边
        if (show) {
            self.tableView.hidden=YES;
            self.collectionView.hidden=YES;
            [self.view addSubview:self.leftplaceHoldView];
            [self.leftplaceHoldView setInfo:info ImgName:img buttonTitle:title];
            [self.leftplaceHoldView autoPinEdgesToSuperviewEdges];
        }else{
            self.tableView.hidden=NO;
            self.collectionView.hidden=NO;
            if (self.leftplaceHoldView) {
                [self.leftplaceHoldView removeFromSuperview];
                self.leftplaceHoldView=nil;
            }
        }
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }else{//右边
        if (show) {
            [self.collectionView addSubview:self.rightPlaceholdView];
            [self.rightPlaceholdView setInfo:info ImgName:img buttonTitle:title];
            [self.rightPlaceholdView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.rightPlaceholdView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        }else{
            if (self.rightPlaceholdView) {
                [self.rightPlaceholdView removeFromSuperview];
                self.rightPlaceholdView=nil;
            }
        }
        [self.collectionView reloadData];
    }
}

-(void)initUI
{
    self.tableView = [[YJTableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;//设置这个就会让autoresizingMask失效
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BrandCategoryCell class] forCellReuseIdentifier:[BrandCategoryCell cellReuseIdentifier]];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[YJCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;//设置这个就会让autoresizingMask失效
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = kF5F5F5;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[BrandCategoryItem class] forCellWithReuseIdentifier:[BrandCategoryItem cellReuseIdentifier]];
    [self.collectionView registerClass:[BrandCategoryHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[BrandCategoryHeader reuseIdentifier]];
    
    [self.view addSubview:_collectionView];
    [self.view addSubview:_tableView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView(80)]-0-[_collectionView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:views]];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    UIView *topView=[UIView new];
    [_collectionView addSubview:topView];
    [self.collectionView setContentOffset:CGPointMake(0, -50) animated:YES];
    topView.frame=CGRectMake(0,-50, ScreenW-80, 50);
    
    UIButton *topBtn=[UIButton createButtonWithText:@"为您推荐附近广场>>" textColor:[UIColor whiteColor] font:YJFont(14) bgColor:YJNaviColor image:nil superView:topView];
    [topBtn doBorderWidth:1 color:YJNaviColor cornerRadius:4];
    [topBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [[topBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YJWebViewController *web=[YJWebViewController new];
        web.title=@"广场";
        web.htmlUrl=[NSString stringWithFormat:squareURL,@""];
        [self.navigationController pushViewController:web animated:YES];
    }];
}

#pragma mark - tableView delegate/dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zipModel.leftCategoryArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:[BrandCategoryCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BrandCategoryModel *model=[self.zipModel.leftCategoryArr safeObjectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;
    return cell;
}
#pragma mark - ACTION
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [self showPlaceHolderViewWithInfo:nil imageName:nil buttonTitle:nil show:NO isLeft:NO];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:NO scrollPosition:UITableViewScrollPositionTop];
    }else{
        BrandCategoryModel *model=[self.zipModel.leftCategoryArr safeObjectAtIndex:indexPath.row];
        [self loadRightData:model];
    }
}

#pragma mark - collectionView Delegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [collectionView.collectionViewLayout invalidateLayout];
    NSIndexPath *index=[self.tableView indexPathForSelectedRow];
    if (index.row==0) {//为你推荐里有广场和品牌
        return 2;
    }else{
        BrandCategoryModel *model=(BrandCategoryModel *)self.zipModel.leftCategoryArr[index.row];
        return model.rightArr.count;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSIndexPath *index=[self.tableView indexPathForSelectedRow];
    if (index.row==0) {//为你推荐里有广场和品牌
        return section==0?self.zipModel.recommendModel.market_list.count:self.zipModel.recommendModel.brand_list.count;
    }else{
        BrandCategoryModel *model=(BrandCategoryModel *)self.zipModel.leftCategoryArr[index.row];
        BrandRightModel *rightM=model.rightArr[section];
        return rightM.sub_list.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *index=[self.tableView indexPathForSelectedRow];
    BrandCategoryItem *item=[collectionView dequeueReusableCellWithReuseIdentifier:[BrandCategoryItem cellReuseIdentifier]
                                                                      forIndexPath:indexPath];
    if (index.row==0) {//为你推荐里有广场和品牌
        if (indexPath.section==0) {//广场
            item.marketModel=[self.zipModel.recommendModel.market_list safeObjectAtIndex:indexPath.row];
        }else{//品牌
            item.brandModel=[self.zipModel.recommendModel.brand_list safeObjectAtIndex:indexPath.row];
        }
    }else{
        BrandCategoryModel *model=(BrandCategoryModel *)self.zipModel.leftCategoryArr[index.row];
        BrandRightModel *rightM=model.rightArr[indexPath.section];
        item.subModel=rightM.sub_list[indexPath.row];
    }
    return item;
}

//section的view的定制
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *index=[self.tableView indexPathForSelectedRow];
    BrandCategoryHeader *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                   withReuseIdentifier:[BrandCategoryHeader reuseIdentifier] forIndexPath:indexPath];
    header.indexPath=indexPath;
    if (index.row==0) {//为你推荐里有广场和品牌
        header.titleLb.text=indexPath.section==0?@"广场":@"品牌馆";
    }else{
        BrandCategoryModel *model=(BrandCategoryModel *)self.zipModel.leftCategoryArr[index.row];
        BrandRightModel *rightM=model.rightArr[indexPath.section];
        header.titleLb.text=rightM.catalog_label;
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width=(collectionView.bounds.size.width-40)/3;
    return CGSizeMake(width,width*212/168);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat width = collectionView.bounds.size.width;
    return CGSizeMake(width-20, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - Action
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *table_indexPath=[self.tableView indexPathForSelectedRow];
    
    BrandCategoryModel *leftmodel = (BrandCategoryModel *)self.zipModel.leftCategoryArr[table_indexPath.row];
    BrandRightModel    *rightM    = [leftmodel.rightArr safeObjectAtIndex:indexPath.section];
    BrandSubModel      *subM      = [rightM.sub_list safeObjectAtIndex:indexPath.row];
    
    if (table_indexPath.row==0) {//为你推荐里分广场和品牌，每个类别进去的页面也不一样
        if (indexPath.section==0) {//推荐广场
            YJWebViewController *web=[YJWebViewController new];
            web.title=@"广场";
            web.htmlUrl=[NSString stringWithFormat:squareURL,subM.ID];
            [self.navigationController pushViewController:web animated:YES];
        }else{//品牌馆
            BrandDetailVC *vc=[BrandDetailVC new];
            vc.type=0;
            vc.brandModel=[self.zipModel.recommendModel.brand_list safeObjectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{//其他类别
        BrandDetailVC *vc=[BrandDetailVC new];
        vc.type=1;
        vc.subModel=subM;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
