//
//  MapLocationDetailView.h
//  test
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MapLocationDetailView;

/// 地点详情View代理
@protocol MapLocationDetailViewDelegate <NSObject>

@optional
/// 点击关闭按钮
- (void)mapLocationDetailViewDidTapClose:(MapLocationDetailView *)detailView;
/// 点击分享按钮
- (void)mapLocationDetailViewDidTapShare:(MapLocationDetailView *)detailView;
/// 点击收藏按钮
- (void)mapLocationDetailViewDidTapFavorite:(MapLocationDetailView *)detailView;
/// 点击路线按钮
- (void)mapLocationDetailViewDidTapRoute:(MapLocationDetailView *)detailView;
/// 点击立即导航按钮
- (void)mapLocationDetailViewDidTapNavigate:(MapLocationDetailView *)detailView;

@end

/// 地点详情View
@interface MapLocationDetailView : UIView

/// 代理
@property (nonatomic, weak) id<MapLocationDetailViewDelegate> delegate;

/// 设置地点信息
/// @param name 地点名称
/// @param operatingHours 营业时间
/// @param distance 距离（公里）
/// @param driveTime 开车时间（分钟）
/// @param address 地址
/// @param imageUrls 图片URL数组
- (void)configureWithName:(NSString *)name
           operatingHours:(NSString *)operatingHours
                 distance:(CGFloat)distance
                driveTime:(NSInteger)driveTime
                  address:(NSString *)address
                imageUrls:(NSArray<NSString *> *)imageUrls;

/// @return 按钮底部距离父视图顶部的距离
- (CGFloat)navigateButtonBottomHeight;

@end

NS_ASSUME_NONNULL_END

