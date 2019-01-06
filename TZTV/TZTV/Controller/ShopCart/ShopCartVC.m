//
//  ShopCartVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ShopCartVC.h"
#import "ShopCartCell.h"
#import "ShopCartHeaderView.h"
#import "OTSBorder.h"
#import "PlaceHoldView.h"
#import "ShopCartModel.h"
#import "AccountTool.h"
#import "Account.h"
#import "ShopCartModel.h"
#import "CartModel.h"
#import "ConfirmOrderVC.h"
#import "CartViewModel.h"

@interface ShopCartVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet YJTableView   *tableView;
@property (weak, nonatomic) IBOutlet UIButton       *allChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel        *allPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton       *jiesuanBtn;
@property (weak, nonatomic) IBOutlet UIView         *buttomView;
@property (nonatomic, strong) PlaceHoldView         *placeHoldView;
@property (nonatomic, strong) CartViewModel         *cartViewModel;
@end

@implementation ShopCartVC

-(CartViewModel *)cartViewModel{
    if (!_cartViewModel) {
        _cartViewModel=[CartViewModel new];
    }
    return _cartViewModel;
}

-(PlaceHoldView *)placeHoldView {
    if (_placeHoldView == nil) {
        _placeHoldView = [PlaceHoldView autolayoutView];
        WEAK_SELF
        _placeHoldView.PlaceHoldBlock=^(NSString *buttonTitle){
            if ([buttonTitle isEqualToString:@"去登录"]) {
                [AccountTool getAccount:YES];
            }else{
                [weakSelf loadNewData];
            }
        };
    }
    return _placeHoldView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"购物车";
    self.tabBarHidden = NO;
    self.tableView.separatorStyle=0;
    self.view.backgroundColor=kF5F5F5;
    self.tableView.backgroundColor=kF5F5F5;
    [OTSBorder addBorderWithView:_buttomView type:OTSBorderTypeTop andColor:kEDEDED];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    if ([AccountTool account]==nil) {//如果没登录
        self.buttomView.hidden=YES;
        [self showPlaceHolderViewWithInfo:@"您还没有登录，快去登录吧" imageName:@"goods_Not" buttonTitle:@"去登录" show:YES];
    }else{
        [self loadNewData];//加载新数据
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginOutSuccess) name:LoginOutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:AddToShopCartSuccess object:nil];
}

//退出登录后
-(void)LoginOutSuccess{
    [self.cartViewModel.modelArray removeAllObjects];
    [self showPlaceHolderViewWithInfo:@"您还没有登录，快去登录吧" imageName:@"goods_Not" buttonTitle:@"去登录" show:YES];
}

-(void)loadNewData{
    _allChooseBtn.selected=NO;
    [self setAllSelectedState:NO];
    
    [self.cartViewModel loadDataFromNetwork];
    RACSignal *signal = [self.cartViewModel.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"您的购物车里还没有商品哦" imageName:@"goods_Not"
                              buttonTitle:nil show:self.cartViewModel.modelArray.count?NO:YES];
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:@"网络不好" imageName:@"placeholder"
                              buttonTitle:@"刷新" show:self.cartViewModel.modelArray.count?NO:YES];
    } completed:^{
        [self.tableView.mj_header endRefreshing];
        [self showPlaceHolderViewWithInfo:self.cartViewModel.msg imageName:@"placeholder"
                              buttonTitle:@"刷新" show:self.cartViewModel.modelArray.count?NO:YES];
    }];
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    [self.tableView reloadData];
    if (show) {
        self.tableView.hidden=YES;
        self.buttomView.hidden=YES;
        [self.view addSubview:self.placeHoldView];
        [self.placeHoldView setInfo:info ImgName:img buttonTitle:title];
        [self.placeHoldView autoPinEdgesToSuperviewEdges];
    }else{
        self.tableView.hidden=NO;
        self.buttomView.hidden=NO;
        if (self.placeHoldView) {
            [self.placeHoldView removeFromSuperview];
            self.placeHoldView=nil;
        }
    }
}

//全选按钮
- (IBAction)buttonClicked:(UIButton *)sender {
    sender.selected=!sender.selected;
    NSMutableArray *detailArray = [NSMutableArray array];
    for (int i=0; i<self.cartViewModel.modelArray.count; i++) {
        CartModel *bigModel=[self.self.cartViewModel.modelArray safeObjectAtIndex:i];
        bigModel.selectState=sender.selected;
        for (int j=0; j<bigModel.array.count; j++) {
            ShopCartModel *smallModel=[bigModel.array safeObjectAtIndex:j];
            smallModel.selectState=bigModel.selectState;
            [detailArray addObject:smallModel];
        }
    }
    [self calculateTotalMoney];
    [_tableView reloadData];
}

