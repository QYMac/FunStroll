//
//  RouteLocationCardView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RouteLocationCardView;

@protocol RouteLocationCardViewDelegate <NSObject>

@optional
/// 点击关闭按钮
- (void)locationCardViewDidTapClose:(RouteLocationCardView *)cardView;
/// 点击卡片
- (void)locationCardViewDidTap:(RouteLocationCardView *)cardView;

@end

@interface RouteLocationCardView : UIView

@property (nonatomic, weak) id<RouteLocationCardViewDelegate> delegate;

/// 配置卡片数据
/// @param imageUrl 图片URL
/// @param title 地点名称
/// @param address 地址
/// @param distance 距离
- (void)configureWithImageUrl:(NSString *)imageUrl
                        title:(NSString *)title
                      address:(NSString *)address
                     distance:(NSString *)distance;

@end

NS_ASSUME_NONNULL_END
