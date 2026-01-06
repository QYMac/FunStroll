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

@interface ExploreViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImage *renderedImage;
@property (nonatomic,strong) UIImage *functionImage;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *functionBut;
@property (nonatomic,strong) UIButton *positioningBut;
@property (nonatomic,strong) UIButton *selectedFBut;
@property (nonatomic,strong) MerchantVardView *merchantVardView;
@property (nonatomic,strong) UITextField *searcTextField;
@property (nonatomic,strong) MerchantVardTabListView *merchantVardTabListView;
@property (nonatomic,strong) MapAddressView *mapView;
@property (nonatomic,strong) MapLayerView *mapLayerView;
@property (nonatomic,strong) WeatherView *weatherView;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(234, 234, 234);
    [self setupSelectedBut];
    [self setupMapView];//高德地图
}

// 底部选择按钮，单选
- (void)setupSelectedBut{
    
    NSArray *selectedList = @[@"全部",@"美食",@"景点"];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 6;
    _bgView.layer.masksToBounds = YES;
    [self.view addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- tabBarHeight - 40);
        make.width.mas_equalTo(80*selectedList.count);
        make.left.mas_equalTo((kWidth-80*selectedList.count)/2);
        make.height.mas_equalTo(34);
    }];
    
    //[SetShadow setShadow:_bgView];// 设置阴影
    
    _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 34)];
    _bgImg.hidden = NO;
    _bgImg.layer.cornerRadius = 6;
    _bgImg.layer.masksToBounds = YES;
    [_bgView addSubview:_bgImg];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(255, 176, 79).CGColor, (__bridge id)RGB(255, 105, 31).CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, 80, 34);
    [_bgImg.layer addSublayer:gradientLayer];
    
    UIGraphicsBeginImageContextWithOptions(_bgImg.bounds.size, NO, 0.0);
    [_bgImg.layer renderInContext:UIGraphicsGetCurrentContext()];
    _functionImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _bgImg.layer.cornerRadius = 0;
    _bgImg.layer.masksToBounds = NO;
    UIGraphicsBeginImageContextWithOptions(_bgImg.bounds.size, NO, 0.0);
    [_bgImg.layer renderInContext:UIGraphicsGetCurrentContext()];
    _renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _bgImg.hidden = YES;
    
    [_bgImg removeFromSuperview];
    _bgImg = nil;
    
    for (int i = 0; i < selectedList.count; i++) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_button setTitle:[NSString stringWithFormat:@"%@",selectedList[i]] forState:UIControlStateNormal];
        _button.tag = 100+i;
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(selectedButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.left.mas_equalTo(80*i);
        }];
        
        if (i == 0) {
            
            _button.selected = YES;
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_button setBackgroundImage:_renderedImage forState:UIControlStateNormal];
            _selectedButton = _button;
        } else {
            _button.selected = NO;
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
    }
    
    
    NSArray *functionList = @[@"搜索",@"图层",@"天气",@"行程"];
    NSArray *functionImages = @[@"souSuo",@"fenCeng",@"tianQi",@"xingCheng"];
    for (int i = 0; i < functionList.count; i++) {
        _functionBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _functionBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_functionBut setTitle:[NSString stringWithFormat:@"%@",functionList[i]] forState:UIControlStateNormal];
        [_functionBut setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",functionImages[i]]] forState:UIControlStateNormal];
        [_functionBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _functionBut.tag = 100+i;
        _functionBut.layer.cornerRadius = 6;
        _functionBut.backgroundColor = [UIColor whiteColor];
        [_functionBut setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [_functionBut addTarget:self action:@selector(functionButClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_functionBut];
        [_functionBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(150 + 50*i);
            make.width.height.mas_equalTo(50);
            make.right.mas_equalTo(-15);
        }];
        
        if (i != 0) {
            [_functionBut mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(150 + 65*i);
            }];
        }
        [SetShadow setShadowBut:_functionBut];// 设置阴影
    }
    
    _positioningBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_positioningBut setImage:[UIImage imageNamed:@"dingWei"] forState:UIControlStateNormal];
    [_positioningBut addTarget:self action:@selector(positioningButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_positioningBut];
    [_positioningBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_functionBut.mas_bottom).offset(100);
        make.width.height.mas_equalTo(50);
        make.centerX.mas_equalTo(_functionBut);
    }];
    
    [self setupMerchantVardView];// 商家卡片
    [self setupOperationView];   // 搜索和其它功能界面
}

