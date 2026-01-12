//
//  MineViewController.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "MineViewController.h"
#import "MineView.h"
#import "ProfileViewController.h"

@interface MineViewController ()

@property (nonatomic, strong) MineView *mineView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    
    [self setupMineView];
    [self loadUserInfo];
    [self loadMockData];
}

- (void)setupMineView {
    [self.view addSubview:self.mineView];
    [self.mineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    WeakSelf
    
    // 设置按钮点击
    self.mineView.settingClickBlock = ^{
        NSLog(@"设置按钮点击");
        // TODO: 跳转到设置页面
    };
    
    // 头像点击
    self.mineView.avatarClickBlock = ^{
        NSLog(@"头像点击");
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        [weakSelf.navigationController pushViewController:profileVC animated:YES];
    };
    
    // 编辑简介
    self.mineView.editBioClickBlock = ^{
        NSLog(@"编辑简介点击");
        // TODO: 编辑个人简介
    };
    
    // 警告横幅点击
    self.mineView.alertBannerClickBlock = ^{
        NSLog(@"警告横幅点击");
        // TODO: 查看异常笔记
    };
    
    // 草稿点击
    self.mineView.draftClickBlock = ^{
        NSLog(@"草稿点击");
        // TODO: 跳转到草稿列表
    };
    
    // 笔记点击
    self.mineView.noteClickBlock = ^(NSInteger index) {
        NSLog(@"笔记点击: %ld", (long)index);
        // TODO: 跳转到笔记详情
    };
    
    // Tab切换
    self.mineView.tabChangedBlock = ^(MineTabType tabType) {
        NSLog(@"Tab切换: %ld", (long)tabType);
    };
    
    // 加载更多数据
    self.mineView.loadMoreDataBlock = ^(NSInteger current, NSInteger size, MineTabType tabType) {
        NSLog(@"加载数据: current=%ld, size=%ld, tabType=%ld", (long)current, (long)size, (long)tabType);
        // TODO: 根据tabType请求对应的数据
        [weakSelf loadMockData];
    };
}

- (void)loadUserInfo {
    // 更新用户信息
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kAccount];
    
    if (userName.length == 0) {
        userName = @"这里显示姓名";
    }
    if (userId.length == 0) {
        userId = @"TCL12346";
    }
    
    [self.mineView updateUserInfoWithName:userName
                                   userId:userId
                                      bio:@""
                                avatarUrl:@""];
    
    // 设置草稿数量
    [self.mineView setDraftCount:1];
    
    // 设置异常笔记数量
    [self.mineView setAbnormalNoteCount:1];
}

- (void)loadMockData {
    // 模拟数据
    NSMutableArray *mockList = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        NSDictionary *dict = @{
            @"coverImage": @"https://picsum.photos/400/500",
            @"title": @"青甘大环线7天极限攻坚路线保证完美",
            @"userAvatar": @"",
            @"userNickname": @"好爱吃奶酪",
            @"likeCount": @(1543),
            @"liked": @(NO)
        };
        [mockList addObject:dict];
    }
    
    // 更新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mineView updateNotesWithDataList:mockList hasMore:NO];
    });
}

#pragma mark - 懒加载
- (MineView *)mineView {
    if (!_mineView) {
        _mineView = [[MineView alloc] init];
    }
    return _mineView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
