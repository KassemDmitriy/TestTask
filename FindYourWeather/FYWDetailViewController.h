//
//  FYWDetailViewController.h
//  FindYourWeather
//
//  Created by lemon on 05.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYWWeather.h"

@interface FYWDetailViewController : UIViewController

@property (strong, nonatomic) FYWWeather *weatherObject;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
