//
//  FYWWeatherApiManager.m
//  FindYourWeather
//
//  Created by lemon on 01.06.17.
//  Copyright © 2017 Kassem Dmitriy. All rights reserved.
//

#import "FYWWeatherApiManager.h"

@implementation FYWWeatherApiManager

+ (id)sharedManager {
    
    static FYWWeatherApiManager *apiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiManager = [[self alloc] init];
    });
    
    return apiManager;
}

- (id)init {
    
    if (self = [super init]) {
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    return self;
}

- (void)getWeatherForLat:(NSString *)latitude Lng:(NSString *)longitude Completion:(Completion)completion {
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=f4ecd99dcc1eccc73576b49d423677bd",latitude,longitude];
    
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(nil,error);

    }];
    
}

- (void)getWeatherForCityName:(NSString *)cityName Completion:(Completion)completion {
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=f4ecd99dcc1eccc73576b49d423677bd",cityName];
    
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(nil,error);
        
    }];
    
}

- (void)getWeatherForCityID:(NSString *)cityID Completion:(Completion)completion {
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@&APPID=f4ecd99dcc1eccc73576b49d423677bd",cityID];
    
    [self GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(nil,error);
        
    }];
    
}


@end
