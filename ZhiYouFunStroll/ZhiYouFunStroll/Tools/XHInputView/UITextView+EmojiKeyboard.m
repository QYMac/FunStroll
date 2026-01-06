//
//  UITextView+EmojiKeyboard.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "UITextView+EmojiKeyboard.h"

// 表情数据模型
@interface EmojiItem : NSObject
@property (nonatomic, copy) NSString *emoji;
@property (nonatomic, assign) BOOL isTextBubble;
@property (nonatomic, copy, nullable) NSString *text;
@end

@implementation EmojiItem
@end

// 表情键盘视图
@interface EmojiKeyboardView : UIView

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) UIScrollView *categoryScrollView; // 顶部分类栏
@property (nonatomic, strong) UIView *categoryContainerView;
@property (nonatomic, strong) UILabel *titleLabel; // "全部表情"标题
@property (nonatomic, strong) UIScrollView *contentScrollView; // 内容滚动视图
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray<NSArray<EmojiItem *> *> *emojiCategories;
@property (nonatomic, assign) NSInteger currentCategoryIndex;

- (instancetype)initWithTextView:(UITextView *)textView;

@end

@implementation EmojiKeyboardView

- (instancetype)initWithTextView:(UITextView *)textView {
    // 键盘高度
    CGFloat keyboardHeight = 400.0; // 标准键盘高度
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, keyboardHeight);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = textView;
        self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
        self.currentCategoryIndex = 0;
        
        [self setupEmojiData];
        [self setupUI];
    }
    return self;
}

- (void)setupEmojiData {
    // 表情分类数据
    NSMutableArray<NSArray<EmojiItem *> *> *categories = [NSMutableArray array];
    
    // 分类1: 全部表情（常用表情）
    NSMutableArray<EmojiItem *> *allEmojis = [NSMutableArray array];
    
    // 添加表情
    NSArray<NSString *> *emojis = @[
        @"😀", @"😃", @"😄", @"😁", @"😆", @"😅", @"😂", @"🤣",
        @"😊", @"😇", @"🙂", @"🙃", @"😉", @"😌", @"😍", @"🥰",
        @"😘", @"😗", @"😙", @"😚", @"😋", @"😛", @"😝", @"😜",
        @"🤪", @"🤨", @"🧐", @"🤓", @"😎", @"🤩", @"🥳", @"😏",
        @"😒", @"😞", @"😔", @"😟", @"😕", @"🙁", @"😣", @"😖",
        @"😫", @"😩", @"🥺", @"😢", @"😭", @"😤", @"😠", @"😡",
        @"🤬", @"🤯", @"😳", @"🥵", @"🥶", @"😱", @"😨", @"😰",
        @"😥", @"😓", @"🤗", @"🤔", @"🤭", @"🤫", @"🤥", @"😶",
        @"😐", @"😑", @"😬", @"🙄", @"😯", @"😦", @"😧", @"😮",
        @"😲", @"🥱", @"😴", @"🤤", @"😪", @"😵", @"🤐", @"🥴",
        @"👍", @"👎", @"👊", @"✊", @"🤛", @"🤜", @"🤞", @"✌️",
        @"🤟", @"🤘", @"👌", @"🤌", @"🤏", @"👋", @"🤚", @"🖐",
        @"✋", @"🖖", @"👏", @"🙌", @"🤲", @"🤝", @"🙏", @"✍️"
    ];
    
    for (NSString *emoji in emojis) {
        EmojiItem *item = [[EmojiItem alloc] init];
        item.isTextBubble = NO;
        item.emoji = emoji;
        [allEmojis addObject:item];
    }
    
    [categories addObject:allEmojis];
    
    // 可以添加更多分类...
    
    self.emojiCategories = [categories copy];
}

