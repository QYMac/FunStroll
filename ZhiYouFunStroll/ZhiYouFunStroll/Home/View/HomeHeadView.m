//
//  HomeHeadView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/30.
//

#import "HomeHeadView.h"

@interface HomeHeadView ()<UITextFieldDelegate>

@end

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bgImgView.layer.cornerRadius = 0;
        self.bgImgView.layer.masksToBounds = YES;
        [self addSubview:self.bgImgView];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        [self.bgImgView insertSubview:self.bgImg atIndex:0];
        [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            //make.bottom.mas_equalTo(0);
        }];
        
        self.homeSearcTextField.layer.cornerRadius = 35/2;
        self.homeSearcTextField.layer.masksToBounds = YES;
        self.homeSearcTextField.layer.borderColor = RGB(51, 51, 51).CGColor;
        self.homeSearcTextField.layer.borderWidth = 1;
        [self insertSubview:self.homeSearcTextField atIndex:99];
        CGFloat topFloat = statusBarHeight;
        if ([DeviceInfoHelper isDynamicIsland] == YES) {
            topFloat = statusBarHeight + 10;
        }
        [self.homeSearcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topFloat);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(35);
        }];
        
        [self insertSubview:self.searchBut atIndex:100];
        [self.searchBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.homeSearcTextField);
            make.right.mas_equalTo(self.homeSearcTextField.mas_right).offset(-3);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(29);
        }];
        
        self.bgView.frame = CGRectMake(0, self.frame.size.height - 44, kWidth, 44);
        [self addSubview:self.bgView];
        [self.bgView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(22, 22)];
        
        [self addSubview:self.labelImg];
        [self.labelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(77);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(self.bgView);
        }];
    }
    return self;
}

#pragma mark - 按钮点击
- (void)searchButClick{
    if (self.searcDataListBlcok) {
        self.searcDataListBlcok([CheckTool replaceNullValue:self.homeSearcTextField.text], YES);
    }
}

#pragma mark -UITextFieldDelegate
// 搜索框点击事件
- (void)textFieldDidChange:(UITextField *)textField{
    
}

// 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.homeSearcTextField resignFirstResponder];
    
}

- (void)doneActionClick{
    [self.homeSearcTextField resignFirstResponder];
}

// 点击键盘完成/返回按钮时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"用户点击了完成按钮");
    [self.homeSearcTextField resignFirstResponder];
    
    if (self.searcDataListBlcok) {
        self.searcDataListBlcok([CheckTool replaceNullValue:self.homeSearcTextField.text], YES);
    }
    return YES;
}


#pragma mark - 懒加载
- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.backgroundColor = RGB(240, 240, 240);
        _bgImg.image = [UIImage imageNamed:@"home_bgImg"];
        //_bgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImg;
}

- (UIImageView *)labelImg{
    if (!_labelImg) {
        _labelImg = [[UIImageView alloc] init];
        _labelImg.image = [UIImage imageNamed:@"home_label"];
    }
    return _labelImg;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIView alloc] init];
        _bgImgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgImgView;
}

- (UITextField *)homeSearcTextField{
    if (!_homeSearcTextField) {
        _homeSearcTextField = [[UITextField alloc] init];
        _homeSearcTextField.backgroundColor = [UIColor whiteColor];
        _homeSearcTextField.delegate = self;
        _homeSearcTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入关键字" attributes:@{NSForegroundColorAttributeName:RGB(187, 187, 187),NSFontAttributeName:_homeSearcTextField.font}];
        _homeSearcTextField.attributedPlaceholder = attrString;
        _homeSearcTextField.returnKeyType = UIReturnKeySearch;// 换行变搜索
        _homeSearcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _homeSearcTextField.leftViewMode = UITextFieldViewModeAlways;
        _homeSearcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 0)];
        _homeSearcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_homeSearcTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        //[_homeSearcTextField.keyboardToolbar.doneBarButton setTarget:self action:@selector(doneActionClick)];
    }
    
    return _homeSearcTextField;
}

- (UIButton *)searchBut{
    if (!_searchBut) {
        _searchBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBut setBackgroundImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
        [_searchBut addTarget:self action:@selector(searchButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBut;
}

@end
