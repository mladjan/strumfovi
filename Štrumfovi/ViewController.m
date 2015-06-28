//
//  ViewController.m
//  Štrumfovi
//
//  Created by Mladjan Antic on 6/21/15.
//  Copyright (c) 2015 BLGRDCreative. All rights reserved.
//

#import "ViewController.h"
@import MapKit;
@import CoreLocation;


@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    if([self.locationManager
        respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    
    [self reloadPins];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PositionsSyncDone object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self reloadPins];
    }];
}

-(void)reloadPins{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSArray *pins = [[LocalManager sharedManager] getAllObjectsWithClass:@"Position" sortedBy:@"updated_at" withPredicate:nil];
    for(Position *position in pins){
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(position.latitudeValue, position.longitudeValue)];
        [annotation setTitle:position.comment];
        [self.mapView addAnnotation:annotation];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [manager stopUpdatingLocation];
    
    CLLocation *newLocation = locations.lastObject;
    // Set this location on the map
    [self.mapView setRegion:MKCoordinateRegionMake(newLocation.coordinate,
                                                   MKCoordinateSpanMake(0.1, 0.1)) animated:NO];
    
}



@end
