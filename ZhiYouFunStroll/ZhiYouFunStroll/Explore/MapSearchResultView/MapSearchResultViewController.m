//
//  MapSearchResultViewController.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "MapSearchResultViewController.h"
#import "MapSearchResultCell.h"
#import "MapSearchResultItem.h"
#import "MapAddressView.h"
#import "MapLocationDetailView.h"
#import "RouteViewController.h"

@interface MapSearchResultViewController () <MAMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIGestureRecognizerDelegate, MapLocationDetailViewDelegate>

/// 地图视图
@property (nonatomic, strong) MapAddressView *mapView;

/// 定位按钮
@property (nonatomic,strong) UIButton *addressBut;

/// 搜索栏容器
@property (nonatomic, strong) UIView *searchBarContainer;

/// 返回按钮
@property (nonatomic, strong) UIButton *backButton;

/// 搜索关键词标签
@property (nonatomic,strong) UITextField *searcTextField;

/// 搜索按钮
@property (nonatomic, strong) UIButton *searchButton;

/// 提示文字标签
@property (nonatomic, strong) UITextView *tipLabel;

/// 结果容器视图
@property (nonatomic, strong) UIView *resultContainer;

/// 结果集合视图
@property (nonatomic, strong) UICollectionView *collectionView;

/// 结果数据源
@property (nonatomic, strong) NSArray<MapSearchResultItem *> *resultItems;

/// 搜索栏容器初始顶部约束
@property (nonatomic, strong) MASConstraint *searchBarContainerTopConstraint;

/// 搜索栏容器初始高度约束
@property (nonatomic, strong) MASConstraint *searchBarContainerHeightConstraint;

/// 是否已滑动到顶部
@property (nonatomic, assign) BOOL isScrolledToTop;

/// 当前搜索栏容器的顶部偏移量
@property (nonatomic, assign) CGFloat currentSearchBarTopOffset;

/// 背景视图（用于渐变效果）
@property (nonatomic, strong) UIView *backgroundView;

/// 搜索背景视图（用于渐变效果）
@property (nonatomic, strong) UIView *searchBackgroundView;

/// 地图列表详情信息
@property (nonatomic, strong) MapLocationDetailView *mapLocationDetailView;

@end

