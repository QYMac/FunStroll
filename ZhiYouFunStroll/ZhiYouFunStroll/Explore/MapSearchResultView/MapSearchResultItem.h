//
//  MapSearchResultItem.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 搜索结果卡片模型
@interface MapSearchResultItem : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 副标题
@property (nonatomic, copy) NSString *subtitle;
/// 距离（米）
@property (nonatomic, assign) NSInteger distance;
/// 步行时间（分钟）
@property (nonatomic, assign) NSInteger walkTime;
/// 图片URL或本地图片名
@property (nonatomic, copy, nullable) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END

