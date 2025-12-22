//
//  WeatherViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherViewCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView1;
@property (nonatomic,strong) UILabel *addressTitleL;
@property (nonatomic,strong) UILabel *cityL;
@property (nonatomic,strong) UILabel *temperatureL1;
@property (nonatomic,strong) UILabel *temperatureL2;

@property (nonatomic,strong) UIView *bgView2;
@property (nonatomic,strong) UILabel *titleL1;

- (void)weatherViewCellIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