#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cartViewModel.modelArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CartModel *cart=self.cartViewModel.modelArray[section];
    return cart.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartCell *cell=[tableView dequeueReusableCellWithIdentifier:[ShopCartCell cellReuseIdentifier] forIndexPath:indexPath];
    CartModel *cart=self.cartViewModel.modelArray[indexPath.section];
    cell.smallModel=[cart.array safeObjectAtIndex:indexPath.row];
    cell.cellBlock=^(){
        CartModel *bigModel=self.cartViewModel.modelArray[indexPath.section];
        //设置段头的选择按钮选中状态
        [self setHeaderViewSelectState:bigModel];
        //设置底部选择按钮的选中状态
        [self setBottomBtnSelectState];
        //计算价格
        [self calculateTotalMoney];
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShopCartHeaderView *header=[ShopCartHeaderView tableHeaderWithTableView:tableView];
    header.cartModel=self.cartViewModel.modelArray[section];
    header.headerBlock=^(){
        //计算价格
        [self calculateTotalMoney];
        [self setBottomBtnSelectState];
        [_tableView reloadData];
    };
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    view.backgroundColor=kF5F5F5;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    CartModel *bigModel=self.cartViewModel.modelArray[indexPath.section];
    ShopCartModel *shop=[bigModel.array safeObjectAtIndex:indexPath.row];
    NSString *url=[NSString stringWithFormat:delShopCartURL,[[AccountTool account] pid],shop.ID];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            [bigModel.array removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if (bigModel.array.count==0) {
                [self.cartViewModel.modelArray removeObject:bigModel];
                [self showPlaceHolderViewWithInfo:@"您的购物车里还没有商品哦" imageName:@"goods_Not"
                                      buttonTitle:nil show:self.cartViewModel.modelArray.count?NO:YES];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

/**
 *  设置表头选中状态
 */
- (void)setHeaderViewSelectState:(CartModel *)bigModel{
    BOOL currentState = YES;
    //表头选中状态
    for (int i = 0 ; i < bigModel.array.count; i++) {
        ShopCartModel *detailModel = bigModel.array[i];
        if (detailModel.selectState != YES) {
            currentState = NO;
            break;
        }
    }
    bigModel.selectState = currentState;
}
/**
 *  设置下方全选按钮选中状态
 */
- (void)setBottomBtnSelectState{
    BOOL currentState = YES;
    //下方全选按钮选中状态
    for (int i = 0; i < self.cartViewModel.modelArray.count; i++) {
        CartModel *model = self.cartViewModel.modelArray[i];
        if (model.selectState != YES) {
            currentState = NO;
            break;
        }
    }
    //最下方的全选按钮的状态
    _allChooseBtn.selected =currentState;
}
//计算总价
- (void)calculateTotalMoney{
    float price = 0.0;
    for (CartModel *bigModel in self.cartViewModel.modelArray) {
        for (ShopCartModel *shop in bigModel.array) {
            if (shop.selectState) {
                price = price + shop.goods_num * [shop.goods_now_price floatValue];
            }
        }
    }
    _allPriceLabel.text= [NSString stringWithFormat:@"¥%.2f",price];
}

//结算,去下一个页面
- (IBAction)jiesuanClicked:(UIButton *)sender {
    NSString *price=[_allPriceLabel.text substringFromIndex:1];
    if ([price intValue]==0) {
        [MBProgressHUD showError:@"请选择商品"];
        return;
    }
    ConfirmOrderVC *confirmVC=[sb instantiateViewControllerWithIdentifier:@"ConfirmOrderVC"];
    NSMutableArray *arr=[NSMutableArray array];
    for (CartModel *cart in self.cartViewModel.modelArray) {
        for (ShopCartModel *shop in cart.array) {
            if (shop.selectState) {
                [arr addObject:shop];
            }
        }
    }
    confirmVC.array=[arr copy];
    [self.navigationController pushViewController:confirmVC animated:YES];
}

-(void)setAllSelectedState:(BOOL)selected{
    for (CartModel *cart in self.cartViewModel.modelArray) {
        cart.selectState=selected;
        for (ShopCartModel *shop in cart.array) {
            shop.selectState=selected;
        }
    }
    [self calculateTotalMoney];//计算价格
}

@end







