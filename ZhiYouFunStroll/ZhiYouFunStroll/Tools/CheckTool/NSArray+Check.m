//
//  NSArray+Check.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/24.
//

#import "NSArray+Check.h"

@implementation NSArray (Check)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
     
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
