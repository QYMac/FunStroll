//
//  HomeViewDetailsController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/28.
//

#import "HomeViewDetailsController.h"
#import "HomeViewDetailsCell.h"
#import "HomeViewDetailsHeaderView.h"
#import "CommentListController.h"
#import "AddCommentController.h"

@interface HomeViewDetailsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UIView *fgView;
@property (nonatomic,strong) UIButton *allListBut;

@end

@implementation HomeViewDetailsController

- (void)setTitleText:(NSString *)titleText{
    self.navigationItem.title = [CheckTool replaceNullValue:titleText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupHomeViewDetailsUI];
}

- (void)setupHomeViewDetailsUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

#pragma mark - tableViewDelegate\UITableViewDataSource
// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

// 分组上边预留的空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 320;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomeViewDetailsHeaderView *headerView = (HomeViewDetailsHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeViewDetailsHeaderView"];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor clearColor];
    
    _allListBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _allListBut.frame = CGRectMake(10, 0, kWidth - 20, 44);
    [_allListBut setTitle:@"查看全部评论" forState:UIControlStateNormal];
    [_allListBut setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
    _allListBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [_allListBut addTarget:self action:@selector(allListButClick:) forControlEvents:UIControlEventTouchUpInside];
    _allListBut.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:_allListBut];
    
    _fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    _fgView.backgroundColor  = RGB(240, 240, 240);
    [_footerView addSubview:_fgView];
    
    return _footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeViewDetailsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeViewDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    [cell setIndexPath:indexPath isAllList:NO];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 按钮点击
- (void)allListButClick:(UIButton *)sender{
    CommentListController *navc = [[CommentListController alloc]init];
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
        [_tableView registerClass:NSClassFromString(@"HomeViewDetailsHeaderView") forHeaderFooterViewReuseIdentifier:@"HomeViewDetailsHeaderView"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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