@implementation MapSearchResultViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self setupDefaultData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 更新搜索栏容器的初始位置（如果还没有设置）
    if (!self.isScrolledToTop && self.searchBarContainerTopConstraint) {
        CGFloat mapBottom = self.view.bounds.size.height * 0.5;
        self.currentSearchBarTopOffset = mapBottom;
        [self.searchBarContainerTopConstraint setOffset:mapBottom];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 恢复导航栏
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UI Setup

- (void)setupUI {
    
    // 添加地图视图
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.5);
    }];
    
    [self.view addSubview:self.addressBut];
    [self.addressBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(self.mapView.mas_bottom).offset(-50);
    }];
    
    if (self.isDetailView == YES) {
        [self.mapLocationDetailView configureWithName:@"深圳大梅沙阳光沙滩" operatingHours:@"周一至周五 09:00 - 24:00" distance:1 driveTime:25 address:@"广东省深圳市小梅沙2号停车场" imageUrls:@[@"",@"",@"",@"",@""]];
        [self.view addSubview:self.mapLocationDetailView];
        [self.mapLocationDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mapView.mas_bottom).offset(0);
            make.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(0);
        }];
        
        [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.mas_equalTo(-statusBarHeight - [self.mapLocationDetailView navigateButtonBottomHeight] - 10);
        }];
        return;
    }
    
    // 添加背景视图（占满整个父视图，初始隐藏）
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.backgroundView.alpha = 0; // 初始隐藏
    
    // 添加搜索栏容器
    [self.view addSubview:self.searchBarContainer];
    CGFloat mapBottom = self.view.bounds.size.height * 0.5;
    self.currentSearchBarTopOffset = mapBottom; // 保存初始偏移量
    [self.searchBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        // 初始位置：相对于 view 顶部，偏移量为地图底部位置
        self.searchBarContainerTopConstraint =
        make.top.equalTo(self.view).offset(mapBottom);
        make.left.right.equalTo(self.view);
        self.searchBarContainerHeightConstraint =
        make.height.mas_equalTo(85);
    }];
    
    [self.searchBarContainer addSubview:self.searchBackgroundView];
    
    // 初始状态：搜索栏容器在地图底部
    self.isScrolledToTop = NO;
    
    // 添加返回按钮
    [self.searchBarContainer addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarContainer).offset(5);
        make.centerY.equalTo(self.searchBarContainer).offset(-10);
        make.width.height.mas_equalTo(24);
    }];
    
    // 添加搜索按钮
    [self.searchBarContainer addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchBarContainer).offset(-5);
        make.centerY.equalTo(self.backButton);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(85);
    }];
    
    // 添加搜索关键词标签
    self.searcTextField.layer.cornerRadius = 15;
    self.searcTextField.layer.masksToBounds = YES;
    [self.searchBarContainer addSubview:self.searcTextField];
    [self.searcTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(5);
        make.centerY.equalTo(self.backButton);
        make.right.equalTo(self.searchButton.mas_left).offset(0);
        make.height.mas_equalTo(30);
    }];
    
    // 添加提示文字
    [self.searchBarContainer addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(20);
        make.left.equalTo(self.searchBarContainer).offset(10);
        make.right.equalTo(self.searchBarContainer).offset(-10);
    }];
    
    [self.searchBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.tipLabel.mas_top).offset(-10);
    }];
    self.searchBackgroundView.alpha = 0; // 初始隐藏
    
    // 添加结果容器
    [self.view addSubview:self.resultContainer];
    [self.resultContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBarContainer.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 添加集合视图
    [self.resultContainer addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.resultContainer);
    }];
    
    // 添加向上滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.searchBarContainer addGestureRecognizer:panGesture];
    
    // 添加向上滑动手势到结果容器
    UIPanGestureRecognizer *resultPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    resultPanGesture.delegate = self;
    [self.resultContainer addGestureRecognizer:resultPanGesture];
}

- (void)setupDefaultData {
    // 设置默认搜索关键词
    if (!self.searchKeyword || self.searchKeyword.length == 0) {
        self.searchKeyword = @"沙滩";
    }
    
    // 创建默认结果数据
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        MapSearchResultItem *item = [[MapSearchResultItem alloc] init];
        item.title = @"青甘大环线7天极限攻坚路线保证完美";
        item.subtitle = @"路线保证完美";
        item.distance = 200 + i * 50;
        item.walkTime = 20 + i * 2;
        [items addObject:item];
    }
    self.resultItems = [items copy];
    [self.collectionView reloadData];
}

#pragma mark - Lazy Loading

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.userInteractionEnabled = NO; // 不拦截触摸事件，不影响地图交互
    }
    return _backgroundView;
}

