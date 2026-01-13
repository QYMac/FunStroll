//
//  ProfileViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "ProfileInfoCell.h"
#import "EditNicknameViewController.h"
#import "EditBioViewController.h"

static NSString *const kProfileInfoCellID = @"ProfileInfoCell";

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProfileHeaderView *headerView;
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"个人资料";
    
    self.titlesArray = @[@"ID", @"手机号", @"昵称", @"简介"];
    
    [self setupNavigationBar];
    [self setupTableView];
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
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    // 注册Cell
    [self.tableView registerClass:[ProfileInfoCell class] forCellReuseIdentifier:kProfileInfoCellID];
    
    // 设置头部视图
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)avatarTapped {
    return;
    // 选择头像
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakePicture = YES;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, (kHeight - kWidth) / 2, kWidth, kWidth);
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (photos.count > 0) {
        UIImage *selectedImage = photos.firstObject;
        [self.headerView setAvatarImage:selectedImage];
        // TODO: 上传头像到服务器
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;  // ID, 手机号, 昵称
    }
    return 1;  // 简介
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileInfoCellID forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (indexPath.section == 1) {
        row = 3;  // 简介
    }
    
    NSString *title = self.titlesArray[row];
    NSString *value = @"";
    NSString *placeholder = @"";
    ProfileCellType cellType = ProfileCellTypeDefault;
    
    switch (row) {
        case 0: {
            // ID
            value = [UserModel getObjectForKey:kAccount];
            if (value.length == 0) value = @"zshf1234";
            cellType = ProfileCellTypeDefault;
            [cell configurePosition:ProfileCellPositionFirst];
            break;
        }
        case 1: {
            // 手机号
            value = [UserModel getObjectForKey:kPhoneNumber];
            if (value.length == 0) value = @"13570452845";
            cellType = ProfileCellTypeDefault;
            [cell configurePosition:ProfileCellPositionMiddle];
            break;
        }
        case 2: {
            // 昵称
            value = [UserModel getObjectForKey:kUserName];
            placeholder = @"请输入用户昵称";
            cellType = ProfileCellTypeEdit;
            [cell configurePosition:ProfileCellPositionLast];
            break;
        }
        case 3: {
            // 简介
            placeholder = @"介绍一下自己";
            cellType = ProfileCellTypeArrow;
            [cell configurePosition:ProfileCellPositionOnly];
            break;
        }
        default:
            break;
    }
    
    [cell configureWithTitle:title value:value placeholder:placeholder cellType:cellType];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = RGB(245, 245, 245);
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    if (indexPath.section == 1) {
        row = 3;
    }
    
    switch (row) {
        case 2: {
            // 编辑昵称
            [self showEditNicknameAlert];
            break;
        }
        case 3: {
            // 编辑简介
            [self showEditBioAlert];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Edit Methods
- (void)showEditNicknameAlert {
    EditNicknameViewController *editVC = [[EditNicknameViewController alloc] init];
    editVC.currentNickname = [UserModel getObjectForKey:kUserName];
    WeakSelf
    editVC.saveBlock = ^(NSString *nickname) {
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)showEditBioAlert {
    EditBioViewController *editVC = [[EditBioViewController alloc] init];
    //editVC.currentBio = [UserModel getObjectForKey:kUserBio];
    WeakSelf
    editVC.saveBlock = ^(NSString *bio) {
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - Lazy Loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(250, 250, 250);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (ProfileHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 140)];
        WeakSelf
        _headerView.avatarTappedBlock = ^{
            [weakSelf avatarTapped];
        };
    }
    return _headerView;
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
