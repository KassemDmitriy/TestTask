//
//  FYWWeatherApiManager.h
//  FindYourWeather
//
//  Created by lemon on 01.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface FYWWeatherApiManager : AFHTTPSessionManager

typedef void (^Completion)(NSDictionary *dict, NSError *error);

+ (id)sharedManager;

- (void)getWeatherForLat:(NSString *)latitude Lng:(NSString *)longitude Completion:(Completion)completion;

- (void)getWeatherForCityName:(NSString *)cityName Completion:(Completion)completion;

- (void)getWeatherForCityID:(NSString *)cityID Completion:(Completion)completion;

@end
