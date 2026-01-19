//
//  CommunityCollectionViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/25.
//

#import "CommunityCollectionViewCell.h"
#import "AFNetworkingManage+Home.h"

@interface CommunityCollectionViewCell ()

@property (nonatomic,strong) HomeListRecordModel *dataModel;

@end

@implementation CommunityCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;
        //self.contentView.layer.borderWidth = 1;
        //self.contentView.layer.borderColor = RGB(240, 240, 240).CGColor;
        
        [self.contentView addSubview:self.homeImage];
        self.homeImage.layer.masksToBounds = YES;
        [self.homeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(self.homeImage.mas_width).multipliedBy(1.2);
        }];
        
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.homeImage.mas_bottom).offset(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        
        self.avatarImage.layer.cornerRadius = 25/2;
        self.avatarImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImage];
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(25);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(7.5);
            make.left.mas_equalTo(self.titleL.mas_left).offset(0);
        }];
        
    
        [self.contentView addSubview:self.likeBut];
        [self.likeBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(15);
            make.centerY.mas_equalTo(self.avatarImage);
            make.right.mas_equalTo(-10);
        }];
      
        [self.contentView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(self.avatarImage);
            make.left.mas_equalTo(self.avatarImage.mas_right).offset(5);
            make.right.mas_equalTo(self.likeBut.mas_left).offset(-5);
        }];
        
        /*
        [self.contentView addSubview:self.collectionBut];
        [self.collectionBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22.5);
            make.height.mas_equalTo(15);
            make.centerY.mas_equalTo(self.avatarImage);
            make.right.mas_equalTo(-10);
        }];
         */
        
        /*
        [self.contentView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.nameL.mas_bottom).offset(0);
            make.left.mas_equalTo(self.nameL.mas_left).offset(0);
            make.right.mas_equalTo(self.nameL.mas_right).offset(0);
        }];
         */
    }
    return self;
}

- (void)setModel:(HomeListRecordModel *)model{
    
    self.dataModel = model;
    
    NSString *titleStr = [CheckTool replaceNullValue:model.title];
    NSInteger num = [LabelSpacing needLinesWithWidth:self.frame.size.width textStr:titleStr font:12];
    // 最多两行
    if (num >= 2) {
        num = 2;
    }
    [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(num * 15);
    }];
    
    self.titleL.text = titleStr;
    NSString *coverImage = [CheckTool replaceNullValue:model.coverImage];
    [self.homeImage sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:[UIImage imageNamed:@""]];
    self.nameL.text = [CheckTool replaceNullValue:model.userNickname];
    
    NSString *likeCountStr = [DateHelper formatNumber:model.likeCount];
    [self.likeBut setTitle:likeCountStr forState:UIControlStateNormal];
    
    NSString *userAvatar = [CheckTool replaceNullValue:model.userAvatar];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:[UIImage imageNamed:@"touxiang_m"]];
    
    if (model.liked == YES) {
        self.likeBut.selected = YES;
        [self.likeBut setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
    } else {
        self.likeBut.selected = NO;
        [self.likeBut setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮点击
- (void)likeButClick:(UIButton *)sender{
    
    // 未登录不能点击
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    
    NSString *postId = [CheckTool replaceNullValue:self.dataModel.postId];
    [AFNetworkingManage homeLikePostId:postId success:^(id  _Nonnull responseObject) {
        
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        BOOL isLick = [dict[@"data"] intValue];
        
        NSInteger likeCount = self.dataModel.likeCount;
        
        if (isLick == YES) {
            likeCount += 1;
            [sender setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
        } else {
            likeCount -= 1;
            [sender setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
        }
        
        if (likeCount < 0) {
            likeCount = 0;
        }
        self.dataModel.likeCount = likeCount;
        NSString *likeCountStr = [DateHelper formatNumber:likeCount];
        [self.likeBut setTitle:likeCountStr forState:UIControlStateNormal];
        
    } failureHandler:^(NSError * _Nonnull error) {
        [AlertWith showAlertWithError:error];
    }];
}

- (void)collectionButClick:(UIButton *)sender{
    
    // 未登录不能点击
    if ([UserModel sharedUserModel].isAutoLogin == NO) {
        return;
    }
    
    NSString *postId = [CheckTool replaceNullValue:self.dataModel.postId];
    [AFNetworkingManage homeCollectPostId:postId success:^(id  _Nonnull responseObject) {
        
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        BOOL isCollection = [dict[@"data"] intValue];
        
        if (isCollection == YES) {
            sender.selected = YES;
            [sender setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateNormal];
        } else {
            sender.selected = NO;
            [sender setImage:[UIImage imageNamed:@"collection_off"] forState:UIControlStateNormal];
        }
        
    } failureHandler:^(NSError * _Nonnull error) {
        [AlertWith showAlertWithMessageText:[AFNetworkingErrorHelper getFriendlyErrorMessage:error]];
    }];
}


#pragma mark - 懒加载
- (UIImageView *)homeImage{
    if (!_homeImage) {
        _homeImage = [[UIImageView alloc]init];
        _homeImage.backgroundColor = RGB(240, 240, 240);

        _homeImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _homeImage;
}

- (UIImageView *)avatarImage{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.backgroundColor = RGB(240, 240, 240);
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImage;
}

- (TopLeftLabel *)titleL{
    if (!_titleL) {
        _titleL = [[TopLeftLabel alloc]init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.text = @"卡片标题";
        _titleL.numberOfLines = 2;
        _titleL.font = [UIFont systemFontOfSize:14];
    }
    return _titleL;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = [UIColor blackColor];
        _nameL.text = @"用户昵称";
        _nameL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _nameL;
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = RGB(173, 173, 173);
        _timeL.text = @"2025.11.26";
        _timeL.font = [UIFont systemFontOfSize:10];
    }
    return _timeL;
}

- (UIButton *)likeBut{
    if (!_likeBut) {
        _likeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBut setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
        [_likeBut setTitle:@"9999" forState:UIControlStateNormal];
        [_likeBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _likeBut.titleLabel.font = [UIFont systemFontOfSize:12];
        _likeBut.selected = NO;
        [_likeBut addTarget:self action:@selector(likeButClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_likeBut setImagePositionWithType:SSImagePositionTypeLeft spacing:2];
        
    }
    return _likeBut;
}

- (UIButton *)collectionBut{
    if (!_collectionBut) {
        _collectionBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBut setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateNormal];
        [_collectionBut setTitle:@"9999" forState:UIControlStateNormal];
        [_collectionBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _collectionBut.titleLabel.font = [UIFont systemFontOfSize:10];
        _collectionBut.selected = NO;
        [_collectionBut addTarget:self action:@selector(collectionButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_collectionBut setImagePositionWithType:SSImagePositionTypeLeft spacing:2];;
    }
    return _collectionBut;
}

@end
