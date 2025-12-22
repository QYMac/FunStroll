//
//  HomeViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "HomeViewController.h"
#import "ScenicSpotViewController.h"
#import "DeliciousFoodViewController.h"
#import "CommunityViewController.h"

@interface HomeViewController ()

@property (nonatomic,strong) SwitchPageView *pageView;
@property (nonatomic,strong) UIButton *addresBut;// 定位按钮
@property (nonatomic,strong) UIButton *searchBut;// 搜索按钮

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSwitchPageView];

}

// 创建分页列表
- (void)initSwitchPageView{
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[CommunityViewController new]];
    [titles addObject:@"社区广场"];
    [controllers addObject:[DeliciousFoodViewController new]];
    [titles addObject:@"美食"];
    [controllers addObject:[ScenicSpotViewController new]];
    [titles addObject:@"景点"];
    
    self.pageView = [[SwitchPageView alloc]initWithFrame:CGRectMake(0, statusBarHeight+10, kWidth,kHeight-statusBarHeight-10) titles:titles controllers:controllers];
    self.pageView.titleViewHeight = 35;
    self.pageView.titleButtonWidth = kWidth/5;
    self.pageView.selectTitleFont = [UIFont boldSystemFontOfSize:16];
    self.pageView.defaultTitleFont = [UIFont boldSystemFontOfSize:16];
    self.pageView.defaultTitleColor = RGB(173, 173, 173);
    self.pageView.selectTitleColor = [UIColor blackColor];
    self.pageView.lineColor = RGB(255, 176, 79);
    self.pageView.lineHeight = 3;
    self.pageView.marginToLfet = kWidth/controllers.count - kWidth/5/2;
    [self.view addSubview:self.pageView];
    
    CGSize size = [self.addresBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.addresBut.titleLabel.font}];// 计算文字size
    [self.view addSubview:self.addresBut];
    [self.addresBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+30);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo(statusBarHeight + 10 + self.pageView.titleViewHeight+15);
    }];
    
    self.searchBut.layer.cornerRadius = 32/2;
    self.searchBut.layer.masksToBounds = YES;
    self.searchBut.layer.borderWidth = 1;
    self.searchBut.layer.borderColor = RGB(193, 193, 193).CGColor;
    [self.view addSubview:self.searchBut];
    [self.searchBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.addresBut.mas_right).offset(15);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.addresBut);
    }];

}

#pragma mark - 按钮点击

- (void)addresButClick:(UIButton *)sender{
    
}

- (void)searchButClick:(UIButton *)sender{
    
}

// 懒加载
- (UIButton *)addresBut{
    if (!_addresBut) {
        _addresBut = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *addresImage = [[UIImage imageNamed:@"addres_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_addresBut setImage:addresImage forState:UIControlStateNormal];
        [_addresBut setTitle:@"广东" forState:UIControlStateNormal];
        [_addresBut setTintColor:[UIColor blackColor]];
        [_addresBut addTarget:self action:@selector(addresButClick:) forControlEvents:UIControlEventTouchUpInside];
        _addresBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addresBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _addresBut;
}

- (UIButton *)searchBut{
    if (!_searchBut) {
        _searchBut = [UIButton buttonWithType:UIButtonTypeSystem];
        //UIImage *searchImage = [[UIImage imageNamed:@"search_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //[_searchBut setImage:searchImage forState:UIControlStateNormal];
        _searchBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_searchBut setTitle:@"         搜想去的地方~" forState:UIControlStateNormal];
        _searchBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchBut setTintColor:RGB(196, 196, 196)];
        [_searchBut addTarget:self action:@selector(searchButClick:) forControlEvents:UIControlEventTouchUpInside];
        //[_searchButsetImagePositionWithType:SSImagePositionTypeLeft spacing:5];
        UIImageView *soushuoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 17, 17)];
        soushuoImg.image = [UIImage imageNamed:@"search_home"];
        [_searchBut addSubview:soushuoImg];
    }
    return _searchBut;
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
