//
//  HomeModel.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject

@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) NSString *current;
@property (nonatomic,strong) NSString *pages;
@property (nonatomic,strong) NSArray *records;

@property (nonatomic,strong) NSString *coverImage;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *postId;
@property (nonatomic,strong) NSString *likeCount;
@property (nonatomic,strong) NSString *likeCountFormatted;
@property (nonatomic,strong) NSString *userNickname;
@property (nonatomic,strong) NSString *userAvatar;
@property (nonatomic,strong) NSString *liked;
@property (nonatomic,assign) BOOL collected;

@end

NS_ASSUME_NONNULL_END
