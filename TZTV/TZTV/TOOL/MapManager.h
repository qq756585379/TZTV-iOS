//
//  MapManager.h
//  klxc
//
//  Created by sctto on 16/4/14.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CLManagerCompleteBlock)(CLPlacemark *mark, NSDictionary *addressDictionary, CLLocation *aLocation);

@interface MapManager : NSObject

HMSingletonH(Manager)

- (void)startSearchLocation;
- (void)startWithCompleteBlock:(CLManagerCompleteBlock)block;

- (void)stopSearchLocation;

@end
