//
//  LocalDraftViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "LocalDraftViewController.h"
#import "LocalDraftCell.h"
#import "GeneralWaterfallFlowLayout.h"

static NSString *const kLocalDraftCellID = @"LocalDraftCell";

@interface LocalDraftViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation LocalDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"本地草稿";
    
    [self setupNavigationBar];
    [self setupCollectionView];
    [self loadData];
}

- (void)setupNavigationBar {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setupCollectionView {
    GeneralWaterfallFlowLayout *layout = [[GeneralWaterfallFlowLayout alloc] init];
    layout.headerHeight = 0;
    layout.searcHeight = 0;
    layout.headerLabelHeight = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = RGB(250, 250, 250);
    self.collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self.collectionView registerClass:[LocalDraftCell class] forCellWithReuseIdentifier:kLocalDraftCellID];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)loadData {
    // 模拟数据
    self.dataList = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        NSDictionary *dict = @{
            @"id": @(i),
            @"coverUrl": @"https://picsum.photos/400/500",
            @"title": @"青甘大环线7天极限攻坚路线保证完美",
            @"date": @"9月12日 19:20"
        };
        [self.dataList addObject:dict];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteDraftAtIndex:(NSInteger)index {
    WeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定要删除这篇草稿吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dataList removeObjectAtIndex:index];
        [weakSelf.collectionView reloadData];
        // TODO: 从本地数据库删除
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LocalDraftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLocalDraftCellID forIndexPath:indexPath];
    
    NSDictionary *draftInfo = self.dataList[indexPath.item];
    [cell configureWithCoverUrl:draftInfo[@"coverUrl"]
                          title:draftInfo[@"title"]
                           date:draftInfo[@"date"]];
    
    WeakSelf
    cell.deleteBlock = ^{
        [weakSelf deleteDraftAtIndex:indexPath.item];
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *draftInfo = self.dataList[indexPath.item];
    NSLog(@"点击草稿: %@", draftInfo);
    // TODO: 跳转到编辑页面
}

#pragma mark - GeneralWaterfallFlowLayoutDelegate
- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    // 封面图高度 = 宽度 * 1.2
    CGFloat imageHeight = itemWidth * 1.2;
    // 标题高度（预估2行）
    CGFloat titleHeight = 40;
    // 日期高度
    CGFloat dateHeight = 20;
    // 间距
    CGFloat spacing = 25;
    
    return imageHeight + titleHeight + dateHeight + spacing;
}

- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(5, 5, tabBarHeight, 5);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 5;
}

#pragma mark - Navigation Bar
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
