//
//  NSString+YJ.h
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YJ)

-(NSString *)yj_stringByAddingPercentEscapesUsingEncoding;
-(NSString *)yj_stringByReplacingPercentEscapesUsingEncoding;

-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

-(BOOL)isPhoneNo;
-(BOOL)isEmail;

-(NSString *)stringFromDate:(NSDate *)dat format:(NSString *)format;

//获取首字母
- (NSString *)firstStringSeparatedByString:(NSString *)separeted;

@end
