//
//  UploadImageModel.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/15.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadImageModel : NSObject <YYModel>

/// 审核消息
@property (nonatomic, copy, nullable) NSString *auditMsg;

/// 文件名
@property (nonatomic, copy, nullable) NSString *fileName;

/// 资源类型
@property (nonatomic, copy, nullable) NSString *resourceType;

/// 资源URL
@property (nonatomic, copy, nullable) NSString *resourceUrl;

@end

NS_ASSUME_NONNULL_END
