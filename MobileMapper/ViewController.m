//
//  ViewController.m
//  MobileMapper
//
//  Created by Edil Ashimov on 7/28/15.
//  Copyright (c) 2015 Edil Ashimov. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *mobileMakersAnnotation;
@property CLLocationManager *locMan;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Method used to created a request to access your location
    self.locMan = [CLLocationManager new];
    [self.locMan requestWhenInUseAuthorization];
    [self.mapView showsUserLocation];
    [self prefersStatusBarHidden];

    double latitude = 41.89374;
    double longtitude = -87.63533;


    //    instantiationg the Annotation
    self.mobileMakersAnnotation = [MKPointAnnotation new];
    self.mobileMakersAnnotation.coordinate =
    CLLocationCoordinate2DMake(latitude, longtitude);
    self.mobileMakersAnnotation.title = @"Mobile Makers";

    [self.mapView addAnnotation: self.mobileMakersAnnotation];
    [self geocodeLocation:@"Yosemite National Park"];
    [self geocodeLocation:@"Cafe Central Asia"];
}

//    Method which uses strings to display a location by dropping the pin. and you can call the method only by entering the name.
-(void)geocodeLocation:(NSString *)addressString

{
    NSString *address = addressString;
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError *error)

     {
         for (CLPlacemark *place in placemarks)
         {
             MKPointAnnotation *annotation = [MKPointAnnotation new];
             annotation.coordinate = place.location.coordinate;
             annotation.title = addressString;
             [self.mapView addAnnotation:annotation];
         }
     }];
}

//method to zoom the location
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control

{
    [self.mapView setRegion:MKCoordinateRegionMake(view.annotation.coordinate,
                                                   MKCoordinateSpanMake(0.1, 0.1))animated:true];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isEqual:mapView.userLocation])
    {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]
                                initWithAnnotation:annotation reuseIdentifier:nil];

    if ([annotation isEqual:self.mobileMakersAnnotation])
    {
        pin.image = [UIImage imageNamed:@"mobilemakersicon"];
    }
    if ([annotation.title isEqual:@"Cafe Central Asia"])
    {
        pin.image = [UIImage imageNamed:@"kgzlogo"];
    }
    pin.canShowCallout = true;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure];
    return pin;

}

@end
