//
//  MapSearchResultViewController.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 地图搜索结果页面
@interface MapSearchResultViewController : UIViewController

/// 搜索关键词
@property (nonatomic, copy, nullable) NSString *searchKeyword;

/// 是否详情页
@property(nonatomic, assign) BOOL isDetailView;

@end

NS_ASSUME_NONNULL_END

