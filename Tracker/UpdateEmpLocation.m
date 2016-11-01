//
//  UpdateEmpLocation.m
//  Tracker
//
//  Created by Macbook Pro on 22/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "UpdateEmpLocation.h"


static UpdateEmpLocation *sharedInstance;

@implementation UpdateEmpLocation

+(UpdateEmpLocation *) shareInstance{
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[UpdateEmpLocation alloc] init];
        
    }
    
     return  sharedInstance;

    
}

 - (void)updateLocation:(NSDictionary *)empInfo{
     
     ///uplodate location
     
     
     UIAlertView * alert;
     
     //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
   
         
         
         
         if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
             
             alert = [[UIAlertView alloc]initWithTitle:@""
                                               message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
             [alert show];
             
         }
         else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
             
             alert = [[UIAlertView alloc]initWithTitle:@""
                                               message:@"The functions of this app are limited because the Background App Refresh is disable."
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
             [alert show];
             
         } else{
             
             self.locationTracker = [[LocationTracker alloc]init];
             [self.locationTracker startLocationTracking];
             
             //Send the best location to server every 60 seconds
             //You may adjust the time interval depends on the need of your app.
             NSTimeInterval time = 60.0;
             self.locationUpdateTimer =
             [NSTimer scheduledTimerWithTimeInterval:time
                                              target:self
                                            selector:@selector(updateLocation)
                                            userInfo:nil
                                             repeats:YES];
         }
         
     }

     


-(void)updateLocation {
    
    
     NSLog(@"updateLocation");
    
  [self.locationTracker updateLocationToServer];
    
    }




@end
