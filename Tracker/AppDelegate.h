//
//  AppDelegate.h
//  Tracker
//
//  Created by vikas on 7/19/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationTracker.h"
#import "CustomButton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) NSDictionary *userdetaildict;
@property(nonatomic,strong) CustomButton *appbtn;
@property (nonatomic, strong) CustomButton *clockinbtn;
@property (nonatomic, strong) CustomButton *clockoutbtn;


+(AppDelegate*)getDelegate;
-(BOOL)connected;



@end

