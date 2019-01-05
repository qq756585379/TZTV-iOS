//
//  YouHuiJuanSubVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "YouHuiJuanSubVC.h"
#import "YouHuiJuanCell.h"

@interface YouHuiJuanSubVC ()
@property (nonatomic, strong) UICollectionView  *collectionView;
@end

@implementation YouHuiJuanSubVC

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        CGFloat width=(ScreenW-1)/2;
        flowLayout.itemSize = CGSizeMake(width,300);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.headerReferenceSize = CGSizeMake(ScreenW, 300);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) collectionViewLayout:flowLayout];
//        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
        _collectionView.backgroundColor=kF5F5F5;
        _collectionView.backgroundColor=[UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset=UIEdgeInsetsMake(0,0,35+64,0);
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset=UIEdgeInsetsMake(35, 0, 49+64, 0);
    [self.tableView addSubview:self.collectionView];
    [self.tableView bringSubviewToFront:self.collectionView];
    self.tableView.scrollEnabled=NO;
    [self.tableView registerNib:[YouHuiJuanCell nib] forCellReuseIdentifier:[YouHuiJuanCell cellReuseIdentifier]];
}




@end
