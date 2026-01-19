//
//  HomeViewDetailsCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import "HomeViewDetailsCell.h"
#import "AddCommentController.h"

@interface HomeViewDetailsCell ()<KYPhotoBrowserControllerDelegate>

@property (nonatomic,strong) CommentItem *dataModel;

@end

@implementation HomeViewDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor clearColor];
        
        [self initEvaluationListView];
        
    }
    return self;
}

- (void)setModel:(CommentItem *)model{
    self.dataModel = model;
    
    NSString *userAvatar = [CheckTool replaceNullValue:model.userAvatar];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:[UIImage imageNamed:@"touxiang_m"]];
    self.nameL.text = [CheckTool replaceNullValue:model.userNickname];
    self.contentL.text = [CheckTool replaceNullValue:model.content];
    
    NSString *createTime = [CheckTool replaceNullValue:model.createTime];
    NSString *province = [[CheckTool replaceNullValue:model.province] stringByReplacingOccurrencesOfString:@"省" withString:@""];
    NSString *createTimeStr = [NSString stringWithFormat:@"%@  %@",[DateHelper relativeTimeString:createTime],province];
    self.timeL.text = [CheckTool replaceNullValue:createTimeStr];
    NSString *likesNumber = [NSString stringWithFormat:@"%ld",model.likesNumber];
    [self.likeBut setTitle:[CheckTool replaceNullValue:likesNumber] forState:UIControlStateNormal];
    if (model.liked == YES) {
        [self.likeBut setImage:[UIImage imageNamed:@"home_dianZan_off"] forState:UIControlStateNormal];
    } else {
        [self.likeBut setImage:[UIImage imageNamed:@"home_dianZan"] forState:UIControlStateNormal];
    }
    
    //[self.contentL layoutIfNeeded];
    
    [self.imgList removeAllObjects];
    NSArray *resources = model.resources;
    for (NSDictionary *dict in resources) {
        NSString *resourceUrl = [CheckTool replaceNullValue:dict[@"resourceUrl"]];
        [self.imgList addObject:resourceUrl];
    }
    
    [self.contentL layoutIfNeeded];
    CGFloat tagImgX = 15 + 32 + 15;
    CGFloat contentImgWidth = (kWidth - 15 - 32 - 15 - 35)/3;
    CGFloat tagImgY = 75 + self.contentL.frame.size.height;
    if ([CheckTool replaceNullValue:model.content].length != 0) {
        tagImgY = 72.5 + self.contentL.frame.size.height;
    }
    for (int i = 0; i < self.imgList.count; i++) {
        if (tagImgX + contentImgWidth > kWidth) {
            tagImgX = 15 + 32 + 15;
            tagImgY += (contentImgWidth+10);
        }
        _contentImg = [[UIImageView alloc] init];
        _contentImg.backgroundColor = RGB(240, 240, 240);
        _contentImg.frame  = CGRectMake(tagImgX, tagImgY, contentImgWidth, contentImgWidth);
        NSString *imgURL = [CheckTool replaceNullValue:[self.imgList objectAtIndexCheck:i]];
        _contentImg.tag = i;
        _contentImg.userInteractionEnabled = YES;
        [_contentImg sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@""]];
        _contentImg.contentMode = UIViewContentModeScaleAspectFill;
        _contentImg.layer.cornerRadius = 0;
        _contentImg.layer.masksToBounds = YES;
        // 添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(imageViewTapped:)];
        [_contentImg addGestureRecognizer:tapGesture];
        [self.towBgOneView addSubview:_contentImg];
        
        tagImgX = CGRectGetMaxX(_contentImg.frame)+10;
        
    }
    if (_contentImg) {
        [self.towBgOneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_contentImg.mas_bottom).offset(10);
        }];
    } else {
        [self.towBgOneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.timeL.mas_bottom).offset(10);
        }];
    }
}


// 初始化UI
- (void)initEvaluationListView{
    [self.contentView addSubview:self.towBgOneView];
    [self.towBgOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    self.avatarImage.layer.cornerRadius = 32/2;
    self.avatarImage.layer.masksToBounds = YES;
    [self.towBgOneView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(32);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    [self.towBgOneView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.avatarImage.mas_top).offset(0);
        make.left.mas_equalTo(self.avatarImage.mas_right).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.towBgOneView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL.mas_left).offset(0);
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(5);
        make.right.mas_equalTo(self.nameL.mas_right).offset(0);
    }];
    
    
    [self.towBgOneView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentL.mas_left).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.towBgOneView addSubview:self.likeBut];
    [self.likeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.timeL);
        make.right.mas_equalTo(-15);
    }];
    
    [self.towBgOneView addSubview:self.replyBut];
    [self.replyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.timeL);
        make.left.mas_equalTo(self.timeL.mas_right).offset(-5);
    }];
    
}

