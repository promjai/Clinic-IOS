//
//  PFMapViewController.h
//  Times Clinic
//
//  Created by Pariwat Promjai on 3/10/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

@interface PFMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (assign, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet PFMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end
