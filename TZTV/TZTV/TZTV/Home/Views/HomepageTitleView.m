//
//  HomepageTitleView.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomepageTitleView.h"

@implementation HomepageTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchIicon];
        [self addSubview:self.placeHoldLabel];
    }
    return self;
}

-(UIImageView *)searchIicon{
    if (!_searchIicon) {
        _searchIicon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _searchIicon.image=[UIImage imageNamed:@"search"];
        _searchIicon.contentMode=UIViewContentModeCenter;
    }
    return _searchIicon;
}

-(UILabel *)placeHoldLabel{
    if (!_placeHoldLabel) {
        _placeHoldLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, self.width-40, 20)];
        _placeHoldLabel.font=YJFont(13);
        _placeHoldLabel.textColor=[UIColor lightGrayColor];
        _placeHoldLabel.text=@"快搜我，有惊喜";
    }
    return _placeHoldLabel;
}

@end
