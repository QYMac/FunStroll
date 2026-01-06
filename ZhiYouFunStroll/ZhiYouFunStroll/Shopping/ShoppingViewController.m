//
//  ShoppingViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/24.
//

#import "ShoppingViewController.h"
#import "ShoppingCollectionViewCell.h"
#import "ShoppingDetailsController.h"

@interface ShoppingViewController ()<GeneralWaterfallFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *shopCollectionView;

@property (nonatomic,strong) UITextField *searcTextField;

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupShoppingUI];
}

- (void)setupShoppingUI{
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    searchImage.image = [UIImage imageNamed:@"search_home"];
    [self.searcTextField addSubview:searchImage];
    self.searcTextField.layer.cornerRadius = 6;
    self.searcTextField.layer.masksToBounds = YES;
    self.searcTextField.layer.borderColor = RGB(181, 181, 181).CGColor;
    self.searcTextField.layer.borderWidth = 1;
    self.searcTextField.frame = CGRectMake(20, 10, kWidth - 40, 40);
    self.navigationItem.titleView = self.searcTextField;
    
    [self.view addSubview:self.shopCollectionView];
    [self.shopCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    
    // 刷新数据
    [self cartoonContentRefresh];
    //[self MJRefreshFooter];
}

#pragma mark - 刷新控件
- (void)cartoonContentRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    [header setTitle:@"正在请求数据 ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    //header.stateLabel.textColor = YRGB;
    //header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    //马上进入刷新状态
    //[header beginRefreshing];
    // 设置刷新控件
    self.shopCollectionView.mj_header = header;
}

- (void)MJRefreshFooter{
    // 上拉刷新
    self.shopCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //停止下拉刷新
        [self.shopCollectionView.mj_header endRefreshing];
        [self.shopCollectionView.mj_footer endRefreshing];
    }];
}

// 下拉加载更多数据
- (void)loadMoreData
{
    //停止下拉刷新
    [self.shopCollectionView.mj_header endRefreshing];
    [self.shopCollectionView.mj_footer endRefreshing];
}


#pragma mark - <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShoppingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.shoppingImage.image = [UIImage imageNamed:@"home1"];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingDetailsController *navc = [[ShoppingDetailsController alloc]init];
    [self.navigationController pushViewController:navc animated:YES];
}

#pragma mark - <GeneralWaterfallFlowLayoutDelegate>
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return 190;
}

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    
    return UIEdgeInsetsMake(10, 10, tabBarHeight + 10, 10);
}


#pragma mark - 键盘相关

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

// 回收键盘
- (void)searcTextFieldResignFirstResponder{
    [self.searcTextField resignFirstResponder];
}


#pragma mark - 懒加载

- (UITextField *)searcTextField{
    if (!_searcTextField) {
        _searcTextField = [[UITextField alloc] init];
        _searcTextField.layer.cornerRadius = 6;
        _searcTextField.layer.masksToBounds = YES;
        _searcTextField.backgroundColor = [UIColor whiteColor];
        _searcTextField.delegate = self;
        _searcTextField.font = [UIFont systemFontOfSize:14];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入主题～" attributes:@{NSForegroundColorAttributeName:RGB(173, 173, 173),NSFontAttributeName:_searcTextField.font}];
        _searcTextField.attributedPlaceholder = attrString;
        _searcTextField.returnKeyType = UIReturnKeySearch;// 换行变搜索
        _searcTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
        _searcTextField.leftViewMode = UITextFieldViewModeAlways;
        _searcTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _searcTextField.rightViewMode = UITextFieldViewModeAlways;
        [_searcTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        //[_searcTextField.keyboardToolbar.doneBarButton setTarget:self action:@selector(doneActionDoneAction)];
    }
    
    return _searcTextField;
}

- (UICollectionView *)shopCollectionView {
    if (!_shopCollectionView) {
        GeneralWaterfallFlowLayout *layout = [[GeneralWaterfallFlowLayout alloc] init];
        _shopCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _shopCollectionView.delegate = self;
        _shopCollectionView.dataSource = self;
        _shopCollectionView.showsVerticalScrollIndicator = NO;
        _shopCollectionView.showsHorizontalScrollIndicator = NO;
        [_shopCollectionView registerClass:[ShoppingCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _shopCollectionView.backgroundColor = RGB(231, 231, 231);
    }
    return _shopCollectionView;
}


@end
