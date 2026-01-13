//
//  AlbumListView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumModel : NSObject

@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) PHAsset *coverAsset;

@end

@interface AlbumListView : UIView

@property (nonatomic, strong) PHCachingImageManager *imageManager;

/// 选择相册回调
@property (nonatomic, copy) void(^didSelectAlbumBlock)(AlbumModel *album);

/// 显示相册列表
- (void)showWithAlbums:(NSArray<AlbumModel *> *)albums;

/// 隐藏
- (void)hide;

@end

NS_ASSUME_NONNULL_END
