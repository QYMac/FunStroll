//
//  MapSearchView.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "MapSearchView.h"
#import <Masonry/Masonry.h>

// 分类按钮
@interface MapSearchCategoryButton : UIButton

@property (nonatomic, strong) MapSearchCategory *category;

@end

@implementation MapSearchCategoryButton

@end

// 历史记录Cell
@interface MapSearchHistoryCell : UITableViewCell

@property (nonatomic, strong) UIImageView *searchImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) void(^deleteBlock)(void);

@end

@implementation MapSearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        [self.contentView addSubview:self.searchImg];
        [self.searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(35);
            make.right.equalTo(self.contentView).offset(-40);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(0);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(30);
        }];
        
        
        // 分割线
        [self.contentView addSubview:self.separator];
        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)deleteButtonTapped:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (UIImageView *)searchImg{
    if (!_searchImg) {
        _searchImg = [[UIImageView alloc] init];
        _searchImg.image = [UIImage imageNamed:@"search_E"];
    }
    return _searchImg;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"酒店";
    }
    return _titleLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        // 删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"remove_E"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIView *)separator{
    if (_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return _separator;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(8, 8) viewRect:CGRectMake(0, 0, kWidth - 20, 44)];
    }
    return _bgView;
}

@end

@implementation MapSearchCategory

+ (instancetype)categoryWithTitle:(NSString *)title iconImg:(UIImage *)iconImg categoryId:(NSString *)categoryId {
    MapSearchCategory *category = [[MapSearchCategory alloc] init];
    category.title = title;
    category.iconImg = iconImg;
    category.categoryId = categoryId;
    return category;
}

@end

@interface MapSearchView () <UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UIView *fgView;

/// 分类容器视图
@property (nonatomic, strong) UIView *categoryContainer;

/// 分类按钮数组
@property (nonatomic, strong) NSMutableArray<MapSearchCategoryButton *> *categoryButtons;

/// 历史记录容器视图
@property (nonatomic, strong) UIView *historyContainer;

/// 历史记录标题
@property (nonatomic, strong) UILabel *historyTitleLabel;

/// 清除历史记录按钮
@property (nonatomic, strong) UIButton *clearHistoryButton;

/// 清空按钮
@property (nonatomic, strong) UIButton *clearAllButton;

/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;

@property (strong,nonatomic) UIView *fgView1;

/// 历史记录列表
@property (nonatomic, strong) UITableView *historyTableView;

@end

@implementation MapSearchView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _categoryButtons = [NSMutableArray array];
        [self setupUI];
        [self setupDefaultCategories];
        [self searchList];
    }
    return self;
}

- (void)searchList{
    WeakSelf
    [FMDBManager searchExploreSearchListAndHandle:^(NSArray * _Nullable dataArray) {
        if (dataArray.count == 0) {
            weakSelf.historyTitleLabel.layer.cornerRadius = 8;
            weakSelf.historyTitleLabel.layer.masksToBounds = YES;
        } else {
            weakSelf.historyTitleLabel.layer.cornerRadius = 0;
            weakSelf.historyTitleLabel.layer.masksToBounds = YES;
        }
        weakSelf.historyItems = dataArray;
        [weakSelf.historyTableView reloadData];
    }];
}

#pragma mark - UI Setup

- (void)setupUI {
    // 添加分类容器;
    self.categoryContainer.frame = CGRectMake(0, 0, kWidth - 20, 160);
    [self addSubview:self.categoryContainer];
    /*
    [self.categoryContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(160); // 2行，每行80
    }];
     */
    
    [self.categoryContainer addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(8, 8)];
    
    // 添加历史记录容器
    self.historyContainer.layer.cornerRadius = 8;
    self.historyContainer.layer.masksToBounds = YES;
    [self addSubview:self.historyContainer];
    [self.historyContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryContainer.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(-bottomHeight);
    }];
    
    // 添加历史记录标题
    [self.historyContainer addSubview:self.historyTitleLabel];
    [self.historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 添加清除历史记录按钮
    [self.historyContainer addSubview:self.clearHistoryButton];
    [self.clearHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.historyContainer).offset(-15);
        make.centerY.equalTo(self.historyTitleLabel);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.historyContainer addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.equalTo(self.historyTitleLabel);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.historyContainer addSubview:self.fgView1];
    [self.fgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.doneButton.mas_left).offset(0);
        make.centerY.equalTo(self.historyTitleLabel);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
    }];
    
    [self.historyContainer addSubview:self.clearAllButton];
    [self.clearAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fgView1.mas_left).offset(0);
        make.centerY.equalTo(self.historyTitleLabel);
        make.width.height.mas_equalTo(40);
    }];
    
    // 添加历史记录列表
    [self.historyContainer addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.historyTitleLabel.mas_bottom).offset(0);
        make.left.right.equalTo(self.historyContainer);
        make.bottom.equalTo(self.historyContainer).offset(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self addSubview:self.fgView];
    [self.fgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self MJRefreshFooter];
}

