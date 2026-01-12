//
//  ProfileInfoCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ProfileCellType) {
    ProfileCellTypeDefault = 0,   // 默认样式 (ID、手机号)
    ProfileCellTypeEdit,          // 可编辑样式 (昵称)
    ProfileCellTypeArrow          // 箭头样式 (简介)
};

typedef NS_ENUM(NSInteger, ProfileCellPosition) {
    ProfileCellPositionOnly = 0,  // 唯一一个 (四角圆角)
    ProfileCellPositionFirst,     // 第一个 (顶部圆角)
    ProfileCellPositionMiddle,    // 中间 (无圆角)
    ProfileCellPositionLast       // 最后一个 (底部圆角)
};

@interface ProfileInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *accessoryIcon;
@property (nonatomic, strong) UIView *bgCardView;
@property (nonatomic, strong) UIView *separatorLine;

- (void)configureWithTitle:(NSString *)title
                     value:(NSString *)value
               placeholder:(NSString *)placeholder
                  cellType:(ProfileCellType)cellType;

- (void)configurePosition:(ProfileCellPosition)position;

@end

NS_ASSUME_NONNULL_END
