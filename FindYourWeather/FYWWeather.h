//
//  FYWWeather.h
//  FindYourWeather
//
//  Created by lemon on 01.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYWWeather : NSObject

@property (nonatomic, strong) NSString* status;

@property (nonatomic) int statusID;

@property (nonatomic, strong) NSString* condition;

@property (nonatomic, strong) NSString* latitude;

@property (nonatomic, strong) NSString* longitude;

@property (nonatomic, strong) NSString* visibility;

@property (nonatomic, strong) NSString* country;

@property (nonatomic, strong) NSString* cityName;

@property (nonatomic, strong) NSString* cityID;

@property (nonatomic, strong) NSNumber* temperatureCelcium;

@property (nonatomic, strong) NSNumber* temperatureFahrenheit;


@property (nonatomic) int temperatureMin;

@property (nonatomic) int temperatureMax;

@property (nonatomic) int humidity;

@property (nonatomic) int pressure;

@property (nonatomic) float windSpeed;

@property (nonatomic, strong) NSString* iconUrl;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
