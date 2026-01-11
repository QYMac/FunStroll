//
//  RelatedPhotosCell.m
//  ZhiYouFunStroll
//
//  Created on 2025/12/9.
//

#import "RelatedPhotosCell.h"
#import <Masonry/Masonry.h>

@interface RelatedPhotosCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RelatedPhotosCell

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

#pragma mark - 懒加载

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
    if (imageUrl && imageUrl.length > 0) {
        // 判断是网络URL还是本地图片名
        if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"]) {
            // 网络图片
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""]];
        } else {
            // 本地图片
            self.imageView.image = [UIImage imageNamed:imageUrl];
        }
    } else {
        // 默认占位色
        self.imageView.image = nil;
        self.imageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
}

@end
