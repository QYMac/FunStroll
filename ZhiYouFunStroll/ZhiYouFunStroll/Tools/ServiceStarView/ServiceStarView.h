//
//  ServiceStarView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceStarView : UIView

@property (nonatomic,assign) BOOL selectable;  // 是否触摸选择分数
@property (nonatomic,assign) CGFloat score;    // 分数
@property (nonatomic,assign) BOOL supportDecimal; // 是否支持触摸选择小数

// size是你的图片的size   space是Star间的间距
- (instancetype)initWithStarSize:(CGSize)size space:(CGFloat)space numberOfStar:(NSInteger)number;

// 星星显示规则
+(CGFloat)scoreNumber:(CGFloat)score;

@end

NS_ASSUME_NONNULL_END
