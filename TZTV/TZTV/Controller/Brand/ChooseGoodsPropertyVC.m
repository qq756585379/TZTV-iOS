//
//  ChooseGoodsPropertyVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/19.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChooseGoodsPropertyVC.h"
#import "UIViewController+KNSemiModal.h"
#import "ChooseGoodsPropertyCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "BrandBuyCell2.h"
#import "ShopCartModel.h"
#import "AccountTool.h"
#import "Account.h"
#import "DBManager.h"
#import "YJNav.h"
#import "NSObject+BeeNotification.h"
#import "ConfirmOrderVC.h"

@interface ChooseGoodsPropertyVC ()
@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UIImageView    *iconIV;
@property (weak, nonatomic) IBOutlet UILabel        *desLabel;
@property (weak, nonatomic) IBOutlet UILabel        *moneyLabel;
@property (nonatomic, assign) NSInteger idx1;//选择的颜色
@property (nonatomic, assign) NSInteger idx2;//选择的尺码
@property (nonatomic, assign) NSInteger chooseNum;
@end

@implementation ChooseGoodsPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _idx1=0;
    _idx2=0;
    self.view.backgroundColor=[UIColor clearColor];
    [self.tableView registerNib:[BrandBuyCell2 nib] forCellReuseIdentifier:[BrandBuyCell2 cellReuseIdentifier]];
    [self.tableView registerNib:[ChooseGoodsPropertyCell nib] forCellReuseIdentifier:[ChooseGoodsPropertyCell cellReuseIdentifier]];
    self.tableView.tableFooterView=[UIView new];
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:_sku.picture] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _desLabel.text=[NSString stringWithFormat:@"%@",_sku.name];
    _moneyLabel.text=[NSString stringWithFormat:@"￥%@",_sku.nowPrice];
    YJLog(@"%@",_sku.sku_dict);
}

- (IBAction)makeSureClicked:(UIButton *)sender {
    if (_type==1) {//加入购物车
        [self addToShopCart];
    }else{//立即购买
        [self buy];
    }
}

-(void)addToShopCart{
    BrandBuyCell2 *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    int num=[cell.numLabel.text intValue];
    if (num==0) {
        [MBProgressHUD showError:@"购买数量不能为0"];
        return;
    }
    if ([AccountTool getAccount:YES]==nil) return;
    NSDictionary *sub_sku=[self selectedSKU];
    NSString *url=[NSString stringWithFormat:addShopCartURL,[[AccountTool account] pid],_sku.catalog_name,_sku.ID,sub_sku[@"id"],num];
    YJLog(@"url=====%@",url);
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"加入购物车成功"];
            [self postNotification:AddToShopCartSuccess];//发通知
            UIViewController *parent = [self.view containingViewController];
            if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
                [parent dismissSemiModalView];
            }
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showToast:@"网络不太好"];
    }];
}

#pragma mark - 立即购买
-(void)buy{
    BrandBuyCell2 *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    int num=[cell.numLabel.text intValue];
    if (num==0) {
        [MBProgressHUD showError:@"购买数量不能为0"];
        return;
    }
    UIViewController *parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
        
        ConfirmOrderVC *confirmVC=[sb instantiateViewControllerWithIdentifier:@"ConfirmOrderVC"];
        NSMutableArray *arr=[NSMutableArray array];
        ShopCartModel  *shop=[ShopCartModel new];
        NSDictionary   *sub_sku=[self selectedSKU];
        
        shop.brand_id       =_sku.brand_id;
        shop.goods_now_price=_sku.nowPrice;
        shop.brand_name     =_sku.brand_name;
        shop.brand_img      =_sku.brand_img;
        shop.goods_price    =_sku.price;
        shop.goods_img_url  =_sku.picture;
        shop.catalog_name   =_sku.catalog_name;
        shop.goods_name     =_sku.name;
        shop.goods_num      =num;
        
        shop.goods_id       =sub_sku[@"product_id"];
        shop.goods_sku_id   =sub_sku[@"id"];
        shop.goods_color    =sub_sku[@"color"];
        shop.goods_size     =sub_sku[@"product_size"];
        
        [arr addObject:shop];
        
        confirmVC.array=[arr copy];
        [[YJTOOL getRootControllerSelectedVc] pushViewController:confirmVC animated:YES];
    }
}

-(NSDictionary *)selectedSKU{
    NSArray *keyArr=[_sku.sku_dict allKeys];
    NSString *key=keyArr[_idx1];
    NSArray *valueArr=_sku.sku_dict[key];
    return valueArr[_idx2];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIViewController *parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        BrandBuyCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[BrandBuyCell2 cellReuseIdentifier] forIndexPath:indexPath];
        cell2.sub_sku=[self selectedSKU];
        return cell2;
    }
    ChooseGoodsPropertyCell *cell=[tableView dequeueReusableCellWithIdentifier:[ChooseGoodsPropertyCell cellReuseIdentifier] forIndexPath:indexPath];
    [self congifCell:cell indexpath:indexPath];
    return cell;
}

- (void)congifCell:(ChooseGoodsPropertyCell *)cell indexpath:(NSIndexPath *)indexpath{
    NSDictionary *dict = self.sku.sku_dict;
    NSArray *key = [dict allKeys];
    if (indexpath.row==0) {
        [cell configColorWith:key withIdx:_idx1];
        cell.containerView.didTapTagAtIndex = ^(NSUInteger idx){
            _idx1=idx;
            [self.tableView reloadData];
        };
    }else if (indexpath.row==1){
        [cell configSizeWith:dict[key[_idx1]] withIdx:_idx2];
        cell.containerView.didTapTagAtIndex = ^(NSUInteger idx){
            _idx2=idx;
            [self.tableView reloadData];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return 60;
    }
    
    return [tableView fd_heightForCellWithIdentifier:[ChooseGoodsPropertyCell cellReuseIdentifier]
                                    cacheByIndexPath:indexPath configuration:^(id cell) {
        [self congifCell:cell indexpath:indexPath];
    }];
}

@end
