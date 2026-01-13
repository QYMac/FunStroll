//
//  PhotoPickerViewController.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoPickerViewController : UIViewController

/// 最大选择数量，默认9
@property (nonatomic, assign) NSInteger maxSelectCount;

/// 已选择的图片回调
@property (nonatomic, copy) void(^didFinishPickingBlock)(NSArray<UIImage *> *images, NSArray<PHAsset *> *assets);

/// 取消选择回调
@property (nonatomic, copy) void(^didCancelBlock)(void);

@end

NS_ASSUME_NONNULL_END
