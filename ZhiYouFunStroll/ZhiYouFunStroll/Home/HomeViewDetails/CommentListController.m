//
//  CommentListController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import "CommentListController.h"
#import "HomeViewDetailsCell.h"
#import "AddCommentController.h"

@interface CommentListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *evaluationBut;

@end

@implementation CommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部评论";
    
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupAllCommentListUI];
}

- (void)setupAllCommentListUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomHeight - 44);
    }];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.bgView.layer.shadowOpacity = 0.1;//不透明度
    self.bgView.layer.shadowRadius = 5;//半径
    
    [self.bgView addSubview:self.evaluationBut];
    [self.evaluationBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - tableViewDelegate\UITableViewDataSource

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = RGB(240, 240, 240);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = RGB(240, 240, 240);
    
    return footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeViewDetailsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeViewDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 按钮点击事件
- (void)evaluationButClick:(UIButton *)sender{
    AddCommentController *navc = [[AddCommentController alloc]init];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)evaluationBut{
    if (!_evaluationBut) {
        _evaluationBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_evaluationBut setBackgroundImage:[UIImage imageNamed:@"home_PJ"] forState:UIControlStateNormal];
        [_evaluationBut setTitle:@"立即评价帮助更多人！" forState:UIControlStateNormal];
        [_evaluationBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _evaluationBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_evaluationBut addTarget:self action:@selector(evaluationButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluationBut;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImage * image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(dismissaBtu)];
    self.navigationItem.leftBarButtonItem = backButton;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dismissaBtu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
