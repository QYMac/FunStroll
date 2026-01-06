//
//  AFNetworkingHeaders.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import "AFNetworkingHeaders.h"

@implementation AFNetworkingHeaders

+ (NSDictionary *)headersDictionary{
    NSString *token_type = [UserModel getObjectForKey:kTokenType];
    NSString *access_token = [UserModel getObjectForKey:kAccessToken];
    NSString *basic = [NSString stringWithFormat:@"%@ %@",token_type,access_token];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:basic forKey:@"Authorization"];
    [parameters setObject:@"1" forKey:@"TENANT-ID"];
    [parameters setObject:@"Y" forKey:@"CLIENT-TOC"];
    [parameters setObject:@"Y" forKey:@"CLIENT-ONE-CLICK"];
    //获取版本号
    //NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //[parameters setObject:app_Version forKey:@"app-version"];
    return parameters;
}


+ (NSDictionary *)noTokenHeadersDictionary{
    NSString *basic = [NSString stringWithFormat:@"Basic YXBwOmFwcA=="];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:basic forKey:@"Authorization"];
    [parameters setObject:@"1" forKey:@"TENANT-ID"];
    [parameters setObject:@"Y" forKey:@"CLIENT-TOC"];
    [parameters setObject:@"Y" forKey:@"CLIENT-ONE-CLICK"];
    return parameters;
}

@end
