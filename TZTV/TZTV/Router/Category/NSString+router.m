//
//  NSString+router.m
//  OneStore
//
//  Created by Luosa on 2017/2/14.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "NSString+router.h"
#import "NSString+safe.h"
#import "OTSJsonKit.h"

@implementation NSString (router)

+ (NSDictionary *)getDictFromJsonString:(NSString *)aJsonString{
    //urldecode
    NSString *jsonString = [aJsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *subStrings = [jsonString componentsSeparatedByString:@"="];
    
    if ([OTSRouterParamKey isEqualToString:subStrings[0]]) {
        if (subStrings[1]) {
            NSRange endCharRange = [jsonString rangeOfString:@"}" options:NSBackwardsSearch];
            if (endCharRange.location != NSNotFound) {
                jsonString = [jsonString substringToIndex:endCharRange.location+1];
            }
            NSRange range = [jsonString rangeOfString:@"="];
            //除去body＝剩下纯json格式string
            NSString *jsonStr = [jsonString substringFromIndex:range.location+1];
            if ([[jsonStr safeSubstringFromIndex:(jsonStr.length -1)] isEqualToString:@"\""]) { // 去掉末尾"号
                jsonStr = [jsonStr substringToIndex:(jsonStr.length-1)];
            }
            //将字符串转成dictionary
            NSDictionary *resultDict = [OTSJsonKit dictFromString:jsonStr];
            dict[OTSRouterParamKey] = resultDict;
        }
    }
    [dict.copy enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            dict[key] = [obj stringValue];
        }
    }];
    if (!dict[OTSRouterParamKey])
        dict[OTSRouterParamKey] = @{};
    return dict;
}

+ (NSString *)getRouterUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params{
    NSString *json = [OTSJsonKit stringFromDict:params];
    if (!json) {
        return urlString;
    }
    NSString *jsonString = [urlString stringByAppendingFormat:@"?%@=%@",OTSRouterParamKey,json];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)getRouterVCUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params{
    NSString *scheme = [OTSRouter singletonInstance].appScheme;
    return [self getRouterUrlStringFromUrlString:[NSString stringWithFormat:@"%@://%@", scheme, urlString] andParams:params];
}

+ (NSString *)getRouterFunUrlStringFromUrlString:(NSString *)urlString andParams:(NSDictionary *)params{
    NSString *funcScheme = [OTSRouter singletonInstance].appFuncScheme;
    return [self getRouterUrlStringFromUrlString:[NSString stringWithFormat:@"%@://%@", funcScheme, urlString] andParams:params];
}

@end