// 商家卡片View
- (void)setupMerchantVardView{
    self.merchantVardView.hidden = YES;
    [self.view addSubview:self.merchantVardView];
    [self.merchantVardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.bgView.mas_top).offset(-15);
        make.height.mas_equalTo(110);
    }];
}

- (void)setupOperationView{
    self.searcTextField.hidden = YES;
    [self.view addSubview:self.searcTextField];
    [self.searcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(_functionBut.mas_left).offset(-15);
        make.top.mas_equalTo(85);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    searchImage.image = [UIImage imageNamed:@"search_home"];
    [self.searcTextField addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.searcTextField);
    }];
    
    UIImageView *recordingImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    recordingImage.image = [UIImage imageNamed:@"luYin"];
    // 添加图片点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordingImageTapped:)];
    [recordingImage addGestureRecognizer:tapGesture];
    recordingImage.userInteractionEnabled = YES;
    [self.searcTextField addSubview:recordingImage];
    [recordingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.searcTextField);
    }];
    
    [SetShadow setShadowTextField:self.searcTextField];// 设置阴影
    
    self.merchantVardTabListView.hidden = YES;
    [self.view addSubview:self.merchantVardTabListView];
    [self.merchantVardTabListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searcTextField.mas_left).offset(0);
        make.right.mas_equalTo(self.searcTextField.mas_right).offset(0);
        make.top.mas_equalTo(self.searcTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(90);
    }];
    
    
    
}

- (void)setupMapView{
    [self.view insertSubview:self.mapView atIndex:0];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    WeakSelf
    self.mapView.didSelectAnnotationViewBlcok = ^(NSString * _Nonnull idStr) {
        weakSelf.merchantVardView.hidden = NO;
    };
    
    [self.view addSubview:self.mapLayerView];
    // 退出View
    self.mapLayerView.didMapLayerViewBlcok = ^{
        [weakSelf isPopmapLayerView:NO isClick:NO];
    };
    //更换地图图层
    self.mapLayerView.changeLayerBlcok = ^(NSInteger index) {
        [weakSelf.mapView changeMapLayerClickIndex:index];
    };
    //更换地图背景
    self.mapLayerView.changeBgBlcok = ^(NSInteger index) {
        [weakSelf.mapView changeBgClickIndex:index];
    };
    //更换地图皮肤
    self.mapLayerView.changeSkinBlcok = ^(NSInteger index) {
        [weakSelf.mapView changeSkinClickIndex:index];
    };
    
    // 天气View
    [self.view addSubview:self.weatherView];
    self.weatherView.didWeatherViewBlcok = ^{
        [weakSelf isPopWeatherView:NO isClick:NO];
    };
    
}

#pragma mark - 按钮点击
- (void)selectedButClick:(UIButton *)sender{
    [self searcTextFieldResignFirstResponder];
    
    if (sender.selected == NO) {
        _selectedButton.selected = NO;
        [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        sender.selected = YES;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundImage:_renderedImage forState:UIControlStateNormal];
        
    } else {
        
    }
    
    self.merchantVardView.hidden = YES;
    self.mapView.mapAnnotationType = sender.tag - 100;
    [self.mapView removeAllCustomAnnotations];
    
    _selectedButton = sender;
}


- (void)functionButClick:(UIButton *)sender{
    [self searcTextFieldResignFirstResponder];
    
    if (sender.selected == NO) {
        _selectedFBut.selected = NO;
        [_selectedFBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectedFBut setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        sender.selected = YES;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundImage:_functionImage forState:UIControlStateNormal];
        
    } else {
        
    }
    
    if (sender.tag == 100) {
        self.searcTextField.hidden = NO;
    } else {
        self.searcTextField.text = @"";
        self.searcTextField.hidden = YES;
    }
    
    // 弹出图层View
    if (sender.tag == 101) {
        self.weatherView.hidden = YES;
        [self isPopWeatherView:NO isClick:YES];
        [self isPopmapLayerView:YES isClick:YES];
    } else if (sender.tag == 102) {
        self.mapLayerView.hidden = YES;
        [self isPopmapLayerView:NO isClick:YES];
        [self isPopWeatherView:YES isClick:YES];
    } else {
        [self isPopmapLayerView:NO isClick:YES];
        [self isPopWeatherView:NO isClick:YES];
    }
    
    _selectedFBut = sender;
}

