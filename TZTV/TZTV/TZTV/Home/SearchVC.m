//
//  SearchVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SearchVC.h"
#import "CategorySearchBar.h"
#import "UISearchBar+YJ.h"

@interface SearchVC ()
@property (strong, nonatomic) CategorySearchBar *mySearchBar;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    
}

-(CategorySearchBar *)mySearchBar{
    if (!_mySearchBar) {
        //添加搜索框
        _mySearchBar = [[CategorySearchBar alloc] initWithFrame:CGRectMake(20,7, ScreenW-75, 31)];
        _mySearchBar.layer.cornerRadius=8;
        _mySearchBar.layer.masksToBounds=TRUE;
        [_mySearchBar.layer setBorderWidth:8];
        [_mySearchBar.layer setBorderColor:[UIColor whiteColor].CGColor];//设置边框为白色
        [_mySearchBar sizeToFit];
        [_mySearchBar setTintColor:[UIColor colorWithWhite:1 alpha:0.9]];
        [_mySearchBar insertBGColor:[UIColor colorWithHexString:@"0xffffff"]];
        //        [searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        //        [searchBar setPositionAdjustment:UIOffsetMake(10,0) forSearchBarIcon:UISearchBarIconClear];
        //        searchBar.searchTextPositionAdjustment=UIOffsetMake(10,0);
        [_mySearchBar setHeight:30];
    }
    return _mySearchBar;
}

@end
