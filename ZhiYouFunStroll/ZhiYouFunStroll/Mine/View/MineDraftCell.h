//
//  MineDraftCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineDraftCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;    // 草稿图标
@property (nonatomic, strong) UILabel *titleLabel;           // 本地草稿
@property (nonatomic, strong) UILabel *subtitleLabel;        // 有x篇笔记待发布
@property (nonatomic, strong) UIImageView *bgImageView;      // 背景图
@property (nonatomic, strong) UIImageView *nexImg; 

- (void)configureDraftCount:(NSInteger)count backgroundImage:(UIImage * _Nullable)bgImage;

@end

NS_ASSUME_NONNULL_END
