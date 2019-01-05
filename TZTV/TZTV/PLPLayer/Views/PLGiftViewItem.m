//
//  PLGiftViewItem.m
//  TZTV
//
//  Created by Luosa on 2017/2/20.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGiftViewItem.h"

@interface PLGiftViewItem()
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@end

@implementation PLGiftViewItem

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _chooseImageView.hidden=!selected;
}

-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:[UIImage imageNamed:@""]];
    _numLabel.text=[NSString stringWithFormat:@"%@",dict[@"money"]];
    _nameLabel.text=[NSString stringWithFormat:@"%@",dict[@"name"]];
}

@end
