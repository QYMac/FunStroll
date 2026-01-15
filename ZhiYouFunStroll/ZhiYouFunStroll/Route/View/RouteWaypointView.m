//
//  RouteWaypointView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "RouteWaypointView.h"

@implementation RouteWaypointModel

@end

#pragma mark - RouteWaypointCell

@interface RouteWaypointCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *dragButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteBlock)(void);

- (void)configWithModel:(RouteWaypointModel *)model;

@end

@implementation RouteWaypointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.showsReorderControl = NO; // 隐藏编辑时的三横线重排序图标
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    
    // 删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"route_close"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.contentView).offset(-5);
        make.width.height.mas_equalTo(20);
    }];
    
    // 背景视图
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = RGB(247, 247, 247);
    self.bgView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-5);
        make.bottom.mas_equalTo(-5);
        make.top.mas_equalTo(0);
    }];
    

    
    // 圆点/序号容器（在 bgView 上）
    self.dotView = [[UIView alloc] init];
    self.dotView.layer.cornerRadius = 4;
    [self.bgView addSubview:self.dotView];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(8);
    }];
    
    // 序号标签（在 bgView 上）
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.font = [UIFont systemFontOfSize:8];
    self.indexLabel.textColor = RGB(102, 102, 102);
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.backgroundColor = RGB(227, 227, 227);
    self.indexLabel.layer.cornerRadius = 12/2;
    self.indexLabel.layer.masksToBounds = YES;
    self.indexLabel.hidden = YES;
    [self.bgView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.dotView);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(12);
    }];
    
    // 拖拽按钮（在 bgView 上）
    self.dragButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dragButton setImage:[UIImage imageNamed:@"route_drag"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.dragButton];
    [self.dragButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    
    // 名称输入框（在 bgView 上）
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.font = [UIFont systemFontOfSize:14];
    self.nameTextField.textColor = [UIColor blackColor];
    self.nameTextField.placeholder = @"请输入途经点";
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    [self.bgView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indexLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.dragButton.mas_left).offset(-5);
    }];
    
}

- (void)configWithModel:(RouteWaypointModel *)model {
    self.nameTextField.text = model.name;
    
    if (model.isStart) {
        // 起点
        self.dotView.hidden = NO;
        self.dotView.backgroundColor = RGB(145, 233, 80);
        self.dotView.layer.cornerRadius = 4;
        [self.dotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(8);
        }];
        self.indexLabel.hidden = YES;
        self.deleteButton.hidden = NO; // 起点也能删除
    } else if (model.isEnd) {
        // 终点
        self.dotView.hidden = NO;
        self.dotView.backgroundColor = RGB(255, 87, 87);
        self.dotView.layer.cornerRadius = 4;
        [self.dotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(8);
        }];
        self.indexLabel.hidden = YES;
        self.deleteButton.hidden = NO;
    } else {
        // 途经点
        self.dotView.hidden = YES;
        self.indexLabel.hidden = NO;
        self.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)model.index];
        self.deleteButton.hidden = NO;
    }
    
    // 起点终点可以拖拽但不能删除
    self.dragButton.hidden = NO;
}

