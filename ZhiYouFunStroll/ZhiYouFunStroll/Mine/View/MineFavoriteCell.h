//
//  MineFavoriteCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineFavoriteCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;   // 封面图
@property (nonatomic, strong) UILabel *titleLabel;           // 标题
@property (nonatomic, strong) UILabel *subtitleLabel;        // 副标题
@property (nonatomic, strong) UIImageView *arrowImageView;   // 箭头

- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
