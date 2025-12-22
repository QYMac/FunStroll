//
//  MapLayerView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^didMapLayerViewBlcok)(void);
typedef void(^changeLayerMapButClickBlcok)(NSInteger index);
typedef void(^changeSkinMapButClickBlcok)(NSInteger index);
typedef void(^changeBgMapButClickBlcok)(NSInteger index);
typedef void(^changeRoadMapButClickBlcok)(NSInteger index);

@interface MapLayerView : UIView

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *exitBut;

// 更换图层
@property (nonatomic,strong) UIView *bgView1;
@property (nonatomic,strong) UIButton *mapBut1;
@property (nonatomic,strong) UIButton *mapBut2;
@property (nonatomic,strong) UIButton *mapBut3;
@property (nonatomic,strong) UILabel *mapButTitle1;
@property (nonatomic,strong) UILabel *mapButTitle2;
@property (nonatomic,strong) UILabel *mapButTitle3;

// 更换皮肤
@property (nonatomic,strong) UILabel *titleL1;
@property (nonatomic,strong) UIView *bgView2;
@property (nonatomic,strong) UIButton *mapBut4;
@property (nonatomic,strong) UIButton *mapBut5;
@property (nonatomic,strong) UILabel *mapButTitle4;
@property (nonatomic,strong) UILabel *mapButTitle5;

// 更换背景
@property (nonatomic,strong) UILabel *titleL2;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImage *bgImg1;
@property (nonatomic,strong) UIButton *mapBut6;
@property (nonatomic,strong) UIButton *mapBut7;
@property (nonatomic,strong) UIButton *mapBut8;

// 路况显示
@property (nonatomic,strong) UILabel *titleL3;
@property (nonatomic,strong) UIView *bgView3;
@property (nonatomic,strong) UIButton *mapBut9;
@property (nonatomic,strong) UIButton *mapBut10;

@property(nonatomic,strong) didMapLayerViewBlcok didMapLayerViewBlcok; // 退出view
@property(nonatomic,strong) changeLayerMapButClickBlcok changeLayerBlcok; // 更换图层
@property(nonatomic,strong) changeSkinMapButClickBlcok changeSkinBlcok; // 更换皮肤
@property(nonatomic,strong) changeBgMapButClickBlcok changeBgBlcok; // 更换背景
@property(nonatomic,strong) changeRoadMapButClickBlcok changeRoadBlcok; // 更换背景

@end

NS_ASSUME_NONNULL_END
