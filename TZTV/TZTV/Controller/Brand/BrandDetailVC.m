//
//  BrandDetailVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandDetailVC.h"
#import "BrandDetailVC1.h"
#import "BrandDetailItem.h"
#import "OTSBorder.h"
#import "OTSMask.h"
#import "BrandFilterVC.h"
#import "YJNav.h"
#import "UIButton+LayoutStyle.h"
#import "SortButton.h"
#import "BrandDetailModel.h"
#import "PlaceHoldView.h"

@interface BrandDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) YJCollectionView *collectionView;
@property (nonatomic, assign) int               currentPage;
@property (nonatomic, strong) PlaceHoldView     *placeHoldView;
@property (nonatomic, strong) UIButton          *selectedBtn;
@property (nonatomic, strong) UIView            *titlesView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@end

@implementation BrandDetailVC

-(PlaceHoldView *)placeHoldView
{
    if (_placeHoldView == nil) {
        _placeHoldView = [PlaceHoldView autolayoutView];
        _placeHoldView.backgroundColor = kF5F5F5;
        WEAK_SELF
        _placeHoldView.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf loadNewDeals];
        };
    }
    return _placeHoldView;
}

-(NSArray *)typeArray
{
    return @[@"zx",@"xl",@"jg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_type==0?_brandModel.name:_subModel.name;
    [self initUI];
    [self loadNewDeals];
}

-(void)initUI{
    UIView *titlesView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    titlesView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:titlesView];
    self.titlesView=titlesView;
    
    NSArray *titlesArr=@[@"最新",@"销量",@"价格"];
    CGFloat butnW=ScreenW/titlesArr.count;
    for (int i=0; i<titlesArr.count; i++){
        if (i==2) {
            SortButton *btn=[SortButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*butnW,5,butnW, 30);
            [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
            btn.titleLabel.font=YJFont(14);
            btn.tag=i;
            btn.sortType=typeNormal;
            [titlesView addSubview:btn];
            [btn setLayout:OTSTitleLeftImageRightStyle spacing:5];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UIButton *btn=[UIButton createButtonWithFrame:CGRectMake(i*butnW,5,butnW, 30) text:titlesArr[i] textColor:HEXRGBCOLOR(0x333333) font:YJFont(14) bgColor:[UIColor whiteColor] image:nil superView:titlesView];
            btn.tag=i;
            [btn setTitleColor:YJNaviColor forState:UIControlStateSelected];
            if (i==0) {
                self.selectedBtn=btn;
                btn.selected=YES;
            }
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat width=(ScreenW-1)/2;
    flowLayout.itemSize = CGSizeMake(width,90+(width-20)*480/375);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[YJCollectionView alloc] initWithFrame:CGRectMake(0, 41, ScreenW, ScreenH-41-64) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = kF5F5F5;
    [self.collectionView registerNib:[BrandDetailItem nib] forCellWithReuseIdentifier:[BrandDetailItem cellReuseIdentifier]];
    [self.view addSubview:_collectionView];
    
    self.collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    self.collectionView.mj_footer.automaticallyChangeAlpha = YES;
    self.collectionView.mj_footer.automaticallyHidden=YES;
}

- (void)loadNewDeals{
    [MBProgressHUD showMessage:@""];
    [self.collectionView.mj_footer endRefreshing];
    NSString *url;
    SortButton *jiageBtn=[self.titlesView viewWithTag:2];
    if (_type==0) {//在最新和销量的情况下，order参数无效，随便传个
        url=[NSString stringWithFormat:getGoodsListByBidURL,_brandModel.ID,1,[self typeArray][self.selectedBtn.tag],jiageBtn.sortType==typeDescending?0:1];
        YJLog(@"%@",url);
    }else{
        url=[NSString stringWithFormat:getGoodsListByCidURL,_subModel.ID,1,[self typeArray][self.selectedBtn.tag],jiageBtn.sortType==typeDescending?0:1];
        YJLog(@"%@",url);
    }
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        [self.collectionView.mj_header endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.currentPage=1;
            self.dataArray=[BrandDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.collectionView reloadData];
            [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder" buttonTitle:@"" show:!self.dataArray.count];
        }else{
            [self showPlaceHolderViewWithInfo:json[@"msg"] imageName:@"placeholder" buttonTitle:@"刷新" show:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.collectionView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络似乎不好！" imageName:@"placeholder" buttonTitle:@"刷新" show:YES];
    }];
}

- (void)loadMoreDeals{
    [MBProgressHUD showMessage:@""];
    [self.collectionView.mj_header endRefreshing];
    int page=self.currentPage+1;
    UIButton *jiageBtn=[self.titlesView viewWithTag:2];
    NSString *url;
    if (_type==0) {
        url=[NSString stringWithFormat:getGoodsListByBidURL,_brandModel.ID,page,[self typeArray][self.selectedBtn.tag],jiageBtn.selected?1:0];
    }else{
        url=[NSString stringWithFormat:getGoodsListByCidURL,_subModel.ID,page,[self typeArray][self.selectedBtn.tag],jiageBtn.selected?1:0];
    }
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.collectionView.mj_footer endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.currentPage=page;
            NSArray *arr=[BrandDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.dataArray addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.collectionView.mj_footer endRefreshing];
        [MBProgressHUD showToast:@"网络似乎不好！"];
    }];
}

- (void)btnClicked:(UIButton *)sender{
    if (sender.tag==3) {
        
    }else if (sender.tag==2){//价格排序
        self.selectedBtn.selected=NO;
        self.selectedBtn=sender;
        SortButton *btn=(SortButton *)sender;
        if (btn.sortType==typeDescending) {
            btn.sortType=typeAscending;
        }else{
            btn.sortType=typeDescending;
        }
        [self.collectionView.mj_header beginRefreshing];
    }else{
        SortButton *jiesongBtn=[self.titlesView viewWithTag:2];
        jiesongBtn.sortType=typeNormal;
        self.selectedBtn.selected=NO;
        sender.selected=YES;
        self.selectedBtn=sender;
        [self.collectionView.mj_header beginRefreshing];
    }
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    if (show) {
        self.collectionView.hidden=YES;
        self.titlesView.hidden=YES;
        [self.view addSubview:self.placeHoldView];
        [self.placeHoldView autoPinEdgesToSuperviewEdges];
        [self.placeHoldView setInfo:info ImgName:img buttonTitle:title];
    }else{
        self.collectionView.hidden=NO;
        self.titlesView.hidden=NO;
        if (self.placeHoldView) {
            [self.placeHoldView removeFromSuperview];
            self.placeHoldView=nil;
        }
    }
}

#pragma mark - collectionView Delegate/DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailItem *item=[collectionView dequeueReusableCellWithReuseIdentifier:[BrandDetailItem cellReuseIdentifier] forIndexPath:indexPath];
    item.detail=self.dataArray[indexPath.row];
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailVC1 *vc=[BrandDetailVC1 new];
    BrandDetailModel *detail=[self.dataArray safeObjectAtIndex:indexPath.row];
    vc.ID=detail.ID;
    vc.brand_id=detail.brand_id;
    [self.navigationController pushViewController:vc animated:YES];
}
















//section的view的定制
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat width=(ScreenW-1)/2;
//    return CGSizeMake(width,width*600/370);
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    CGFloat width = collectionView.bounds.size.width;
//    return CGSizeMake(width-20, 30);
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}



@end
