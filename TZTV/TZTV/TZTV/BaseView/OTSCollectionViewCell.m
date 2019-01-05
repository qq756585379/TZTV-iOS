//
//  OTSCollectionViewCell.m
//  OneStoreFramework
//
//  Created by Aimy on 9/4/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSCollectionViewCell.h"

@implementation OTSCollectionViewCell

+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}
+ (UINib *)nib{
    NSString *className = NSStringFromClass([self class]);
    return [UINib nibWithNibName:className bundle:nil];
}
- (void)updateWithCellData:(id)aData
{
    
}
- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath
{
    
}
+ (CGSize)sizeForCellData:(id)aData{
    return CGSizeZero;
}
//这个方法如果滥用，会很恐怖。。。所以不能公开
- (UICollectionView *)__getCollectionView{
    static int level = 10;
    UICollectionView *collectionView = nil;
    
    UIView *view = self.superview;
    for (int i = 0; i < level; i++) {
        if ([view isKindOfClass:[UICollectionView class]]) {
            collectionView = (UICollectionView *)view;
            break;
        }
        if (view.superview) {
            view = view.superview;
        }else {
            break;
        }
    }
    return collectionView;
}
- (NSIndexPath *)indexPath{
    _indexPath = [[self __getCollectionView] indexPathForCell:self];
    return _indexPath;
}
- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

@end
