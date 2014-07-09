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
    
    //setup the mapview delegate and user location
    self.mapView.delegate = self;
    [self.mapView showsUserLocation];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    //configure the location manager
    [self configureLocationManger];
}

- (void)configureLocationManger
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = (id)self;
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[self.locationManager requestWhenInUseAuthorization];
}

- (void)displayRegionInMapView
{
    if (self.trail)
    {
      [self createRegionForTrail];
    }
    else
    {
        
    }

}

- (void)createRegionForTrail
{
    //create a 2D coordinate for the map view
    CLLocationCoordinate2D centerCoordinate = [self calculateCenterCoordinate];
    
    //determine the size of the map area to show around the location
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.01, 0.01);
    
    //create the region of the map that we want to show
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
    
    //update the map view
    self.mapView.region = region;
}

- (CLLocationCoordinate2D)calculateCenterCoordinate
{
    CLLocation* startPostiton = [self.trail.geopoints firstObject];
    CLLocation* endPostiton = [self.trail.geopoints lastObject];
    
    float latitude = (startPostiton.coordinate.latitude + endPostiton.coordinate.latitude )/ 2;
    float longitude = (startPostiton.coordinate.longitude + endPostiton.coordinate.longitude )/ 2;
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}


#pragma mark - CLLocationManagerDelegate Method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self displayRegionInMapView];
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - MKMapViewDelegate Methods
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation %@",userLocation);
    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLocatingUser");
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers
{
    
}
@end
