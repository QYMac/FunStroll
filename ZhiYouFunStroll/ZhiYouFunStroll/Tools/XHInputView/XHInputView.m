//
//  XHInputView.m
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHInputView

#import "XHInputView.h"
#import "UITextView+EmojiKeyboard.h"
#import "AddCommentCollectionCell.h"

#define XHInputView_ScreenW    [UIScreen mainScreen].bounds.size.width
#define XHInputView_ScreenH    [UIScreen mainScreen].bounds.size.height
#define XHInputView_StyleLarge_LRSpace 10
#define XHInputView_StyleLarge_TBSpace 8
#define XHInputView_StyleDefault_LRSpace 5
#define XHInputView_StyleDefault_TBSpace 5
#define XHInputView_CountLabHeight 20
#define XHInputView_BgViewColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

#define XHInputView_StyleLarge_Height 190
#define XHInputView_StyleDefault_Height 45

static CGFloat keyboardAnimationDuration = 0.5;

@interface XHInputView()<UITextViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIView *oldInputView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *bqBut;
@property (nonatomic, strong) UIButton *imgBut;
@property (nonatomic, assign) InputViewStyle style;

@property (nonatomic, assign) CGRect showFrameDefault;
@property (nonatomic, assign) CGRect sendButtonFrameDefault;
@property (nonatomic, assign) CGRect textViewFrameDefault;

@property (nonatomic, strong) UIScrollView *categoryScrollView; // 顶部分类栏表情
@property (nonatomic, strong) UIView *categoryContainerView;

@property (nonatomic,strong) UICollectionView *addImageCollectionView;
@property (nonatomic,strong) NSMutableArray *imgList;
@property (nonatomic,assign) BOOL isAddImgClick;
@property (nonatomic,assign) CGSize keyboardSize;
@property (nonatomic, weak) UIResponder *currentFirstResponder; // 保存当前的第一响应者


/** 发送按钮点击回调 */
@property (nonatomic, copy) BOOL(^sendBlcok)(NSString *text,NSArray *images);

@end

@implementation XHInputView

-(void)dealloc{
    //NSLog(@"XHInputView 销毁");
    if(_style == InputViewStyleDefault){
        [_textView removeObserver:self forKeyPath:@"contentSize"];
    }
}
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(XHInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text,NSArray *images))sendBlock{
    XHInputView *inputView = [[XHInputView alloc] initWithStyle:style];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:inputView];
    if(configurationBlock) configurationBlock(inputView);
    inputView.sendBlcok = [sendBlock copy];
    [inputView show];
}
#pragma mark - private
-(void)show{
    if([self.delegate respondsToSelector:@selector(xhInputViewWillShow:)]){
        [self.delegate xhInputViewWillShow:self];
    }
    _textView.text = nil;
    _placeholderLab.hidden = NO;
    
    if(_style == InputViewStyleLarge){
        if(_maxCount>0) _countLab.text = [NSString stringWithFormat:@"0/%ld",(long)_maxCount];
    }
    
    [_textView becomeFirstResponder];
}

-(void)hide{
    
    if([self.delegate respondsToSelector:@selector(xhInputViewWillHide:)]){
        [self.delegate xhInputViewWillHide:self];
    }
    [_textView resignFirstResponder];
}

