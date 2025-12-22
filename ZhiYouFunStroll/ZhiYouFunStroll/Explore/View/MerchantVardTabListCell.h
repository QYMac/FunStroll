//
//  MerchantVardTabListCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MerchantVardTabListCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *fgView;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *distanceL;

@end

NS_ASSUME_NONNULL_END
