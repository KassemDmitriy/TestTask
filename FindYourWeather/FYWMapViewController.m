//
//  FYWMapViewController.m
//  FindYourWeather
//
//  Created by lemon on 31.05.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import "FYWMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FYWMarkerInfoWindow.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "FYWWeatherApiManager.h"
#import "FYWWeather.h"

@interface FYWMapViewController () <CLLocationManagerDelegate,GMSMapViewDelegate> {
    
    CLLocationManager *locationManager;
    GMSMarker *myPosition;
    GMSMarker *scanPosition;
    FYWWeatherApiManager *apiManager;
    FYWWeather *myWeather;
    FYWWeather *scanWeather;

    FYWMarkerInfoWindow *infoWindowView;
}

@end

@implementation FYWMapViewController

#pragma mark -
#pragma mark - UIViewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedScannerData:) name:@"scanSucceed" object:nil];

    
    apiManager = [FYWWeatherApiManager sharedManager];
    
    self.mapView.myLocationEnabled = NO;
    self.mapView.settings.myLocationButton = NO;
    self.mapView.settings.compassButton = NO;
    self.mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [locationManager requestWhenInUseAuthorization];
        
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    [self updateMyLocationWeather];

  
}


#pragma mark -
#pragma mark - GMSViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay {
    
    NSLog(@"tapped");
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    FYWWeather *currentWeather;
    
    infoWindowView = nil;
    
    if (marker.zIndex == myPosition.zIndex) {
        
        currentWeather = myWeather;
        
    } else {
        
        currentWeather = scanWeather;
    }
    
    infoWindowView = [[[NSBundle mainBundle] loadNibNamed:@"FYWMarkerInfoWindow" owner:self options:nil] objectAtIndex:0];
    
    NSURL *imageURL = [NSURL URLWithString:currentWeather.iconUrl];
    
    infoWindowView.weatherImage.backgroundColor = [UIColor whiteColor];
    infoWindowView.weatherImage.layer.cornerRadius = 4.0;
    infoWindowView.infoBG.layer.cornerRadius = 4.0;
    infoWindowView.infoBG.layer.masksToBounds = YES;
    
    
    infoWindowView.name.text = [NSString stringWithFormat:@"%@ , %@",currentWeather.cityName,currentWeather.condition];
    infoWindowView.temperature.text = [NSString stringWithFormat:@"%@ C / %@ F",currentWeather.temperatureCelcium,currentWeather.temperatureFahrenheit];
    
    
    [infoWindowView.weatherImage setImageWithURL:imageURL];
    

    
    return infoWindowView;
    
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    if ([marker isEqual:myPosition]) {
        
        
        
    } else {
        
        
        
    }
    
}


#pragma mark -
#pragma mark - CoreLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (locations.count >= 1) {
        
        for (CLLocation *loc in locations) {
            float latt = loc.coordinate.latitude;
            float longtt = loc.coordinate.longitude;
            
            myPosition.position = loc.coordinate;
            
            NSLog(@"%f , %f",latt,longtt);
        }
        
        
    }
    
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        

        [self updateMyLocationWeather];
        
    } else {
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [locationManager requestWhenInUseAuthorization];
            
        }
        
    }
    
}

- (IBAction)locateUser:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:8];
    
    [self.mapView setCamera:camera];
    
}


#pragma mark -
#pragma mark - Additional Methods

- (IBAction)openQRReader:(id)sender {
    
}



- (void)recievedScannerData:(NSNotification *)notification {

    NSString *scanResult = [notification object];
    
    BOOL containsLetter = NSNotFound != [scanResult rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
    BOOL containsNumber = NSNotFound != [scanResult rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location;

    
    NSLog(@"%@",scanResult);
    scanPosition.map = nil;
    scanPosition = nil;
    
    if ([scanResult containsString:@"; "]) {
        
        NSArray *subStrings = [scanResult componentsSeparatedByString:@"; "];
        NSString *latitude = [subStrings objectAtIndex:0];
        NSString *longitude = [subStrings objectAtIndex:1];
        
        
        [apiManager getWeatherForLat:latitude Lng:longitude Completion:^(NSDictionary *dict, NSError *error) {
            
            if (dict) {
                
                NSLog(@"%@",dict);

                
                scanWeather = [[FYWWeather alloc] initWithDictionary:dict];
                scanPosition = [self createPinWithImage:@"pin" Position:CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue])];
                scanPosition.map = self.mapView;
                scanPosition.zIndex = 2;

                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:scanPosition.position.latitude
                                                                        longitude:scanPosition.position.longitude
                                                                             zoom:8];
                
                [self.mapView setCamera:camera];
                
            } else {
                
                NSLog(@"error = %@",error);
            }
            
            
        }];
        
        
    } else if (containsNumber && !containsLetter) {
        
        [apiManager getWeatherForCityID:scanResult Completion:^(NSDictionary *dict, NSError *error) {
            if (dict) {
                
                NSLog(@"%@",dict);

                
                scanWeather = [[FYWWeather alloc] initWithDictionary:dict];
                scanPosition = [self createPinWithImage:@"pin" Position:CLLocationCoordinate2DMake([dict[@"coord"][@"lat"] floatValue], [dict[@"coord"][@"lon"] floatValue])];
                scanPosition.map = self.mapView;
                scanPosition.zIndex = 2;

                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:scanPosition.position.latitude
                                                                        longitude:scanPosition.position.longitude
                                                                             zoom:8];
                
                [self.mapView setCamera:camera];
                
                
            } else {
                
                NSLog(@"%@",error);
            }
        }];
        
    } else {
        
        [apiManager getWeatherForCityName:scanResult Completion:^(NSDictionary *dict, NSError *error) {
            if (dict) {
                
                NSLog(@"%@",dict);

                
                scanWeather = [[FYWWeather alloc] initWithDictionary:dict];
                scanPosition = [self createPinWithImage:@"pin" Position:CLLocationCoordinate2DMake([dict[@"coord"][@"lat"] floatValue], [dict[@"coord"][@"lon"] floatValue])];
                scanPosition.map = self.mapView;
                scanPosition.zIndex = 2;

                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:scanPosition.position.latitude
                                                                        longitude:scanPosition.position.longitude
                                                                             zoom:8];
                
                [self.mapView setCamera:camera];
                
            } else {
                
                NSLog(@"%@",error);

                
            }
        }];
        
        
        
    }
    

}

- (void)updateMyLocationWeather {
    
    
    [apiManager getWeatherForLat:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude] Lng:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude] Completion:^(NSDictionary *dict, NSError *error) {
        
        if (dict) {
            NSLog(@"%@",dict);
            
            myWeather = [[FYWWeather alloc] initWithDictionary:dict];
            
        } else {
            NSLog(@"%@",error);
        }
        
    }];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:8];
    
    [self.mapView setCamera:camera];
    
    myPosition = [self createPinWithImage:@"pin" Position:locationManager.location.coordinate];
    myPosition.zIndex = 1;
    myPosition.map = self.mapView;
    

    
}


- (GMSMarker *)createPinWithImage:(NSString *)imageName Position:(CLLocationCoordinate2D)coord {
    
    GMSMarker *pin = [[GMSMarker alloc] init];
    pin.position = coord;
    pin.icon = [UIImage imageNamed:imageName];
    pin.infoWindowAnchor = CGPointMake(0.465f, 0.30f);
    pin.appearAnimation = kGMSMarkerAnimationPop;
    pin.tappable = YES;
    

    return pin;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
