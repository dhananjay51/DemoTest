//
//  UpdateEmpLocation.h
//  Tracker
//
//  Created by Macbook Pro on 22/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationTracker.h"

@interface UpdateEmpLocation : NSObject<CLLocationManagerDelegate>
+ (UpdateEmpLocation *)shareInstance;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

- (void)updateLocation:(NSDictionary *)empInfo;
@end
