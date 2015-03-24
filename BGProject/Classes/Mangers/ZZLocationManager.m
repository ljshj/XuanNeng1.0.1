//
//  ZZLocationManager.m
//  BGProject
//
//  Created by ssm on 14-9-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZLocationManager.h"

#import <CoreLocation/CoreLocation.h>



@interface ZZLocationManager()<CLLocationManagerDelegate>

@end

@implementation ZZLocationManager


//  @{
//    @"longitude":longitude,//经度 NSNumber
//    @"latitude":latitude   //纬度 NSNumber
//  };

+(NSDictionary*)location {
    double currentLatitude = 0;
    double currentLongitude = 0;
    
    CLLocationManager *locManager = [[CLLocationManager alloc] init];
    
    // 判断是否可用
    if([CLLocationManager locationServicesEnabled]) {
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        locManager.distanceFilter = 5;
        
        [locManager startUpdatingLocation];
        currentLatitude = locManager.location.coordinate.latitude;
        currentLongitude=locManager.location.coordinate.longitude;
        
        [locManager stopUpdatingLocation];
    }
    NSNumber* longitude = [NSNumber numberWithDouble:currentLongitude];
    NSNumber* latitude = [NSNumber numberWithDouble:currentLatitude];
    
    NSDictionary* dic = @{@"longitude":longitude,
                          @"latitude":latitude};
    return dic;
}


@end
