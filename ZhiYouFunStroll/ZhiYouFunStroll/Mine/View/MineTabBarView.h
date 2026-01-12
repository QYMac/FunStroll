//
//  MineTabBarView.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MineTabType) {
    MineTabTypeNotes = 0,      // 笔记
    MineTabTypeLikes,          // 喜欢
    MineTabTypeFavorites       // 收藏
};

@interface MineTabBarView : UIView

@property (nonatomic, assign) MineTabType currentTab;
@property (nonatomic, copy) void(^tabChangedBlock)(MineTabType tabType);

- (void)selectTabAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
