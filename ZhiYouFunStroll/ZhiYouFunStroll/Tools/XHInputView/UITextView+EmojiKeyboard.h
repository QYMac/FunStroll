//
//  UITextView+EmojiKeyboard.h
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (EmojiKeyboard)

/// 显示自定义表情键盘（作为inputView）
- (void)showEmojiKeyboard;

/// 隐藏自定义表情键盘，恢复系统键盘
- (void)hideEmojiKeyboard;

/// 设置是否使用自定义表情键盘
/// @param useCustomKeyboard YES表示使用自定义表情键盘，NO表示使用系统键盘
- (void)setUseCustomEmojiKeyboard:(BOOL)useCustomKeyboard;

@end

NS_ASSUME_NONNULL_END
