//
//  HomeViewDetailsController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/28.
//

#import "HomeViewDetailsController.h"
#import "HomeViewDetailsCell.h"
#import "CommentListController.h"
#import "AddCommentController.h"
#import "ImageTableViewCell.h"
#import "AddCommentTableViewCell.h"

@interface HomeViewDetailsController ()<UITableViewDelegate,UITableViewDataSource,XHInputViewDelagete>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *backBut;
@property (nonatomic,strong) UIImageView *userImage;
@property (nonatomic,strong) UILabel *usetNameL;
@property (nonatomic,strong) UIButton *userNameBut;
@property (nonatomic,strong) UIButton *moreBut;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *buttonBgView;
@property (nonatomic,strong) UIButton *addcommentBut;
@property (nonatomic,strong) UIButton *dianZanBut;
@property (nonatomic,strong) UIButton *pingLunBut;

@end

@implementation HomeViewDetailsController

- (void)setTitleText:(NSString *)titleText{
    self.navigationItem.title = [CheckTool replaceNullValue:titleText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    [self setupHomeViewDetailsUI];
}

- (void)setupHomeViewDetailsUI{
    
    [self.view addSubview:self.backBut];
    [self.backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusBarHeight);
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.moreBut];
    [self.moreBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBut.mas_top).offset(0);
        make.right.mas_equalTo(0);
        make.width.height.mas_equalTo(self.backBut.mas_height);
    }];
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@""]];
    self.userImage.layer.cornerRadius = 10;
    self.userImage.layer.masksToBounds = YES;
    [self.view addSubview:self.userImage];
    [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backBut);
        make.left.mas_equalTo(self.backBut.mas_right).offset(0);
        make.width.height.mas_equalTo(20);
    }];
    
    self.usetNameL.text = self.userNameText;
    [self.view addSubview:self.usetNameL];
    [self.usetNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backBut);
        make.left.mas_equalTo(self.userImage.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.moreBut.mas_left).offset(-5);
    }];
    
    [self.view addSubview:self.userNameBut];
    [self.userNameBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBut.mas_top).offset(0);
        make.left.mas_equalTo(self.backBut.mas_right).offset(5);
        make.height.mas_equalTo(self.backBut.mas_height);
        make.right.mas_equalTo(self.moreBut.mas_left).offset(-5);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(40 + statusBarHeight);
        make.bottom.mas_equalTo(-bottomHeight - 41);
    }];

    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomHeight + 40);
        make.bottom.mas_equalTo(0);
    }];
    
    self.buttonBgView.layer.cornerRadius = 32/2;
    self.buttonBgView.layer.masksToBounds = YES;
    [self.bgView addSubview:self.buttonBgView];
    [self.buttonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(4);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(230*DDVerticalFlexibleRatio());
    }];
    
    [self.buttonBgView addSubview:self.addcommentBut];
    [self.addcommentBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    [self.bgView addSubview:self.pingLunBut];
    [self.pingLunBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.addcommentBut.mas_top).offset(0);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(65);
    }];
    
    [self.bgView addSubview:self.dianZanBut];
    [self.dianZanBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.pingLunBut.mas_left).offset(0);
        make.top.mas_equalTo(self.addcommentBut.mas_top).offset(0);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(65);
    }];
}

