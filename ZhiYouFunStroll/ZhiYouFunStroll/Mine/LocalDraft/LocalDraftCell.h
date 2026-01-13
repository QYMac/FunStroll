//
//  LocalDraftCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalDraftCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteBlock)(void);

- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                         date:(NSString *)date;

@end

NS_ASSUME_NONNULL_END
