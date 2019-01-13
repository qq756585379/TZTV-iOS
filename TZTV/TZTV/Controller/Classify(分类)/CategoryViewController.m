//
//  CategoryViewController.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/7.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "CategoryViewController.h"
#import "ClassCategoryCell.h"
#import "DCGoodsSortCell.h"
#import "ClassifyVO.h"
#import "ClassifyLogic.h"
#import "DCBrandsSortHeadView.h"

#define tableViewWidth  95

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* collectionViw */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 搜索 */
@property (strong , nonatomic)UIView *topSearchView;
/* 搜索按钮 */
@property (strong , nonatomic)UIButton *searchButton;
/* 语音按钮 */
@property (strong , nonatomic)UIButton *voiceButton;

@property (strong , nonatomic)ClassifyLogic *classifyLogic;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpTab];
    [self setUpData];
}

- (void)setUpTab
{
    self.tabBarHidden = NO;
    self.navigationBarTranslucent = YES;
    self.tableView.backgroundColor = RGB(245,245,245);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - 加载数据
- (void)setUpData{
    WEAK_SELF
    [self.classifyLogic getDataWithParma:nil completionBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF
        [self.tableView reloadData];
        if (self.classifyLogic.dataArray.count) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - 设置导航条
- (void)setUpNav
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIBarButtonItem *msgButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mshop_message_gray_icon"] target:self action:@selector(messButtonBarItemClick)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, msgButton];
    
    _topSearchView = [[UIView alloc] initWithFrame:CGRectMake(50, 6, SCREEN_WIDTH - 110, 32)];
    _topSearchView.backgroundColor = [UIColor whiteColor];
    _topSearchView.layer.cornerRadius = 16;
    [_topSearchView.layer masksToBounds];
    self.navigationItem.titleView = _topSearchView;
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:@"搜索商品/店铺" forState:0];
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:0];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_searchButton setImage:[UIImage imageNamed:@"group_home_search_gray"] forState:0];
    [_searchButton adjustsImageWhenHighlighted];
    _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * 10, 0, 0);
    _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.frame = CGRectMake(0, 0, _topSearchView.width - 2 * 10, _topSearchView.height);
    [_topSearchView addSubview:_searchButton];
    
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceButton.adjustsImageWhenHighlighted = NO;
    _voiceButton.frame = CGRectMake(_topSearchView.width - 45, 0, 35, _topSearchView.height);
    [_voiceButton addTarget:self action:@selector(voiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_voiceButton setImage:[UIImage imageNamed:@"icon_voice_search"] forState:0];
    [_topSearchView addSubview:_voiceButton];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classifyLogic.dataArray.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[ClassCategoryCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.classifyVO = self.classifyLogic.dataArray[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    ClassifyVO *vo = self.classifyLogic.dataArray[self.tableView.indexPathForSelectedRow.row];
    return vo.children.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ClassifyVO *vo1 = self.classifyLogic.dataArray[self.tableView.indexPathForSelectedRow.row];
    ClassifyVO *vo2 = vo1.children[section];
    return vo2.children.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DCGoodsSortCell cellReuseIdentifier] forIndexPath:indexPath];
    ClassifyVO *vo1 = self.classifyLogic.dataArray[self.tableView.indexPathForSelectedRow.row];
    ClassifyVO *vo2 = vo1.children[indexPath.section];
    cell.classifyVO = vo2.children[indexPath.row];
    return cell;
}
    
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        DCBrandsSortHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:[DCBrandsSortHeadView reuseIdentifier]
                                                                                     forIndexPath:indexPath];
        ClassifyVO *vo1 = self.classifyLogic.dataArray[self.tableView.indexPathForSelectedRow.row];
        ClassifyVO *vo2 = vo1.children[indexPath.section];
        headerView.headLabel.text = vo2.name;
        reusableview = headerView;
    }
    return reusableview;
}
    
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - tableViewWidth - 6 - 10)/3, (SCREEN_WIDTH - tableViewWidth - 6 - 10)/3 + 20);
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 25);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了个第%zd分组第%zd几个Item",indexPath.section,indexPath.row);
//    DCGoodsSetViewController *goodSetVc = [[DCGoodsSetViewController alloc] init];
//    goodSetVc.goodPlisName = @"ClasiftyGoods.plist";
//    [self.navigationController pushViewController:goodSetVc animated:YES];
}

#pragma mark - 搜索点击
- (void)searchButtonClick
{
    
}

#pragma mark - 语音点击
- (void)voiceButtonClick
{
    
}

#pragma mark - 消息点击
- (void)messButtonBarItemClick
{
    
}

#pragma mark - LazyLoad
- (ClassifyLogic *)classifyLogic
{
    if (!_classifyLogic) {
        _classifyLogic = [ClassifyLogic logicWithOperationManager:self.operationManager];
    }
    return _classifyLogic;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UIEdgeInsets insets = [YJGlobalValue sharedInstance].safeAreaInset;
        _tableView.frame = CGRectMake(0, insets.top+44, tableViewWidth, SCREEN_HEIGHT - insets.top);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[ClassCategoryCell class] forCellReuseIdentifier:[ClassCategoryCell cellReuseIdentifier]];
    }
    return _tableView;
}
    
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        UIEdgeInsets insets = [YJGlobalValue sharedInstance].safeAreaInset;
        _collectionView.frame = CGRectMake(tableViewWidth + 5, insets.top+44, SCREEN_WIDTH - tableViewWidth - 10, SCREEN_HEIGHT - insets.top);
        //注册Cell
        [_collectionView registerClass:[DCGoodsSortCell class] forCellWithReuseIdentifier:[DCGoodsSortCell cellReuseIdentifier]];
        //注册Header
        [_collectionView registerClass:[DCBrandsSortHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[DCBrandsSortHeadView reuseIdentifier]];
    }
    return _collectionView;
}

@end
