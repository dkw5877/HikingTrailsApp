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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
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
      [self createTrailFromGeopoints];
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

- (void)createTrailFromGeopoints
{
    NSInteger pointsCount = self.trail.geopoints.count;
    
    //create C style array for holding the point structure
    CLLocationCoordinate2D points[pointsCount];
    
    for (int i = 0; i < pointsCount; i++)
    {
        CLLocation* location = self.trail.geopoints[i];
        points[i] = location.coordinate;
    }
    
    MKPolyline* route = [MKPolyline polylineWithCoordinates:points count:pointsCount];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:route];
}


- (void)calculateSpan
{
    float maxLatitude = 0.0;
    float minLatitude = 0.0;
    float maxLongitude = 0.0;
    float minLongitude  = 0.0;
    
    for (CLLocation* location in self.trail.geopoints)
    {
        if (location.coordinate.latitude > maxLatitude)
        {
            maxLatitude = location.coordinate.latitude;
        }
        else if (location.coordinate.latitude < minLatitude)
        {
            minLatitude = location.coordinate.latitude;
        }
        else if (location.coordinate.longitude > maxLongitude)
        {
            maxLongitude = location.coordinate.longitude;
        }
        else if (location.coordinate.longitude < minLongitude)
        {
            minLongitude = location.coordinate.longitude;
        }
    }
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
    [self createRegionForTrail];
    [self createTrailFromGeopoints];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer* routeView = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    routeView.strokeColor = [UIColor greenColor];
    routeView.lineWidth = 1.0f;
    return routeView;
}
@end
