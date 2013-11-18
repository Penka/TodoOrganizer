#import "IndoorViewController.h"
#import <GoogleMapsM4B/GoogleMaps.h>

@implementation IndoorViewController {
  GMSMapView *mapView_;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.78318
                                                          longitude:-122.403874
                                                               zoom:18];

  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.settings.myLocationButton = YES;

  self.view = mapView_;
}


@end
