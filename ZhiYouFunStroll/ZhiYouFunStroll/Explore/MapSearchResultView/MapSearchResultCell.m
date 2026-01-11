//
//  MapSearchResultCell.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "MapSearchResultCell.h"
#import "MapSearchResultItem.h"

@interface MapSearchResultCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TopLeftLabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *walkTimeLabel;

@end

@implementation MapSearchResultCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Lazy Loading

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[TopLeftLabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        [self.contentView addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (UILabel *)walkTimeLabel {
    if (!_walkTimeLabel) {
        _walkTimeLabel = [[UILabel alloc] init];
        _walkTimeLabel.font = [UIFont systemFontOfSize:12];
        _walkTimeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        _walkTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_walkTimeLabel];
    }
    return _walkTimeLabel;
}

#pragma mark - UI Setup

- (void)setupConstraints {
    // 确保所有控件都已创建
    [self imageView];
    [self titleLabel];
    [self distanceLabel];
    [self walkTimeLabel];
    
    // 设置约束
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(220);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(self.frame.size.width/2 - 5);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
    }];
    
    [_walkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(self.frame.size.width/2 - 5);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
    }];
}

#pragma mark - Public Methods

- (void)configureWithItem:(MapSearchResultItem *)item {
    self.titleLabel.text = item.title;
    self.distanceLabel.text = [NSString stringWithFormat:@"距离%ldm", (long)item.distance];
    self.walkTimeLabel.text = [NSString stringWithFormat:@"步行约%ld分钟", (long)item.walkTime];
    
    // 设置图片（使用色块代替）
    self.imageView.backgroundColor = [UIColor colorWithRed:0.7 green:0.8 blue:0.9 alpha:1.0];
}

@end

