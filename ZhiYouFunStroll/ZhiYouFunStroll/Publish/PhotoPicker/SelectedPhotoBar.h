//
//  SelectedPhotoBar.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectedPhotoBar : UIView

@property (nonatomic, strong) PHCachingImageManager *imageManager;

/// 删除回调
@property (nonatomic, copy) void(^didDeleteBlock)(PHAsset *asset);

/// 重新排序回调
@property (nonatomic, copy) void(^didReorderBlock)(NSArray<PHAsset *> *assets);

/// 选中回调
@property (nonatomic, copy) void(^didSelectBlock)(PHAsset *asset, NSInteger index);

/// 更新已选图片
- (void)updateWithAssets:(NSArray<PHAsset *> *)assets;

@end

NS_ASSUME_NONNULL_END
