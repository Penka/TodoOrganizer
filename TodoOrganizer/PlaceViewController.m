//
//  PlaceViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/18/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "PlaceViewController.h"
#import <MapKit/MapKit.h>

@implementation PlaceViewController{
    MKMapView *mapView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
	self.view.backgroundColor = [UIColor whiteColor];

    mapView_ = [[MKMapView alloc] init];
    self.view = mapView_;
    [self searchPlace:self.todoPlace];
}

- (void)searchPlace: (NSString *) address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error)
     {
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *topResult = [placemarks objectAtIndex:0];
             MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
             
             [mapView_ addAnnotation:placemark];
             
             CLLocationCoordinate2D _venue = placemark.coordinate;
             
             [mapView_ setCenterCoordinate:_venue];
             
             MKCoordinateRegion region = mapView_.region;
             region.span.longitudeDelta = 1.0;
             region.span.latitudeDelta = 1.0;
             [mapView_ setRegion:region animated:YES];
             
         }
         else{
             UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
             label.text = @"Sorry but no such address.";
             label.backgroundColor = [UIColor whiteColor];
             label.textColor = [UIColor redColor];
             self.view = label;
         }
         
     }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
