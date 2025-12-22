//
//  HomeViewDetailsCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import "HomeViewDetailsCell.h"
#import "AddCommentController.h"

@implementation HomeViewDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor clearColor];
        
        
        
    }
    return self;
}


- (void)setIndexPath:(NSIndexPath *)indexPath isAllList:(BOOL)isAllList{
    self.oneBgOneView.hidden = YES;
    self.towBgOneView.hidden = YES;
    if (indexPath.section == 0 && isAllList == NO) {
        self.oneBgOneView.hidden = NO;
        [self initEvaluationButView];
    } else {
        self.towBgOneView.hidden = NO;
        [self initEvaluationListView];
    }
}


- (void)initEvaluationButView{
    [self.contentView addSubview:self.oneBgOneView];
    [self.oneBgOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(90);
    }];
    
    [self.oneBgOneView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.oneBgOneView addSubview:self.evaluationBut];
    [self.evaluationBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(35);
    }];
    
    [self.oneBgOneView insertSubview:self.fgView atIndex:99];
    [self.fgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)initEvaluationListView{
    [self.contentView addSubview:self.towBgOneView];
    [self.towBgOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.avatarImage.layer.cornerRadius = 20;
    self.avatarImage.layer.masksToBounds = YES;
    [self.towBgOneView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    
    [self.towBgOneView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.avatarImage.mas_top).offset(0);
        make.left.mas_equalTo(self.avatarImage.mas_right).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.towBgOneView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-200);
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(0);
        make.left.mas_equalTo(self.nameL.mas_left).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.towBgOneView addSubview:self.likeBut];
    [self.likeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(22.5);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.timeL);
        make.right.mas_equalTo(-15);
    }];
    
    [self.towBgOneView addSubview:self.numBut];
    [self.numBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeL.mas_right).offset(10);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.timeL);
        make.right.mas_equalTo(self.likeBut.mas_left).offset(-10);
    }];
    
    [self.towBgOneView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImage.mas_left).offset(0);
        make.top.mas_equalTo(self.avatarImage.mas_bottom).offset(15);
        make.right.mas_equalTo(-15);
    }];
    
    [self.contentL layoutIfNeeded];;
    CGFloat tagImgX = 10;
    CGFloat contentImgWidth = (kWidth - 60)/3;
    CGFloat tagImgY = 85 + self.contentL.frame.size.height;
    NSArray *imageList = @[@"",@"",@"",@"",@"",@"",@"",@"",@""];
    for (int i = 0; i < imageList.count; i++) {
        if (tagImgX + contentImgWidth> kWidth - 30) {
            tagImgX = 10;
            tagImgY += (contentImgWidth+10);
        }
        _contentImg = [[UIImageView alloc] init];
        _contentImg.backgroundColor = RGB(240, 240, 240);
        _contentImg.frame  = CGRectMake(tagImgX, tagImgY, contentImgWidth, contentImgWidth);
        [self.towBgOneView addSubview:_contentImg];
        
        tagImgX = CGRectGetMaxX(_contentImg.frame)+10;
        
    }
    
    [self.towBgOneView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_contentImg.mas_bottom).offset(15);
    }];
}

#pragma mark - 按钮点击事件
- (void)evaluationButClick:(UIButton *)sender{
    AddCommentController *navc = [[AddCommentController alloc]init];
    [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
}

- (void)likeButClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"like_off"] forState:UIControlStateNormal];
    } else {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"like_on"] forState:UIControlStateNormal];
    }
}

- (void)numButClick:(UIButton *)sender{
    
}

#pragma mark - 懒加载
- (UIView *)oneBgOneView{
    if (!_oneBgOneView) {
        _oneBgOneView = [[UIView alloc]init];
        _oneBgOneView.backgroundColor = [UIColor whiteColor];
    }
    return _oneBgOneView;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"用户评价";
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}

- (UIButton *)evaluationBut{
    if (!_evaluationBut) {
        _evaluationBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_evaluationBut setBackgroundImage:[UIImage imageNamed:@"home_PJ"] forState:UIControlStateNormal];
        [_evaluationBut setTitle:@"立即评价获得积分！" forState:UIControlStateNormal];
        [_evaluationBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _evaluationBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_evaluationBut addTarget:self action:@selector(evaluationButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluationBut;
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc]init];
        _fgView.backgroundColor = RGB(240, 240, 240);
    }
    return _fgView;
}

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
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
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
        _likeBut.selected = NO;
        [_likeBut addTarget:self action:@selector(likeButClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.text = @"非常有意思的景点，非常推荐";
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.textColor = [UIColor blackColor];
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

@end
