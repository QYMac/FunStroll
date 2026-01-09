//
//  ExploreViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "ExploreViewController.h"
#import "MerchantVardView.h"
#import "MerchantVardTabListView.h"
#import "MapAddressView.h"
#import "MapLayerView.h"
#import "WeatherView.h"
#import "XBTextLoopView.h"
#import "MapSearchView.h"

@interface ExploreViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *searcTextField;
@property (nonatomic,strong) UIButton *searcTopBut;
@property (nonatomic,strong) MapAddressView *mapView;
@property (nonatomic,strong) UIButton *addressBut;
@property (nonatomic,strong) UIButton *searcBut;
@property (nonatomic,strong) XBTextLoopView *loopView; // 滚动文字
@property (nonatomic,strong) UIButton *searcClickBut;
@property (strong,nonatomic) UIView *fgView;
@property (strong,nonatomic) UIImageView *bgImage;
@property (strong,nonatomic) MapSearchView *mapSearchView;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    WeakSelf
    // 延迟执行，确保布局已完成
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setupMapView];//高德地图
    });
}

- (void)setupMapView{
    
    [self.view insertSubview:self.mapView atIndex:0];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.bgImage.frame = CGRectMake(0, 0, kWidth, kHeight);
    [self.view addSubview:self.bgImage];
    
    [self.view addSubview:self.searcTextField];
    [self.searcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(statusBarHeight);
        make.height.mas_equalTo(40);
    }];
    
    if (_isSearch == YES) {
        self.bgImage.hidden = NO;
        [self.searcTextField layoutIfNeeded];
        [self.searcTextField addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(8, 8)];
    } else {
        self.bgImage.hidden = YES;
        self.searcTextField.layer.cornerRadius = 8;
        self.searcTextField.layer.masksToBounds = YES;
        
        _loopView = [XBTextLoopView textLoopViewWith:@[@"美食", @"景点", @"酒店", @"停车场"] loopInterval:3.0 initWithFrame:CGRectMake(50, statusBarHeight, kWidth - 45 - 100, 40) selectBlock:^(NSString *selectString, NSInteger index) {
            
        }];
        _loopView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_loopView];
    }

    [self.searcTextField addSubview:self.searcTopBut];
    [self.searcTopBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(self.searcTextField.mas_height);
        make.centerY.mas_equalTo(self.searcTextField);
    }];
    
    [self.view addSubview:self.addressBut];
    [self.addressBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(self.searcTextField.mas_right).offset(0);
        make.top.mas_equalTo(self.searcTextField.mas_bottom).offset(10);
    }];

    
    [self.view addSubview:self.searcBut];
    [self.searcBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searcTextField.mas_left).offset(0);
        make.right.mas_equalTo(self.searcTextField.mas_right).offset(0);
        make.top.mas_equalTo(self.searcTextField.mas_top).offset(0);
        make.height.mas_equalTo(self.searcTextField.mas_height);
    }];
    
    [self.searcTextField addSubview:self.searcClickBut];
    [self.searcClickBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(55);
    }];
    
    [self.view addSubview:self.fgView];
    [self.fgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.searcClickBut.mas_left).offset(0);
        make.centerY.mas_equalTo(self.searcClickBut);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(1);
    }];
    
    
    
    
    if (self.isSearch == YES) {
        self.searcBut.selected = YES;
        [self.searcTopBut setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _loopView.hidden = YES;
        self.fgView.hidden = NO;
        self.searcClickBut.hidden = NO;
        self.searcBut.hidden = YES;
        
        self.mapSearchView.hidden = NO;
        [self.view addSubview:self.mapSearchView];
        [self.mapSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searcTextField.mas_bottom).offset(0);
            make.left.mas_equalTo(self.searcTextField.mas_left).offset(0);
            make.right.mas_equalTo(self.searcTextField.mas_right).offset(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    WeakSelf
    self.mapView.didSelectAnnotationViewBlcok = ^(NSString * _Nonnull idStr) {
        
    };
}

#pragma mark - 按钮点击
- (void)addressButClick{
    [self searcTextFieldResignFirstResponder];
    [self.mapView moveToCurrentLocation];
}

- (void)searcSelectedButClick:(UIButton *)sender{
    
    if (self.isSearch == NO) {
        ExploreViewController *navc = [[ExploreViewController alloc] init];
        navc.isSearch = YES;
        [self.navigationController pushViewController:navc animated:YES];
        return;
    }
}

- (void)searcTopButClick{
    if (self.isSearch == YES) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (void)searcClickButClick:(UIButton *)sender{
    WeakSelf
    [FMDBManager saveExploreSearchList:self.searcTextField.text andHandle:^(BOOL isSuccess) {
        [weakSelf.mapSearchView reloadHistory];
    }];
}

#pragma mark -UITextFieldDelegate
// 搜索框点击事件
- (void)textFieldDidChange:(UITextField *)textField{
    
}

// 图片点击
- (void)recordingImageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
}

// 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self searcTextFieldResignFirstResponder];

}

- (void)doneActionDoneAction{
    [self searcTextFieldResignFirstResponder];
}

// 点击键盘完成/返回按钮时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"用户点击了完成按钮");
    [self searcTextFieldResignFirstResponder];
    
    return YES;
}


