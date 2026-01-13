//
//  EditBioViewController.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditBioViewController : UIViewController

@property (nonatomic, copy) NSString *currentBio;
@property (nonatomic, copy) void(^saveBlock)(NSString *bio);

@end

NS_ASSUME_NONNULL_END