- (instancetype)initWithStyle:(InputViewStyle)style
{
    self = [super init];
    if (self) {
        
        _style = style;
        /** 创建UI */
        [self  setupUI];
        /** 键盘监听 */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _inputView = [[UIView alloc] init];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputView];
    
    switch (_style) {
        case InputViewStyleDefault:{
            
            _inputView.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, XHInputView_StyleDefault_Height);
            
            /** StyleDefaultUI */
            CGFloat sendButtonWidth = 45;
            CGFloat sendButtonHeight = _inputView.bounds.size.height -2*XHInputView_StyleDefault_TBSpace;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - sendButtonWidth, XHInputView_StyleDefault_TBSpace,sendButtonWidth, sendButtonHeight);
            [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_inputView addSubview:_sendButton];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace, XHInputView_ScreenW - 3*XHInputView_StyleDefault_LRSpace - sendButtonWidth, self.inputView.bounds.size.height-2*XHInputView_StyleDefault_TBSpace)];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _textView.delegate = self;
            [_inputView addSubview:_textView];
            //KVO监听contentSize变化
            [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, _textView.bounds.size.height)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            _sendButtonFrameDefault = _sendButton.frame;
            _textViewFrameDefault = _textView.frame;
            
        }
            break;
        case InputViewStyleLarge:{
            
            CGFloat height = 15 + 32 + 15 + 23 + 15 + 50;
            
            _inputView.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, height);
            
            /** StyleLargeUI */
            
            
            _textBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kWidth - 30, 32)];
            _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _textBgView.layer.cornerRadius = 32/2;
            _textBgView.layer.masksToBounds = YES;
            [_inputView addSubview:_textBgView];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, _textBgView.bounds.size.width - 20, 32)];
            _textView.backgroundColor = [UIColor clearColor];
            _textView.font = [UIFont systemFontOfSize:12];
            _textView.delegate = self;
            [_textBgView addSubview:_textView];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _textView.bounds.size.width, 32)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.font = [UIFont systemFontOfSize:12];
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            CGFloat sendButtonWidth = 50;
            CGFloat sendButtonHeight = 23;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(kWidth - 15 - sendButtonWidth, _textBgView.y + _textBgView.height + 15, sendButtonWidth, sendButtonHeight);
            _sendButton.backgroundColor = RGB(198, 248, 161);
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _sendButton.layer.cornerRadius = 23/2;
            _sendButton.layer.masksToBounds = YES;
            [_sendButton setTitleColor:RGB(176, 176, 176) forState:UIControlStateNormal];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:_sendButton];
            
            _bqBut = [UIButton buttonWithType:UIButtonTypeCustom];
            _bqBut.frame = CGRectMake(10, _sendButton.centerY - 17.5, 35, 35);
            [_bqBut setImage:[UIImage imageNamed:@"home_biaoqing"] forState:UIControlStateNormal];
            [_bqBut addTarget:self action:@selector(bqButClick) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:_bqBut];
            
            _imgBut = [UIButton buttonWithType:UIButtonTypeCustom];
            _imgBut.frame = CGRectMake(_bqBut.x + 35, _sendButton.centerY - 17.5, 35, 35);
            [_imgBut setImage:[UIImage imageNamed:@"home_imgClick"] forState:UIControlStateNormal];
            [_imgBut addTarget:self action:@selector(imgButClick:) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:_imgBut];
            
            /*
            _countLab = [[UILabel alloc] initWithFrame:CGRectMake(0,_textView.bounds.size.height, _textBgView.bounds.size.width-5, XHInputView_CountLabHeight)];
            _countLab.font = [UIFont systemFontOfSize:12];
            _countLab.textColor =  [UIColor lightGrayColor];
            _countLab.textAlignment = NSTextAlignmentRight;
            _countLab.backgroundColor = _textView.backgroundColor;
            [_textBgView addSubview:_countLab];
             */
            
            CGFloat categoryHeight = 50.0;
            CGFloat collectionHeight = 0;
            
            self.addImageCollectionView.frame = CGRectMake(0, _bqBut.y + 35, kWidth, collectionHeight);
            [_inputView addSubview:self.addImageCollectionView];
            
            //分类滚动栏
            self.categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.addImageCollectionView.y + collectionHeight, self.bounds.size.width, categoryHeight)];
            self.categoryScrollView.showsHorizontalScrollIndicator = NO;
            self.categoryScrollView.showsVerticalScrollIndicator = NO;
            self.categoryScrollView.backgroundColor = [UIColor whiteColor];
            [_inputView addSubview:self.categoryScrollView];
            
            self.categoryContainerView = [[UIView alloc] init];
            [self.categoryScrollView addSubview:self.categoryContainerView];
            
            // 分类按钮（使用表情作为图标）
            NSArray<NSString *> *categoryEmojis = @[@"😀", @"😃", @"😄", @"😁", @"😆", @"😅", @"😂", @"🤣",@"😊", @"😇", @"🙂", @"🙃", @"😉", @"😌", @"😍", @"🥰"];
            CGFloat categoryButtonSize = 40.0;
            CGFloat categorySpacing = 10.0;
            CGFloat categoryPadding = 10.0;
            
            for (NSInteger i = 0; i < categoryEmojis.count; i++) {
                UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
                categoryButton.frame = CGRectMake(categoryPadding + i * (categoryButtonSize + categorySpacing),
                                                 (categoryHeight - categoryButtonSize) / 2,
                                                 categoryButtonSize,
                                                 categoryButtonSize);
                [categoryButton setTitle:categoryEmojis[i] forState:UIControlStateNormal];
                categoryButton.titleLabel.font = [UIFont systemFontOfSize:32];
                categoryButton.tag = i;
                [categoryButton addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [self.categoryContainerView addSubview:categoryButton];
            }
            
            CGFloat categoryContentWidth = categoryPadding * 2 + categoryEmojis.count * (categoryButtonSize + categorySpacing) - categorySpacing;
            self.categoryContainerView.frame = CGRectMake(0, 0, categoryContentWidth, categoryHeight);
            self.categoryScrollView.contentSize = CGSizeMake(categoryContentWidth, categoryHeight);
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _textView && [keyPath isEqualToString:@"contentSize"]){
        CGFloat height = _textView.contentSize.height;
        CGFloat heightDefault = XHInputView_StyleDefault_Height;
        if(height >= heightDefault){
            [UIView animateWithDuration:0.3 animations:^{
                //调整frame
                CGRect frame = self->_showFrameDefault;
                frame.size.height = height;
                frame.origin.y = self->_showFrameDefault.origin.y - (height - self->_showFrameDefault.size.height);
                self->_inputView.frame = frame;
                //调整sendButton frame
                self->_sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - self->_sendButton.frame.size.width, self->_inputView.bounds.size.height - self->_sendButton.bounds.size.height - XHInputView_StyleDefault_TBSpace, self->_sendButton.bounds.size.width, self->_sendButton.bounds.size.height);
                //调整textView frame
                self->_textView.frame = CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace, self->_textView.bounds.size.width, self->_inputView.bounds.size.height - 2*XHInputView_StyleDefault_TBSpace);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self resetFrameDefault];//恢复到,键盘弹出时,视图初始位置
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_inputView]) {
        return NO;
    }
    return YES;
}
-(void)resetFrameDefault{
    self.inputView.frame = _showFrameDefault;
    self.sendButton.frame = _sendButtonFrameDefault;
    self.textView.frame =_textViewFrameDefault;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length){
        _placeholderLab.hidden = YES;
    }else{
        _placeholderLab.hidden = NO;
    }
    if(_maxCount > 0){
        if(textView.text.length>=_maxCount){
            textView.text = [textView.text substringToIndex:_maxCount];
        }
        if(_style == InputViewStyleLarge){
            _countLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)_maxCount];
        }
    }
    
    if (_style == InputViewStyleLarge) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5; // 行间距设为10

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, textView.text.length)];

        // 应用到 TextView
        textView.attributedText = attributedString;
        
        if(textView.text.length){
            _sendButton.backgroundColor = RGB(145, 233, 80);
            [_sendButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        } else {
            _sendButton.backgroundColor = RGB(198, 248, 161);
            [_sendButton setTitleColor:RGB(176, 176, 176) forState:UIControlStateNormal];
        }
        
        NSInteger num = [LabelSpacing needLinesWithWidth:kWidth - 60 textStr:[CheckTool replaceNullValue:textView.text] font:12];
        
        CGFloat textHi = [LabelSpacing getTextHeightWithText:[CheckTool replaceNullValue:textView.text] font:[UIFont systemFontOfSize:12] maxWidth:kWidth - 50];
        
        if (num <= 1) {
            num = 0;
            textHi = 0;
        }
        
        if (textHi > 100) {
            textHi = 100;
        }
        
        CGFloat height = 15 + 32 + textHi  + 15 + 23 + 15 + 50;
        
        
        CGFloat collectionHeight = 0;
        if (self.imgBut.selected == YES) {
            height = 15 + 32 + textHi  + 15 + 23 + 15 + 50 + 50;
            collectionHeight = 50;
        }
        
        _inputView.frame = CGRectMake(self.showFrameDefault.origin.x, XHInputView_ScreenH - self.keyboardSize.height -  height, XHInputView_ScreenW, height);
        
        _textBgView.frame = CGRectMake(15, 15, kWidth - 30, 32 + textHi);
        
        if (num == 0) {
            _textView.frame = CGRectMake(10, 0, _textBgView.bounds.size.width - 20, _textBgView.height);
        } else {
            _textView.frame = CGRectMake(10, 5, _textBgView.bounds.size.width - 20, _textBgView.height - 10);
        }
        
        _placeholderLab.frame = CGRectMake(0, 0, _textView.bounds.size.width, _textView.height);
        
        CGFloat sendButtonWidth = 50;
        CGFloat sendButtonHeight = 23;
        _sendButton.frame = CGRectMake(kWidth - 15 - sendButtonWidth, _textBgView.y + _textBgView.height + 15, sendButtonWidth, sendButtonHeight);
        
        _bqBut.frame = CGRectMake(10, _sendButton.centerY - 17.5, 35, 35);
        _imgBut.frame = CGRectMake(_bqBut.x + 35, _sendButton.centerY - 17.5, 35, 35);
        
        self.addImageCollectionView.frame = CGRectMake(0, _bqBut.y + 35, kWidth, collectionHeight);
        
        CGFloat categoryHeight = 50.0;
        self.categoryScrollView.frame = CGRectMake(0, self.addImageCollectionView.y + collectionHeight, self.bounds.size.width, categoryHeight);
    }
}

