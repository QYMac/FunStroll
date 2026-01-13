//
//  PhotoPickerCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "PhotoPickerCell.h"

@implementation PhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 图片
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 选择按钮背景
    self.selectView = [[UIView alloc] init];
    self.selectView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.selectView.layer.cornerRadius = 11;
    self.selectView.layer.borderWidth = 1.5;
    self.selectView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.width.height.mas_equalTo(22);
    }];
    
    // 选择序号
    self.selectLabel = [[UILabel alloc] init];
    self.selectLabel.font = [UIFont boldSystemFontOfSize:12];
    self.selectLabel.textColor = [UIColor whiteColor];
    self.selectLabel.textAlignment = NSTextAlignmentCenter;
    self.selectLabel.hidden = YES;
    [self.selectView addSubview:self.selectLabel];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        self.selectView.backgroundColor = RGB(145, 233, 80);
        self.selectView.layer.borderColor = RGB(145, 233, 80).CGColor;
        self.selectLabel.hidden = NO;
    } else {
        self.selectView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.selectView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.selectLabel.hidden = YES;
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    self.selectLabel.text = [NSString stringWithFormat:@"%ld", (long)selectIndex];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    // 不清除图片，避免闪烁
    // self.imageView.image = nil;
    self.isSelected = NO;
    self.selectIndex = 0;
    self.representedAssetIdentifier = nil;
}

@end
