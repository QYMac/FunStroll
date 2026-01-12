//
//  EditNicknameViewController.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditNicknameViewController : UIViewController

@property (nonatomic, copy) NSString *currentNickname;
@property (nonatomic, copy) void(^saveBlock)(NSString *nickname);

@end

NS_ASSUME_NONNULL_END