- (void)MJRefreshFooter{
    
    if (self.historyTableView.mj_footer) {
        return;
    }
    
    // 上拉刷新
    WeakSelf
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.historyTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    [footer setTitle:@"-没有更多记录了-" forState:MJRefreshStateNoMoreData];
    self.historyTableView.mj_footer = footer;
    [self.historyTableView.mj_footer endRefreshingWithNoMoreData];

}

- (void)setupDefaultCategories {
    // 默认分类数据
    NSArray *defaultCategories = @[
        [MapSearchCategory categoryWithTitle:@"美食" iconImg:[UIImage imageNamed:@"icon_search1"] categoryId:@"food"],
        [MapSearchCategory categoryWithTitle:@"景点" iconImg:[UIImage imageNamed:@"icon_search2"] categoryId:@"attraction"],
        [MapSearchCategory categoryWithTitle:@"酒店" iconImg:[UIImage imageNamed:@"icon_search3"] categoryId:@"hotel"],
        [MapSearchCategory categoryWithTitle:@"休闲娱乐" iconImg:[UIImage imageNamed:@"icon_search4"] categoryId:@"entertainment"],
        [MapSearchCategory categoryWithTitle:@"停车场" iconImg:[UIImage imageNamed:@"icon_search5"] categoryId:@"parking"],
        [MapSearchCategory categoryWithTitle:@"广场" iconImg:[UIImage imageNamed:@"icon_search6"] categoryId:@"plaza"],
        [MapSearchCategory categoryWithTitle:@"超市" iconImg:[UIImage imageNamed:@"icon_search7"] categoryId:@"supermarket"],
        [MapSearchCategory categoryWithTitle:@"电影院" iconImg:[UIImage imageNamed:@"icon_search8"] categoryId:@"cinema"],
        [MapSearchCategory categoryWithTitle:@"公园" iconImg:[UIImage imageNamed:@"icon_search9"] categoryId:@"park"],
        [MapSearchCategory categoryWithTitle:@"洗手间" iconImg:[UIImage imageNamed:@"icon_search10"] categoryId:@"restroom"]
    ];
    
    self.categories = defaultCategories;
    [self reloadCategories];
}

- (void)reloadCategories {
    // 清除旧的分类按钮
    for (MapSearchCategoryButton *button in self.categoryButtons) {
        [button removeFromSuperview];
    }
    [self.categoryButtons removeAllObjects];
    
    if (!self.categories || self.categories.count == 0) {
        return;
    }
    
    NSInteger columns = 5; // 每行5个
    CGFloat buttonWidth = (kWidth - 20  - 30) / columns; // 左右各15pt间距
    CGFloat buttonHeight = 80;
    //CGFloat spacing = 0;
    
    for (NSInteger i = 0; i < self.categories.count; i++) {
        MapSearchCategory *category = self.categories[i];
        
        NSInteger row = i / columns;
        NSInteger col = i % columns;
        
        MapSearchCategoryButton *button = [MapSearchCategoryButton buttonWithType:UIButtonTypeCustom];
        button.category = category;
        button.backgroundColor = [UIColor whiteColor];
        
        // 图标色块
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.image = category.iconImg;
        [button addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(12);
            make.centerX.equalTo(button);
            make.width.height.mas_equalTo(40);
        }];
        
        // 标题标签
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = category.title;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImage.mas_bottom).offset(4);
            make.left.right.equalTo(button);
            make.bottom.equalTo(button).offset(-8);
        }];
        
        [button addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.categoryContainer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.categoryContainer).offset(15 + col * buttonWidth);
            make.top.equalTo(self.categoryContainer).offset(row * buttonHeight);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
        }];
        
        [self.categoryButtons addObject:button];
    }
}

#pragma mark - Lazy Loading

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc] init];
        _fgView.backgroundColor = RGB(238, 238, 238);
    }
    return _fgView;
}

- (UIView *)categoryContainer {
    if (!_categoryContainer) {
        _categoryContainer = [[UIView alloc] init];
        _categoryContainer.backgroundColor = [UIColor whiteColor];
    }
    return _categoryContainer;
}

- (UIView *)historyContainer {
    if (!_historyContainer) {
        _historyContainer = [[UIView alloc] init];
        _historyContainer.backgroundColor = [UIColor clearColor];
    }
    return _historyContainer;
}

