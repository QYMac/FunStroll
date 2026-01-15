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
#import "AFNetworkingManage+Home.h"
#import "ResponseModel.h"
#import "CommentListModel.h"

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
@property (nonatomic,strong) ResponseModel *responseModel;
@property (nonatomic,strong) CommentListModel *commentListModel;

@property (nonatomic,strong) NSMutableArray *dataList; // 数据源
@property (nonatomic,assign) NSInteger current; // 分页
@property (nonatomic,assign) NSInteger size; // 列数


@end

@implementation HomeViewDetailsController

- (void)setTitleText:(NSString *)titleText{
    self.navigationItem.title = [CheckTool replaceNullValue:titleText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    self.current = 1;
    self.size = 20;
    [self AFNetworkingHomeDetails];
    [self setupHomeViewDetailsUI];
}

// 获取帖子详情数据
- (void)AFNetworkingHomeDetails{
    [ZSProgressHUD showHUDShowText:@"加载中..."];
    WeakSelf
    dispatch_group_t homeGetDetailsGroup = dispatch_group_create();
    dispatch_group_async(homeGetDetailsGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_enter(homeGetDetailsGroup);
        [AFNetworkingManage homeGetDetailsPostId:self.postId success:^(id  _Nonnull responseObject) {
            NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
            weakSelf.responseModel = [ResponseModel yy_modelWithJSON:dict];
            dispatch_group_leave(homeGetDetailsGroup);
        } failureHandler:^(NSError * _Nonnull error) {
            dispatch_group_leave(homeGetDetailsGroup);
        }];
        
        dispatch_group_enter(homeGetDetailsGroup);
        [weakSelf searchCommentListCurrent:weakSelf.current andHandle:^(BOOL isSuccess) {
            dispatch_group_leave(homeGetDetailsGroup);
        }];
        
        dispatch_group_notify(homeGetDetailsGroup, dispatch_get_main_queue(), ^{
            [ZSProgressHUD hideAllHUDAnimated:YES];
            [weakSelf.pingLunBut setTitle:[NSString stringWithFormat:@"%ld",weakSelf.commentListModel.total] forState:UIControlStateNormal];
            NSString *likeCountStr = [DateHelper formatNumber:weakSelf.responseModel.data.likeCount];
            [weakSelf.dianZanBut setTitle:likeCountStr forState:UIControlStateNormal];
            [weakSelf.tableView reloadData];
        });
        
    });
}

// 获取评论列表数据
- (void)searchCommentListCurrent:(NSInteger)current andHandle:(void (^ _Nullable)(BOOL isSuccess))handle{
    NSString *currentStr = [NSString stringWithFormat:@"%ld",current];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",self.size];
    WeakSelf
    [AFNetworkingManage homeGetDetailsCommentPostId:self.postId current:currentStr size:sizeStr sortType:@"" userId:@"" keyword:@"" success:^(id  _Nonnull responseObject) {
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        weakSelf.commentListModel = [CommentListModel yy_modelWithJSON:dict];
        if (weakSelf.commentListModel.records.count > 0) {
            [ArrayHelper addItemsToMutableArray:weakSelf.dataList newItems:weakSelf.commentListModel.records uniqueKey:@"commentId" sortKey:@"createTime"];
            if (weakSelf.dataList.count >= self.size) {
                [weakSelf MJRefreshFooter];
            }
        }
        if (handle) {
            handle(YES);
        }
    } failureHandler:^(NSError * _Nonnull error) {
        if (handle) {
            handle(NO);
        }
    }];
}

// 初始化UI
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

- (void)MJRefreshFooter{
    
    if (self.tableView.mj_footer) {
        return;
    }
    
    // 上拉刷新
    WeakSelf
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.current += 1;
        [weakSelf searchCommentListCurrent:weakSelf.current andHandle:^(BOOL isSuccess) {
            if (weakSelf.commentListModel.records.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;

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
        return self.commentListModel.records.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ImageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        cell.model = self.responseModel;
        
        return cell;
    } else if (indexPath.section == 1) {
        AddCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AddCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        cell.postId = [CheckTool replaceNullValue:self.postId];
        cell.imgURL = [CheckTool replaceNullValue:self.imageURL];
        cell.model = self.commentListModel;
        
        WeakSelf
        cell.addCommentClickBlcok = ^(NSString * _Nonnull addText, NSArray * _Nonnull images) {
            [weakSelf addText:addText images:images];
        };

        return cell;
    } else {
        HomeViewDetailsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HomeViewDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        cell.model = [self.commentListModel.records objectAtIndexCheck:indexPath.row];
        
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
        inputView.maxCount = 150;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = RGB(244, 244, 244);
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text,NSArray *images) {
        if(text.length){
            //NSLog(@"输入的信息为:%@",text);
            [self addText:text images:images];
            return YES;//return YES,收起键盘
        }else{
            //NSLog(@"显示提示框-请输入要评论的的内容");
            [AlertWith showAlertWithMessageText:@"请输入评论内容"];
            return NO;//return NO,不收键盘
        }
    }];
    
}

- (void)addText:(NSString *)text images:(NSArray *)images{
    if (images.count == 0 || images == nil) {
        images = @[];
    }
    WeakSelf
    NSString *content = [CheckTool replaceNullValue:text];
    [AFNetworkingManage homeAddCommentPostId:self.postId parentCommentId:@"" content:content resources:images success:^(id  _Nonnull responseObject) {
        //NSLog(@"%@",responseObject);
        [weakSelf searchCommentListCurrent:1 andHandle:^(BOOL isSuccess) {
            [weakSelf.tableView reloadData];
        }];
    } failureHandler:^(NSError * _Nonnull error) {
        [AlertWith showAlertWithMessageText:[AFNetworkingErrorHelper getFriendlyErrorMessage:error]];
    }];
}

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
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
        [_pingLunBut setTitle:@"0" forState:UIControlStateNormal];
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
        [_dianZanBut setTitle:@"0" forState:UIControlStateNormal];
        [_dianZanBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _dianZanBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_dianZanBut addTarget:self action:@selector(dianZanButClick) forControlEvents:UIControlEventTouchUpInside];
        _dianZanBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_dianZanBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _dianZanBut;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
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