- (MapAddressView *)mapView{
    if (!_mapView) {
        _mapView = [[MapAddressView alloc] init];
        _mapView.mapAnnotationType = 0;
    }
    return _mapView;
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


- (UIView *)searchBarContainer {
    if (!_searchBarContainer) {
        _searchBarContainer = [[UIView alloc] init];
        _searchBarContainer.backgroundColor = RGB(250, 250, 250);
    }
    return _searchBarContainer;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UITextField *)searcTextField{
    if (!_searcTextField) {
        _searcTextField = [[UITextField alloc] init];
        _searcTextField.backgroundColor = RGB(244, 244, 244);
        _searcTextField.delegate = self;
        _searcTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入关键词" attributes:@{NSForegroundColorAttributeName:RGB(187, 187, 187),NSFontAttributeName:_searcTextField.font}];
        _searcTextField.attributedPlaceholder = attrString;
        _searcTextField.returnKeyType = UIReturnKeySearch;// 换行变搜索
        _searcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _searcTextField.leftViewMode = UITextFieldViewModeAlways;
        _searcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _searcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_searcTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _searcTextField;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UITextView *)tipLabel {
    if (!_tipLabel) {
        NSString *fullText = @"以下为当前屏幕结果,可切换到您的附近查找~";
        _tipLabel = [[UITextView alloc] init];
        _tipLabel.text = fullText;
        _tipLabel.editable = NO;          // 禁止编辑
        _tipLabel.scrollEnabled = NO;     // 禁止滚动
        _tipLabel.textContainerInset = UIEdgeInsetsZero; // 移除内边距
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        // 创建富文本
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
        
        // 创建段落样式
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;  // 设置居中

        // 应用到整个字符串范围
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle
                                 range:NSMakeRange(0, fullText.length)];
        
        // 设置整体样式
        [attributedString addAttributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:12],
            NSForegroundColorAttributeName: RGB(153, 153, 153)
        } range:NSMakeRange(0, fullText.length)];
        
        // 找到变色文字的范围
        NSRange protocolRange = [fullText rangeOfString:@"您的附近"];
        
        // 设置变色文字样式
        [attributedString addAttributes:@{
            NSForegroundColorAttributeName: RGB(58, 175, 6),
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
        } range:protocolRange];
        
        // 应用到 TextView
        _tipLabel.attributedText = attributedString;
        
        // 添加点击手势
        _tipLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
        [_tipLabel addGestureRecognizer:tapGesture];
    }
    return _tipLabel;
}

- (UIView *)searchBackgroundView {
    if (!_searchBackgroundView) {
        _searchBackgroundView = [[UIView alloc] init];
        _searchBackgroundView.backgroundColor = [UIColor whiteColor];
        _searchBackgroundView.userInteractionEnabled = NO;
    }
    return _searchBackgroundView;
}

- (UIView *)resultContainer {
    if (!_resultContainer) {
        _resultContainer = [[UIView alloc] init];
        _resultContainer.backgroundColor = RGB(250, 250, 250);
    }
    return _resultContainer;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 10, 5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(250, 250, 250);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO; // 初始状态：不允许滚动（在中间位置）
        [_collectionView registerClass:[MapSearchResultCell class] forCellWithReuseIdentifier:@"ResultCell"];
    }
    return _collectionView;
}

- (MapLocationDetailView *)mapLocationDetailView{
    if (!_mapLocationDetailView) {
        _mapLocationDetailView = [[MapLocationDetailView alloc] init];
        _mapLocationDetailView.delegate = self;
    }
    return _mapLocationDetailView;
}

#pragma mark - Actions

- (void)backButtonTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonTapped:(UIButton *)sender {
    NSLog(@"搜索按钮点击");
    // 这里可以添加搜索逻辑
}

- (void)addressButClick{
    [self.mapView moveToCurrentLocation];
}

- (void)textViewTapped:(UITapGestureRecognizer *)gesture {
    UITextView *textView = (UITextView *)gesture.view;
    // 获取点击位置
    CGPoint location = [gesture locationInView:textView];
    
    // 找到点击的字符位置
    UITextPosition *tapPosition = [textView closestPositionToPoint:location];
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition
                                                          withGranularity:UITextGranularityWord
                                                              inDirection:UITextLayoutDirectionRight];
    
    if (textRange) {
        NSInteger startIndex = [textView offsetFromPosition:textView.beginningOfDocument toPosition:textRange.start];
        
        NSString *fullText = textView.attributedText.string;
        
        // 判断点击了哪个部分
        NSRange protocolRange = [fullText rangeOfString:@"您的附近"];
        
        if (NSLocationInRange(startIndex, protocolRange)) {
            NSLog(@"点击了您的附近");
            [self.mapView moveToCurrentLocation];
        }
    }
}

#pragma mark - MapLocationDetailViewDelegate

