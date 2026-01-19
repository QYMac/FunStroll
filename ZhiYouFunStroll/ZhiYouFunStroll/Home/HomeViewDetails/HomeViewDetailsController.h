//
//  HomeViewDetailsController.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewDetailsController : UIViewController

@property (nonatomic,strong) NSString *titleText;
@property (nonatomic,strong) NSString *imageURL;
@property (nonatomic,strong) NSString *userNameText;
@property (nonatomic,strong) NSString *postId;

// 刷新收藏
@property (nonatomic,copy) void(^updateLike)(NSInteger likeCount,NSInteger liked);

@end

NS_ASSUME_NONNULL_END
