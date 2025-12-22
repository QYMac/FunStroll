//
//  WeatherHourData.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/5.
//

#import "WeatherHourData.h"

@implementation WeatherHourData

- (instancetype)initWithTime:(NSString *)time
                 temperature:(CGFloat)temperature
                        type:(WeatherType)type {
    self = [super init];
    if (self) {
        _time = time;
        _temperature = temperature;
        _type = type;
    }
    return self;
}

@end
