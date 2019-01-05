//
//  PLGiftCountView.h
//  TZTV
//
//  Created by Luosa on 2017/2/22.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLGiftCountView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,   copy) void(^myBlock)(NSString *string);

@end
