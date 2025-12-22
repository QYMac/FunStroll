//
//  AdaptScreen.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#ifndef AdaptScreen_h
#define AdaptScreen_h

#define iphoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)) : NO)

#import <UIKit/UIKit.h>

static const CGFloat baseScreenWidth = 414.f;
static const CGFloat baseScreenHeight = 736.f;

#define DD_INLINE   static inline
// 内联函数：函数的栈只分配一次
// 尽量用在使用频繁，函数体简单的函数

/**
 *  当前屏幕高度/基准屏幕高度
 *
 *  @return 竖直方向的比例
 */
DD_INLINE CGFloat DDVerticalFlexibleRatio()
{
    //这里判断为适配iPhoneX
    if ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812) {
        return 375 / baseScreenWidth;
    }else if ([UIScreen mainScreen].bounds.size.width == 414 || [UIScreen mainScreen].bounds.size.height == 896){//这里判断为适配iPhoneXr
        return 414 / baseScreenWidth;
    }else if ([UIScreen mainScreen].bounds.size.width == 428 || [UIScreen mainScreen].bounds.size.height == 926){//这里判断为适配iPhone12 por max
        return 428 / baseScreenWidth;
    }else if ([UIScreen mainScreen].bounds.size.width == 390 || [UIScreen mainScreen].bounds.size.height == 884){//这里判断为适配iPhone12 / por 
        return 390 / baseScreenWidth;
    }else if ([UIScreen mainScreen].bounds.size.width == 360 || [UIScreen mainScreen].bounds.size.height == 780){//这里判断为适配iPhone12 / por
        return 360 / baseScreenWidth;
    }
    
    return [UIScreen mainScreen].bounds.size.height / baseScreenHeight;
}

/**
 *  水平方向的比例=当前屏幕的宽/基准屏幕的宽
 *
 *  @return 水平方向的比例
 */
DD_INLINE CGFloat DDHorizontalFlexibleRatio()
{
    return [UIScreen mainScreen].bounds.size.width /  baseScreenWidth;
}

// 外面传一个frame进来，我们通过等比例的操作反一个frame出去
// 但是我们的等比例需要对center操作
// 所以先要把frame拆分成center和size，再分别对center和size等比例适配，再把适配后的center和size合成一个frame返回
// 在适配size的时候有两种情况：宽高同时乘以高的比例，对一般的视图；宽乘以宽的比例，高乘以高的比例，对要铺满屏幕宽的视图。

// 通过center和size合成一个frame
DD_INLINE CGRect DDFrameWithCenterAndSize(CGPoint center, CGSize size)
{
    return CGRectMake(center.x - size.width/2, center.y - size.height/2, size.width, size.height);
}

/**
 *  通过基准屏幕下的size返回当前屏幕下适配的size
 *
 *  @param baseSize 基准屏幕下的size
 *  @param flag     YES表示宽和高都乘以高的比例，NO表示宽乘以宽的比例，高乘以高的比例
 *
 *  @return 适配后的size
 */
DD_INLINE CGSize DDFlexibleSizeWithBaseSize(CGSize baseSize, BOOL flag)
{
    CGFloat ratio = flag? DDVerticalFlexibleRatio():DDHorizontalFlexibleRatio();
    // 宽通过flag来判断是乘以高的比例还是宽的比例
    CGFloat width = baseSize.width * ratio;
    // 高直接乘以高的比例
    CGFloat height = baseSize.height * DDVerticalFlexibleRatio();
    return CGSizeMake(width, height);
}

/**
 *  通过基准屏幕的center返回适配后的center
 *
 *  @param baseCenter 基准屏幕的center
 *
 *  @return 适配后的center
 */
DD_INLINE CGPoint DDFlexibleCenterWithBaseCenter(CGPoint baseCenter)
{
    CGFloat x = baseCenter.x * DDHorizontalFlexibleRatio();
    CGFloat y = baseCenter.y * DDVerticalFlexibleRatio();
    return CGPointMake(x, y);
}

DD_INLINE CGRect DDFlexibleFrameWithBaseFrame(CGRect baseFrame, BOOL flag)
{
    // 适配size
    CGSize size = DDFlexibleSizeWithBaseSize(baseFrame.size, flag);
    // 适配center
    CGPoint center = CGPointMake(baseFrame.origin.x + baseFrame.size.width/2, baseFrame.origin.y + baseFrame.size.height/2);
    center = DDFlexibleCenterWithBaseCenter(center);
    // 通过适配好的 size和center合成frame然后返回
    return DDFrameWithCenterAndSize(center, size);
    
}

#endif /* AdaptScreen_h */
