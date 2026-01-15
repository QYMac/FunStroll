//
//  MapLocationDetailView.m
//  test
//
//  Created on 2025/12/9.
//

#import "MapLocationDetailView.h"
#import "MapLocationImageCell.h"
#import "RelatedPhotosViewController.h"
#import "TabBarViewController.h"
#import "RelatedPhotosViewController.h"

@interface MapLocationDetailView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

/// 图片集合视图
@property (nonatomic, strong) UICollectionView *imageCollectionView;

/// 地点名称标签
@property (nonatomic, strong) UILabel *nameLabel;

/// 营业时间标签
@property (nonatomic, strong) UILabel *operatingHoursLabel;

/// 距离和时间标签
@property (nonatomic, strong) UILabel *distanceTimeLabel;

/// 地址标签
@property (nonatomic, strong) UILabel *addressLabel;

/// 分享按钮
@property (nonatomic, strong) UIButton *shareButton;

/// 收藏按钮
@property (nonatomic, strong) UIButton *favoriteButton;

/// 路线按钮
@property (nonatomic, strong) UIButton *routeButton;

/// 立即导航按钮
@property (nonatomic, strong) UIButton *navigateButton;

/// 图片URL数组
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

/// 全部图片按钮
@property (nonatomic, strong) UIButton *relatedPhotosButton;

/// 营业时间分割线
@property (nonatomic, strong) UIView *operatingHoursSeparator;

/// 地址分割线
@property (nonatomic, strong) UIView *addressSeparator;

/// 定位按钮
@property (nonatomic, strong) UIButton *locationButton;

/// 电话号码按钮
@property (nonatomic, strong) UIButton *phoneButton;



@end

@implementation MapLocationDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    // 添加关闭按钮
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-6);
        make.width.height.mas_equalTo(24);
    }];
    
    // 添加图片集合视图
    [self addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closeButton.mas_bottom).offset(10);
        make.left.equalTo(self).offset(12);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(115);
    }];
    
    // 添加电话号码按钮
    [self addSubview:self.phoneButton];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageCollectionView.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    
    // 添加定位按钮
    [self addSubview:self.locationButton];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageCollectionView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.phoneButton.mas_left).offset(0);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    
    // 添加地点名称标签
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageCollectionView.mas_bottom).offset(18);
        make.left.equalTo(self).offset(12);
        make.right.mas_equalTo(self.locationButton.mas_left).offset(-5);
    }];
    
    // 添加营业时间标签
    [self addSubview:self.operatingHoursLabel];
    [self.operatingHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
    
    // 添加营业时间分割线
    [self addSubview:self.operatingHoursSeparator];
    [self.operatingHoursSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operatingHoursLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(0.5);
    }];
    
    // 添加距离和时间标签
    [self addSubview:self.distanceTimeLabel];
    [self.distanceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operatingHoursSeparator.mas_bottom).offset(16);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
    
    // 添加地址标签
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceTimeLabel.mas_bottom).offset(8);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
    }];
    
    // 添加地址分割线
    [self addSubview:self.addressSeparator];
    [self.addressSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(0.5);
    }];
    
    // 添加分享按钮
    [self addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressSeparator.mas_bottom).offset(10);
        make.left.equalTo(self).offset(12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    // 添加收藏按钮
    [self addSubview:self.favoriteButton];
    [self.favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton);
        make.left.equalTo(self.shareButton.mas_right).offset(12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    // 添加立即导航按钮
    [self addSubview:self.navigateButton];
    [self.navigateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    // 添加路线按钮
    [self addSubview:self.routeButton];
    [self.routeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton);
        make.right.equalTo(self.navigateButton.mas_left).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    [self addSubview:self.relatedPhotosButton];
    [self.relatedPhotosButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageCollectionView).offset(-8);
        make.bottom.equalTo(self.imageCollectionView).offset(-8);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    self.relatedPhotosButton.hidden = YES; // 初始隐藏，有图片时显示
}

#pragma mark - Lazy Loading

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"tuichu_d"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UICollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollectionView.backgroundColor = [UIColor clearColor];
        _imageCollectionView.dataSource = self;
        _imageCollectionView.delegate = self;
        _imageCollectionView.showsHorizontalScrollIndicator = NO;
        [_imageCollectionView registerClass:[MapLocationImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    }
    return _imageCollectionView;
}

- (UIButton *)locationButton {
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setImage:[UIImage imageNamed:@"dingwei_d"] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}

- (UIButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setImage:[UIImage imageNamed:@"dianhua_d"] forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)operatingHoursLabel {
    if (!_operatingHoursLabel) {
        _operatingHoursLabel = [[UILabel alloc] init];
        _operatingHoursLabel.font = [UIFont systemFontOfSize:14];
        _operatingHoursLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        _operatingHoursLabel.numberOfLines = 0;
    }
    return _operatingHoursLabel;
}

- (UILabel *)distanceTimeLabel {
    if (!_distanceTimeLabel) {
        _distanceTimeLabel = [[UILabel alloc] init];
        _distanceTimeLabel.font = [UIFont systemFontOfSize:14];
        _distanceTimeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        _distanceTimeLabel.numberOfLines = 0;
    }
    return _distanceTimeLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}


- (UIView *)operatingHoursSeparator {
    if (!_operatingHoursSeparator) {
        _operatingHoursSeparator = [[UIView alloc] init];
        _operatingHoursSeparator.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return _operatingHoursSeparator;
}

- (UIView *)addressSeparator {
    if (!_addressSeparator) {
        _addressSeparator = [[UIView alloc] init];
        _addressSeparator.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return _addressSeparator;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"fenxiang_d"] forState:UIControlStateNormal];
        [_shareButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    }
    return _shareButton;
}

- (UIButton *)favoriteButton {
    if (!_favoriteButton) {
        _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"shoucang_d"] forState:UIControlStateNormal];
        [_favoriteButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _favoriteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_favoriteButton addTarget:self action:@selector(favoriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_favoriteButton setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    }
    return _favoriteButton;
}

- (UIButton *)routeButton {
    if (!_routeButton) {
        _routeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_routeButton setTitle:@"路线" forState:UIControlStateNormal];
        [_routeButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _routeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _routeButton.layer.cornerRadius = 20;
        _routeButton.layer.borderWidth = 1;
        _routeButton.layer.borderColor = RGB(219, 219, 219).CGColor;
        [_routeButton addTarget:self action:@selector(routeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _routeButton;
}

- (UIButton *)navigateButton {
    if (!_navigateButton) {
        _navigateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navigateButton setTitle:@"立即导航" forState:UIControlStateNormal];
        [_navigateButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _navigateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _navigateButton.backgroundColor = RGB(145, 233, 80);
        _navigateButton.layer.cornerRadius = 20;
        [_navigateButton addTarget:self action:@selector(navigateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigateButton;
}

- (UIButton *)relatedPhotosButton {
    if (!_relatedPhotosButton) {
        _relatedPhotosButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_relatedPhotosButton setTitle:@"相关照片99>" forState:UIControlStateNormal];
        [_relatedPhotosButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _relatedPhotosButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _relatedPhotosButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _relatedPhotosButton.layer.cornerRadius = 10;
        _relatedPhotosButton.layer.masksToBounds = YES;
        [_relatedPhotosButton addTarget:self action:@selector(relatedPhotosButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _relatedPhotosButton;
}

#pragma mark - Actions

- (void)closeButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapLocationDetailViewDidTapClose:)]) {
        [self.delegate mapLocationDetailViewDidTapClose:self];
    }
}

- (void)shareButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapLocationDetailViewDidTapShare:)]) {
        [self.delegate mapLocationDetailViewDidTapShare:self];
    }
}

- (void)favoriteButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapLocationDetailViewDidTapFavorite:)]) {
        [self.delegate mapLocationDetailViewDidTapFavorite:self];
    }
}

