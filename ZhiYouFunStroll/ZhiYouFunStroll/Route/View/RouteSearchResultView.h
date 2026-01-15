//
//  RouteSearchResultView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RouteSearchResultView;

@protocol RouteSearchResultViewDelegate <NSObject>

@optional
/// 选中搜索结果
- (void)searchResultView:(RouteSearchResultView *)view didSelectResult:(NSDictionary *)result;
/// 点击"您的附近"
- (void)searchResultViewDidTapNearby:(RouteSearchResultView *)view;

@end

@interface RouteSearchResultView : UIView

@property (nonatomic, weak) id<RouteSearchResultViewDelegate> delegate;

/// 搜索结果数据
@property (nonatomic, strong) NSArray *searchResultList;

/// 根据关键词搜索
- (void)searchWithText:(NSString *)text;

/// 刷新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
