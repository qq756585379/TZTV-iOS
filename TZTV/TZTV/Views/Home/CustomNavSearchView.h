//
//  CustomNavSearchView.h
//  TZTV
//
//  Created by Luosa on 2016/12/2.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

-(void)cancelSearchClicked;

@end

@interface CustomNavSearchView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UITextField *inputTF;

@property (nonatomic, strong) UIImageView *searchIicon;

@property (nonatomic, strong) UIView *cornerView;

@property (nonatomic,   weak) id<SearchViewDelegate>delegate;

@end
