//
//  PlaceViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/18/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "PlaceViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PlaceViewController ()

@end

@implementation PlaceViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
	self.view.backgroundColor = [UIColor whiteColor];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:2];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic"]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
