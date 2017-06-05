//
//  FYWMapViewController.h
//  FindYourWeather
//
//  Created by lemon on 31.05.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FYWMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *barView;

@end
