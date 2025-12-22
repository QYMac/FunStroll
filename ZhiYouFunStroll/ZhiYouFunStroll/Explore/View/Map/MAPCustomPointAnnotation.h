//
//  MAPCustomPointAnnotation.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/3.
//

#import <UIKit/UIKit.h>

// 根据不同类型显示不同样式的标注
typedef NS_ENUM(NSInteger, AnnotationType) {
    AnnotationTypeDefault,
    AnnotationTypeScenicSpot,
    AnnotationTypesDeliciousFood
};

NS_ASSUME_NONNULL_BEGIN

@interface MAPCustomPointAnnotation : MAPointAnnotation

@property (nonatomic,assign) AnnotationType annotationType;
@property (nonatomic,strong) NSString *annotationId;

@end

NS_ASSUME_NONNULL_END
