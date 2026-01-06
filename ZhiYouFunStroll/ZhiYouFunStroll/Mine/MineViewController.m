//
//  MineViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "MineViewController.h"
#import "MineViewTableViewCell.h"
#import "LoginViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *bgImage;
@property (nonatomic,strong) UILabel *LoginTitle;
@property (nonatomic,strong) UILabel *statusLoginL;
@property (nonatomic,strong) UIButton *loginBut;
@property (nonatomic,strong) NSArray *titleList;
@property (nonatomic,strong) NSArray *imgList;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    
    [self setupMyUI];
}

- (void)setupMyUI{
    
    [self.view addSubview:self.bgImage];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(300);
        make.left.top.right.mas_equalTo(0);
    }];
    
    self.LoginTitle.hidden = NO;
    [self.view addSubview:self.LoginTitle];
    [self.LoginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
        make.centerY.mas_equalTo(self.bgImage).offset(20);
        make.centerX.mas_equalTo(self.bgImage);
    }];
    
    self.statusLoginL.hidden = NO;
    [self.view addSubview:self.statusLoginL];
    [self.statusLoginL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(self.LoginTitle.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.bgImage);
    }];
    
    self.loginBut.hidden = NO;
    [self.view addSubview:self.loginBut];
    [self.loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(100);
        make.centerX.mas_equalTo(self.LoginTitle);
        make.centerY.mas_equalTo(self.LoginTitle);
    }];
    
    
    self.titleList = @[@"",@"",@"我的收藏",@"发布管理",@"我的评论",@"我的主题",@"消息中心",@"积分管理",@"实名认证",@"意见反馈",@"隐私政策"];
    self.imgList = @[@"",@"",@"myShouCang",@"myFaBu",@"myPingLun",@"myZhuTi",@"myXiaoXi",@"myJiFen",@"myWoMen",@"myYiJian",@"myYinSi"];
    
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - tableViewDelegate\UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 185;
    } else if (indexPath.row == 1) {
        return 120;
    } else if (indexPath.row == self.titleList.count - 1) {
        return 150;
    }
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineViewTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MineViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.indexPathCell = indexPath;
    
    cell.headTitle.text = [NSString stringWithFormat:@"%@",self.titleList[indexPath.row]];
    cell.headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgList[indexPath.row]]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 按钮点击
- (void)loginButClick:(UIButton *)sender{
    
    //TransitionAnimation *transition = [[TransitionAnimation alloc] init];
    LoginViewController *navc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:navc animated:YES];
    
}



#pragma mark - 懒加载
- (UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.backgroundColor = [UIColor whiteColor];
        _bgImage.image = [UIImage imageNamed:@"myBg"];
        _bgImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImage;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UILabel *)LoginTitle{
    if (!_LoginTitle) {
        _LoginTitle = [[UILabel alloc]init];
        _LoginTitle.textColor = [UIColor whiteColor];
        _LoginTitle.text = @"早上好！";
        _LoginTitle.font = [UIFont systemFontOfSize:20];
        _LoginTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _LoginTitle;
}

- (UILabel *)statusLoginL{
    if (!_statusLoginL) {
        _statusLoginL = [[UILabel alloc]init];
        _statusLoginL.textColor = [UIColor whiteColor];
        _statusLoginL.text = @"登录/注册";
        _statusLoginL.font = [UIFont systemFontOfSize:16];
        _statusLoginL.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLoginL;
}

- (UIButton *)loginBut{
    if (!_loginBut) {
        _loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBut addTarget:self action:@selector(loginButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBut;
}


// 在 viewWillAppear: 方法中隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}



@end
