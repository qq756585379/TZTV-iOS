//
//  MapManager.m
//  klxc
//
//  Created by sctto on 16/4/14.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "MapManager.h"
#import "YJTOOL.h"
#import <CoreLocation/CoreLocation.h>

@interface MapManager ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager        *locationManager;
@property (nonatomic,  copy) CLManagerCompleteBlock    block;
@end

@implementation MapManager

HMSingletonM(Manager)

-(instancetype)init{
    if (self = [super init]) {
        if([CLLocationManager locationServicesEnabled]) {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                [self.locationManager requestWhenInUseAuthorization]; // 在使用时请求一直定位
            }
        }else{
            YJLog(@"无法定位");
        }
    }
    return self;
}

-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1000.f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

-(void)startSearchLocation{
    if (self.locationManager) {
        [self.locationManager startUpdatingLocation];
    }else{
        [self locationWithIp];
    }
}
- (void)startWithCompleteBlock:(CLManagerCompleteBlock)block{
    self.block = block;
    [self startSearchLocation];
}
-(void)stopSearchLocation{
    self.block=nil;
    [self.locationManager stopUpdatingLocation];
}
- (void)locationWithIp{
    [self locationWithCLLocation:nil];
}
- (void)locationWithCLLocation:(CLLocation *)aLocation{
    [self locationWithCLLocation:aLocation andCLPlacemark:nil];
}

- (void)locationWithCLLocation:(CLLocation *)aLocation andCLPlacemark:(CLPlacemark *)aMark{
    NSLog(@"纬度%0.12f 经度%0.8f", aLocation.coordinate.latitude, aLocation.coordinate.longitude);
//    if (aLocation!=nil) {
//        [YJTOOL setObject:aMark.locality forKey:CurrentCityKey];
//        [YJTOOL setObject:[NSString stringWithFormat:@"%0.12f",aLocation.coordinate.latitude] forKey:LatitudeKey];
//        [YJTOOL setObject:[NSString stringWithFormat:@"%0.8f",aLocation.coordinate.longitude] forKey:LongitudeKey];
//    }
    if (self.block) {
        self.block(aMark, aMark.addressDictionary, aLocation);
        self.block = nil;
    }
}

//通过定位信息获取城市信息
- (void)locationToCityName:(CLLocation *)aLocation{
    WEAK_SELF
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemark, NSError *error) {
        STRONG_SELF
        CLPlacemark *mark = nil;
        if (error) {
            YJLog(@"error = %@",error);
            [self locationWithCLLocation:aLocation];
        }else {
            mark = [placemark objectAtIndex:0];
            NSLog(@"国家:%@ 城市:%@ 区:%@ 具体位置:%@", mark.country, mark.locality, mark.subLocality, mark.name);
            NSLog(@"mark %@", mark);
            NSLog(@"dict %@", mark.addressDictionary);
            NSLog(@"Country %@", mark.addressDictionary[@"Country"]);
            NSLog(@"State %@", mark.addressDictionary[@"State"]);
            NSLog(@"City %@", mark.addressDictionary[@"City"]);
            [self locationWithCLLocation:aLocation andCLPlacemark:mark];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate -- ios5
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [self locationToCityName:newLocation];
    [self.locationManager stopUpdatingLocation];
}
#pragma mark 定位成功 iOS7 及其以后的新方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self locationToCityName:locations[0]];
    [self.locationManager stopUpdatingLocation];
}
#pragma mark 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    YJLog(@"定位失败:error:%@", error.localizedDescription);
    [self locationWithIp];
    [self.locationManager stopUpdatingLocation];
}
- (void)dealloc{
    self.locationManager.delegate = nil;
}

@end
