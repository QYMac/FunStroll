//
//  MapSearchView.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 搜索分类模型
@interface MapSearchCategory : NSObject

/// 分类标题
@property (nonatomic, copy) NSString *title;
/// 分类图标颜色（用于色块显示）
@property (nonatomic, strong) UIImage *iconImg;
/// 分类标识
@property (nonatomic, copy) NSString *categoryId;

+ (instancetype)categoryWithTitle:(NSString *)title iconImg:(UIImage *)iconImg categoryId:(NSString *)categoryId;

@end

/// 搜索View代理
@protocol MapSearchViewDelegate <NSObject>

@optional
/// 搜索框文本改变
- (void)mapSearchView:(UIView *)searchView textDidChange:(NSString *)text;
/// 搜索框开始编辑
- (void)mapSearchViewDidBeginEditing:(UIView *)searchView;
/// 搜索框点击搜索
- (void)mapSearchView:(UIView *)searchView didSearchWithText:(NSString *)text;
/// 点击分类
- (void)mapSearchView:(UIView *)searchView didSelectCategory:(MapSearchCategory *)category;
/// 点击历史记录项
- (void)mapSearchView:(UIView *)searchView didSelectHistoryItem:(NSString *)historyItem;
/// 点击清除历史记录
- (void)mapSearchViewDidClearHistory:(UIView *)searchView;

@end

/// 地图搜索View
@interface MapSearchView : UIView

/// 代理
@property (nonatomic, weak) id<MapSearchViewDelegate> delegate;

/// 搜索框占位符文本
@property (nonatomic, copy) NSString *placeholder;

/// 历史记录数据源
@property (nonatomic, strong) NSArray *historyItems;

/// 分类数据源
@property (nonatomic, strong) NSArray<MapSearchCategory *> *categories;

/// 刷新历史记录显示
- (void)reloadHistory;

@end

NS_ASSUME_NONNULL_END

