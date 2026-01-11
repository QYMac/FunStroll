//
//  MapLocationImageCell.h
//  test
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 地点图片Cell
@interface MapLocationImageCell : UICollectionViewCell

/// 设置图片
/// @param imageUrl 图片URL或本地图片名
- (void)configureWithImageUrl:(nullable NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END

