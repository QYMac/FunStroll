//
//  ImageTableViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/4.
//

#import <UIKit/UIKit.h>
#import "DCCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *imageSeveralL;
@property (nonatomic,strong) UIView *severalBg;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) DCCycleScrollView *bannerView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UILabel *topicL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIView *fgView;


@end

NS_ASSUME_NONNULL_END
