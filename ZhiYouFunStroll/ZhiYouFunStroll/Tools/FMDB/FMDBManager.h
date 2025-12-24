//
//  FMDBManager.h
//  PixelCloud
//
//  Created by Qingyun Wei on 2025/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBManager : NSObject

/// 储存首页列表数据
+ (void)saveHomeList:(NSDictionary *)homeList andHandle:(void (^ _Nullable)(BOOL isSuccess))handle;

@end

NS_ASSUME_NONNULL_END
