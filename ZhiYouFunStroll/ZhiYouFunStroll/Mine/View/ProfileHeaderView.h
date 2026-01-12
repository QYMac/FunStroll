//
//  ProfileHeaderView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *cameraIcon;

@property (nonatomic, copy) void(^avatarTappedBlock)(void);

- (void)setAvatarImage:(UIImage *)image;
- (void)setAvatarWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
