//
//  RelatedPhotosCell.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 相关照片Cell
@interface RelatedPhotosCell : UICollectionViewCell

/// 设置图片
/// @param imageUrl 图片URL或本地图片名
- (void)configureWithImageUrl:(nullable NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
