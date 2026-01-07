//
//  LabelSpacing.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelSpacing : NSObject

/**
 显示当前文字需要几行

 @param width 给定一个宽度
 @return 返回行数
 */
+ (NSInteger)needLinesWithWidth:(CGFloat)width textStr:(NSString *)textStr font:(NSInteger)font;

/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+ (void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label;

/**
 获取文字高度

@param maxWidth 最大宽度
@param text 文本内容
@param font 文字的 font
*/
+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

///  设置 label 行间距
+ (void)setLineSpacing:(CGFloat)spacing label:(UILabel *)label;

@end

NS_ASSUME_NONNULL_END