#pragma mark - UICollectionViewDataSource/UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgList.count + 1;
}
// 左右
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

// 上下
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddCommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell AddCommentIndexPath:indexPath imageList:_imgList];
    
    WeakSelf
    cell.addImgButtonBlcok = ^(NSMutableArray * _Nonnull addImageList) {
        [weakSelf reloadDataCellImagList:addImageList];
    };
    
    cell.removeImgButBlcok = ^(NSMutableArray * _Nonnull addImageList) {
        [weakSelf reloadDataCellImagList:addImageList];
    };
    
    cell.addButClickBlcok = ^{
        weakSelf.isAddImgClick = YES;
    };
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(45,45);
    
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

// 刷新cell
- (void)reloadDataCellImagList:(NSMutableArray *)imgArray{
    self.isAddImgClick = NO;
    self.imgList = imgArray;
    [self.addImageCollectionView reloadData];
    [self restoreFirstResponder];
}

#pragma mark - Action
-(void)bgViewClick{
    [self hide];
}
-(void)sendButtonClick:(UIButton *)button{
    if(self.sendBlcok){
        BOOL hideKeyBoard = self.sendBlcok(self.textView.text,self.imgList);
        if(hideKeyBoard){
            [self hide];
        }
    }
}

- (void)bqButClick{
    [_textView showEmojiKeyboard];
}

