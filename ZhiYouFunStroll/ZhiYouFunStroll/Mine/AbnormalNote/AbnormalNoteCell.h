//
//  AbnormalNoteCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AbnormalNoteCell : UITableViewCell

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *warningIcon;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, copy) void(^editBlock)(void);
@property (nonatomic, copy) void(^deleteBlock)(void);

- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                  warningText:(NSString *)warningText;

@end

NS_ASSUME_NONNULL_END
