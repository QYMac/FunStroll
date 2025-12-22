//
//  UIView+TBFrame.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TBFrame)

@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGPoint origin;
@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;


@end

NS_ASSUME_NONNULL_END