- (void)imgButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        self.addImageCollectionView.hidden = NO;
        //保存当前的第一响应者
        _currentFirstResponder = [self findFirstResponder];
    } else {
        sender.selected = NO;
        self.addImageCollectionView.hidden = YES;
    }
    // 手动触发 textViewDidChange 代理方法
    if ([self.textView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textView.delegate textViewDidChange:self.textView];
    }
}


- (void)categoryButtonTapped:(UIButton *)sender{
    NSString *textToInsert = [CheckTool replaceNullValue:sender.titleLabel.text];
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
}


// 保存第一响应者
- (UIResponder *)findFirstResponder {
    if ([_textView isFirstResponder]) {
        return _textView;
    }
    return nil;
}

// 打开第一响应者
- (void)restoreFirstResponder {
    if (_currentFirstResponder && ![_currentFirstResponder isFirstResponder]) {
        [_currentFirstResponder becomeFirstResponder];
    }
}

#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)noti{
    if(_textView.isFirstResponder){
        NSDictionary *info = [noti userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        _keyboardSize = [value CGRectValue].size;
        //NSLog(@"keyboardSize.height = %f",keyboardSize.height);
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = XHInputView_ScreenH - self.keyboardSize.height - frame.size.height;
            self.inputView.frame = frame;
            self.backgroundColor = XHInputView_BgViewColor;
            self.showFrameDefault = self.inputView.frame;
        }];
    }
}
- (void)keyboardWillDisappear:(NSNotification *)noti{
    
    if(_textView.isFirstResponder){
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = XHInputView_ScreenH;
            self.inputView.frame = frame;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            if (self.isAddImgClick == NO) {
                [self removeFromSuperview];
            }
        }];
    }
}

#pragma mark - set
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    if(_style == InputViewStyleLarge){
        _countLab.text = [NSString stringWithFormat:@"0/%ld",(long)maxCount];
    }
}
-(void)setTextViewBackgroundColor:(UIColor *)textViewBackgroundColor{
    _textViewBackgroundColor = textViewBackgroundColor;
    _textBgView.backgroundColor = textViewBackgroundColor;
}
-(void)setFont:(UIFont *)font{
    _font = font;
    _textView.font = font;
    _placeholderLab.font = _textView.font;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _placeholderLab.text = placeholder;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placeholderLab.textColor = placeholderColor;
    _countLab.textColor = placeholderColor;
}
-(void)setSendButtonBackgroundColor:(UIColor *)sendButtonBackgroundColor{
    _sendButtonBackgroundColor = sendButtonBackgroundColor;
    _sendButton.backgroundColor = sendButtonBackgroundColor;
}
-(void)setSendButtonTitle:(NSString *)sendButtonTitle{
    _sendButtonTitle = sendButtonTitle;
    [_sendButton setTitle:sendButtonTitle forState:UIControlStateNormal];
}
-(void)setSendButtonCornerRadius:(CGFloat)sendButtonCornerRadius{
    _sendButtonCornerRadius = sendButtonCornerRadius;
    _sendButton.layer.cornerRadius = sendButtonCornerRadius;
}
-(void)setSendButtonFont:(UIFont *)sendButtonFont{
    _sendButtonFont = sendButtonFont;
    _sendButton.titleLabel.font = sendButtonFont;
}


- (UICollectionView *)addImageCollectionView {
    if (!_addImageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);//上左下右
        _addImageCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _addImageCollectionView.backgroundColor = [UIColor whiteColor];
        _addImageCollectionView.delegate = self;
        _addImageCollectionView.dataSource = self;
        _addImageCollectionView.allowsMultipleSelection = YES;
        _addImageCollectionView.showsVerticalScrollIndicator = NO;
        _addImageCollectionView.showsHorizontalScrollIndicator = NO;
        //这种是原生cell的注册
        [_addImageCollectionView registerClass:[AddCommentCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _addImageCollectionView.hidden = YES;
    }
    return _addImageCollectionView;
}

@end

