//
//  ShoppingCollectionViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *shoppingImage;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *moneyTitleL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *shoppingBut;

@end

NS_ASSUME_NONNULL_END
