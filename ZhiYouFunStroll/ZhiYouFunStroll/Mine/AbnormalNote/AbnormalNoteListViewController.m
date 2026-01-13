//
//  AbnormalNoteListViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "AbnormalNoteListViewController.h"
#import "AbnormalNoteCell.h"

static NSString *const kAbnormalNoteCellID = @"AbnormalNoteCell";

@interface AbnormalNoteListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation AbnormalNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"发布异常";
    
    [self setupNavigationBar];
    [self setupTableView];
    [self loadData];
}

- (void)setupNavigationBar {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tableView registerClass:[AbnormalNoteCell class] forCellReuseIdentifier:kAbnormalNoteCellID];
}

- (void)loadData {
    // 模拟数据
    self.dataList = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        NSDictionary *dict = @{
            @"id": @(i),
            @"coverUrl": @"https://picsum.photos/200/200",
            @"title": @"青甘大环线7天极限攻坚路线",
            @"warningText": @"系统检测到内容涉嫌政治相关，无法发布此内容！"
        };
        [self.dataList addObject:dict];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editNoteAtIndex:(NSInteger)index {
    NSDictionary *noteInfo = self.dataList[index];
    NSLog(@"编辑笔记: %@", noteInfo);
    // TODO: 跳转到编辑页面
}

- (void)deleteNoteAtIndex:(NSInteger)index {
    WeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定要删除这篇笔记吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dataList removeObjectAtIndex:index];
        [weakSelf.tableView reloadData];
        // TODO: 调用删除接口
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AbnormalNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kAbnormalNoteCellID forIndexPath:indexPath];
    
    NSDictionary *noteInfo = self.dataList[indexPath.row];
    [cell configureWithCoverUrl:noteInfo[@"coverUrl"]
                          title:noteInfo[@"title"]
                    warningText:noteInfo[@"warningText"]];
    
    WeakSelf
    cell.editBlock = ^{
        [weakSelf editNoteAtIndex:indexPath.row];
    };
    
    cell.deleteBlock = ^{
        [weakSelf deleteNoteAtIndex:indexPath.row];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteNoteAtIndex:indexPath.row];
    }
}

// iOS 11+ 左滑操作
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    WeakSelf
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                               title:@"删除"
                                                                             handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf deleteNoteAtIndex:indexPath.row];
        completionHandler(YES);
    }];
    deleteAction.backgroundColor = RGB(255, 80, 80);
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

#pragma mark - Lazy Loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(250, 250, 250);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 10, 0);
        // 自适应高度
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