#pragma mark - 按钮点击事件
- (void)evaluationButClick:(UIButton *)sender{
    AddCommentController *navc = [[AddCommentController alloc]init];
    [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
}

// 点赞
- (void)likeButClick:(UIButton *)sender{
    
    // 未登录不能点击
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    
    WeakSelf
    NSString *commentId = [CheckTool replaceNullValue:self.dataModel.commentId];
    [AFNetworkingManage homeToggleCommentLikeCommentId:commentId success:^(id  _Nonnull responseObject) {
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        if ([dict[@"data"] intValue] == 1) {
            weakSelf.dataModel.liked = YES;
            weakSelf.dataModel.likesNumber += 1;
            [sender setImage:[UIImage imageNamed:@"home_dianZan_off"] forState:UIControlStateNormal];
        } else {
            weakSelf.dataModel.liked = NO;
            weakSelf.dataModel.likesNumber -= 1;
            [sender setImage:[UIImage imageNamed:@"home_dianZan"] forState:UIControlStateNormal];
        }
        if (weakSelf.dataModel.likesNumber < 0) {
            weakSelf.dataModel.likesNumber = 0;
        }
        NSString *likesNumber = [NSString stringWithFormat:@"%ld",weakSelf.dataModel.likesNumber];
        [sender setTitle:[CheckTool replaceNullValue:likesNumber] forState:UIControlStateNormal];
    } failureHandler:^(NSError * _Nonnull error) {
        [AlertWith showAlertWithError:error];
    }];
}

- (void)numButClick:(UIButton *)sender{
    
}

- (void)replyButClick{
    
}

// 点击事件处理方法
- (void)imageViewTapped:(UITapGestureRecognizer *)gesture {
    NSLog(@"图片被点击了");
    
    // 获取被点击的 imageView
    UIImageView *tappedImageView = (UIImageView *)gesture.view;
    [KYPhotoBrowserController showPhotoBrowserWithImages:self.imgList currentImageIndex:tappedImageView.tag delegate:self];
    
}

#pragma mark - 懒加载
- (UIView *)towBgOneView{
    if (!_towBgOneView) {
        _towBgOneView = [[UIView alloc]init];
        _towBgOneView.backgroundColor = [UIColor whiteColor];
    }
    return _towBgOneView;
}

- (UIImageView *)avatarImage{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.backgroundColor = RGB(240, 240, 240);
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImage;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = RGB(182, 182, 182);
        _nameL.text = @"用户昵称";
        _nameL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _nameL;
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = RGB(153, 153, 153);
        _timeL.text = @"1小时前 广东";
        _timeL.font = [UIFont systemFontOfSize:12];
    }
    return _timeL;
}

- (UIButton *)likeBut{
    if (!_likeBut) {
        _likeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBut setImage:[UIImage imageNamed:@"home_dianZan"] forState:UIControlStateNormal];
        _likeBut.selected = NO;
        [_likeBut setTitle:@"3000" forState:UIControlStateNormal];
        [_likeBut addTarget:self action:@selector(likeButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _likeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _likeBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _likeBut;
}

- (UIButton *)numBut{
    if (!_numBut) {
        _numBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numBut setImage:[UIImage imageNamed:@"home_num"] forState:UIControlStateNormal];
        [_numBut setTitle:@"3000" forState:UIControlStateNormal];
        [_numBut setTitleColor:RGB(173, 173, 173) forState:UIControlStateNormal];
        _numBut.titleLabel.font = [UIFont systemFontOfSize:10];
        _numBut.selected = NO;
        [_numBut addTarget:self action:@selector(numButClick:) forControlEvents:UIControlEventTouchUpInside];
        _numBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_numBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _numBut;
}

- (UIButton *)replyBut{
    if (!_replyBut) {
        _replyBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyBut setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBut setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _replyBut.titleLabel.font = [UIFont systemFontOfSize:12];
        [_replyBut addTarget:self action:@selector(replyButClick) forControlEvents:UIControlEventTouchUpInside];
        _replyBut.hidden = YES;
    }
    return _replyBut;
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.text = @"非常有意思的景点，非常推荐";
        _contentL.font = [UIFont systemFontOfSize:12];
        _contentL.textColor = RGB(51, 51, 51);
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

- (NSMutableArray *)imgList{
    if (!_imgList) {
        _imgList = [[NSMutableArray alloc] init];
    }
    return _imgList;
}

@end
