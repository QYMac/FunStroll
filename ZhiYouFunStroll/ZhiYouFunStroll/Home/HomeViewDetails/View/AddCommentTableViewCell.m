//
//  AddCommentTableViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/4.
//

#import "AddCommentTableViewCell.h"
#import "AFNetworkingManage+Home.h"

@interface AddCommentTableViewCell ()<XHInputViewDelagete>


@end

@implementation AddCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self.contentView insertSubview:self.bgView atIndex:0];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(100);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [self.contentView insertSubview:self.numCommentL atIndex:99];
        [self.numCommentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(20);
        }];
        
        self.avatarImage.layer.cornerRadius = 32/2;
        self.avatarImage.layer.masksToBounds = YES;
        [self.contentView insertSubview:self.avatarImage atIndex:99];
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(32);
            make.left.mas_equalTo(self.numCommentL.mas_left).offset(0);
            make.top.mas_equalTo(self.numCommentL.mas_bottom).offset(10);
        }];
        
        self.addBut.layer.cornerRadius = 32/2;
        self.addBut.layer.masksToBounds = YES;
        [self.contentView insertSubview:self.addBut atIndex:99];
        [self.addBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
            make.left.mas_equalTo(self.avatarImage.mas_right).offset(15);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.avatarImage);
        }];
        
        [self.contentView insertSubview:self.addImgBut atIndex:99];
        [self.addImgBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addBut.mas_top).offset(0);
            make.width.mas_equalTo(25);
            make.right.mas_equalTo(self.addBut.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.addBut.mas_bottom).offset(0);
        }];
        
        [self.contentView insertSubview:self.expressionBut atIndex:99];
        [self.expressionBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addBut.mas_top).offset(0);
            make.width.mas_equalTo(25);
            make.right.mas_equalTo(self.addImgBut.mas_left).offset(-2.5);
            make.bottom.mas_equalTo(self.addBut.mas_bottom).offset(0);
        }];
        
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.avatarImage.mas_bottom).offset(10);
        }];
        
    }
    return self;
}

- (void)setModel:(CommentListModel *)model{
    self.numCommentL.text = [NSString stringWithFormat:@"共%ld条评论",model.total];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:self.imgURL] placeholderImage:[UIImage imageNamed:@"touxiang_m"]];
}

#pragma mark - 按钮点击
- (void)addButClick:(UIButton *)sender{
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    [self showXHInputViewWithStyle:InputViewStyleLarge];
}

- (void)expressionButClick{
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    [self showXHInputViewWithStyle:InputViewStyleLarge];
}

- (void)addImgButClick{
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    [self showXHInputViewWithStyle:InputViewStyleLarge];
}


-(void)showXHInputViewWithStyle:(InputViewStyle)style{
    
    [XHInputView showWithStyle:style configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        /** 代理 */
        inputView.delegate = self;
        /** 占位符文字 */
        inputView.placeholder = @"说点什么...";
        /** 设置最大输入字数 */
        inputView.maxCount = 150;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = RGB(244, 244, 244);
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text,NSArray *images) {
        if(text.length || images.count != 0){
            //NSLog(@"输入的信息为:%@",text);
            [self addText:text images:images];
            return YES;//return YES,收起键盘
        }else{
            //NSLog(@"显示提示框-请输入要评论的的内容");
            [AlertWith showAlertWithMessageText:@"请输入评论内容"];
            return NO;//return NO,不收键盘
        }
    }];
    
}

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)addText:(NSString *)text images:(NSArray *)images{
    if (images.count == 0 || images == nil) {
        images = @[];
    }
    if (self.addCommentClickBlcok) {
        self.addCommentClickBlcok(text,images);
    }
}

#pragma mark - 懒加载
- (UILabel *)numCommentL{
    if (!_numCommentL) {
        _numCommentL = [[UILabel alloc]init];
        _numCommentL.text = @"共564条评论";
        _numCommentL.font = [UIFont boldSystemFontOfSize:12];
        _numCommentL.textColor = RGB(51, 51, 51);
    }
    return _numCommentL;
}

- (UIImageView *)avatarImage{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.backgroundColor = RGB(244, 244, 244);
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

- (UIButton *)addBut{
    if (!_addBut) {
        _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBut setTitle:@"    有话要说，快来评论" forState:UIControlStateNormal];
        [_addBut setTitleColor:RGB(187, 187, 187) forState:UIControlStateNormal];
        _addBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_addBut addTarget:self action:@selector(addButClick:) forControlEvents:UIControlEventTouchUpInside];
        _addBut.userInteractionEnabled = YES;
        _addBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addBut.backgroundColor = RGB(244, 244, 244);
    }
    return _addBut;
}

- (UIButton *)expressionBut{
    if (!_expressionBut) {
        _expressionBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expressionBut setImage:[UIImage imageNamed:@"home_bq"] forState:UIControlStateNormal];
        [_expressionBut addTarget:self action:@selector(expressionButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expressionBut;
}

- (UIButton *)addImgBut{
    if (!_addImgBut) {
        _addImgBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImgBut setImage:[UIImage imageNamed:@"home_addImg"] forState:UIControlStateNormal];
        [_addImgBut addTarget:self action:@selector(addImgButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgBut;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

@end
