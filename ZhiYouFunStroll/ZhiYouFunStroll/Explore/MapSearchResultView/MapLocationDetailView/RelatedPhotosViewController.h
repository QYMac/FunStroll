//
//  RelatedPhotosViewController.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 相关照片页面
@interface RelatedPhotosViewController : UIViewController

/// 初始化方法
/// @param imageUrls 图片URL数组
- (instancetype)initWithImageUrls:(NSArray<NSString *> *)imageUrls;

@end

NS_ASSUME_NONNULL_END
