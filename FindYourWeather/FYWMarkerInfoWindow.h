//
//  FYWMarkerInfoWindow.h
//  FindYourWeather
//
//  Created by lemon on 31.05.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYWMarkerInfoWindow : UIView

@property (weak, nonatomic) IBOutlet UIImageView *infoBG;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *temperature;


@end
