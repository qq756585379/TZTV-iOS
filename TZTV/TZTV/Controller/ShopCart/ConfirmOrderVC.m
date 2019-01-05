//
//  ConfirmOrderVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "CartModel.h"
#import "ShopCartModel.h"
#import "ConfirmOrderCell.h"
#import "ConfirmOrderCell0.h"
#import "ConfirmOrderCell1.h"
#import "UploadModel.h"
#import "ConfirmOrderHeader.h"
#import "ConfirmOrderVC2.h"
#import "AddressVC.h"
#import "AddressModel.h"

@interface ConfirmOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel     *totalMoneyLabel;
@property (nonatomic, strong) AddressModel       *addressM;
@property (nonatomic, strong) NSMutableArray     *dataArray;
@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"确认订单";
    self.tableView.separatorStyle=0;
    [self.tableView registerNib:[ConfirmOrderCell nib] forCellReuseIdentifier:[ConfirmOrderCell cellReuseIdentifier]];
    [self.tableView registerNib:[ConfirmOrderCell0 nib] forCellReuseIdentifier:[ConfirmOrderCell0 cellReuseIdentifier]];
    [self setUpData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDefaultAddress];
}

-(void)getDefaultAddress{
    Account *account=[AccountTool account];
    NSString *url=[NSString stringWithFormat:getDefaultAddressURL,account.user_id,account.token];
    [MBProgressHUD showMessage:@""];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.addressM=[AddressModel mj_objectWithKeyValues:json[@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

-(void)setUpData{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    for (int i=0; i<_array.count; i++) {
        ShopCartModel *shop=_array[i];
        NSNumber *brand_id=shop.brand_id;
        
        if ([[dict allKeys] containsObject:brand_id]){
            CartModel *bigModel=dict[brand_id];
            [bigModel.array addObject:shop];
        }else{
            [dict setObject:[CartModel new] forKey:brand_id];
            CartModel *bigModel=dict[brand_id];
            bigModel.brand_id=brand_id;
            bigModel.brand_name=shop.brand_name;
            bigModel.brand_img=shop.brand_img;
            bigModel.isDeliver=YES;//默认需要配送
            [bigModel.array addObject:shop];
            [self.dataArray addObject:bigModel];
        }
        
    }
    [self calculateTotalMoney];//计算合计
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section>0) {
        CartModel *cart=self.dataArray[section-1];
        return cart.array.count+1;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ConfirmOrderCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:[ConfirmOrderCell1 cellReuseIdentifier] forIndexPath:indexPath];
        cell1.addressM=self.addressM;
        return cell1;
    }else{
        CartModel *cart=self.dataArray[indexPath.section-1];
        if (indexPath.row<cart.array.count) {
            ConfirmOrderCell0 *cell0=[tableView dequeueReusableCellWithIdentifier:[ConfirmOrderCell0 cellReuseIdentifier] forIndexPath:indexPath];
            cell0.shop=[cart.array safeObjectAtIndex:indexPath.row];
            cell0.bottomView.hidden=YES;
            return cell0;
        }else{
            ConfirmOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:[ConfirmOrderCell cellReuseIdentifier] forIndexPath:indexPath];
            cell.cart=cart;
            cell.myBlock=^(){
                [self calculateTotalMoney];//计算总价
            };
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [ConfirmOrderCell1 heightForCellData:nil];
    }else{
        CartModel *cart=self.dataArray[indexPath.section-1];
        if (indexPath.row<cart.array.count) {
            return [ConfirmOrderCell0 heightForCellData:nil];
        }else{
            return [ConfirmOrderCell heightForCellData:nil];
        }
    }
}

//计算总价
-(void)calculateTotalMoney{
    CGFloat price=0;
    for (CartModel *cart in self.dataArray) {
        for (ShopCartModel *shop in cart.array) {
            price = price + shop.goods_num * [shop.goods_now_price floatValue];
        }
        if (cart.isDeliver) {
            price=price + 15;//加运费，写死
        }
    }
    _totalMoneyLabel.text=[NSString stringWithFormat:@"￥%.2f",price];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) return nil;
    if (section==self.dataArray.count+1) return nil;
    ConfirmOrderHeader *header=[ConfirmOrderHeader tableHeaderWithTableView:tableView];
    CartModel *cart=self.dataArray[section-1];
    header.label.text=cart.brand_name;
    [header.iconIV sd_setImageWithURL:[NSURL URLWithString:cart.brand_img] placeholderImage:[UIImage imageNamed:@"placehold_160"]];
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        [self.navigationController pushViewController:[AddressVC new] animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0 || section==self.dataArray.count+1) {
        return 0.1;
    }
    return 45;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//提交订单
- (IBAction)submmitClicked:(UIButton *)sender {
    if (self.addressM==nil) {
        [MBProgressHUD showError:@"请完善收货信息！"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = [[AccountTool account] user_id];
    params[@"order_name"] =self.addressM.name;
    params[@"order_phone"] =self.addressM.phone;
    params[@"order_address"] =[NSString stringWithFormat:@"%@%@",self.addressM.address,self.addressM.detail];
    
    NSMutableArray *arr=[NSMutableArray array];
    for (CartModel *cart in self.dataArray) {
        UploadBigModel *bigModel=[UploadBigModel new];
        bigModel.brand_id=cart.brand_id;
        bigModel.express_method=cart.isDeliver?0:1;
        bigModel.express_price=@"15";
        bigModel.coupon_token=@"";
        bigModel.coupon_price=@"";
        bigModel.order_remark=cart.order_remark;
        
        for (ShopCartModel *shop in cart.array) {
            UploadModel *model=[UploadModel new];
            
            model.brand_id      =shop.brand_id;
            model.goods_id      =shop.goods_id;
            model.goods_sku_id  =shop.goods_sku_id;
            model.goods_num     =shop.goods_num;
            model.goods_price   =shop.goods_price;
            
            [bigModel.goodsList addObject:model];
        }
        [arr addObject:bigModel];
    }
    // Model array -> JSON array
    NSArray *dictArray = [UploadBigModel mj_keyValuesArrayWithObjectArray:arr];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString==%@",jsonString);
    params[@"order_info"] =jsonString;
    YJLog(@"params===%@",params);
    [MBProgressHUD showMessage:@""];
    [[YJHttpRequest sharedManager] post:addOrderURL params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            ConfirmOrderVC2 *vc2=[sb instantiateViewControllerWithIdentifier:@"ConfirmOrderVC2"];
            vc2.totalPrice=_totalMoneyLabel.text;
            vc2.data=json[@"data"];
            vc2.addressM=self.addressM;
            [self.navigationController pushViewController:vc2 animated:YES];
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        YJLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络貌似不太好"];
    }];
}

@end
