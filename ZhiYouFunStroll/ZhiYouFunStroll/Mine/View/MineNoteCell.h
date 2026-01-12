//
//  MineNoteCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineNoteCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;   // 封面图
@property (nonatomic, strong) UILabel *titleLabel;           // 标题
@property (nonatomic, strong) UIImageView *avatarImageView;  // 用户头像
@property (nonatomic, strong) UILabel *nicknameLabel;        // 用户昵称
@property (nonatomic, strong) UIButton *likeButton;          // 点赞按钮

@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL isLiked;

- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                    avatarUrl:(NSString *)avatarUrl
                     nickname:(NSString *)nickname
                    likeCount:(NSInteger)likeCount
                      isLiked:(BOOL)isLiked;

@end

NS_ASSUME_NONNULL_END
