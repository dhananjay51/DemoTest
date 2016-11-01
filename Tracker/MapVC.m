//
//  MapVC.m
//  Tracker
//
//  Created by Macbook Pro on 27/07/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "MapVC.h"
#import "SWRevealViewController.h"
#import "MapViewAnnotation.h"
#define METERS_PER_MILE 1609.344
@interface MapVC ()

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    self.navigationItem.title=@"MAP";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    

    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.theMapView addAnnotations:[self createAnnotations]];
    
    [self zoomToLocation];

    
       // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    //Read locations details from plist
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *lat= [prefs stringForKey:@"latitude"];
    NSString * log=[ prefs stringForKey:@"longitude"];
     NSString *address=[ prefs stringForKey:@"address"];

   
    double latitude = [lat doubleValue ];//[[self.tempdict objectForKey:@"latitude"] doubleValue];
          double longitude = [log doubleValue];
    NSString *title =address;
    
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
    
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
    
        [annotations addObject:annotation];
        
    
    return annotations;
}

- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *lat= [prefs stringForKey:@"latitude"];
    NSString * log=[ prefs stringForKey:@"longitude"];
    
    double latitude = [ lat doubleValue];
    double longitude = [ log doubleValue];
    

    zoomLocation.latitude = latitude;
    zoomLocation.longitude= longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.theMapView setRegion:viewRegion animated:YES];
    
    [self.theMapView regionThatFits:viewRegion];
}

@end
