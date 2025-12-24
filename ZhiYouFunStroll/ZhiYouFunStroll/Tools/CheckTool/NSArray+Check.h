//
//  NSArray+Check.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Check)

/**
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
