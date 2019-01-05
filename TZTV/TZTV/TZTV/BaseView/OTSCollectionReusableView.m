//
//  OTSCollectionReusableView.m
//  OneStoreFramework
//
//  Created by Aimy on 9/16/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSCollectionReusableView.h"

@implementation OTSCollectionReusableView

+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (UINib *)nib{
    NSString *className = NSStringFromClass([self class]);
    return [UINib nibWithNibName:className bundle:nil];
}

- (void)updateWithCellData:(id)aData{
    
}

+ (CGSize)sizeForCellData:(id)aData{
    return CGSizeZero;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
