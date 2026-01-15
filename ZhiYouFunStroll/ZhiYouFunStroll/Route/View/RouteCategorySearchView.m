//
//  RouteCategorySearchView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/14.
//

#import "RouteCategorySearchView.h"

@interface RouteCategorySearchView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *categoryContainer;
@property (nonatomic, strong) UIView *historyContainer;
@property (nonatomic, strong) UILabel *historyTitleLabel;
@property (nonatomic, strong) UIButton *clearHistoryButton;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) UILabel *noMoreLabel;
@property (nonatomic, strong) NSArray *categories;

@end

@implementation RouteCategorySearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(250, 250, 250);
        [self setupUI];
        [self loadHistory];
    }
    return self;
}

- (void)setupUI {
    // 分类容器
    self.categoryContainer = [[UIView alloc] init];
    self.categoryContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.categoryContainer];
    [self.categoryContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(165);
    }];
    
    // 设置默认分类
    [self setupDefaultCategories];
    
    // 历史记录容器
    self.historyContainer = [[UIView alloc] init];
    self.historyContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.historyContainer];
    [self.historyContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryContainer.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    // 历史记录标题
    self.historyTitleLabel = [[UILabel alloc] init];
    self.historyTitleLabel.text = @"历史记录";
    self.historyTitleLabel.font = [UIFont systemFontOfSize:14];
    self.historyTitleLabel.textColor = RGB(51, 51, 51);
    self.historyTitleLabel.backgroundColor = [UIColor whiteColor];
    [self.historyContainer addSubview:self.historyTitleLabel];
    [self.historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(44);
    }];
    
    // 清除历史记录按钮
    self.clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearHistoryButton setImage:[UIImage imageNamed:@"search_shanchu"] forState:UIControlStateNormal];
    [self.clearHistoryButton addTarget:self action:@selector(clearHistoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.historyContainer addSubview:self.clearHistoryButton];
    [self.clearHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.historyTitleLabel);
        make.width.height.mas_equalTo(20);
    }];
    
    // 历史记录列表
    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.backgroundColor = [UIColor whiteColor];
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.historyTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.historyTableView.rowHeight = 44;
    self.historyTableView.tableFooterView = [self createFooterView];
    [self.historyContainer addSubview:self.historyTableView];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.historyTitleLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomHeight);
    }];
}

- (UIView *)createFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    self.noMoreLabel = [[UILabel alloc] init];
    self.noMoreLabel.text = @"-没有更多记录了-";
    self.noMoreLabel.font = [UIFont systemFontOfSize:13];
    self.noMoreLabel.textColor = RGB(187, 187, 187);
    self.noMoreLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:self.noMoreLabel];
    [self.noMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    return footerView;
}

- (void)setupDefaultCategories {
    // 默认分类数据
    self.categories = @[
        @{@"title": @"美食", @"icon": @"icon_search1", @"categoryId": @"food"},
        @{@"title": @"景点", @"icon": @"icon_search2", @"categoryId": @"attraction"},
        @{@"title": @"酒店", @"icon": @"icon_search3", @"categoryId": @"hotel"},
        @{@"title": @"休闲娱乐", @"icon": @"icon_search4", @"categoryId": @"entertainment"},
        @{@"title": @"停车场", @"icon": @"icon_search5", @"categoryId": @"parking"},
        @{@"title": @"广场", @"icon": @"icon_search6", @"categoryId": @"plaza"},
        @{@"title": @"超市", @"icon": @"icon_search7", @"categoryId": @"supermarket"},
        @{@"title": @"电影院", @"icon": @"icon_search8", @"categoryId": @"cinema"},
        @{@"title": @"公园", @"icon": @"icon_search9", @"categoryId": @"park"},
        @{@"title": @"洗手间", @"icon": @"icon_search10", @"categoryId": @"restroom"}
    ];
    
    NSInteger columns = 5;
    CGFloat buttonWidth = (kWidth - 30) / columns;
    CGFloat buttonHeight = 80;
    
    for (NSInteger i = 0; i < self.categories.count; i++) {
        NSDictionary *category = self.categories[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger row = i / columns;
        NSInteger col = i % columns;
        CGFloat x = 15 + col * buttonWidth;
        CGFloat y = row * buttonHeight;
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        
        // 图标
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:category[@"icon"]];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
        }];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = category[@"title"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = RGB(51, 51, 51);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(iconView.mas_bottom).offset(5);
            make.left.right.mas_equalTo(0);
        }];
        
        [self.categoryContainer addSubview:button];
    }
}

- (void)loadHistory {
    WeakSelf
    [FMDBManager searchExploreSearchListAndHandle:^(NSArray * _Nullable dataArray) {
        weakSelf.historyItems = dataArray;
        [weakSelf.historyTableView reloadData];
    }];
}

#pragma mark - Public Methods
- (void)show {
    self.hidden = NO;
    [self loadHistory];
}

- (void)hide {
    self.hidden = YES;
}

- (void)reloadHistory {
    [self loadHistory];
}

#pragma mark - Actions
- (void)categoryButtonTapped:(UIButton *)sender {
    NSInteger index = sender.tag;
    if (index < self.categories.count) {
        NSDictionary *category = self.categories[index];
        if ([self.delegate respondsToSelector:@selector(categorySearchView:didSelectCategory:)]) {
            [self.delegate categorySearchView:self didSelectCategory:category];
        }
    }
}

- (void)clearHistoryButtonTapped {
    WeakSelf
    [FMDBTool clearTableWithTab:kExploreSearchList andHandle:^(BOOL isSuccess) {
        [weakSelf loadHistory];
        if ([weakSelf.delegate respondsToSelector:@selector(categorySearchViewDidClearHistory:)]) {
            [weakSelf.delegate categorySearchViewDidClearHistory:weakSelf];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"search_E"];
        searchIcon.tag = 100;
        [cell.contentView addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(15);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(35);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
        }];
    }
    
    NSDictionary *dict = self.historyItems[indexPath.row];
    UILabel *titleLabel = [cell.contentView viewWithTag:101];
    titleLabel.text = [CheckTool replaceNullValue:dict[@"searchText"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.historyItems.count) {
        NSDictionary *dict = self.historyItems[indexPath.row];
        NSString *text = [CheckTool replaceNullValue:dict[@"searchText"]];
        if ([self.delegate respondsToSelector:@selector(categorySearchView:didSelectHistoryItem:)]) {
            [self.delegate categorySearchView:self didSelectHistoryItem:text];
        }
    }
}

@end
