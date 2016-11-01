//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"

#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
			_locationManager.allowsBackgroundLocationUpdates = YES;
			_locationManager.pausesLocationUpdatesAutomatically = NO;
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

-(void)applicationEnterBackground{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}


- (void)startLocationTracking {
    NSLog(@"startLocationTracking");

	if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[servicesDisabledAlert show];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if(IS_OS_8_OR_LATER) {
              [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
	}
}


  - (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
	 CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	 [locationManager stopUpdatingLocation];
}

 #pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations");
    
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 30.0)
        {
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:dict];
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                    userInfo:nil
                                                     repeats:NO];

}


//Stop the locationManager
 -(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
     NSLog(@"locationManager stop Updating after 10 seconds");
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
   // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer");
    
    // Find the best location from the array based on accuracy
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    NSLog(@"My Best location:%@",myBestLocation);
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count==0)
    {
        NSLog(@"Unable to get location, use the last known location");

        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else{
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    
       NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);

    
    
        //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
    
         //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    
             [self.shareModel.myLocationArray removeAllObjects];
             self.shareModel.myLocationArray = nil;
             self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
    
     CLLocation *location = [[CLLocation alloc]
                             initWithLatitude:self.myLocation.latitude
                             longitude:self.myLocation.longitude];
    
      [self AddttenceWebservice];

    
     // Reverse Geocoding
    
       [geocoder reverseGeocodeLocation: location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            
              placemark = [placemarks lastObject];
              NSString*sss= [NSString stringWithFormat:@"%@ , %@ , %@",[placemark thoroughfare],[placemark locality],[placemark administrativeArea]];
              NSString*locationstr=[NSString stringWithFormat:@"%@ %@",
                                  placemark.locality,
                                  placemark.subLocality ];
            
            
            
            
            
        }
        else {
            
            NSLog(@"%@", error.debugDescription);
            
        }
        
    } ];
    

    
    
}


-(void)AddttenceWebservice{
    
    if ([[AppDelegate getDelegate] connected])
    {
        NSMutableDictionary * tempDict;
        
        tempDict=[[ NSMutableDictionary alloc]init];
        
        
      
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
      
        NSString *custimerid = [prefs stringForKey:@"customer_id"];
        NSString * rosterId=[ prefs stringForKey:@"rosterId"];
        NSString * companyname=[ prefs stringForKey:@"companyname"];
        
        
          [tempDict setObject:[NSNumber numberWithDouble:self.myLocation.latitude ]forKey:@"lattitude"];
        
             [tempDict setValue:[NSNumber numberWithDouble:self.myLocation.longitude] forKey:@"longitude"];
            
            
            [tempDict setObject:custimerid forKey:@"customer_site_id"];
        
            [tempDict setObject:@"1" forKey:@"LoginStatus"];
        
           [tempDict setObject:rosterId forKey:@"roster_id"];
        
           [tempDict setObject:companyname forKey:@"company_name"];
        
        
           NSString * ip=[ self getIPAddress];
        
        
        NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
        NSLog(@"output is : %@", Identifier);
        
        [tempDict setObject:ip forKey:@"ip_in"];
        [tempDict setObject:Identifier forKey:@"imei_in"];


        
            
            NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"TokenId"];
            
            
            
            NSURL *strURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/addattendance"];
            
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
            [request addValue:TokenId forHTTPHeaderField:@"Auth"];
            
            NSError *error;
            NSData *json = [NSJSONSerialization dataWithJSONObject:tempDict options:0 error:&error];
            
            [request setHTTPBody:json];
            
            
            
            
            
             [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (data == nil)
                 {
                     
                     UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"The network connection lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     
                      [msg show];
                     
                     return;
                 }
                 
                 
                  NSDictionary * dictionary = nil;
                 
                 
                  dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 
                 
                   NSLog(@"results == %@",dictionary);
                  int code=[[ dictionary valueForKey:@"code"] intValue];
                 
                 
                 
                 
                 
                 if  (code==0)
                 {
                      [ AppDelegate getDelegate].clockoutbtn.enabled=YES;
                      [ AppDelegate getDelegate].clockoutbtn.alpha = 1;
                     
                     
                    }
                 
                 
                 
                 else{
                     
                     
                     
                 }
                 
                 
                 
             }];
            
        }
        
    
        
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
@end
