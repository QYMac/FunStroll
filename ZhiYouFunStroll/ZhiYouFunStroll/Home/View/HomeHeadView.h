//
//  HomeHeadView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeHeadView : UICollectionReusableView

@property (nonatomic,copy) void(^searcDataListBlcok)(NSString *keywordStr,BOOL isSearcDome);

@property (nonatomic,strong) UIView *bgImgView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *labelImg;
@property (nonatomic,strong) UITextField *homeSearcTextField;
@property (nonatomic,strong) UIButton *searchBut;

@end

NS_ASSUME_NONNULL_END
