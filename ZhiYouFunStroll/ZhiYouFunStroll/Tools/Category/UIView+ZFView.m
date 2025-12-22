//
//  UIView+ZFView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//


#import "UIView+ZFView.h"

@implementation UIView (ZFView)
#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

// 封装的方法
- (void)setPartialCorners:(UIRectCorner)corners
                   radius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor
                 forButton:(UIButton *)button {
    
    // 设置圆角
    button.layer.cornerRadius = radius;
    if (@available(iOS 11.0, *)) {
        button.layer.maskedCorners = [self cornersToMask:corners];
    } else {
        // iOS 11 以下使用贝塞尔曲线
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                       byRoundingCorners:corners
                                                             cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        button.layer.mask = maskLayer;
    }
    button.layer.masksToBounds = YES;
    
    // 设置边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.lineWidth = borderWidth;
    
    CGRect borderBounds = CGRectInset(button.bounds, borderWidth/2, borderWidth/2);
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderBounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:CGSizeMake(radius, radius)];
    
    borderLayer.path = borderPath.CGPath;
    [button.layer addSublayer:borderLayer];
}

// 转换圆角类型
- (CACornerMask)cornersToMask:(UIRectCorner)corners {
    CACornerMask mask = 0;
    if (corners & UIRectCornerTopLeft) mask |= kCALayerMinXMinYCorner;
    if (corners & UIRectCornerTopRight) mask |= kCALayerMaxXMinYCorner;
    if (corners & UIRectCornerBottomLeft) mask |= kCALayerMinXMaxYCorner;
    if (corners & UIRectCornerBottomRight) mask |= kCALayerMaxXMaxYCorner;
    return mask;
}

@end
