//
//  WeatherView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/5.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^didWeatherViewBlcok)(void);

@interface WeatherView : UIView

@property(nonatomic,strong) didWeatherViewBlcok didWeatherViewBlcok; // 退出vie

@end

NS_ASSUME_NONNULL_END
