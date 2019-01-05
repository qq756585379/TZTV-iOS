//
//  OTSBlockImageView.h
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSBlockImageView;

typedef void(^OTSBlockImageViewClickBlock)(OTSBlockImageView *sender);

@interface OTSBlockImageView : UIImageView

@property (nonatomic, strong) id data;

- (void)setBlock:(OTSBlockImageViewClickBlock)block;

@end
