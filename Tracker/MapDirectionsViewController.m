//
//  MapDirectionsViewController.m
//  MapRouteKP
//
//  Created by kushal on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


 #import "MapDirectionsViewController.h"

 #define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)
 #define kBaseUrl @"http://maps.googleapis.com/maps/api/directions/json?"
 @implementation MapDirectionsViewController
 @synthesize theMapView;
 @synthesize startPoint=_startPoint;
 @synthesize endPoint = _endPoint;
 @synthesize wayPoints = _wayPoints;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
{
}
    return self;
}

- (void)didReceiveMemoryWarning
{
       [super didReceiveMemoryWarning];
 }

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
   
    self.navigationController.navigationBar.topItem.title = @"";

    
    oncezoom=YES;
    theMapView.userTrackingMode=YES;
    [theMapView setShowsUserLocation: YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *lat = [prefs stringForKey:@"latitude"];
    NSString *lon = [prefs stringForKey:@"longitude"];
    CLLocationCoordinate2D coord;
    
    coord.latitude=[ self.vendorlat floatValue];
    coord.longitude=[ self.vendorlon floatValue];
    MKCoordinateRegion region1;
    region1.center=coord;
    //     region1.span.longitudeDelta=0.1 ;
    //     region1.span.latitudeDelta=0.1;
    [theMapView setRegion:region1 animated:YES];
    
    NSString *titleStr =self.sourcename;
    ;
    
    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc]init];
    
    sourceAnnotation.coordinate=coord;
    
    sourceAnnotation.title=titleStr;
    [theMapView addAnnotation:sourceAnnotation];
    
    if ([lat isEqualToString:@""]) {
        
    }
    else if ([lon isEqualToString:@""])
    {
        
    }
    else{
        NSString* apiUrlStr =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@,%@&destination=%@,%@&sensor=false",lat,lon, _vendorlat, _vendorlon
                              ];
    
    
    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:apiUrlStr]];
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];

    }
}

#pragma mark - json parser

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    NSArray *arrRouts=[json objectForKey:@"routes"];
    if ([arrRouts isKindOfClass:[NSArray class]]&&arrRouts.count==0) {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"didn't find direction" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         [alrt show];
        return; 
    }
    NSArray *arrDistance =[[[json valueForKeyPath:@"routes.legs.steps.distance.text"] objectAtIndex:0]objectAtIndex:0];
    NSString *totalDuration = [[[json valueForKeyPath:@"routes.legs.duration.text"] objectAtIndex:0]objectAtIndex:0];
    NSString *totalDistance = [[[json valueForKeyPath:@"routes.legs.distance.text"] objectAtIndex:0]objectAtIndex:0];
    NSArray *arrDescription =[[[json valueForKeyPath:@"routes.legs.steps.html_instructions"] objectAtIndex:0] objectAtIndex:0];
    dictRouteInfo=[NSDictionary dictionaryWithObjectsAndKeys:totalDistance,@"totalDistance",totalDuration,@"totalDuration",arrDistance ,@"distance",arrDescription,@"description", nil];
    
    NSArray* arrpolyline = [[[json valueForKeyPath:@"routes.legs.steps.polyline.points"] objectAtIndex:0] objectAtIndex:0]; //2
    double srcLat=[[[[json valueForKeyPath:@"routes.legs.start_location.lat"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    double srcLong=[[[[json valueForKeyPath:@"routes.legs.start_location.lng"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    double destLat=[[[[json valueForKeyPath:@"routes.legs.end_location.lat"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    double destLong=[[[[json valueForKeyPath:@"routes.legs.end_location.lng"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    CLLocationCoordinate2D sourceCordinate = CLLocationCoordinate2DMake(srcLat, srcLong);
    CLLocationCoordinate2D destCordinate = CLLocationCoordinate2DMake(destLat, destLong);
   
    [self addAnnotationSrcAndDestination:sourceCordinate :destCordinate];
//    NSArray *steps=[[aary objectAtIndex:0]valueForKey:@"steps"];   
    
//    replace lines with this may work
    
    NSMutableArray *polyLinesArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < [arrpolyline count]; i++)
    {
        NSString* encodedPoints = [arrpolyline objectAtIndex:i] ;
        MKPolyline *route = [self polylineWithEncodedString:encodedPoints];
        [polyLinesArray addObject:route];
    }
    
    [theMapView addOverlays:polyLinesArray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    theMapView.delegate=self;
}

#pragma mark - add annotation on source and destination

-(void)addAnnotationSrcAndDestination :(CLLocationCoordinate2D )srcCord :(CLLocationCoordinate2D)destCord
{
    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *destAnnotation = [[MKPointAnnotation alloc]init];
    sourceAnnotation.coordinate=srcCord;
    destAnnotation.coordinate=destCord;
    sourceAnnotation.title=_startPoint;
    
    destAnnotation.title=_endPoint;
   
    [theMapView addAnnotation:sourceAnnotation];
    [theMapView addAnnotation:destAnnotation];
    
    MKCoordinateRegion region;
    
    
    MKCoordinateSpan span;
    region.center=srcCord;
    region.span=span;
    
}

#pragma mark - decode map polyline

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}
#pragma mark - map overlay 
- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {

    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 3;
    overlayView.strokeColor = [UIColor purpleColor];
    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1f];
    return overlayView;
    
}

#pragma mark - map annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if (annotation==theMapView.userLocation) {
        return nil;
    }
    static NSString *annotaionIdentifier=@"annotationIdentifier";
    MKPinAnnotationView *aView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotaionIdentifier ];
    if (aView==nil) {
        
        aView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotaionIdentifier];
        aView.pinColor = MKPinAnnotationColorRed;
//        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    aView.image=[UIImage imageNamed:@"3-star.png"];
       aView.animatesDrop=TRUE;
        aView.canShowCallout = YES;
        aView.calloutOffset = CGPointMake(-5, 5);
    } 
	
	return aView;
}


- (void)viewDidUnload
{
     [self setTheMapView:nil];
      [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation *currentLocation = userLocation;
    NSString * latitude= [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    NSString *longitude   = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    
    if (currentLocation != nil) {
    }
    
    // Stop Location Manager
    
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:latitude.floatValue
                            longitude:longitude.floatValue];
    
    self.myGeocoder = [[CLGeocoder alloc] init];
    
    [self.myGeocoder
     reverseGeocodeLocation:location
     completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error == nil &&
             [placemarks count] > 0){
             placemark = [placemarks lastObject];
             vendorLocation=[NSString stringWithFormat:@"%@ %@",
                             placemark.locality,
                             placemark.subLocality];
             NSLog(@"%@",vendorLocation);
             
        ///     [locationManager stopUpdatingLocation];
             
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:vendorLocation forKey:@"location"];
             [prefs setObject:latitude forKey:@"latitude"];
             [prefs setObject:longitude forKey:@"longitude"];
             [prefs synchronize];
             
         }
         
     }];

    if (oncezoom==YES) {
        
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    [theMapView setRegion:mapRegion animated: YES];
    oncezoom=NO;
    }else
    {
      
    }
   
}



@end
