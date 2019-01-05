//
//  ChatCell.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=0;
        self.backgroundColor=kClearColor;
        self.contentView.backgroundColor=kClearColor;
        [self.contentView addSubview:self.chatLabel];
        [self.chatLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3];
        [self.chatLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [self.chatLabel autoSetDimension:ALDimensionWidth toSize:300];
    }
    return self;
}

-(void)setChatM:(ChatModel *)chatM
{
    _chatM=chatM;
    self.chatLabel.attributedText=chatM.chatString;
}

-(UILabel *)chatLabel
{
    if (!_chatLabel) {
        _chatLabel=[UILabel autolayoutView];
        _chatLabel.font=YJFont(14);
        _chatLabel.textColor=kWhiteColor;
        _chatLabel.numberOfLines=0;
    }
    return _chatLabel;
}

@end
