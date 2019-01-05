//
//  FenLeiTableCell.h
//  TZTV
//
//  Created by Luosa on 2017/2/23.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenLeiModel.h"

@interface FenLeiTableCell : YJTableViewCell <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) FenLeiModel *bigModel;

@end
