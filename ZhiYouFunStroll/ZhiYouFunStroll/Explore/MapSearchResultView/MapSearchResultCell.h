//
//  MapSearchResultCell.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MapSearchResultItem;

/// 搜索结果卡片Cell
@interface MapSearchResultCell : UICollectionViewCell

/// 配置Cell数据
/// @param item 搜索结果数据模型
- (void)configureWithItem:(MapSearchResultItem *)item;

@end

NS_ASSUME_NONNULL_END