- (void)searcTextFieldResignFirstResponder{
    [self.searcTextField resignFirstResponder];
}

#pragma  mark - 懒加载
- (UITextField *)searcTextField{
    if (!_searcTextField) {
        _searcTextField = [[UITextField alloc] init];
        _searcTextField.backgroundColor = [UIColor whiteColor];
        _searcTextField.delegate = self;
        //_searcTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searcTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入关键词" attributes:@{NSForegroundColorAttributeName:RGB(187, 187, 187),NSFontAttributeName:_searcTextField.font}];
        _searcTextField.attributedPlaceholder = attrString;
        _searcTextField.returnKeyType = UIReturnKeySearch;// 换行变搜索
        _searcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
        _searcTextField.leftViewMode = UITextFieldViewModeAlways;
        _searcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
        _searcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_searcTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        //[_searcTextField.keyboardToolbar.doneBarButton setTarget:self action:@selector(doneActionDoneAction)];
    }
    
    return _searcTextField;
}

- (MapAddressView *)mapView{
    if (!_mapView) {
        _mapView = [[MapAddressView alloc] init];
        _mapView.mapAnnotationType = 0;
    }
    return _mapView;
}

- (UIButton *)searcTopBut{
    if (!_searcTopBut) {
        _searcTopBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searcTopBut setImage:[UIImage imageNamed:@"search_home"] forState:UIControlStateNormal];
        [_searcTopBut addTarget:self action:@selector(searcTopButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searcTopBut;
}

- (UIButton *)addressBut{
    if (!_addressBut) {
        _addressBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBut setImage:[UIImage imageNamed:@"dingWei"] forState:UIControlStateNormal];
        [_addressBut addTarget:self action:@selector(addressButClick) forControlEvents:UIControlEventTouchUpInside];
        _addressBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _addressBut;
}

- (UIButton *)searcBut{
    if (!_searcBut) {
        _searcBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searcBut addTarget:self action:@selector(searcSelectedButClick:) forControlEvents:UIControlEventTouchUpInside];
        _searcBut.backgroundColor = [UIColor clearColor];
    }
    return _searcBut;
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc] init];
        _fgView.backgroundColor = RGB(238, 238, 238);
        _fgView.hidden = YES;
    }
    return _fgView;
}

- (UIButton *)searcClickBut{
    if (!_searcClickBut) {
        _searcClickBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searcClickBut addTarget:self action:@selector(searcClickButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searcClickBut setTitle:@"搜索" forState:UIControlStateNormal];
        _searcClickBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_searcClickBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _searcClickBut.backgroundColor = [UIColor clearColor];
        _searcClickBut.hidden = YES;
    }
    return _searcClickBut;
}


- (UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.image = [UIImage imageNamed:@"searchBgImg"];
        _bgImage.hidden = YES;
    }
    return _bgImage;
}

- (MapSearchView *)mapSearchView{
    if (!_mapSearchView) {
        _mapSearchView = [[MapSearchView alloc] init];
        _mapSearchView.hidden = YES;
    }
    return _mapSearchView;
}

// 在 viewWillAppear: 方法中隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
