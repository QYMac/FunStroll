//
//  PhotoPickerCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoPickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UILabel *selectLabel;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger selectIndex;

/// 当前显示的 asset 标识符，用于防止 cell 复用时图片错乱
@property (nonatomic, copy, nullable) NSString *representedAssetIdentifier;

/// 当前图片请求ID，用于取消旧请求
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

NS_ASSUME_NONNULL_END
