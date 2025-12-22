//
//  MineViewTableViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineViewTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *userInfoBgView;
@property (nonatomic,strong) UIImageView *userInfoImg;
@property (nonatomic,strong) UIImageView *avatarImage;
@property (nonatomic,strong) UIButton *userNameBut;
@property (nonatomic,strong) UIButton *exitLoginBut;
@property (nonatomic,strong) UIButton *introductionBut;
@property (nonatomic,strong) NSIndexPath *indexPathCell;

@property (nonatomic,strong) UIView *orderBgView;
@property (nonatomic,strong) UILabel *orderTitle;
@property (nonatomic,strong) UIButton *next_order;
@property (nonatomic,strong) UIButton *orderBut1;
@property (nonatomic,strong) UIButton *orderBut2;
@property (nonatomic,strong) UIButton *orderBut3;
@property (nonatomic,strong) UIButton *orderBut4;

@property (nonatomic,strong) UIView *myCellListBgView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UIImageView *nextPageImg;
@property (nonatomic,strong) UILabel *headTitle;

@end

NS_ASSUME_NONNULL_END