- (void)mapLocationDetailViewDidTapRoute:(MapLocationDetailView *)detailView {
    RouteViewController *routeVC = [[RouteViewController alloc] init];
    routeVC.startName = @"我的位置";
    routeVC.endName = @"深圳大梅沙沙滩";
    // TODO: 设置实际坐标
    // routeVC.startCoordinate = self.mapView.userLocation.coordinate;
    // routeVC.endCoordinate = CLLocationCoordinate2DMake(lat, lng);
    [self.navigationController pushViewController:routeVC animated:YES];
}

- (void)mapLocationDetailViewDidTapNavigate:(MapLocationDetailView *)detailView {
    // TODO: 立即导航
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 当搜索栏容器在顶部时，允许列表滚动
    if ([gestureRecognizer.view isEqual:self.resultContainer] && [otherGestureRecognizer.view isEqual:self.collectionView]) {
        // 如果搜索栏容器在顶部，允许同时识别，让列表可以滚动
        if (self.isScrolledToTop) {
            return YES;
        }
    }
    // 如果搜索栏容器不在顶部，不允许列表滚动
    if ([otherGestureRecognizer.view isEqual:self.collectionView] && !self.isScrolledToTop) {
        return NO;
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果是结果容器的滑动手势，检查滑动方向
    if ([gestureRecognizer.view isEqual:self.resultContainer] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        
        // 如果搜索栏容器已经在顶部，允许列表滚动
        if (self.isScrolledToTop) {
            // 向上滑动：如果列表可以滚动，让列表滚动
            if (translation.y < 0) {
                // 检查列表是否还能向上滚动
                if (self.collectionView.contentOffset.y < (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
                    return NO; // 让列表滚动
                }
            }
            // 向下滑动：恢复中间位置
            if (translation.y > 0 && self.collectionView.contentOffset.y <= 0) {
                return YES;
            }
            return NO;
        }
        
        // 搜索栏容器不在顶部时
        // 向上滑动：优先响应，不管 collectionView 状态
        if (translation.y < 0) {
            return YES;
        }
        
        // 向下滑动：只有当列表在顶部时，才响应下滑手势（恢复中间位置）
        if (translation.y > 0 && self.collectionView.contentOffset.y <= 0) {
            return YES;
        }
        
        // 其他情况不响应
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 让 collectionView 的滚动手势在上滑手势失败后才响应
    if ([gestureRecognizer.view isEqual:self.resultContainer] && [otherGestureRecognizer.view isEqual:self.collectionView]) {
        return NO; // 不要求失败，优先响应上滑手势
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 让 collectionView 的滚动手势在上滑手势失败后才响应
    if ([gestureRecognizer.view isEqual:self.resultContainer] && [otherGestureRecognizer.view isEqual:self.collectionView]) {
        return YES; // 要求 collectionView 的滚动手势在上滑手势失败后才响应
    }
    return NO;
}

#pragma mark - Pan Gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    
    // 如果是结果容器的滑动手势，检查 collectionView 状态
    if ([gesture.view isEqual:self.resultContainer]) {
        // 向上滑动：优先响应，不管 collectionView 状态
        if (translation.y < 0) {
            // 继续处理上滑手势
        }
        // 向下滑动：只有当 collectionView 在顶部时才响应
        else if (translation.y > 0 && self.collectionView.contentOffset.y > 0) {
            // collectionView 不在顶部，不处理下滑手势，让 collectionView 滚动
            return;
        }
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            // 手势开始
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 手势进行中，实时更新位置
            CGFloat mapBottom = self.view.bounds.size.height * 0.5;
            CGFloat safeAreaTop = self.view.safeAreaInsets.top; // 安全区域顶部高度
            
            // 使用保存的偏移量计算新位置
            CGFloat newTop = self.currentSearchBarTopOffset + translation.y;
            
            // 限制滑动范围：从安全区域顶部到地图底部
            CGFloat minTop = safeAreaTop; // 顶部位置（安全区域顶部）
            CGFloat maxTop = mapBottom; // 初始位置（地图底部）
            
            if (newTop < minTop) {
                newTop = minTop;
            } else if (newTop > maxTop) {
                newTop = maxTop;
            }
            
            // 更新约束：相对于 view 顶部
            [self.searchBarContainerTopConstraint setOffset:newTop];
            
            // 更新保存的偏移量
            self.currentSearchBarTopOffset = newTop;
            
            // 更新背景视图透明度：根据位置计算，从透明渐变到白色
            CGFloat progress = 1.0 - (newTop - minTop) / (maxTop - minTop); // 0.0 在底部（透明），1.0 在顶部（白色）
            progress = MAX(0.0, MIN(1.0, progress)); // 限制在 0-1 之间
            self.backgroundView.alpha = progress;
            self.searchBackgroundView.alpha = progress;
            
            [gesture setTranslation:CGPointZero inView:self.view];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 手势结束，根据速度和位置决定最终状态
            CGFloat mapBottom = self.view.bounds.size.height * 0.5;
            CGFloat safeAreaTop = self.view.safeAreaInsets.top;
            CGFloat currentTop = self.currentSearchBarTopOffset;
            CGFloat threshold = (safeAreaTop + mapBottom) * 0.5; // 中间位置作为阈值
            
            BOOL shouldScrollToTop = NO;
            if (velocity.y < -500) {
                // 快速向上滑动，滑动到顶部（安全区域顶部）
                shouldScrollToTop = YES;
            } else if (velocity.y > 500) {
                // 快速向下滑动，恢复原位置（中间位置）
                shouldScrollToTop = NO;
            } else {
                // 根据当前位置决定
                shouldScrollToTop = currentTop < threshold;
            }
            
            [self scrollToTop:shouldScrollToTop animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)scrollToTop:(BOOL)toTop animated:(BOOL)animated {
    self.isScrolledToTop = toTop;
    
    CGFloat mapBottom = self.view.bounds.size.height * 0.5;
    CGFloat safeAreaTop = self.view.safeAreaInsets.top;
    CGFloat targetTop = toTop ? safeAreaTop : mapBottom; // 顶部是安全区域顶部，底部是地图底部
    
    // 更新保存的偏移量
    self.currentSearchBarTopOffset = targetTop;
    
    // 更新约束：相对于 view 顶部
    [self.searchBarContainerTopConstraint setOffset:targetTop];
    
    // 控制列表滚动：只有在顶部时才允许滚动
    self.collectionView.scrollEnabled = toTop;
    
    // 更新背景视图透明度
    CGFloat targetAlpha = toTop ? 1.0 : 0.0;
    
    if (animated) {
        WeakSelf
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf.view layoutIfNeeded];
            weakSelf.backgroundView.alpha = targetAlpha;
            weakSelf.searchBackgroundView.alpha = targetAlpha;
        } completion:nil];
    } else {
        [self.view layoutIfNeeded];
        self.backgroundView.alpha = targetAlpha;
        self.searchBackgroundView.alpha = targetAlpha;
    }
}

#pragma mark -UITextFieldDelegate
// 搜索框点击事件
- (void)textFieldDidChange:(UITextField *)textField{
    
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MapSearchResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];
    if (indexPath.item < self.resultItems.count) {
        MapSearchResultItem *item = self.resultItems[indexPath.item];
        [cell configureWithItem:item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.bounds.size.width - 15) / 2.0; // 2列，左右各12，中间12
    return CGSizeMake(width, 295);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item < self.resultItems.count) {
        MapSearchResultItem *item = self.resultItems[indexPath.item];
        NSLog(@"点击了结果: %@", item.title);
        // 这里可以添加跳转逻辑
        MapSearchResultViewController *navc = [[MapSearchResultViewController alloc] init];
        navc.isDetailView = YES;
        [self.navigationController pushViewController:navc animated:YES];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        // 更新用户位置
    }
}

@end

