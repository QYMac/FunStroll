//
//  HomeViewDetailsHeaderView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewDetailsHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *numberL;
@property (nonatomic,strong) UILabel *scoreL;
@property (nonatomic,strong) ServiceStarView *starsView;
@property (nonatomic,strong) UIButton *iphoneBut;
@property (nonatomic,strong) UIButton *addressBut;
@property (nonatomic,strong) UIButton *shareBut;
@property (nonatomic,strong) UIButton *collectionBut;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,strong) UILabel *timeL;

@end

NS_ASSUME_NONNULL_END
