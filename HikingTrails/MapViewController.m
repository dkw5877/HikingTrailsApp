//
//  SecondViewController.m
//  HikingTrails
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () < MKMapViewDelegate, CLLocationManagerDelegate >

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic)CLLocationManager* locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = (id)self;
    [self.locationManager startUpdatingLocation];
}

- (void)configureLocationManger
{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[self.locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}

@end
