//
//  FYWWeather.m
//  FindYourWeather
//
//  Created by lemon on 01.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import "FYWWeather.h"

@implementation FYWWeather

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];

    if (self) {
        
        int temperatureMin =
        [dictionary[@"main"][@"temp_min"] intValue];
        if(temperatureMin) {
            _temperatureMin = temperatureMin;
        }
        
        int temperature =
        [dictionary[@"main"][@"temp"] intValue];
        if(temperature) {
            _temperatureCelcium = [self kelvinToCelcius:[NSNumber numberWithInt:temperature]];
            _temperatureFahrenheit = [self kelvinToFahrenheit:[NSNumber numberWithInt:temperature]];

        }
        
        int pressure =
        [dictionary[@"main"][@"pressure"] intValue];
        if (pressure) {
            _pressure = pressure;
        }
        
        int temperatureMax =
        [dictionary[@"main"][@"temp_max"] intValue];
        if (temperatureMax) {
            _temperatureMax = temperatureMax;
        }
        
        int humidity =
        [dictionary[@"main"][@"humidity"] intValue];
        if (humidity) {
            _humidity = humidity;
        }
        
        float windSpeed =
        [dictionary[@"wind"][@"speed"] floatValue];
        if (windSpeed) {
            _windSpeed = windSpeed;
        }
        
        NSString *latitude = dictionary[@"coord"][@"lat"];
        if (latitude) {
            _latitude = latitude;
        }
        
        NSString *longitude = dictionary[@"coord"][@"lon"];
        if (longitude) {
            _longitude = longitude;
        }
        
        NSString *cityId = dictionary[@"id"];
        if (cityId) {
            _cityID = cityId;
        }
        
        NSString *cityName = dictionary[@"name"];
        if (cityName) {
            _cityName = cityName;
        }
        
        NSArray* weather = dictionary[@"weather"];
        if ([weather count] > 0) {
            NSDictionary* weatherData = [weather objectAtIndex:0];
            if (weatherData) {
                NSString *status = weatherData[@"main"];
                if (status) {
                    _status = status;
                }
                
                int statusID = [weatherData[@"id"] intValue];
                if (statusID) {
                    _statusID = statusID;
                }
                
                NSString *condition = weatherData[@"description"];
                if (condition) {
                    _condition = condition;
                }
                
                NSString *icon = weatherData[@"icon"];
                if (icon) {
                    _iconUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",icon];
                }
            }
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark - Conversions


- (NSNumber *)kelvinToCelcius:(NSNumber *)kelvin {
    
    float number = kelvin.floatValue - 273.15f;
    
    float roundedValue = round(2.0f * number) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
    
    return @([numberString floatValue]);
}


- (NSNumber *)kelvinToFahrenheit:(NSNumber *)kelvin {
    
    float number = (kelvin.floatValue * 9.0f/5.0f) - 459.67f;
    
    float roundedValue = round(2.0f * number) / 2.0f;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:roundedValue]];
    
    return @([numberString floatValue]);
}

@end
