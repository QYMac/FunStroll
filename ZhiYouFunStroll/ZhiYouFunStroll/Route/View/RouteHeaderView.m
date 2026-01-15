//
//  RouteHeaderView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "RouteHeaderView.h"

@interface RouteHeaderView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *cardView;        // 白色卡片背景
@property (nonatomic, strong) UIView *startDot;
@property (nonatomic, strong, readwrite) UITextField *startTextField;
@property (nonatomic, strong) UIView *lineView;        // 分割线
@property (nonatomic, strong) UIView *endDot;
@property (nonatomic, strong, readwrite) UITextField *endTextField;
@property (nonatomic, strong) UIButton *waypointButton;
@property (nonatomic, strong) UIButton *routeEditButton;

@end

@implementation RouteHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 白色卡片背景
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = RGB(247, 247, 247);
    self.cardView.layer.cornerRadius = 8;
    [self addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    // 起点圆点
    self.startDot = [[UIView alloc] init];
    self.startDot.backgroundColor = RGB(145, 233, 80);
    self.startDot.layer.cornerRadius = 4;
    [self.cardView addSubview:self.startDot];
    [self.startDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(18);
        make.width.height.mas_equalTo(8);
    }];
    
    // 起点输入框
    self.startTextField = [[UITextField alloc] init];
    self.startTextField.font = [UIFont systemFontOfSize:15];
    self.startTextField.textColor = [UIColor blackColor];
    self.startTextField.placeholder = @"请输入起点";
    self.startTextField.delegate = self;
    self.startTextField.tag = RouteInputTypeStart;
    self.startTextField.returnKeyType = UIReturnKeyDone;
    [self.startTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardView addSubview:self.startTextField];
    [self.startTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startDot.mas_right).offset(12);
        make.centerY.mas_equalTo(self.startDot);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(30);
    }];
    
    
    // 终点圆点
    self.endDot = [[UIView alloc] init];
    self.endDot.backgroundColor = RGB(255, 87, 87);
    self.endDot.layer.cornerRadius = 4;
    [self.cardView addSubview:self.endDot];
    [self.endDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.startDot.mas_bottom).offset(25);
        make.width.height.mas_equalTo(8);
    }];
    
    // 终点输入框
    self.endTextField = [[UITextField alloc] init];
    self.endTextField.font = [UIFont systemFontOfSize:15];
    self.endTextField.textColor = [UIColor blackColor];
    self.endTextField.placeholder = @"请输入终点";
    self.endTextField.delegate = self;
    self.endTextField.tag = RouteInputTypeEnd;
    self.endTextField.returnKeyType = UIReturnKeyDone;
    [self.endTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardView addSubview:self.endTextField];
    [self.endTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endDot.mas_right).offset(12);
        make.centerY.mas_equalTo(self.endDot);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(30);
    }];
    
    
    // 路线修改按钮
    self.routeEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.routeEditButton setImage:[UIImage imageNamed:@"route_edit"] forState:UIControlStateNormal];
    [self.routeEditButton addTarget:self action:@selector(routeEditButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.routeEditButton];
    [self.routeEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cardView.mas_right).offset(-5);
        make.centerY.mas_equalTo(self.cardView);
        make.width.height.mas_equalTo(24);
    }];
    
    // 途经点按钮
    self.waypointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.waypointButton setImage:[UIImage imageNamed:@"route_waypoint"] forState:UIControlStateNormal];
    [self.waypointButton addTarget:self action:@selector(waypointButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.waypointButton];
    [self.waypointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.routeEditButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.cardView);
        make.width.height.mas_equalTo(24);
    }];
    
    
    // 连接线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB(229, 229, 229);
    [self.cardView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startTextField.mas_left).offset(0);
        make.right.mas_equalTo(self.waypointButton.mas_left).offset(-5);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.startTextField.mas_bottom).offset(2.5);
    }];
     
}

- (void)setStartName:(NSString *)startName {
    _startName = startName;
    self.startTextField.text = startName;
}

- (void)setEndName:(NSString *)endName {
    _endName = endName;
    self.endTextField.text = endName;
}

- (void)endEditing {
    [self.startTextField resignFirstResponder];
    [self.endTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    RouteInputType type = (RouteInputType)textField.tag;
    if ([self.delegate respondsToSelector:@selector(headerView:didBeginEditingWithType:)]) {
        [self.delegate headerView:self didBeginEditingWithType:type];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    RouteInputType type = (RouteInputType)textField.tag;
    if ([self.delegate respondsToSelector:@selector(headerView:didEndEditingWithType:)]) {
        [self.delegate headerView:self didEndEditingWithType:type];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    RouteInputType type = (RouteInputType)textField.tag;
    if ([self.delegate respondsToSelector:@selector(headerView:didTapReturnWithType:)]) {
        [self.delegate headerView:self didTapReturnWithType:type];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    RouteInputType type = (RouteInputType)textField.tag;
    if ([self.delegate respondsToSelector:@selector(headerView:didChangeText:withType:)]) {
        [self.delegate headerView:self didChangeText:textField.text withType:type];
    }
}

#pragma mark - Actions
- (void)waypointButtonClicked {
    if (self.waypointButtonBlock) {
        self.waypointButtonBlock();
    }
}

- (void)routeEditButtonClicked {
    if (self.routeEditButtonBlock) {
        self.routeEditButtonBlock();
    }
}

@end
