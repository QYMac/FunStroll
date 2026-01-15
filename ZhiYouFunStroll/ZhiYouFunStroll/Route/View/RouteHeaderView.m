//
//  RouteHeaderView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "RouteHeaderView.h"
#import "RouteWaypointView.h"

#pragma mark - RouteHeaderCell

@interface RouteHeaderCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UIView *dotView;         // 圆点
@property (nonatomic, strong) UITextField *textField;  // 输入框
@property (nonatomic, strong) UIView *lineView;        // 分割线
@property (nonatomic, assign) RouteInputType inputType;
@property (nonatomic, assign) NSInteger cellIndex;     // cell 索引（用于途经点）

@property (nonatomic, copy) void(^didBeginEditingBlock)(RouteInputType type, NSInteger index);
@property (nonatomic, copy) void(^didEndEditingBlock)(RouteInputType type, NSInteger index);
@property (nonatomic, copy) void(^didChangeTextBlock)(NSString *text, RouteInputType type, NSInteger index);
@property (nonatomic, copy) void(^didTapReturnBlock)(RouteInputType type, NSInteger index);

- (void)configWithType:(RouteInputType)type name:(NSString *)name index:(NSInteger)index isLast:(BOOL)isLast;

@end

@implementation RouteHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 圆点
    self.dotView = [[UIView alloc] init];
    self.dotView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.dotView];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(8);
    }];
    
    // 输入框
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.textColor = [UIColor blackColor];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dotView.mas_right).offset(12);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    // 分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB(229, 229, 229);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_left);
        make.right.mas_equalTo(self.textField.mas_right);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)configWithType:(RouteInputType)type name:(NSString *)name index:(NSInteger)index isLast:(BOOL)isLast {
    self.inputType = type;
    self.cellIndex = index;
    self.textField.text = name;
    self.lineView.hidden = isLast;
    
    // 设置圆点颜色和占位符
    if (type == RouteInputTypeStart) {
        self.dotView.backgroundColor = RGB(145, 233, 80);  // 绿色
        self.textField.placeholder = @"请输入起点";
    } else if (type == RouteInputTypeEnd) {
        self.dotView.backgroundColor = RGB(255, 87, 87);   // 红色
        self.textField.placeholder = @"请输入终点";
    } else {
        self.dotView.backgroundColor = RGB(100, 149, 237); // 蓝色途经点
        self.textField.placeholder = [NSString stringWithFormat:@"途经点%ld", (long)index];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didBeginEditingBlock) {
        self.didBeginEditingBlock(self.inputType, self.cellIndex);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock(self.inputType, self.cellIndex);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.didTapReturnBlock) {
        self.didTapReturnBlock(self.inputType, self.cellIndex);
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.didChangeTextBlock) {
        self.didChangeTextBlock(textField.text, self.inputType, self.cellIndex);
    }
}

@end

#pragma mark - RouteHeaderView

@interface RouteHeaderView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *waypointButton;
@property (nonatomic, strong) UIButton *routeEditButton;
@property (nonatomic, strong) NSMutableArray<RouteWaypointModel *> *dataList;
@property (nonatomic, strong, readwrite) UITextField *startTextField;
@property (nonatomic, strong, readwrite) UITextField *endTextField;

@end

@implementation RouteHeaderView

static CGFloat const kCellHeight = 35.0;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataList = [NSMutableArray array];
        [self setupUI];
        [self setupDefaultData];
    }
    return self;
}

- (void)setupDefaultData {
    // 默认只有起点和终点
    RouteWaypointModel *startModel = [[RouteWaypointModel alloc] init];
    startModel.name = self.startName ?: @"";
    startModel.isStart = YES;
    startModel.isEnd = NO;
    startModel.index = 0;
    
    RouteWaypointModel *endModel = [[RouteWaypointModel alloc] init];
    endModel.name = self.endName ?: @"";
    endModel.isStart = NO;
    endModel.isEnd = YES;
    endModel.index = 0;
    
    [self.dataList addObject:startModel];
    [self.dataList addObject:endModel];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 白色卡片背景
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = RGB(247, 247, 247);
    self.cardView.layer.cornerRadius = 8;
    self.cardView.clipsToBounds = YES;
    [self addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    // 路线修改按钮
    self.routeEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.routeEditButton setImage:[UIImage imageNamed:@"route_edit"] forState:UIControlStateNormal];
    [self.routeEditButton addTarget:self action:@selector(routeEditButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.routeEditButton];
    [self.routeEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(30); 
    }];
    
    // 途经点按钮
    self.waypointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.waypointButton setImage:[UIImage imageNamed:@"route_waypoint"] forState:UIControlStateNormal];
    [self.waypointButton addTarget:self action:@selector(waypointButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.waypointButton];
    [self.waypointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.routeEditButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(30);
    }];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[RouteHeaderCell class] forCellReuseIdentifier:@"RouteHeaderCell"];
    [self.cardView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.waypointButton.mas_left).offset(-5);
    }];
}

