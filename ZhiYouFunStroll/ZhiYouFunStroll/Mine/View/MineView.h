//
//  MineView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import <UIKit/UIKit.h>
#import "MineTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineView : UIView

@property (nonatomic, copy) void(^settingClickBlock)(void);
@property (nonatomic, copy) void(^avatarClickBlock)(void);
@property (nonatomic, copy) void(^editBioClickBlock)(void);
@property (nonatomic, copy) void(^alertBannerClickBlock)(void);
@property (nonatomic, copy) void(^draftClickBlock)(void);
@property (nonatomic, copy) void(^noteClickBlock)(NSInteger index);
@property (nonatomic, copy) void(^tabChangedBlock)(MineTabType tabType);
@property (nonatomic, copy) void(^loadMoreDataBlock)(NSInteger current, NSInteger size, MineTabType tabType);

// 更新用户信息
- (void)updateUserInfoWithName:(NSString *)name
                        userId:(NSString *)userId
                           bio:(NSString *)bio
                     avatarUrl:(NSString *)avatarUrl;

// 更新笔记数据
- (void)updateNotesWithDataList:(NSArray *)dataList hasMore:(BOOL)hasMore;

// 设置草稿数量
- (void)setDraftCount:(NSInteger)count;

// 设置异常笔记数量
- (void)setAbnormalNoteCount:(NSInteger)count;

// 刷新数据
- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