#pragma mark - tableViewDelegate\UITableViewDataSource
// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ImageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        cell.dataArray = @[@"http://47.121.183.217:9000/zytech/c13754dab01849e9b8896948e368e4bd.jpg",@"http://47.121.183.217:9000/zytech/c13754dab01849e9b8896948e368e4bd.jpg",@"http://47.121.183.217:9000/zytech/c13754dab01849e9b8896948e368e4bd.jpg",@"http://47.121.183.217:9000/zytech/c13754dab01849e9b8896948e368e4bd.jpg"];
        return cell;
    } else if (indexPath.section == 1) {
        AddCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AddCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }

        return cell;
    } else {
        HomeViewDetailsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HomeViewDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        [cell setIndexPath:indexPath isAllList:NO];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 按钮点击
- (void)allListButClick:(UIButton *)sender{
    CommentListController *navc = [[CommentListController alloc]init];
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)backButClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButClick{
    
}

- (void)userNameButClick{
    
}

- (void)addcommentButClick{
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    [self showXHInputViewWithStyle:InputViewStyleLarge];
}

- (void)pingLunButClick{
    
}

- (void)dianZanButClick{
    
}


-(void)showXHInputViewWithStyle:(InputViewStyle)style{
    
    [XHInputView showWithStyle:style configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        /** 代理 */
        inputView.delegate = self;
        /** 占位符文字 */
        inputView.placeholder = @"说点什么...";
        /** 设置最大输入字数 */
        inputView.maxCount = 100000;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = RGB(244, 244, 244);
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            //NSLog(@"输入的信息为:%@",text);
            [self addText:text];
            return YES;//return YES,收起键盘
        }else{
            //NSLog(@"显示提示框-请输入要评论的的内容");
            [AlertWith showAlertWithMessageText:@"请输入评论内容"];
            return NO;//return NO,不收键盘
        }
    }];
    
}

- (void)addText:(NSString *)text{
    
}

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)backBut{
    if (!_backBut) {
        _backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBut setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBut addTarget:self action:@selector(backButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBut;
}

- (UIButton *)moreBut{
    if (!_moreBut) {
        _moreBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBut setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
        [_moreBut addTarget:self action:@selector(moreButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBut;
}

- (UIImageView *)userImage{
    if (!_userImage) {
        _userImage = [[UIImageView alloc]init];
        _userImage.backgroundColor = RGB(244, 244, 244);
        _userImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImage;
}

- (UILabel *)usetNameL{
    if (!_usetNameL) {
        _usetNameL = [[UILabel alloc]init];
        _usetNameL.textColor = [UIColor blackColor];
        _usetNameL.text = @"用户昵称";
        _usetNameL.font = [UIFont systemFontOfSize:14];
    }
    return _usetNameL;
}

- (UIButton *)userNameBut{
    if (!_userNameBut) {
        _userNameBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userNameBut addTarget:self action:@selector(userNameButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userNameBut;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)buttonBgView{
    if (!_buttonBgView) {
        _buttonBgView = [[UIView alloc] init];
        _buttonBgView.backgroundColor = RGB(244, 244, 244);
    }
    return _buttonBgView;
}

- (UIButton *)addcommentBut{
    if (!_addcommentBut) {
        _addcommentBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addcommentBut setImage:[UIImage imageNamed:@"home_xiePL"] forState:UIControlStateNormal];
        [_addcommentBut setTitle:@"说点什么..." forState:UIControlStateNormal];
        [_addcommentBut setTitleColor:RGB(182, 182, 182) forState:UIControlStateNormal];
        _addcommentBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_addcommentBut addTarget:self action:@selector(addcommentButClick) forControlEvents:UIControlEventTouchUpInside];
        _addcommentBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addcommentBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _addcommentBut;
}

- (UIButton *)pingLunBut{
    if (!_pingLunBut) {
        _pingLunBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pingLunBut setImage:[UIImage imageNamed:@"home_pingLun"] forState:UIControlStateNormal];
        [_pingLunBut setTitle:@"10" forState:UIControlStateNormal];
        [_pingLunBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _pingLunBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_pingLunBut addTarget:self action:@selector(pingLunButClick) forControlEvents:UIControlEventTouchUpInside];
        _pingLunBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_pingLunBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _pingLunBut;
}

- (UIButton *)dianZanBut{
    if (!_dianZanBut) {
        _dianZanBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dianZanBut setImage:[UIImage imageNamed:@"home_dsc"] forState:UIControlStateNormal];
        [_dianZanBut setTitle:@"10" forState:UIControlStateNormal];
        [_dianZanBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _dianZanBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_dianZanBut addTarget:self action:@selector(dianZanButClick) forControlEvents:UIControlEventTouchUpInside];
        _dianZanBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_dianZanBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _dianZanBut;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    /*
    UIImage * image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(dismissaBtu)];
    self.navigationItem.leftBarButtonItem = backButton;
     */

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dismissaBtu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
