//
//  NSString+YJ.m
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "NSString+YJ.h"

@implementation NSString (YJ)

-(NSString *)yj_stringByAddingPercentEscapesUsingEncoding{
    return [self stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

-(NSString *)yj_stringByReplacingPercentEscapesUsingEncoding{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(NSString *)stringFromDate:(NSDate *)dat format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:dat];
}

- (NSString *)firstStringSeparatedByString:(NSString *)separeted{
    NSArray *list = [self componentsSeparatedByString:separeted];
    return [list firstObject];
}


@end
