//
//  PublishListView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/4.
//

#import "PublishListView.h"
#import "PublishListViewCell.h"

@interface PublishListView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *searcTextField;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIButton *textImgBut;
@property (nonatomic,strong) UIButton *itineraryBut;

@end

@implementation PublishListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navBarHeight + 25);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(25);
        }];
        
        [self addSubview:self.searcTextField];
        [self.searcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(15);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(35);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searcTextField.mas_bottom).offset(15);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-tabBarHeight - 100);
        }];
        
        [self addSubview:self.textImgBut];
        [self.textImgBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-tabBarHeight - 30);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(45);
            make.left.mas_equalTo(65);
        }];
        
        [self addSubview:self.itineraryBut];
        [self.itineraryBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-tabBarHeight - 30);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(45);
            make.right.mas_equalTo(-65);
        }];
        
        self.bgImg.hidden = YES;
        [self.tableView addSubview:self.bgImg];
        [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.tableView);
            make.width.mas_equalTo(143);
            make.height.mas_equalTo(170);
            make.centerX.mas_equalTo(self.tableView);
        }];
    }
    
    return self;
}

#pragma mark - tableViewDelegate\UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PublishListViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PublishListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSDictionary *dict;
    [cell publishListViewCellIndexPath:indexPath dict:dict];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -UITextFieldDelegate
// 搜索框点击事件
- (void)textFieldDidChangeClick:(UITextField *)textField{
    
}

// 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self textFieldResignFirstResponder];
}

// 点击键盘完成/返回按钮时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldResignFirstResponder];
    
    return YES;
}

- (void)textFieldResignFirstResponder{
    [self.searcTextField resignFirstResponder];
}

- (void)doneActionDoneActionClick{
    [self textFieldResignFirstResponder];
}

#pragma mark - 按钮点击
- (void)textImgButClick:(UIButton *)sender{
    
}

- (void)itineraryButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"快来发布属于您的动态吧！";
        _titleL.font = [UIFont systemFontOfSize:18];
        _titleL.textColor = [UIColor blackColor];
        //_titleL.textAlignment = NSTextAlignmentRight;
    }
    return _titleL;
}

- (UITextField *)searcTextField{
    if (!_searcTextField) {
        _searcTextField = [[UITextField alloc] init];
        _searcTextField.layer.cornerRadius = 6;
        _searcTextField.layer.masksToBounds = YES;
        _searcTextField.backgroundColor = RGB(240, 240, 240);
        _searcTextField.delegate = self;
        _searcTextField.font = [UIFont systemFontOfSize:14];
        _searcTextField.placeholder = @" 搜索您的动态/图文~";
        _searcTextField.returnKeyType = UIReturnKeySearch;// 换行变搜索
        _searcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _searcTextField.leftViewMode = UITextFieldViewModeAlways;
        _searcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _searcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_searcTextField addTarget:self action:@selector(textFieldDidChangeClick:) forControlEvents:UIControlEventEditingChanged];
        //[_searcTextField.keyboardToolbar.doneBarButton setTarget:self action:@selector(doneActionDoneActionClick)];
    }
    
    return _searcTextField;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)textImgBut{
    if (!_textImgBut) {
        _textImgBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textImgBut setBackgroundImage:[UIImage imageNamed:@"xuXian"] forState:UIControlStateNormal];
        [_textImgBut setTitle:@"发布图文" forState:UIControlStateNormal];
        [_textImgBut setTitleColor:RGB(255, 105, 31) forState:UIControlStateNormal];
        _textImgBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_textImgBut addTarget:self action:@selector(textImgButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textImgBut;
}

- (UIButton *)itineraryBut{
    if (!_itineraryBut) {
        _itineraryBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_itineraryBut setBackgroundImage:[UIImage imageNamed:@"xuXian"] forState:UIControlStateNormal];
        [_itineraryBut setTitle:@"发布行程" forState:UIControlStateNormal];
        [_itineraryBut setTitleColor:RGB(255, 105, 31) forState:UIControlStateNormal];
        _itineraryBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_itineraryBut addTarget:self action:@selector(itineraryButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itineraryBut;
}

- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"no_list"];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImg;
}

@end
