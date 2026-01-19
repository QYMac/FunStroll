//
//  HomeView.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/29.
//

#import <UIKit/UIKit.h>
#import "HomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView

@property (nonatomic,copy) void(^updateHomeDataListBlcok)(NSInteger current,NSInteger size,NSString *keywordStr,BOOL isUpdtataTop);

@property (nonatomic,strong) HomeListModel *model;

@end

NS_ASSUME_NONNULL_END
