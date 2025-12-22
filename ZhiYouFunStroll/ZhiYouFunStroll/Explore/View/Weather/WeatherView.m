//
//  WeatherView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/5.
//

#import "WeatherView.h"
#import "WeatherViewCell.h"

@interface WeatherView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *exitBut;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WeatherView

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = RGB(240, 240, 240);
        
        [self addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-120);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.exitBut];
        [self.exitBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-10);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(15);
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    return self;
}

#pragma mark - tableViewDelegate\UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WeatherViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    [cell weatherViewCellIndexPath:indexPath];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// 点击空白处
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - 按钮点击
- (void)exitButClick:(UIButton *)sender{
    if (self.didWeatherViewBlcok) {
        self.didWeatherViewBlcok();
    }
}

#pragma mark - 懒加载
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"当前天气";
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}

- (UIButton *)exitBut{
    if (!_exitBut) {
        _exitBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitBut setImage:[UIImage imageNamed:@"Exit_Map"] forState:UIControlStateNormal];
        [_exitBut addTarget:self action:@selector(exitButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBut;
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

@end
