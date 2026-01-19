//
//  HomeListModel.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/01/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 帖子记录模型 (records 中的每条记录)
@interface HomeListRecordModel : NSObject

@property (nonatomic, assign) BOOL collected;           // 是否收藏
@property (nonatomic, copy) NSString *coverImage;       // 封面图片
@property (nonatomic, assign) NSInteger likeCount;      // 点赞数
@property (nonatomic, copy) NSString *likeCountFormatted; // 格式化的点赞数
@property (nonatomic, assign) BOOL liked;               // 是否已点赞
@property (nonatomic, copy) NSString *postId;           // 帖子ID
@property (nonatomic, copy) NSString *title;            // 标题
@property (nonatomic, copy) NSString *userAvatar;       // 用户头像
@property (nonatomic, copy) NSString *userNickname;     // 用户昵称

@end

#pragma mark - 分页数据模型 (data)
@interface HomeListDataModel : NSObject

@property (nonatomic, assign) NSInteger current;        // 当前页
@property (nonatomic, assign) NSInteger pages;          // 总页数
@property (nonatomic, strong) NSArray<HomeListRecordModel *> *records; // 记录列表（model数组）
@property (nonatomic, strong) NSArray *recordsArray;    // 记录列表（原始字典数组）
@property (nonatomic, assign) NSInteger size;           // 每页大小
@property (nonatomic, assign) NSInteger total;          // 总数

@end

#pragma mark - 首页列表响应模型
@interface HomeListModel : NSObject

@property (nonatomic, assign) NSInteger code;           // 状态码
@property (nonatomic, copy, nullable) NSString *msg;    // 消息
@property (nonatomic, assign) BOOL ok;                  // 是否成功
@property (nonatomic, strong) HomeListDataModel *data;  // 分页数据

@end

NS_ASSUME_NONNULL_END
