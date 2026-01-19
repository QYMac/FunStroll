//
//  UploadImageModel.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/15.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片数据模型
@interface UploadImageDataModel : NSObject <YYModel>

/// 审核消息
@property (nonatomic, copy, nullable) NSString *auditMsg;

/// 文件名
@property (nonatomic, copy, nullable) NSString *fileName;

/// 资源类型
@property (nonatomic, copy, nullable) NSString *resourceType;

/// 资源URL
@property (nonatomic, copy, nullable) NSString *resourceUrl;

@end

/// 批量上传数据模型
@interface UploadImageBatchDataModel : NSObject <YYModel>

/// 失败数量
@property (nonatomic, assign) NSInteger failCount;

/// 失败列表
@property (nonatomic, strong, nullable) NSArray<UploadImageDataModel *> *failList;

/// 成功数量
@property (nonatomic, assign) NSInteger successCount;

/// 成功列表
@property (nonatomic, strong, nullable) NSArray<UploadImageDataModel *> *successList;

/// 总数量
@property (nonatomic, assign) NSInteger totalCount;

@end

/// 图片上传响应模型
@interface UploadImageModel : NSObject <YYModel>

/// 响应码
@property (nonatomic, assign) NSInteger code;

/// 响应消息
@property (nonatomic, copy, nullable) NSString *msg;

/// 是否成功
@property (nonatomic, assign) BOOL ok;

/// 批量上传数据
@property (nonatomic, strong, nullable) UploadImageBatchDataModel *data;

@end

NS_ASSUME_NONNULL_END
