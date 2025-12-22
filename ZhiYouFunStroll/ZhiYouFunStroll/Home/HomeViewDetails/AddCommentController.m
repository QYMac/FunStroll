//
//  AddCommentController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import "AddCommentController.h"
#import "AddCommentCollectionCell.h"

@interface AddCommentController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *fgView;
@property (nonatomic,strong) UILabel *scoreL;
@property (nonatomic,strong) ServiceStarView *starsView;
@property (nonatomic,strong) UILabel *scoreMaxL;
@property (nonatomic,strong) UITextView *addMessage;
@property (nonatomic,strong) NSString *messageText;
@property (nonatomic,strong) UICollectionView *addImageCollectionView;
@property (nonatomic,strong) NSMutableArray *imgList;
@property (nonatomic,strong) UIButton *publishBut;

@end

@implementation AddCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.view.backgroundColor = RGB(240, 240, 240);
    [self setupCommentController];
}

- (void)setupCommentController{
    
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(400);
    }];
    
    [self.bgView addSubview:self.fgView];
    [self.fgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(49);
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView addSubview:self.scoreL];
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    self.starsView.selectable = YES;
    self.starsView.supportDecimal = NO;
    [self.bgView addSubview:self.starsView];
    [self.starsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.scoreL.mas_centerY).offset(1.5);
        make.left.mas_equalTo(self.scoreL.mas_right).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
    
    [self.bgView addSubview:self.scoreMaxL];
    [self.scoreMaxL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.scoreL);
        make.left.mas_equalTo(self.starsView.mas_left).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    _messageText = @"写出你的评价内容，可以分享交通，饮食，便捷，景色方面的内容帮助大家哦~";
    [self.bgView addSubview:self.addMessage];
    [self.addMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fgView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.right .mas_equalTo(-15);
        make.bottom.mas_equalTo(-100);
    }];
    
    [self.bgView addSubview:self.addImageCollectionView];
    [self.addImageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addMessage.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right .mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    
    self.publishBut.layer.cornerRadius = 35/2;
    self.publishBut.layer.masksToBounds = YES;
    [self.view addSubview:self.publishBut];
    [self.publishBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(50);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - UICollectionViewDataSource/UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgList.count + 1;
}
// 左右
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

// 上下
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier = [NSString stringWithFormat:@"AddCommentCollectionCell+%ld+%ld", (long)indexPath.section, (long)indexPath.row];
    [collectionView registerClass:[AddCommentCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    AddCommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell AddCommentIndexPath:indexPath imageList:_imgList];
    
    WeakSelf
    cell.addImgButtonBlcok = ^(NSMutableArray * _Nonnull addImageList) {
        [weakSelf reloadDataCellImagList:addImageList];
    };
    
    cell.removeImgButBlcok = ^(NSMutableArray * _Nonnull addImageList) {
        [weakSelf reloadDataCellImagList:addImageList];
    };
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80,80);
    
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

// 刷新cell
- (void)reloadDataCellImagList:(NSMutableArray *)imgArray{
    self.imgList = imgArray;
    [self.addImageCollectionView reloadData];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    NSInteger numbers = [textView.text length];
    if (numbers > 500) {
        textView.text = [textView.text substringToIndex:500];
        numbers = 500;
        [textView resignFirstResponder];
    }
    
    if (numbers > 0) {
        [self.publishBut setBackgroundImage:[UIImage imageNamed:@"home_PJ"] forState:UIControlStateNormal];
    } else {
        [self.publishBut setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.addMessage.text isEqualToString:_messageText]) {
        self.addMessage.text = nil;
        self.addMessage.textColor = [UIColor blackColor];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([self.addMessage.text isEqualToString:@""]) {
        self.addMessage.text = _messageText;
        self.addMessage.textColor = RGB(173, 173, 173);
    }
    return YES;
}

// 键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.addMessage resignFirstResponder];
}

#pragma mark - 点击事件
- (void)publishButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc]init];
        _fgView.backgroundColor = RGB(240, 240, 240);
    }
    return _fgView;
}

- (UILabel *)scoreL{
    if (!_scoreL) {
        _scoreL = [[UILabel alloc]init];
        _scoreL.text = @"总分";
        _scoreL.font = [UIFont systemFontOfSize:14];
        _scoreL.textColor = [UIColor blackColor];
    }
    return _scoreL;
}

- (UILabel *)scoreMaxL{
    if (!_scoreMaxL) {
        _scoreMaxL = [[UILabel alloc]init];
        _scoreMaxL.text = @"满意请给五星";
        _scoreMaxL.font = [UIFont systemFontOfSize:12];
        _scoreMaxL.textColor = RGB(173, 173, 173);
        _scoreMaxL.textAlignment = NSTextAlignmentRight;
    }
    return _scoreMaxL;
}

- (ServiceStarView *)starsView{
    if (!_starsView) {
        _starsView = [[ServiceStarView alloc] initWithStarSize:CGSizeMake(15, 15) space:5 numberOfStar:5];
        _starsView.score = 0.0;
    }
    return _starsView;
}

- (UITextView *)addMessage {
    if (!_addMessage) {
        _addMessage = [[UITextView alloc]init];
        _addMessage.delegate = self;
        _addMessage.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _addMessage.textContainer.lineFragmentPadding = 0;
        _addMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _addMessage.backgroundColor = [UIColor whiteColor];
        _addMessage.font = [UIFont systemFontOfSize:14];
        _addMessage.scrollEnabled = YES;
        _addMessage.text = _messageText;
        _addMessage.textColor = RGB(173, 173, 173);
        _addMessage.autocorrectionType = UITextAutocorrectionTypeNo;
        _addMessage.layoutManager.allowsNonContiguousLayout = NO;
        _addMessage.showsVerticalScrollIndicator = NO;
        _addMessage.showsHorizontalScrollIndicator = NO;
    }
    return _addMessage;
}

- (UICollectionView *)addImageCollectionView {
    if (!_addImageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.sectionInset = UIEdgeInsetsMake(0, 0,0, 0);//上左下右
        _addImageCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _addImageCollectionView.backgroundColor = [UIColor whiteColor];
        _addImageCollectionView.delegate = self;
        _addImageCollectionView.dataSource = self;
        _addImageCollectionView.allowsMultipleSelection = YES;
        _addImageCollectionView.showsVerticalScrollIndicator = NO;
        _addImageCollectionView.showsHorizontalScrollIndicator = NO;
        //这种是原生cell的注册
        //[_addImageCollectionView registerClass:[AddCommentCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _addImageCollectionView;
}


- (NSMutableArray *)imgList{
    if (!_imgList) {
        _imgList = [[NSMutableArray alloc]init];
    }
    return _imgList;
}

- (UIButton *)publishBut{
    if (!_publishBut) {
        _publishBut = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_publishBut setBackgroundImage:[UIImage imageNamed:@"home_PJ"] forState:UIControlStateNormal];
        [_publishBut setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishBut.titleLabel.font = [UIFont systemFontOfSize:14];
        _publishBut.backgroundColor = RGB(189, 189, 189);
        [_publishBut addTarget:self action:@selector(publishButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBut;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(dismissaBtu)];
    self.navigationItem.leftBarButtonItem = backButton;

}


- (void)dismissaBtu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
