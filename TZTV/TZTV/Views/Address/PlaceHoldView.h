//
//  PlaceHoldView.h
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHoldView : UIView

@property (nonatomic, strong) YJBlockImageView *placeImageView;
@property (nonatomic, strong) UILabel           *placeHoldLabel;
@property (nonatomic, strong) UIButton          *placeHoldBtn;

- (void)setInfo:(NSString *)Info ImgName:(NSString *)ImgName buttonTitle:(NSString *)title;

@property (nonatomic,   copy) void(^PlaceHoldBlock)(NSString *buttonTitle);

@end
