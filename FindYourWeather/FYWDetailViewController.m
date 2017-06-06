//
//  FYWDetailViewController.m
//  FindYourWeather
//
//  Created by lemon on 05.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import "FYWDetailViewController.h"
#import <UIImageView+AFNetworking.h>

@interface FYWDetailViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@end

@implementation FYWDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.weatherImage setImageWithURL:[NSURL URLWithString:self.weatherObject.iconUrl]];
    
    dataSource = [NSArray arrayWithObjects:
                  [NSString stringWithFormat:@"Area name: %@",self.weatherObject.cityName],
                  [NSString stringWithFormat:@"Latitude: %@",self.weatherObject.latitude],
                  [NSString stringWithFormat:@"Longitude: %@",self.weatherObject.longitude],
                  [NSString stringWithFormat:@"Temperature Celcium: %@",self.weatherObject.temperatureCelcium],
                  [NSString stringWithFormat:@"Temperature Fahrenheit: %@",self.weatherObject.temperatureFahrenheit],
                  [NSString stringWithFormat:@"Humidity: %i",self.weatherObject.humidity],
                  [NSString stringWithFormat:@"Wind speed: %.2f",self.weatherObject.windSpeed],
                  [NSString stringWithFormat:@"Pressure: %i",self.weatherObject.pressure],
                  [NSString stringWithFormat:@"Weather condition: %@",self.weatherObject.condition],nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.headerView.layer.masksToBounds = YES;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.headerView.clipsToBounds = YES;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headerView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.tableView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.tableView.layer.mask = maskLayer2;
}

#pragma mark -
#pragma mark - PopUp methods

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate {
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated {
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.dataSource.count;
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = dataSource[indexPath.row];
    
    return cell;
}

- (void)dealloc {
    
    dataSource = nil;
}

@end
