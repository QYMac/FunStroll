//
//  PhotoGridPreviewViewController.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoGridPreviewViewController : UIViewController

/// 所有资源列表
@property (nonatomic, strong) NSArray<PHAsset *> *allAssets;

/// 已选择的资源列表
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAssets;

/// 当前索引
@property (nonatomic, assign) NSInteger currentIndex;

/// 最大选择数量
@property (nonatomic, assign) NSInteger maxSelectCount;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

/// 选择/取消选择回调
@property (nonatomic, copy) void(^didSelectBlock)(PHAsset *asset, BOOL isSelected);

/// 完成选择回调（点击下一步）
@property (nonatomic, copy) void(^didFinishBlock)(void);

@end

NS_ASSUME_NONNULL_END
