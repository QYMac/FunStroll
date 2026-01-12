//
//  MineTabBarView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/11.
//

#import "MineTabBarView.h"

@interface MineTabBarView ()

@property (nonatomic, strong) UIButton *notesButton;
@property (nonatomic, strong) UIButton *likesButton;
@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSArray<UIButton *> *tabButtons;

@end

@implementation MineTabBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.currentTab = MineTabTypeNotes;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 笔记按钮 (无图标)
    self.notesButton = [self createTabButtonWithTitle:@"笔记" imageName:nil];
    self.notesButton.tag = MineTabTypeNotes;
    [self addSubview:self.notesButton];
    
    // 喜欢按钮 (带锁图标)
    self.likesButton = [self createTabButtonWithTitle:@"喜欢" imageName:@"xihuan_m"];
    self.likesButton.tag = MineTabTypeLikes;
    [self addSubview:self.likesButton];
    
    // 收藏按钮 (带锁图标)
    self.favoritesButton = [self createTabButtonWithTitle:@"收藏" imageName:@"xihuan_m"];
    self.favoritesButton.tag = MineTabTypeFavorites;
    [self addSubview:self.favoritesButton];
    
    self.tabButtons = @[self.notesButton, self.likesButton, self.favoritesButton];
    
    // 布局按钮 - 左对齐排列而非平均分布
    [self.notesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(30);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.likesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notesButton.mas_right).offset(20);
        make.width.mas_equalTo(60);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.favoritesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likesButton.mas_right).offset(20);
        make.width.mas_equalTo(60);
        make.top.bottom.mas_equalTo(0);
    }];
    
    // 指示器
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(30);
        make.centerX.mas_equalTo(self.notesButton);
    }];
    
    // 默认选中第一个
    [self selectTabAtIndex:0];
}

- (UIButton *)createTabButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (imageName.length > 0) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    
    [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Actions
- (void)tabButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag;
    [self selectTabAtIndex:index];
    
    if (self.tabChangedBlock) {
        self.tabChangedBlock((MineTabType)index);
    }
}

- (void)selectTabAtIndex:(NSInteger)index {
    self.currentTab = (MineTabType)index;
    
    // 更新按钮状态
    for (UIButton *button in self.tabButtons) {
        button.selected = (button.tag == index);
        if (button.selected) {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    // 动画移动指示器
    UIButton *selectedButton = self.tabButtons[index];
    [UIView animateWithDuration:0.25 animations:^{
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(30);
            make.centerX.mas_equalTo(selectedButton);
        }];
        [self layoutIfNeeded];
    }];
}

#pragma mark - Lazy Loading
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = RGB(76, 175, 80);  // 绿色指示器
        _indicatorView.layer.cornerRadius = 1.5;
    }
    return _indicatorView;
}

@end