- (void)setupUI {
    CGFloat categoryHeight = 0.0; // 分类栏高度
    CGFloat titleHeight = 30.0; // 标题高度
    CGFloat contentHeight = self.bounds.size.height - categoryHeight - titleHeight;
    
    /*
    // 1. 顶部分类滚动栏
    self.categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, categoryHeight)];
    self.categoryScrollView.showsHorizontalScrollIndicator = NO;
    self.categoryScrollView.showsVerticalScrollIndicator = NO;
    self.categoryScrollView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    [self addSubview:self.categoryScrollView];
    
    self.categoryContainerView = [[UIView alloc] init];
    [self.categoryScrollView addSubview:self.categoryContainerView];
    
    // 分类按钮（使用表情作为图标）
    NSArray<NSString *> *categoryEmojis = @[@"😀", @"😃", @"😄", @"😁", @"😆", @"😅", @"😂", @"🤣",@"😊", @"😇", @"🙂", @"🙃", @"😉", @"😌", @"😍", @"🥰"];
    CGFloat categoryButtonSize = 30.0;
    CGFloat categorySpacing = 10.0;
    CGFloat categoryPadding = 10.0;
    
    for (NSInteger i = 0; i < categoryEmojis.count; i++) {
        UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryButton.frame = CGRectMake(categoryPadding + i * (categoryButtonSize + categorySpacing), 
                                         (categoryHeight - categoryButtonSize) / 2, 
                                         categoryButtonSize, 
                                         categoryButtonSize);
        [categoryButton setTitle:categoryEmojis[i] forState:UIControlStateNormal];
        categoryButton.titleLabel.font = [UIFont systemFontOfSize:20];
        categoryButton.tag = i;
        [categoryButton addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryContainerView addSubview:categoryButton];
    }
    
    CGFloat categoryContentWidth = categoryPadding * 2 + categoryEmojis.count * (categoryButtonSize + categorySpacing) - categorySpacing;
    self.categoryContainerView.frame = CGRectMake(0, 0, categoryContentWidth, categoryHeight);
    self.categoryScrollView.contentSize = CGSizeMake(categoryContentWidth, categoryHeight);
     */
    
    // 2. 标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, categoryHeight, self.bounds.size.width - 30, titleHeight)];
    self.titleLabel.text = @"全部表情";
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [self addSubview:self.titleLabel];
    
    // 3. 内容滚动视图
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryHeight + titleHeight, self.bounds.size.width, contentHeight)];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = YES;
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentScrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.contentScrollView addSubview:self.contentView];
    
    // 加载当前分类的表情
    [self reloadContent];
}

- (void)reloadContent {
    // 移除旧的内容
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (self.currentCategoryIndex >= self.emojiCategories.count) {
        return;
    }
    
    NSArray<EmojiItem *> *emojis = self.emojiCategories[self.currentCategoryIndex];
    
    // 布局参数
    NSInteger columns = 6; // 每行6个
    CGFloat buttonSize = 50.0;
    CGFloat padding = 0.0;
    CGFloat spacing = 5.0;
    CGFloat rowHeight = buttonSize + spacing;
    
    NSInteger rows = (emojis.count + columns - 1) / columns;
    CGFloat contentHeight = rows * rowHeight + padding * 2;
    
    self.contentView.frame = CGRectMake(0, 0, self.bounds.size.width, contentHeight);
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, contentHeight);
    
    // 创建表情按钮
    for (NSInteger i = 0; i < emojis.count; i++) {
        NSInteger row = i / columns;
        NSInteger col = i % columns;
        
        CGFloat x = padding + col * (self.bounds.size.width / columns);
        CGFloat y = padding + row * rowHeight;
        CGFloat width = (self.bounds.size.width - padding * 2) / columns;
        
        EmojiItem *item = emojis[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, buttonSize);
        button.tag = i;
        [button addTarget:self action:@selector(emojiButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (item.isTextBubble) {
            // 文字气泡样式
            UILabel *bubbleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, width - 10, buttonSize - 10)];
            bubbleLabel.text = item.text;
            bubbleLabel.font = [UIFont systemFontOfSize:12];
            bubbleLabel.textAlignment = NSTextAlignmentCenter;
            bubbleLabel.textColor = [UIColor whiteColor];
            bubbleLabel.numberOfLines = 0;
            bubbleLabel.adjustsFontSizeToFitWidth = YES;
            
            // 根据文字设置气泡颜色
            if ([item.text containsString:@"小哥哥"]) {
                bubbleLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.6 alpha:1.0]; // 粉色
            } else {
                bubbleLabel.backgroundColor = [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:1.0]; // 蓝色
            }
            
            bubbleLabel.layer.cornerRadius = 8.0;
            bubbleLabel.clipsToBounds = YES;
            [button addSubview:bubbleLabel];
        } else {
            // 普通表情
            [button setTitle:item.emoji forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:32];
        }
        
        button.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:button];
    }
}