- (UILabel *)historyTitleLabel {
    if (!_historyTitleLabel) {
        _historyTitleLabel = [[UILabel alloc] init];
        _historyTitleLabel.text = @"    历史记录";
        _historyTitleLabel.font = [UIFont systemFontOfSize:14];
        _historyTitleLabel.textColor = RGB(51, 51, 51);
        _historyTitleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _historyTitleLabel;
}

- (UIButton *)clearHistoryButton {
    if (!_clearHistoryButton) {
        _clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearHistoryButton setImage:[UIImage imageNamed:@"search_shanchu"] forState:UIControlStateNormal];
        [_clearHistoryButton addTarget:self action:@selector(clearHistoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearHistoryButton;
}

- (UITableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.backgroundColor = [UIColor clearColor];
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyTableView.showsVerticalScrollIndicator = YES;
        _historyTableView.estimatedRowHeight = 44;
        [_historyTableView registerClass:[MapSearchHistoryCell class] forCellReuseIdentifier:@"HistoryCell"];
    }
    return _historyTableView;
}

- (UIButton *)clearAllButton {
    if (!_clearAllButton) {
        _clearAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearAllButton setTitle:@"清空" forState:UIControlStateNormal];
        [_clearAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearAllButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_clearAllButton addTarget:self action:@selector(clearAllButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _clearAllButton.hidden = YES;
    }
    return _clearAllButton;
}


- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _doneButton.hidden = YES;
    }
    return _doneButton;
}

- (UIView *)fgView1{
    if (!_fgView1) {
        _fgView1 = [[UIView alloc] init];
        _fgView1.backgroundColor = RGB(238, 238, 238);
        _fgView1.hidden = YES;
    }
    return _fgView1;
}

#pragma mark - Actions

- (void)searchIconButtonTapped:(UIButton *)sender {
    
}

- (void)categoryButtonTapped:(MapSearchCategoryButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapSearchView:didSelectCategory:)]) {
        [self.delegate mapSearchView:self didSelectCategory:sender.category];
    }
}

- (void)clearHistoryButtonTapped:(UIButton *)sender {
    /*
    if ([self.delegate respondsToSelector:@selector(mapSearchViewDidClearHistory:)]) {
        [self.delegate mapSearchViewDidClearHistory:self];
    }
     */
    if (sender.selected == NO) {
        sender.selected = YES;
        sender.hidden = YES;
        self.doneButton.hidden = NO;
        self.fgView1.hidden = NO;
        self.clearAllButton.hidden = NO;
        [self.historyTableView reloadData];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(mapSearchView:textDidChange:)]) {
        [self.delegate mapSearchView:self textDidChange:textField.text];
    }
}

- (void)clearAllButtonTapped:(UIButton *)sender {
    // 清空所有历史记录
    WeakSelf
    [FMDBTool clearTableWithTab:kExploreSearchList andHandle:^(BOOL isSuccess) {
        [weakSelf searchList];
    }];
    
    /*
    if ([self.delegate respondsToSelector:@selector(mapSearchViewDidClearHistory:)]) {
        [self.delegate mapSearchViewDidClearHistory:self];
    }
     */
}

- (void)doneButtonTapped:(UIButton *)sender {
    // 退出编辑模式
    self.clearHistoryButton.selected = NO;
    self.clearHistoryButton.hidden = NO;
    self.doneButton.hidden = YES;
    self.fgView1.hidden = YES;
    self.clearAllButton.hidden = YES;
    [self.historyTableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(mapSearchView:didSearchWithText:)]) {
        [self.delegate mapSearchView:self didSearchWithText:textField.text];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(mapSearchViewDidBeginEditing:)]) {
        [self.delegate mapSearchViewDidBeginEditing:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MapSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];

    NSDictionary *dict = [self.historyItems objectAtIndexCheck:indexPath.row];
    cell.titleLabel.text = [CheckTool replaceNullValue:dict[@"searchText"]];
    
    if (self.clearHistoryButton.selected == NO) {
        cell.deleteButton.hidden = YES;
    } else {
        cell.deleteButton.hidden = NO;
    }
    
    WeakSelf
    cell.deleteBlock = ^{
        [FMDBManager deleteExploreSearchText:[CheckTool replaceNullValue:dict[@"searchText"]] andHandle:^(BOOL isSuccess) {
            [weakSelf searchList];
        }];
    };
    if (indexPath.row == self.historyItems.count - 1) {
        cell.bgView.hidden = NO;
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.bgView.hidden = YES;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.historyItems.count) {
        NSString *historyItem = self.historyItems[indexPath.row];
        
        /*
        if ([self.delegate respondsToSelector:@selector(mapSearchView:didSelectHistoryItem:)]) {
            [self.delegate mapSearchView:self didSelectHistoryItem:historyItem];
        }
         */
    }
}

#pragma mark - Public Methods

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
}

- (void)setCategories:(NSArray<MapSearchCategory *> *)categories {
    _categories = categories;
    [self reloadCategories];
}

- (void)reloadHistory {
    //[self.historyTableView reloadData];
    [self searchList];
}

@end

