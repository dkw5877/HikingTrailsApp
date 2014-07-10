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

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

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
    if (self.trail)
    {
        self.navigationBar.topItem.title = self.trail.trailName;
    }
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

}

- (void)createRegionForTrail
{
    //create a 2D coordinate for the map view
    CLLocationCoordinate2D centerCoordinate = [self calculateCenterCoordinate];
    
    //determine the size of the map area to show around the location
    MKCoordinateSpan coordinateSpan = [self calculateRegionSpan];
    //MKCoordinateSpanMake(0.01, 0.01);
    
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
        if (i == 0)
        {
            NSLog(@"start %f  %f",location.coordinate.latitude, location.coordinate.longitude);
        }
        points[i] = location.coordinate;
    }
    
    MKPolyline* route = [MKPolyline polylineWithCoordinates:points count:pointsCount];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:route];
}


- (MKCoordinateSpan)calculateRegionSpan
{
    float maxLatitude = -MAXFLOAT;
    float minLatitude = MAXFLOAT;
    float maxLongitude = -MAXFLOAT;
    float minLongitude  = MAXFLOAT;
    float margin = 0.005f;
    
    for (CLLocation* location in self.trail.geopoints)
    {
        if (location.coordinate.latitude > maxLatitude)
        {
            maxLatitude = location.coordinate.latitude;
        }
        if (location.coordinate.latitude < minLatitude)
        {
            minLatitude = location.coordinate.latitude;
        }
        if (location.coordinate.longitude > maxLongitude)
        {
            maxLongitude = location.coordinate.longitude;
        }
        if (location.coordinate.longitude < minLongitude)
        {
            minLongitude = location.coordinate.longitude;
        }
    }
    
    float latitudeDelta = fabs(maxLatitude) - fabs(minLatitude) + margin;
    float longitudeDelta = fabs(maxLongitude) - fabs(minLongitude) + margin;
    
    NSLog(@"maxLatitude:%f",maxLatitude);
    NSLog(@"minLatitude:%f",minLatitude);
    NSLog(@"maxLongitude:%f",maxLongitude);
    NSLog(@"minLongitude:%f",minLongitude);
    NSLog(@"latitudeDelta:%f",latitudeDelta);
    NSLog(@"longitudeDelta:%f",longitudeDelta);
    
    return MKCoordinateSpanMake(fabs(latitudeDelta), fabs(longitudeDelta));
}



#pragma mark - CLLocationManagerDelegate Method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self displayRegionInMapView];
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - MKMapViewDelegate Methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer* routeView = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    routeView.strokeColor = [UIColor redColor];
    routeView.lineWidth = 2.0f;
    return routeView;
}
@end
