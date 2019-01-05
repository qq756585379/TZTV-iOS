//
//  NSDate+YJ.h
//  TZTV
//
//  Created by Luosa on 2016/11/18.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YJ)

-(NSString *)stringFromDateWithFormat:(NSString *)format;

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;

@end
