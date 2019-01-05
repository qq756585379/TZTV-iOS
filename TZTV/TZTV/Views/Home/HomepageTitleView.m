//
//  HomepageTitleView.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomepageTitleView.h"

@implementation HomepageTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchBar];
        [self.searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    }
    return self;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入要搜索的文字";
        _searchBar.showsCancelButton = NO;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.backgroundImage = [UIImage new];
        
        UITextField *searBarTextField = [_searchBar valueForKey:@"_searchField"];
        
        if (searBarTextField){
            [searBarTextField setBackgroundColor:kClearColor];
            searBarTextField.borderStyle = UITextBorderStyleNone;
            //searBarTextField.layer.cornerRadius = 5.0f;
        }else{
            [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:kClearColor] forState:UIControlStateNormal];
        }
        //[[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YJNaviColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
        //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
        //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor redColor]];
    }
    return _searchBar;
}

@end
