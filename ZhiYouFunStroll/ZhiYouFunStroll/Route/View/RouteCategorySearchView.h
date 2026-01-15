//
//  RouteCategorySearchView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RouteCategorySearchView;

@protocol RouteCategorySearchViewDelegate <NSObject>

@optional
/// 点击分类
- (void)categorySearchView:(RouteCategorySearchView *)view didSelectCategory:(NSDictionary *)category;
/// 点击历史记录
- (void)categorySearchView:(RouteCategorySearchView *)view didSelectHistoryItem:(NSString *)historyItem;
/// 清除历史记录
- (void)categorySearchViewDidClearHistory:(RouteCategorySearchView *)view;

@end

@interface RouteCategorySearchView : UIView

@property (nonatomic, weak) id<RouteCategorySearchViewDelegate> delegate;

/// 历史记录数据
@property (nonatomic, strong) NSArray *historyItems;

/// 显示视图
- (void)show;

/// 隐藏视图
- (void)hide;

/// 刷新历史记录
- (void)reloadHistory;

@end

NS_ASSUME_NONNULL_END
