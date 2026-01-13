//
//  PhotoPreviewViewController.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoPreviewViewController : UIViewController

/// PHAsset 模式
@property (nonatomic, strong) NSMutableArray<PHAsset *> *assets;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

/// UIImage 模式
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@property (nonatomic, assign) NSInteger currentIndex;

/// 删除回调 (PHAsset 模式)
@property (nonatomic, copy) void(^didDeleteBlock)(PHAsset *asset);

/// 更新回调 (PHAsset 模式)
@property (nonatomic, copy) void(^didUpdateBlock)(NSArray<PHAsset *> *assets);

/// 删除回调 (UIImage 模式)
@property (nonatomic, copy) void(^didDeleteImageBlock)(NSInteger index);

/// 更新回调 (UIImage 模式)
@property (nonatomic, copy) void(^didUpdateImagesBlock)(NSArray<UIImage *> *images);

@end

NS_ASSUME_NONNULL_END