#pragma mark - Public Methods

- (void)setStartName:(NSString *)startName {
    _startName = startName;
    if (self.dataList.count > 0) {
        RouteWaypointModel *startModel = self.dataList.firstObject;
        if (startModel.isStart) {
            startModel.name = startName;
            [self.tableView reloadData];
        }
    }
}

- (void)setEndName:(NSString *)endName {
    _endName = endName;
    if (self.dataList.count > 0) {
        RouteWaypointModel *endModel = self.dataList.lastObject;
        if (endModel.isEnd) {
            endModel.name = endName;
            [self.tableView reloadData];
        }
    }
}

- (void)updateWithWaypoints:(NSArray<RouteWaypointModel *> *)waypoints {
    [self.dataList removeAllObjects];
    
    if (waypoints.count == 0) {
        // 无数据时使用默认的起点和终点
        [self setupDefaultData];
    } else {
        for (RouteWaypointModel *model in waypoints) {
            RouteWaypointModel *newModel = [[RouteWaypointModel alloc] init];
            newModel.name = model.name;
            newModel.isStart = model.isStart;
            newModel.isEnd = model.isEnd;
            newModel.index = model.index;
            [self.dataList addObject:newModel];
        }
        
        // 更新起点和终点名称
        for (RouteWaypointModel *model in self.dataList) {
            if (model.isStart) {
                _startName = model.name;
            } else if (model.isEnd) {
                _endName = model.name;
            }
        }
    }
    
    [self.tableView reloadData];
    [self updateHeight];
}

- (CGFloat)calculatedHeight {
    if (self.dataList.count > 5) {
        return 5 * kCellHeight;
    }
    return self.dataList.count * kCellHeight;
}

- (void)updateHeight {
    CGFloat newHeight = [self calculatedHeight];
    
    // 更新按钮高度
    [self.routeEditButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(newHeight);
    }];
    [self.waypointButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(newHeight);
    }];
    
    [self layoutIfNeeded];
    
    if (self.heightDidChangeBlock) {
        self.heightDidChangeBlock(newHeight);
    }
}

- (void)endEditing {
    [self.tableView endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteHeaderCell" forIndexPath:indexPath];
    
    RouteWaypointModel *model = self.dataList[indexPath.row];
    BOOL isLast = (indexPath.row == self.dataList.count - 1);
    
    RouteInputType type;
    NSInteger index = 0;
    
    if (model.isStart) {
        type = RouteInputTypeStart;
        // 保存起点输入框引用
        self.startTextField = cell.textField;
    } else if (model.isEnd) {
        type = RouteInputTypeEnd;
        // 保存终点输入框引用
        self.endTextField = cell.textField;
    } else {
        type = RouteInputTypeWaypoint;
        index = model.index;
    }
    
    [cell configWithType:type name:model.name index:index isLast:isLast];
    
    // 设置回调
    __weak typeof(self) weakSelf = self;
    cell.didBeginEditingBlock = ^(RouteInputType type, NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(headerView:didBeginEditingWithType:atIndex:)]) {
            [weakSelf.delegate headerView:weakSelf didBeginEditingWithType:type atIndex:index];
        }
    };
    
    cell.didEndEditingBlock = ^(RouteInputType type, NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(headerView:didEndEditingWithType:atIndex:)]) {
            [weakSelf.delegate headerView:weakSelf didEndEditingWithType:type atIndex:index];
        }
    };
    
    cell.didChangeTextBlock = ^(NSString *text, RouteInputType type, NSInteger index) {
        // 更新数据
        RouteWaypointModel *model = weakSelf.dataList[indexPath.row];
        model.name = text;
        
        if (model.isStart) {
            weakSelf.startName = text;
        } else if (model.isEnd) {
            weakSelf.endName = text;
        }
        
        if ([weakSelf.delegate respondsToSelector:@selector(headerView:didChangeText:withType:atIndex:)]) {
            [weakSelf.delegate headerView:weakSelf didChangeText:text withType:type atIndex:index];
        }
    };
    
    cell.didTapReturnBlock = ^(RouteInputType type, NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(headerView:didTapReturnWithType:atIndex:)]) {
            [weakSelf.delegate headerView:weakSelf didTapReturnWithType:type atIndex:index];
        }
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

#pragma mark - Actions

- (void)waypointButtonClicked {
    if (self.waypointButtonBlock) {
        self.waypointButtonBlock();
    }
}

- (void)routeEditButtonClicked {
    if (self.routeEditButtonBlock) {
        self.routeEditButtonBlock();
    }
}

@end
