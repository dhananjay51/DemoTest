//
//  MapVC.h
//  Tracker
//
//  Created by Macbook Pro on 27/07/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface MapVC : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *theMapView;
@property (nonatomic, strong) CLGeocoder *myGeocoder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(weak, nonatomic)  NSDictionary *tempdict;

@end
