//
//  BrandDetailVC1.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandDetailVC1.h"
#import "BrandDetailHeadImageView.h"
#import "PhoneDragTips.h"
#import "BrandDetailCell1.h"
#import "BrandDetailCell2.h"
#import "OTSBorder.h"
#import "ChooseGoodsPropertyVC.h"
#import "UIViewController+KNSemiModal.h"
#import "BrandSKU.h"

@interface BrandDetailVC1 ()
@property (nonatomic, strong) UIView                    *footerView;
@property (nonatomic, strong) ChooseGoodsPropertyVC     *chooseVC;
@property (nonatomic, strong) BrandSKU *sku;
@end

@implementation BrandDetailVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商品详情";
    [self initUI];
    [self getGoodsInfoSku];
}

-(void)getGoodsInfoSku{
    NSString *url=[NSString stringWithFormat:getGoodsInfoSkuURL,_ID];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"getGoodsInfoSku===%@",json);
        self.sku=[[BrandSKU alloc] initWithDict:json[@"data"]];
    } failure:^(NSError *error) {
        
    }];
}

-(void)initUI{
    self.webView.frame=CGRectMake(0,0,ScreenW,ScreenH-50);
    YJLog(@"_htmlString======%@",self.htmlUrl);
    if (self.htmlUrl.length) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]];
    }else{
        NSString *htmlUrl=[NSString stringWithFormat:shopDetail,_ID,_brand_id];
        YJLog(@"htmlUrl===%@",htmlUrl);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlUrl]]];
    }
    
    UIView *footerView=[[UIView alloc] init];
    footerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footerView];
    [footerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [footerView autoSetDimension:ALDimensionHeight toSize:50];
    self.footerView=footerView;
    [OTSBorder addBorderWithView:footerView type:OTSBorderTypeTop andColor:kEDEDED];
    
    CGFloat btnW=130;
    CGFloat kMargin=(ScreenW-btnW*2)/3;
    UIButton *addToCartBtn=[UIButton createButtonWithFrame:CGRectMake(kMargin, 8, btnW, 34) text:@"加入购物车" textColor:HEXRGBCOLOR(0x333333) font:YJFont(15) bgColor:YJNaviColor image:nil superView:footerView];
    UIButton *buyBtn=[UIButton createButtonWithFrame:CGRectMake(2*kMargin+btnW, 8, btnW, 34) text:@"立即购买" textColor:HEXRGBCOLOR(0x333333) font:YJFont(15) bgColor:YJNaviColor image:nil superView:footerView];
    [addToCartBtn doBorderWidth:1 color:YJNaviColor cornerRadius:17];
    [buyBtn doBorderWidth:1 color:YJNaviColor cornerRadius:17];
    addToCartBtn.tag=1;buyBtn.tag=2;
    [addToCartBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClicked:(UIButton *)sender{
    self.chooseVC.sku=self.sku;
    self.chooseVC.type=sender.tag;
    [self.navigationController presentSemiViewController:self.chooseVC withOptions:@{
                                                                                     KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                                     KNSemiModalOptionKeys.animationDuration : @(0.6),
                                                                                     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                                     KNSemiModalOptionKeys.backgroundView : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowBG"]]
                                                                                     }];
}

-(ChooseGoodsPropertyVC *)chooseVC{
    if (!_chooseVC) {
        _chooseVC=[sb instantiateViewControllerWithIdentifier:@"ChooseGoodsPropertyVC"];
    }
    return _chooseVC;
}

@end






