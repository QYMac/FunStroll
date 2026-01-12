//
//  MineHeaderView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import <UIKit/UIKit.h>
#import "MineTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *bgImageView;      // 背景图
@property (nonatomic, strong) UIImageView *avatarImageView;  // 头像
@property (nonatomic, strong) UILabel *nameLabel;            // 用户名
@property (nonatomic, strong) UILabel *idLabel;              // 用户ID
@property (nonatomic, strong) UILabel *bioLabel;             // 个人简介
@property (nonatomic, strong) UIButton *editBioButton;       // 编辑简介按钮
@property (nonatomic, strong) UIButton *settingButton;       // 设置按钮
@property (nonatomic, strong) MineTabBarView *tabBarView;    // Tab切换
@property (nonatomic, strong) UIView *alertBannerView;       // 警告横幅
@property (nonatomic, strong) UILabel *alertLabel;           // 警告文本
@property (nonatomic, strong) UIButton *arrowBut;         //双箭(用户名旁边)
@property (nonatomic, strong) UIButton *arrowBut1;
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic, copy) void(^settingButtonClickBlock)(void);
@property (nonatomic, copy) void(^editBioClickBlock)(void);
@property (nonatomic, copy) void(^avatarClickBlock)(void);
@property (nonatomic, copy) void(^tabChangedBlock)(MineTabType tabType);
@property (nonatomic, copy) void(^alertBannerClickBlock)(void);

- (void)updateWithUserName:(NSString *)userName
                    userId:(NSString *)userId
                       bio:(NSString *)bio
                 avatarUrl:(NSString *)avatarUrl;

- (void)setAlertMessage:(NSString *)message hidden:(BOOL)hidden;


@end

NS_ASSUME_NONNULL_END
