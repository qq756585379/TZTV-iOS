//
//  ConfirmOrderVC2.m
//  TZTV
//
//  Created by Luosa on 2016/12/1.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ConfirmOrderVC2.h"
#import "AddressModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MyOrderDetailVC.h"
#import "MyOrderFatherVC.h"

@interface ConfirmOrderVC2 ()
@property (weak, nonatomic) IBOutlet UILabel *shouhuorenLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouhuoAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (nonatomic,   copy) NSString *pid;
@end

@implementation ConfirmOrderVC2

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"支付";
    self.tableView.separatorStyle=1;
    [self setData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySussess:) name:PaySuccessNotification object:nil];
}

-(void)setData{
    if (self.type==ConfirmOrderTypeFromMyOrderSon) {
        _moneyLabel.text=[NSString stringWithFormat:@"￥%@",_order.order_price];
        _shouhuorenLabel.text=[NSString stringWithFormat:@"收货人：%@",_order.order_name];
        _telLabel.text=_order.order_phone;
        _shouhuoAddressLabel.text=[NSString stringWithFormat:@"收货地址：%@",_order.order_address];
    }else{
        _moneyLabel.text=_totalPrice;
        _shouhuorenLabel.text=[NSString stringWithFormat:@"收货人：%@",_addressM.name];
        _telLabel.text=_addressM.phone;
        _shouhuoAddressLabel.text=[NSString stringWithFormat:@"收货地址：%@%@",_addressM.address,_addressM.detail];
    }
}

-(void)paySussess:(NSNotification *)notify{
    [self loadRequestWith:[notify userInfo]];
}

-(void)loadRequestWith:(NSDictionary *)resultDic{
    if ([resultDic[@"resultStatus"] intValue]==9000) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"pid"] = self.pid;
        NSString *jsonString=[NSString stringWithFormat:@"resultStatus={%@};memo={%@};result={%@}",resultDic[@"resultStatus"],resultDic[@"memo"],resultDic[@"result"]];
        params[@"payResult"] = jsonString;
        
        [[YJHttpRequest sharedManager] post:setPayResultURL params:params success:^(id json) {
            YJLog(@"+++++++++++++%@",json);
            [MBProgressHUD hideHUD];
            if ([json[@"code"] isEqualToNumber:@0]) {
                [MBProgressHUD showSuccess:@"支付成功"];
                MyOrderDetailVC *detail=[sb instantiateViewControllerWithIdentifier:@"MyOrderDetailVC"];
                //支付成功后改变order的order_state状态跳到订单详情页面
                _order.order_state=1;//待发货
                detail.order=_order;
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                [MBProgressHUD showToast:json[@"msg"]];
                MyOrderFatherVC *vc=[MyOrderFatherVC new];
                vc.type=1;
                [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"支付失败"];
            
            MyOrderFatherVC *vc=[MyOrderFatherVC new];
            vc.type=1;
            [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
        }];
    }else{
        NSString *resultMes = [resultDic[@"memo"] length]?resultDic[@"memo"]:@"支付失败";
        [MBProgressHUD hideHUD];
        [MBProgressHUD showToast:resultMes];
        
        MyOrderFatherVC *vc=[MyOrderFatherVC new];
        vc.type=1;
        [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
    }
}

- (IBAction)zhifubaoClicked:(UIButton *)sender {
    if (sender.selected) return;
    _weixinBtn.selected=NO;
    _zhifubaoBtn.selected=YES;
}
- (IBAction)weixinClicked:(UIButton *)sender {
    if (sender.selected) return;
    _zhifubaoBtn.selected=NO;
    _weixinBtn.selected=YES;
}

#pragma mark - 确认支付
- (IBAction)sureClicked:(UIButton *)sender {
    [MBProgressHUD showMessage:@""];
    NSString *url=@"";
    if (self.type==ConfirmOrderTypeFromMyOrderSon) {
        //ids/user_id/pay_type --0为微信支付;1：支付宝；2：钱包；3：银联；4：现金；/pay_method --0：支付,1：充值
        url=[NSString stringWithFormat:getPayDataURL,_order.order_no,[[AccountTool account] pid],_weixinBtn.selected?0:1,0];
    }else{
        url=[NSString stringWithFormat:getPayDataURL,_data,[[AccountTool account] pid],_weixinBtn.selected?0:1,0];
    }
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            NSDictionary *dict=json[@"data"];
            self.pid=dict[@"pid"];
            
            NSString *signedString=(__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)dict[@"sign"], NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
            
            NSString *orderSpec=dict[@"orderInfo"];
            
            if (signedString != nil) {
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString, @"RSA"];
                //网页支付回调
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"TZTV" callback:^(NSDictionary *resultDic) {
                    NSLog(@"web callback reslut = %@",resultDic);
                    [self loadRequestWith:resultDic];
                }];
            }
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"支付失败！"];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
@end







