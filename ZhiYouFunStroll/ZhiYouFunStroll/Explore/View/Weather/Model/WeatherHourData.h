//
//  WeatherHourData.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WeatherType) {
    WeatherTypeSunny,
    WeatherTypeCloudy,
    WeatherTypePartlyCloudy,
    WeatherTypeRainy,
    WeatherTypeThunderstorm
};

@interface WeatherHourData : NSObject

@property (nonatomic, strong) NSString *time;      // 时间，如"07:00"
@property (nonatomic, assign) CGFloat temperature; // 温度
@property (nonatomic, assign) WeatherType type;    // 天气类型
@property (nonatomic, assign) CGFloat positionX;   // 曲线中的X坐标

- (instancetype)initWithTime:(NSString *)time
                 temperature:(CGFloat)temperature
                        type:(WeatherType)type;

@end

NS_ASSUME_NONNULL_END
