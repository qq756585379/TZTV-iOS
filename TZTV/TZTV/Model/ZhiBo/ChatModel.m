//
//  ChatModel.m
//  TZTV
//
//  Created by Luosa on 2016/12/26.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel
{
    CGFloat _cellHeight;
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGRect attrsRect=[self.chatString boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        _cellHeight=attrsRect.size.height+6;
    }
    return _cellHeight;
}

-(NSMutableAttributedString *)chatString
{
    if (!_chatString) {
        NSString *allStr=[NSString stringWithFormat:@"%@: %@",_nicname,_msg_content];
        NSMutableAttributedString *attributeString_atts=[[NSMutableAttributedString alloc] initWithString:allStr];
        NSRange range = [allStr rangeOfString:[NSString stringWithFormat:@"%@:",_nicname]];
        [attributeString_atts addAttributes:@{NSForegroundColorAttributeName:HEXRGBCOLOR(0xE15555),
                                              NSFontAttributeName:YJFont(14)
                                              } range:range];
        [attributeString_atts addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                              NSFontAttributeName:YJFont(14)
                                              } range:[allStr rangeOfString:_msg_content]];
        _chatString=attributeString_atts;
    }
    return _chatString;
}

-(instancetype)initWith:(NSDictionary *)dict
{
    if (self = [super init]) {
        _nicname=dict[@"nicname"];
        _msg_content=dict[@"msg_content"];
        _msg_id=dict[@"msg_id"];
    }
    return self;
}

@end
