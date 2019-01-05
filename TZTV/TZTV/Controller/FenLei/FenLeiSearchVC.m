//
//  FenLeiSearchVC.m
//  TZTV
//
//  Created by Luosa on 2017/2/28.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "FenLeiSearchVC.h"
#import "SKTagView.h"
#import "UIImage+YJ.h"
#import "BrandDetailItem.h"
#import "PlaceHoldView.h"
#import "BrandDetailVC1.h"
#import "BrandDetailModel.h"
#import "HomepageTitleView.h"
#import "UIBarButtonItem+Create.h"

@interface FenLeiSearchVC ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) SKTagView *tagView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic, strong) UICollectionView *resultCollectionView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) PlaceHoldView *placeHoldView;
@property (nonatomic, strong) HomepageTitleView *titleView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation FenLeiSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kWhiteColor;
    [self setUpUISearchBar];
    [self configTagView];
    [self setUpResultView];
}

-(void)setUpResultView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    CGFloat width=(ScreenW-1)/2;
    flowLayout.itemSize = CGSizeMake(width,90+(width-20)*480/375);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.resultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) collectionViewLayout:flowLayout];
    self.resultCollectionView.delegate = self;
    self.resultCollectionView.dataSource = self;
    self.resultCollectionView.bounces = YES;
    self.resultCollectionView.alwaysBounceVertical = YES;
    self.resultCollectionView.backgroundColor = kF5F5F5;
    [self.resultCollectionView registerNib:[BrandDetailItem nib] forCellWithReuseIdentifier:[BrandDetailItem cellReuseIdentifier]];
    [self.view addSubview:self.resultCollectionView];
    
    self.resultCollectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
    self.resultCollectionView.mj_header.automaticallyChangeAlpha = YES;
    
//    self.resultCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
//    self.resultCollectionView.mj_footer.automaticallyChangeAlpha = YES;
//    self.resultCollectionView.mj_footer.automaticallyHidden=YES;
    
    self.resultCollectionView.hidden=YES;
    if (_keyWord!=0) {
        [self loadNewDeals];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleView.searchBar.text=_keyWord;
}

-(void)setUpUISearchBar
{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTitle:@"搜索" textColor:[UIColor lightGrayColor] textFont:YJFont(14) target:self action:@selector(rightBtnClicked)];
    self.titleView=[[HomepageTitleView alloc] initWithFrame:CGRectMake(50, 0, ScreenW-100, 32)];
    self.titleView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    [self.titleView doBorderWidth:1 color:kF5F5F5 cornerRadius:4];
    self.titleView.searchBar.delegate=self;
    self.navigationItem.titleView = self.titleView;
}

-(void)rightBtnClicked
{
    [self.titleView.searchBar resignFirstResponder];
    [self loadNewDeals];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.titleView.searchBar resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.titleView.searchBar resignFirstResponder];
    [self loadNewDeals];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _keyWord=searchText;
    self.label.hidden=(searchText.length!=0);
    self.tagView.hidden=(searchText.length!=0);
    self.resultCollectionView.hidden=(searchText.length==0);
    if (self.placeHoldView && searchText.length==0) {
        [self.placeHoldView removeFromSuperview];
        self.placeHoldView=nil;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.titleView.searchBar resignFirstResponder];
    [self cancelFirstResponse];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self cancelFirstResponse];
    [self.titleView.searchBar resignFirstResponder];
}

- (void)configTagView{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 30)];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.text = @"热门搜索";
    [self.view addSubview:self.label];
    
    [self.tagView removeAllTags];
    self.tagView = [[SKTagView alloc] init];
    // 整个tagView对应其SuperView的上左下右距离
    self.tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    // 上下行之间的距离
    self.tagView.lineSpacing = 10;
    // item之间的距离
    self.tagView.interitemSpacing = 20;
    // 最大宽度
    self.tagView.preferredMaxLayoutWidth = 375;
    // 开始加载
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [[SKTag alloc] initWithText:self.dataSource[idx]];
        // 标签相对于自己容器的上左下右的距离
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        tag.cornerRadius = 3.0f;
        tag.font = [UIFont boldSystemFontOfSize:12];
        tag.borderWidth = 1;
        tag.bgColor = kWhiteColor;
        tag.borderColor = [UIColor lightGrayColor];
        tag.textColor = [UIColor lightGrayColor];
        tag.enable = YES;
        [self.tagView addTag:tag];
    }];
    WEAK_SELF
    self.tagView.didTapTagAtIndex = ^(NSUInteger idx){
        NSLog(@"点击了第%ld个",idx);
        weakSelf.titleView.searchBar.text=[weakSelf.dataSource safeObjectAtIndex:idx];
        weakSelf.keyWord=[weakSelf.dataSource safeObjectAtIndex:idx];
        [weakSelf loadNewDeals];
    };
    // 获取刚才加入所有tag之后的内在高度
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    NSLog(@"高度%lf",tagHeight);
    self.tagView.frame = CGRectMake(0, 60, ScreenW, tagHeight);
    [self.tagView layoutSubviews];
    [self.view addSubview:self.tagView];
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"男装",@"女装",@"男鞋",@"女鞋"]];
    }
    return _dataSource;
}

- (void)loadNewDeals{
    [MBProgressHUD showMessage:@""];
    NSString *url=[NSString stringWithFormat:Search_URL,_keyWord,1];
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        [self.resultCollectionView.mj_header endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.currentPage=1;
            self.dataArray=[BrandDetailModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.resultCollectionView reloadData];
            [self showPlaceHolderViewWithInfo:@"暂无数据" imageName:@"placeholder" buttonTitle:@"" show:!self.dataArray.count];
        }else{
            [self showPlaceHolderViewWithInfo:json[@"msg"] imageName:@"placeholder" buttonTitle:@"刷新" show:!self.dataArray.count];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.resultCollectionView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络似乎不好！" imageName:@"placeholder" buttonTitle:@"刷新" show:!self.dataArray.count];
    }];
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    if (show) {
        self.resultCollectionView.hidden=YES;
        self.placeHoldView.hidden=NO;
        [self.view addSubview:self.placeHoldView];
        [self.placeHoldView autoPinEdgesToSuperviewEdges];
        [self.placeHoldView setInfo:info ImgName:img buttonTitle:title];
    }else{
        self.resultCollectionView.hidden=NO;
        if (self.placeHoldView) {
            [self.placeHoldView removeFromSuperview];
            self.placeHoldView=nil;
        }
    }
}

-(PlaceHoldView *)placeHoldView {
    if (!_placeHoldView) {
        _placeHoldView = [PlaceHoldView autolayoutView];
        _placeHoldView.backgroundColor = kF5F5F5;
        WEAK_SELF
        _placeHoldView.PlaceHoldBlock=^(NSString *buttonTitle){
            [weakSelf loadNewDeals];
        };
    }
    return _placeHoldView;
}

#pragma mark - collectionView Delegate/DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailItem *item=[collectionView dequeueReusableCellWithReuseIdentifier:[BrandDetailItem cellReuseIdentifier]
                                                                    forIndexPath:indexPath];
    item.detail=[self.dataArray safeObjectAtIndex:indexPath.row];
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailVC1 *vc=[BrandDetailVC1 new];
    BrandDetailModel *detail=[self.dataArray safeObjectAtIndex:indexPath.row];
    vc.ID=detail.ID;
    vc.brand_id=detail.brand_id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end









