//
//  MapLocationImageCell.m
//  test
//
//  Created on 2025/12/9.
//

#import "MapLocationImageCell.h"
#import <Masonry/Masonry.h>

@interface MapLocationImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MapLocationImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
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


#pragma mark - UI Setup

- (void)setupConstraints {
    [self imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

}

#pragma mark - Public Methods

- (void)configureWithImageUrl:(nullable NSString *)imageUrl {
    // 设置图片（使用色块代替）
    self.imageView.backgroundColor = [UIColor colorWithRed:0.7 green:0.8 blue:0.9 alpha:1.0];
}

@end

