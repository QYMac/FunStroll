//
//  CommunityCollectionViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/25.
//

#import "CommunityCollectionViewCell.h"

@implementation CommunityCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = RGB(240, 240, 240).CGColor;
        
        self.avatarImage.layer.cornerRadius = 20;
        self.avatarImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImage];
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(40);
            make.bottom.mas_equalTo(-12.5);
            make.left.mas_equalTo(10);
        }];
        
        [self.contentView addSubview:self.titleL];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.avatarImage.mas_top).offset(-10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        
        [self.contentView addSubview:self.homeImage];
        [self.homeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.titleL.mas_top).offset(-10);
            make.left.right.top.mas_equalTo(0);
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
            make.left.mas_equalTo(self.avatarImage.mas_right).offset(10);
            make.right.mas_equalTo(self.likeBut.mas_left).offset(-5);
        }];
        
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

- (void)setTitleText:(NSString *)titleText{
    NSString *titleStr = [CheckTool replaceNullValue:titleText];
    self.titleL.text = titleStr;
    // 计算文字行数
    NSInteger num = [LabelSpacing needLinesWithWidth:self.frame.size.width - 20 textStr:titleStr font:12];
    // 最多两行
    if (num > 2) {
        num = 2;
    }
    
    [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(num * 15);
    }];
    
}

#pragma mark - 按钮点击
- (void)likeButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
    } else {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
    }
}

- (void)collectionButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"collection_off"] forState:UIControlStateNormal];
    } else {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateNormal];
    }
}


#pragma mark - 懒加载
- (UIImageView *)homeImage{
    if (!_homeImage) {
        _homeImage = [[UIImageView alloc]init];
        _homeImage.backgroundColor = RGB(240, 240, 240);

        _homeImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _homeImage;
}

- (UIImageView *)avatarImage{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.backgroundColor = RGB(240, 240, 240);
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

- (TopLeftLabel *)titleL{
    if (!_titleL) {
        _titleL = [[TopLeftLabel alloc]init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.text = @"卡片标题";
        _titleL.numberOfLines = 2;
        //_titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:12];
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
        _likeBut.titleLabel.font = [UIFont systemFontOfSize:10];
        _likeBut.selected = NO;
        [_likeBut addTarget:self action:@selector(likeButClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_likeBut setImagePositionWithType:SSImagePositionTypeLeft spacing:5];;
        
    }
    return _likeBut;
}

- (UIButton *)collectionBut{
    if (!_collectionBut) {
        _collectionBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBut setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateNormal];
        _collectionBut.selected = NO;
        [_collectionBut addTarget:self action:@selector(collectionButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBut;
}

@end