// 定位
- (void)positioningButClick:(UIButton *)sender{
    [self searcTextFieldResignFirstResponder];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocation object:nil userInfo:nil];
    [self.mapView moveToCurrentLocation];
}

// 弹出图层View
- (void)isPopmapLayerView:(BOOL)isPop isClick:(BOOL)isClick{
    WeakSelf
    if (isPop == YES) {
        self.mapLayerView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.mapLayerView.frame = CGRectMake(0, kHeight - 680*DDHorizontalFlexibleRatio(), kWidth, 680*DDHorizontalFlexibleRatio());
        }];
    } else {
        if (isClick == NO) {
            _selectedFBut.selected = NO;
            [_selectedFBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_selectedFBut setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.mapLayerView.frame = CGRectMake(0, kHeight, kWidth, 680*DDHorizontalFlexibleRatio());
        } completion:^(BOOL finished) {
            weakSelf.mapLayerView.hidden = YES;
        }];
    }
}


// 弹出天气View
- (void)isPopWeatherView:(BOOL)isPop isClick:(BOOL)isClick{
    WeakSelf
    if (isPop == YES) {
        self.weatherView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.weatherView.frame = CGRectMake(0, kHeight - 600, kWidth, 600);
        }];
    } else {
        if (isClick == NO) {
            _selectedFBut.selected = NO;
            [_selectedFBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_selectedFBut setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.weatherView.frame = CGRectMake(0, kHeight, kWidth, 600);
        } completion:^(BOOL finished) {
            weakSelf.weatherView.hidden = YES;
        }];
    }
}

#pragma mark -UITextFieldDelegate
// 搜索框点击事件
- (void)textFieldDidChange:(UITextField *)textField{
    self.merchantVardTabListView.hidden = NO;
}

// 图片点击
- (void)recordingImageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
}

// 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self searcTextFieldResignFirstResponder];
    self.merchantVardView.hidden = YES;
    [self isPopmapLayerView:NO isClick:NO];
    [self isPopWeatherView:NO isClick:NO];
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
    self.merchantVardTabListView.hidden = YES;
    [self.searcTextField resignFirstResponder];
}

#pragma  mark - 懒加载

- (MerchantVardView *)merchantVardView{
    if (!_merchantVardView) {
        _merchantVardView = [[MerchantVardView alloc] init];
    }
    return _merchantVardView;
}

- (UITextField *)searcTextField{
    if (!_searcTextField) {
        _searcTextField = [[UITextField alloc] init];
        _searcTextField.layer.cornerRadius = 6;
        _searcTextField.layer.masksToBounds = YES;
        _searcTextField.backgroundColor = [UIColor whiteColor];
        _searcTextField.delegate = self;
        //_searcTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searcTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜想去的地方~" attributes:@{NSForegroundColorAttributeName:RGB(173, 173, 173),NSFontAttributeName:_searcTextField.font}];
        _searcTextField.attributedPlaceholder = attrString;
        _searcTextField.returnKeyType = UIReturnKeySearch;// 换行变搜索
        _searcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 0)];
        _searcTextField.leftViewMode = UITextFieldViewModeAlways;
        _searcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
        _searcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_searcTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        //[_searcTextField.keyboardToolbar.doneBarButton setTarget:self action:@selector(doneActionDoneAction)];
    }
    
    return _searcTextField;
}


- (MerchantVardTabListView *)merchantVardTabListView{
    if (!_merchantVardTabListView) {
        _merchantVardTabListView = [[MerchantVardTabListView alloc] init];
    }
    return _merchantVardTabListView;
}

- (MapAddressView *)mapView{
    if (!_mapView) {
        _mapView = [[MapAddressView alloc] init];
        _mapView.mapAnnotationType = 0;
    }
    return _mapView;
}

- (MapLayerView *)mapLayerView{
    if (!_mapLayerView) {
        _mapLayerView = [[MapLayerView alloc] init];
        _mapLayerView.frame= CGRectMake(0, kHeight, kWidth, 680*DDHorizontalFlexibleRatio());
        _mapLayerView.hidden = YES;
    }
    return _mapLayerView;
}

- (WeatherView *)weatherView{
    if (!_weatherView) {
        _weatherView = [[WeatherView alloc] init];
        _weatherView.frame= CGRectMake(0, kHeight, kWidth, 600);
        _weatherView.hidden = YES;
    }
    return _weatherView;
}

// 在 viewWillAppear: 方法中隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
