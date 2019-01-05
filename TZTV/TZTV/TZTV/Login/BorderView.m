//
//  BorderView.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BorderView.h"
#import "UIView+YJ.h"

@implementation BorderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super initWithCoder:decoder]) {
        
    }
    return self;
}

/**
 *  这个方法在initWithCoder:方法后调用
 */
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    [self doBorderWidth:1 color:HEXRGBCOLOR(0x9d9d9d) cornerRadius:6];
}



@end