- (void)categoryButtonTapped:(UIButton *)button {
    NSInteger categoryIndex = button.tag;
    if (categoryIndex != self.currentCategoryIndex && categoryIndex < self.emojiCategories.count) {
        self.currentCategoryIndex = categoryIndex;
        // 更新标题（可以根据分类更改）
        self.titleLabel.text = @"全部表情";
        [self reloadContent];
    }
}

- (void)emojiButtonTapped:(UIButton *)button {
    if (self.currentCategoryIndex >= self.emojiCategories.count) {
        return;
    }
    
    NSArray<EmojiItem *> *emojis = self.emojiCategories[self.currentCategoryIndex];
    if (button.tag >= emojis.count) {
        return;
    }
    
    EmojiItem *item = emojis[button.tag];
    NSString *textToInsert = item.isTextBubble ? item.text : item.emoji;
    
    if (textToInsert && textToInsert.length > 0 && self.textView) {
        // 在当前光标位置插入
        NSRange selectedRange = self.textView.selectedRange;
        NSString *text = self.textView.text ?: @"";
        
        NSMutableString *mutableText = [text mutableCopy];
        [mutableText insertString:textToInsert atIndex:selectedRange.location];
        
        NSString *newText = [mutableText copy];
        self.textView.text = newText;
        
        // 更新光标位置
        NSRange newRange = NSMakeRange(selectedRange.location + textToInsert.length, 0);
        self.textView.selectedRange = newRange;
        
        // 手动触发 textViewDidChange 代理方法
        if ([self.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.textView.delegate textViewDidChange:self.textView];
        }
        
        // 发送文本改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    }
}

@end

// 使用关联对象存储自定义键盘视图
#import <objc/runtime.h>

static char kEmojiKeyboardViewKey;

@implementation UITextView (EmojiKeyboard)

- (EmojiKeyboardView *)emojiKeyboardView {
    return objc_getAssociatedObject(self, &kEmojiKeyboardViewKey);
}

- (void)setEmojiKeyboardView:(EmojiKeyboardView *)emojiKeyboardView {
    objc_setAssociatedObject(self, &kEmojiKeyboardViewKey, emojiKeyboardView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showEmojiKeyboard {
    // 创建或获取表情键盘视图
    EmojiKeyboardView *emojiKeyboard = [self emojiKeyboardView];
    if (!emojiKeyboard) {
        emojiKeyboard = [[EmojiKeyboardView alloc] initWithTextView:self];
        [self setEmojiKeyboardView:emojiKeyboard];
    }
    
    // 设置inputView为表情键盘
    self.inputView = emojiKeyboard;
    
    // 如果已经是第一响应者，需要重新设置
    if (self.isFirstResponder) {
        [self reloadInputViews];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self becomeFirstResponder];
        });
    } else {
        // 成为第一响应者，显示键盘
        dispatch_async(dispatch_get_main_queue(), ^{
            [self becomeFirstResponder];
        });
    }
}

- (void)hideEmojiKeyboard {
    // 恢复系统键盘
    self.inputView = nil;
    
    // 如果已经是第一响应者，需要重新设置
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self becomeFirstResponder];
        });
    }
}

- (void)setUseCustomEmojiKeyboard:(BOOL)useCustomKeyboard {
    if (useCustomKeyboard) {
        [self showEmojiKeyboard];
    } else {
        [self hideEmojiKeyboard];
    }
}

@end
