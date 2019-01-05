//
//  PLGiftView.m
//  TZTV
//
//  Created by Luosa on 2017/2/20.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGiftView.h"
#import "PLGiftViewItem.h"
#import "PLGiftCountView.h"

@interface PLGiftView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectinView;
@property (weak, nonatomic) IBOutlet PLGiftCountView *giftCountView;
@property (weak, nonatomic) IBOutlet UIButton *countButton;
@end

@implementation PLGiftView

+(CGFloat)view_height{
    return 306;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    YJLog(@"PLGiftView---awakeFromNib");
    [self configFlowLayout];
}

-(void)configFlowLayout{
    _collectinView.backgroundColor=kF5F5F5;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(ScreenW/4,130);
    _collectinView.showsVerticalScrollIndicator = NO;
    _collectinView.showsHorizontalScrollIndicator = NO;
    [_collectinView setCollectionViewLayout:flowLayout animated:YES];
    [_collectinView registerNib:[PLGiftViewItem nib] forCellWithReuseIdentifier:[PLGiftViewItem cellReuseIdentifier]];
    
    [_giftCountView setMyBlock:^(NSString *string) {
        [self.countButton setTitle:[NSString stringWithFormat:@"数量:%@",string] forState:UIControlStateNormal];
        [self hideView];
    }];
}

- (IBAction)p_btnClicked:(UIButton *)sender {
    if (sender.tag==1) {//选择数量按钮
        if ([_giftCountView isHidden]) {
            [self showView];
        }else{
            [self hideView];
        }
    }else if (sender.tag==2){//充值按钮
        
    }else if (sender.tag==3){//发送按钮
        
    }
}

-(void)setGiftArray:(NSArray *)giftArray{
    _giftArray=giftArray;
    [self.collectinView reloadData];
    [self.collectinView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - Collection view data souce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _giftArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLGiftViewItem *item=[collectionView dequeueReusableCellWithReuseIdentifier:[PLGiftViewItem cellReuseIdentifier] forIndexPath:indexPath];
    item.dict=[_giftArray safeObjectAtIndex:indexPath.row];
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self hideView];
}
-(void)showView{
    _giftCountView.hidden=NO;
    _giftCountView.alpha=0;
    [UIView animateWithDuration:0.2 animations:^{
        _giftCountView.alpha=1;
    }];
}
-(void)hideView{
    [UIView animateWithDuration:0.2 animations:^{
        _giftCountView.alpha=0;
    } completion:^(BOOL finished) {
        _giftCountView.hidden=YES;
    }];
}

@end




