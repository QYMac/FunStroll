//
//  AbnormalNoteCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "AbnormalNoteCell.h"

@implementation AbnormalNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 卡片背景
    [self.contentView addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
    }];
    
    // 顶部背景区域 (封面图+标题+按钮区域)
    [self.cardView addSubview:self.topBgView];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.5);
        make.left.mas_equalTo(7.5);
        make.right.mas_equalTo(-7.5);
        make.height.mas_equalTo(55);
    }];
    
    // 封面图
    [self.topBgView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7.5);
        make.centerY.mas_equalTo(self.topBgView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    // 删除按钮
    [self.topBgView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-7.5);
        make.centerY.mas_equalTo(self.topBgView);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(20);
    }];
    
    // 分隔符
    UILabel *separator = [[UILabel alloc] init];
    separator.text = @"|";
    separator.font = [UIFont systemFontOfSize:12];
    separator.textColor = RGB(187, 187, 187);
    [self.topBgView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.topBgView);
    }];
    
    // 编辑按钮
    [self.topBgView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(separator.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.topBgView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(20);
    }];
    
    // 标题
    [self.topBgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(12);
        make.right.mas_equalTo(self.editButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.topBgView);
    }];
    
    // 警告图标
    [self.cardView addSubview:self.warningIcon];
    [self.warningIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(12);
        make.width.height.mas_equalTo(12);
    }];
    
    // 警告文字
    [self.cardView addSubview:self.warningLabel];
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningIcon.mas_right).offset(5);
        make.centerY.mas_equalTo(self.warningIcon);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-12);  // 添加底部约束实现自适应高度
    }];
}

#pragma mark - Public Methods
- (void)configureWithCoverUrl:(NSString *)coverUrl
                        title:(NSString *)title
                  warningText:(NSString *)warningText {
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = title;
    self.warningLabel.text = warningText;
}

#pragma mark - Actions
- (void)editButtonClicked {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)deleteButtonClicked {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - Lazy Loading
- (UIView *)cardView {
    if (!_cardView) {
        _cardView = [[UIView alloc] init];
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.layer.cornerRadius = 8;
        _cardView.layer.masksToBounds = YES;
    }
    return _cardView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = RGB(249, 249, 249);
        _topBgView.layer.cornerRadius = 8;
    }
    return _topBgView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.cornerRadius = 4;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.backgroundColor = RGB(240, 240, 240);
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIImageView *)warningIcon {
    if (!_warningIcon) {
        _warningIcon = [[UIImageView alloc] init];
        _warningIcon.image = [UIImage imageNamed:@"jinggao_m"];
        _warningIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _warningIcon;
}

- (UILabel *)warningLabel {
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.font = [UIFont systemFontOfSize:12];
        _warningLabel.textColor = RGB(187, 187, 187);
        _warningLabel.numberOfLines = 0;
    }
    return _warningLabel;
}

@end
