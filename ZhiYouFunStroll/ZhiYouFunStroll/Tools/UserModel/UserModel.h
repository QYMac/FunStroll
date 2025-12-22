//
//  UserModel.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

+ (instancetype)sharedUserModel;

/**
 保存数据
 */
+(void)saveObject:(id)obj forKey:(NSString *)key;
/**
 清除数据
 */
+(void)clearObjectForKey:(NSString *)key;
/**
 获取数据
 */
+(id)getObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