- (void)routeButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapLocationDetailViewDidTapRoute:)]) {
        [self.delegate mapLocationDetailViewDidTapRoute:self];
    }
}

- (void)navigateButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mapLocationDetailViewDidTapNavigate:)]) {
        [self.delegate mapLocationDetailViewDidTapNavigate:self];
    }
}

- (void)relatedPhotosButtonTapped:(UIButton *)sender {
    RelatedPhotosViewController *vc = [[RelatedPhotosViewController alloc] initWithImageUrls:self.imageUrls];
    [[TabBarViewController takeCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)locationButtonTapped:(UIButton *)sender {
    
}

- (void)phoneButtonTapped:(UIButton *)sender {
    
}

#pragma mark - Public Methods

- (void)configureWithName:(NSString *)name
           operatingHours:(NSString *)operatingHours
                 distance:(CGFloat)distance
                driveTime:(NSInteger)driveTime
                  address:(NSString *)address
                imageUrls:(NSArray<NSString *> *)imageUrls {
    self.nameLabel.text = name;
    self.operatingHoursLabel.text = [NSString stringWithFormat:@"营业时间: %@", operatingHours];
    self.distanceTimeLabel.text = [NSString stringWithFormat:@"距您%.0f公里 开车%ld小时%ld分钟", distance, (long)(driveTime / 60), (long)(driveTime % 60)];
    self.addressLabel.text = address;
    self.imageUrls = imageUrls;
    // 如果有图片，显示相关照片按钮
    self.relatedPhotosButton.hidden = (imageUrls.count == 0);
    [self.imageCollectionView reloadData];
}

- (CGFloat)navigateButtonBottomHeight {
    // 确保布局已更新
    [self layoutIfNeeded];
    // 返回按钮底部距离父视图顶部的距离
    return CGRectGetMaxY(self.navigateButton.frame);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MapLocationImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if (indexPath.item < self.imageUrls.count) {
        NSString *imageUrl = self.imageUrls[indexPath.item];
        [cell configureWithImageUrl:imageUrl];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(115, 115);
}

@end

