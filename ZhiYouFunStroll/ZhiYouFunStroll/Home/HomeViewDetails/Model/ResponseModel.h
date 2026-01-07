//
//  ResponseModel.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <Foundation/Foundation.h>
#import "PostDataModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 响应模型
@interface ResponseModel : NSObject

/// 响应码
@property (nonatomic, assign) NSInteger code;

/// 数据
@property (nonatomic, strong, nullable) PostDataModel *data;

/// 消息
@property (nonatomic, strong, nullable) NSString *msg;

/// 是否成功
@property (nonatomic, assign) NSInteger ok;

@end

NS_ASSUME_NONNULL_END

