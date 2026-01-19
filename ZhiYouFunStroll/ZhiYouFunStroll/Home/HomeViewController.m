//
//  HomeViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "AFNetworkingManage+Home.h"
#import "AFNetworkingManage+Login.h"
#import "HomeListModel.h"

@interface HomeViewController ()

@property (nonatomic,strong) HomeView *homeView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSMutableArray *recordsArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"Width=====%fHeight=====%f",kWidth,kHeight);
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 刷新token，进入app就刷新，保持最新的
    [self refreshToken];
    // 首页列表
    [self setupHomeView];
    // 检查是否登录
    [UserModel logoutView];
    
    // 请求首页数据
    [self AFNetworkingHomeDataListCurrent:1 size:20 keywordStr:@""];
}

- (void)setupHomeView{
    [self.view addSubview:self.homeView];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    WeakSelf
    [self.homeView setUpdateHomeDataListBlcok:^(NSInteger current, NSInteger size, NSString * _Nonnull keywordStr, BOOL isUpdtataTop) {
        if (isUpdtataTop == YES) {
            [weakSelf.dataList removeAllObjects];
            [weakSelf.recordsArray removeAllObjects];
        }
        // 请求首页数据
        [weakSelf AFNetworkingHomeDataListCurrent:current size:size keywordStr:keywordStr];
    }];
}

// 刷新toekn
- (void)refreshToken{
    [UserModel updateUserLoginToken];
}


// 获取首页列表数据
- (void)AFNetworkingHomeDataListCurrent:(NSInteger)current size:(NSInteger)size keywordStr:(NSString *)keywordStr{
    WeakSelf
    if ([UserModel sharedUserModel].isNetworkStatus == NO) {
        [FMDBManager searchHomeDataListKeyword:keywordStr andHandle:^(NSArray * _Nullable homeList) {
            HomeListModel *model = [[HomeListModel alloc] init];
            if (homeList.count > 0 && current == 1) {
                model.data.records = homeList;
            }
            weakSelf.homeView.model = model;
        }];
    } else {
        NSString *currentStr = [NSString stringWithFormat:@"%ld",current];
        NSString *sizeStr = [NSString stringWithFormat:@"%ld",size];
        [AFNetworkingManage homeListCurrent:currentStr size:sizeStr keyword:keywordStr success:^(id  _Nonnull responseObject) {
            //NSLog(@"%@",responseObject);
            HomeListModel *model = [HomeListModel yy_modelWithDictionary:responseObject];
            NSArray *dataArray = model.data.records;
            if (dataArray.count > 0) {
                [weakSelf.dataList addObjectsFromArray:dataArray];
                [weakSelf.recordsArray addObjectsFromArray:model.data.recordsArray];
                [FMDBManager saveHomeList:weakSelf.recordsArray andHandle:^(BOOL isSuccess) {
                    weakSelf.homeView.model = model;
                }];
            } else {
                weakSelf.homeView.model = model;
            }
        } failureHandler:^(NSError * _Nonnull error) {
            //NSLog(@"%@",error);
            [AlertWith showAlertWithMessageText:[AFNetworkingErrorHelper getFriendlyErrorMessage:error]];
            HomeListModel *model;
            weakSelf.homeView.model = model;
        }];
    }
}

#pragma mark - 懒加载
- (HomeView *)homeView{
    if (!_homeView) {
        _homeView = [[HomeView alloc] init];
    }
    return _homeView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (NSMutableArray *)recordsArray{
    if (!_recordsArray) {
        _recordsArray = [[NSMutableArray alloc] init];
    }
    return _recordsArray;
}

// 在 viewWillAppear: 方法中隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// 在 viewWillDisappear: 方法中显示回来
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    // 显示导航栏
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//}

@end
