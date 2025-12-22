//
//  MapAddressView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/3.
//

#import <UIKit/UIKit.h>

// 根据不同类型显示不同样式的标注
typedef NS_ENUM(NSInteger, MAPAnnotationType) {
    AnnotationTypeAll,
    AnnotationTypesDelicious,
    AnnotationTypeScenic
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^didSelectAnnotationViewBlcok)(NSString *idStr);

@interface MapAddressView : UIView

@property (nonatomic,assign) MAPAnnotationType mapAnnotationType;

@property(nonatomic,strong) didSelectAnnotationViewBlcok didSelectAnnotationViewBlcok;

/// 定位到当前位置
- (void)moveToCurrentLocation;

/// 移除标注
- (void)removeAllCustomAnnotations;

/// 更换地图图层
- (void)changeMapLayerClickIndex:(NSInteger)index;

/// 更换地图背景
- (void)changeBgClickIndex:(NSInteger)index;

/// 更换地图图层
- (void)changeSkinClickIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
