//
//  LocalDraftViewController.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "LocalDraftViewController.h"
#import "LocalDraftCell.h"
#import "GeneralWaterfallFlowLayout.h"
#import "FMDBManager.h"
#import "PublishNoteViewController.h"

static NSString *const kLocalDraftCellID = @"LocalDraftCell";

@interface LocalDraftViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation LocalDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(250, 250, 250);
    self.title = @"本地草稿";
    
    [self setupNavigationBar];
    [self setupCollectionView];
    [self setupEmptyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 每次进入页面重新加载草稿
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

- (void)setupEmptyView {
    self.emptyLabel = [[UILabel alloc] init];
    self.emptyLabel.text = @"暂无草稿";
    self.emptyLabel.font = [UIFont systemFontOfSize:16];
    self.emptyLabel.textColor = RGB(187, 187, 187);
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.hidden = YES;
    [self.view addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)loadData {
    WeakSelf
    [FMDBManager searchDraftListAndHandle:^(NSArray * _Nullable dataArray) {
        weakSelf.dataList = [NSMutableArray array];
        if (dataArray && dataArray.count > 0) {
            [weakSelf.dataList addObjectsFromArray:dataArray];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            weakSelf.emptyLabel.hidden = weakSelf.dataList.count > 0;
        });
    }];
}

#pragma mark - Actions
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteDraftAtIndex:(NSInteger)index {
    if (index >= self.dataList.count) return;
    
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
        NSDictionary *draftDict = weakSelf.dataList[index];
        NSString *draftId = [CheckTool replaceNullValue:draftDict[@"draftId"]];
        
        // 从本地数据库删除
        [FMDBManager deleteDraftWithDraftId:draftId andHandle:^(BOOL isSuccess) {
            if (isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.dataList removeObjectAtIndex:index];
                    [weakSelf.collectionView reloadData];
                    weakSelf.emptyLabel.hidden = weakSelf.dataList.count > 0;
                });
            } else {
                [AlertWith showAlertWithMessageText:@"删除失败"];
            }
        }];
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
    
    if (indexPath.item < self.dataList.count) {
        NSDictionary *draftDict = self.dataList[indexPath.item];
        [cell configureWithDraftDict:draftDict];
        
        WeakSelf
        cell.deleteBlock = ^{
            [weakSelf deleteDraftAtIndex:indexPath.item];
        };
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.dataList.count) return;
    
    NSDictionary *draftDict = self.dataList[indexPath.item];
    
    // 跳转到编辑页面
    PublishNoteViewController *publishVC = [[PublishNoteViewController alloc] init];
    publishVC.draftDict = draftDict;
    [self.navigationController pushViewController:publishVC animated:YES];
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

@end
