//
//  ShoppingDetailsCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingDetailsCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *themeImg;
@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *moneyTitleL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *purchaseBut;
@property (nonatomic,strong) UIButton *dressingBut;

@end

NS_ASSUME_NONNULL_END
