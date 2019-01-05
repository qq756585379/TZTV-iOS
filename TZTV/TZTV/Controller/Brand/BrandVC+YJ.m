//
//  BrandVC+YJ.m
//  TZTV
//
//  Created by Luosa on 2016/11/25.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandVC+YJ.h"
#import "HomepageTitleView.h"

@implementation BrandVC (YJ)

-(void)initNavBar{
    HomepageTitleView *titleView=[[HomepageTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-40, 30)];
    titleView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
    [titleView doBorderWidth:1 color:kEDEDED cornerRadius:4];
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToSearchVCc)]];
    self.navigationItem.titleView = titleView;
}

@end