- (void)deleteClicked {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

#pragma mark - RouteWaypointView

@interface RouteWaypointView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *addTipLabel;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSMutableArray<RouteWaypointModel *> *dataList;
@property (nonatomic, assign) NSInteger maxWaypoints;

// 当前编辑的 cell
@property (nonatomic, weak) RouteWaypointCell *editingCell;
@property (nonatomic, assign) NSInteger editingIndex;

@end

@implementation RouteWaypointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWaypoints = 8;
        self.dataList = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 0;
    // 底部阴影
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowOpacity = 0.1;
    self.containerView.layer.shadowRadius = 2;
    self.containerView.layer.masksToBounds = NO;
    [self insertSubview:self.containerView atIndex:1];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(24);
    }];
    
    // 列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:[RouteWaypointCell class] forCellReuseIdentifier:@"RouteWaypointCell"];
    [self.containerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backButton.mas_top).offset(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.backButton.mas_right).offset(10);
        make.height.mas_equalTo(120);
    }];
    
    // 长按拖拽排序手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    [self.tableView addGestureRecognizer:longPress];
    
    // 添加途经点按钮
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"route_add"] forState:UIControlStateNormal];
    [self.addButton setTitle:@"  添加途经点" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.addButton addTarget:self action:@selector(addWaypointClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.backButton.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    // 添加提示
    self.addTipLabel = [[UILabel alloc] init];
    self.addTipLabel.font = [UIFont systemFontOfSize:12];
    self.addTipLabel.textColor = RGB(153, 153, 153);
    [self.containerView addSubview:self.addTipLabel];
    [self.addTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self.addButton);
    }];
    
    // 完成按钮
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:RGB(58, 175, 6) forState:UIControlStateNormal];
    self.doneButton.backgroundColor = RGB(216, 246, 193);
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.doneButton.layer.cornerRadius = 25/2;
    [self.doneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.addButton);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    
    // 设置 containerView 的底部约束，基于 addButton 的底部
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.addButton.mas_bottom).offset(10);
    }];
    
    // 设置 self 的底部约束，等于 containerView 的底部
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.containerView.mas_bottom);
    }];
    
    // 点击背景关闭
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self updateAddTip];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 找到对应的 cell
    UIView *view = textField.superview;
    while (view && ![view isKindOfClass:[RouteWaypointCell class]]) {
        view = view.superview;
    }
    
    if ([view isKindOfClass:[RouteWaypointCell class]]) {
        self.editingCell = (RouteWaypointCell *)view;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.editingCell];
        if (indexPath) {
            self.editingIndex = indexPath.row;
        }
    }
    
    // 通知外部显示分类页
    if (self.inputDidBeginEditingBlock) {
        self.inputDidBeginEditingBlock();
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *text = textField.text;
    
    // 更新数据
    if (self.editingIndex >= 0 && self.editingIndex < self.dataList.count) {
        RouteWaypointModel *model = self.dataList[self.editingIndex];
        model.name = text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // 更新数据
    if (self.editingIndex < self.dataList.count) {
        RouteWaypointModel *model = self.dataList[self.editingIndex];
        model.name = textField.text;
    }
    
    // 通知外部显示搜索结果页
    if (textField.text.length > 0 && self.inputDidTapReturnBlock) {
        self.inputDidTapReturnBlock(textField.text);
    }
    return YES;
}

- (void)setStartName:(NSString *)startName endName:(NSString *)endName waypoints:(NSArray *)waypoints {
    [self.dataList removeAllObjects];
    
    // 起点
    RouteWaypointModel *startModel = [[RouteWaypointModel alloc] init];
    startModel.name = startName;
    startModel.isStart = YES;
    [self.dataList addObject:startModel];
    
    // 途经点
    NSInteger index = 1;
    for (NSDictionary *waypoint in waypoints) {
        RouteWaypointModel *model = [[RouteWaypointModel alloc] init];
        model.name = waypoint[@"name"];
        model.index = index++;
        [self.dataList addObject:model];
    }
    
    // 添加一个空的途经点输入框
    RouteWaypointModel *emptyModel = [[RouteWaypointModel alloc] init];
    emptyModel.name = @"";
    emptyModel.index = index;
    [self.dataList addObject:emptyModel];
    
    // 终点
    RouteWaypointModel *endModel = [[RouteWaypointModel alloc] init];
    endModel.name = endName;
    endModel.isEnd = YES;
    [self.dataList addObject:endModel];
    
    [self.tableView reloadData];
    [self updateTableViewHeight];
    [self updateAddTip];
}

- (void)updateTableViewHeight {
    CGFloat height = self.dataList.count * 40;
    if (self.dataList.count > 6) {
        height = 6 * 40;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)updateAddTip {
    NSInteger waypointCount = 0;
    for (RouteWaypointModel *model in self.dataList) {
        if (!model.isStart && !model.isEnd) {
            waypointCount++;
        }
    }
    NSInteger remaining = self.maxWaypoints - waypointCount; // +1 因为有一个空的输入框
    self.addTipLabel.text = [NSString stringWithFormat:@"您还可添加%ld个", (long)remaining];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteWaypointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteWaypointCell" forIndexPath:indexPath];
    RouteWaypointModel *model = self.dataList[indexPath.row];
    [cell configWithModel:model];
    
    // 设置 nameTextField 的 delegate
    cell.nameTextField.delegate = self;
    
    // 监听文本变化
    [cell.nameTextField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    WeakSelf
    cell.deleteBlock = ^{
        [weakSelf deleteWaypointAtIndex:indexPath.row];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // 起点和终点不能移动
    RouteWaypointModel *model = self.dataList[indexPath.row];
    return !model.isStart && !model.isEnd;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    RouteWaypointModel *model = self.dataList[sourceIndexPath.row];
    [self.dataList removeObjectAtIndex:sourceIndexPath.row];
    [self.dataList insertObject:model atIndex:destinationIndexPath.row];
    
    // 更新序号
    [self updateWaypointIndexes];
    [self.tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    // 不能移动到起点位置（第0行）或终点位置（最后一行）
    if (proposedDestinationIndexPath.row == 0) {
        return [NSIndexPath indexPathForRow:1 inSection:0];
    }
    if (proposedDestinationIndexPath.row == self.dataList.count - 1) {
        return [NSIndexPath indexPathForRow:self.dataList.count - 2 inSection:0];
    }
    return proposedDestinationIndexPath;
}

#pragma mark - Actions
- (void)deleteWaypointAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.dataList.count) return;
    
    // 至少保留起点和终点
    if (self.dataList.count <= 2) return;
    
    RouteWaypointModel *model = self.dataList[index];
    
    // 如果删除的是起点，下一个位置变成新起点
    if (model.isStart && index + 1 < self.dataList.count) {
        RouteWaypointModel *nextModel = self.dataList[index + 1];
        nextModel.isStart = YES;
        nextModel.index = 0;
    }
    
    [self.dataList removeObjectAtIndex:index];
    [self updateWaypointIndexes];
    [self.tableView reloadData];
    [self updateTableViewHeight];
    [self updateAddTip];
}

- (void)updateWaypointIndexes {
    NSInteger index = 1;
    for (RouteWaypointModel *model in self.dataList) {
        if (!model.isStart && !model.isEnd) {
            model.index = index++;
        }
    }
}

- (void)addWaypointClicked {
    // 回收键盘
    [self endEditing:YES];
    
    // 检查是否还能添加途经点
    NSInteger waypointCount = 0;
    for (RouteWaypointModel *model in self.dataList) {
        if (!model.isStart && !model.isEnd) {
            waypointCount++;
        }
    }
    
    if (waypointCount >= self.maxWaypoints) {
        return;
    }
    
    // 创建新的途经点
    RouteWaypointModel *newModel = [[RouteWaypointModel alloc] init];
    newModel.name = @"";
    newModel.index = waypointCount + 1;
    
    // 插入到终点之前
    NSInteger insertIndex = self.dataList.count - 1; // 终点的位置
    [self.dataList insertObject:newModel atIndex:insertIndex];
    
    // 更新序号
    [self updateWaypointIndexes];
    [self.tableView reloadData];
    [self updateTableViewHeight];
    [self updateAddTip];
    
    // 自动滚动到新添加的 cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:insertIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - 长按拖拽排序
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static NSIndexPath *sourceIndexPath = nil;
    static UIView *snapshotView = nil;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (!indexPath) return;
            
            // 回收键盘
            [self endEditing:YES];
            
            // 起点和终点不能移动
            RouteWaypointModel *model = self.dataList[indexPath.row];
            if (model.isStart || model.isEnd) return;
            
            sourceIndexPath = indexPath;
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            snapshotView = [cell snapshotViewAfterScreenUpdates:YES];
            snapshotView.frame = cell.frame;
            snapshotView.alpha = 0.9;
            snapshotView.layer.shadowColor = [UIColor blackColor].CGColor;
            snapshotView.layer.shadowOffset = CGSizeMake(0, 2);
            snapshotView.layer.shadowOpacity = 0.3;
            snapshotView.layer.shadowRadius = 4;
            [self.tableView addSubview:snapshotView];
            
            cell.hidden = YES;
            
            [UIView animateWithDuration:0.2 animations:^{
                snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
            }];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (!sourceIndexPath || !snapshotView) return;
            
            CGPoint center = snapshotView.center;
            center.y = location.y;
            snapshotView.center = center;
            
            if (indexPath && indexPath.row != sourceIndexPath.row) {
                // 不能移动到起点位置（第0行）或终点位置（最后一行）
                if (indexPath.row == 0 || indexPath.row == self.dataList.count - 1) {
                    return;
                }
                
                RouteWaypointModel *model = self.dataList[sourceIndexPath.row];
                [self.dataList removeObjectAtIndex:sourceIndexPath.row];
                [self.dataList insertObject:model atIndex:indexPath.row];
                
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (!sourceIndexPath || !snapshotView) return;
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            
            [UIView animateWithDuration:0.2 animations:^{
                snapshotView.transform = CGAffineTransformIdentity;
                snapshotView.frame = cell.frame;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [snapshotView removeFromSuperview];
                snapshotView = nil;
                sourceIndexPath = nil;
                
                [self updateWaypointIndexes];
                [self.tableView reloadData];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)backButtonClicked {
    // 回收键盘
    [self endEditing:YES];
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)doneClicked {
    // 回收键盘
    [self endEditing:YES];
    
    NSMutableArray *waypoints = [NSMutableArray array];
    for (RouteWaypointModel *model in self.dataList) {
        if (!model.isStart && !model.isEnd && ![model.name isEqualToString:@"请输入途经点"]) {
            [waypoints addObject:@{@"name": model.name}];
        }
    }
    
    if (self.doneBlock) {
        self.doneBlock(waypoints);
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(self.containerView.frame, point)) {
        if (self.closeBlock) {
            self.closeBlock();
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 如果点击的是 collectionView 或其子视图，不拦截
    UIView *touchView = touch.view;
    while (touchView) {
        if ([touchView isKindOfClass:[UICollectionView class]] || 
            [touchView isKindOfClass:[UICollectionViewCell class]]) {
            return NO;
        }
        touchView = touchView.superview;
    }
    return YES;
}

#pragma mark - 自动聚焦
- (void)focusFirstEmptyTextField {
    // 延迟一下，让 tableView 完成布局
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 找到第一个文字为空的 model
        NSInteger firstEmptyIndex = -1;
        for (NSInteger i = 0; i < self.dataList.count; i++) {
            RouteWaypointModel *model = self.dataList[i];
            if (model.name.length == 0 || [model.name isEqualToString:@"请输入起点"] || [model.name isEqualToString:@"请输入终点"] || [model.name isEqualToString:@"请输入途经点"]) {
                firstEmptyIndex = i;
                break;
            }
        }
        
        if (firstEmptyIndex >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstEmptyIndex inSection:0];
            RouteWaypointCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell && cell.nameTextField) {
                [cell.nameTextField becomeFirstResponder];
            }
        }
    });
}

#pragma mark - 公共方法
- (void)updateCurrentEditingText:(NSString *)text {
    // 更新当前编辑的输入框文本
    if (self.editingCell) {
        self.editingCell.nameTextField.text = text;
        
        // 更新数据
        if (self.editingIndex >= 0 && self.editingIndex < self.dataList.count) {
            RouteWaypointModel *model = self.dataList[self.editingIndex];
            model.name = text;
        }
    }
}

- (void)hideSearchViews {
    // 回收键盘
    [self endEditing:YES];
}

@end
