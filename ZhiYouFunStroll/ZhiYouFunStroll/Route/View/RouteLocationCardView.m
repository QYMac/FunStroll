//
//  RouteLocationCardView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/14.
//

#import "RouteLocationCardView.h"

@interface RouteLocationCardView ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation RouteLocationCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        self.layer.masksToBounds = YES;
        
        [self setupUI];
        [self addTapGesture];
    }
    return self;
}

- (void)setupUI {
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"route_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(24);
    }];
    
    // 封面图片
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 6;
    self.coverImageView.backgroundColor = RGB(240, 240, 240);
    [self addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    // 地点名称
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = RGB(51, 51, 51);
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.coverImageView.mas_top).offset(0);
        make.right.mas_equalTo(self.closeButton.mas_left).offset(-10);
    }];
    
    // 地址
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = [UIFont systemFontOfSize:13];
    self.addressLabel.textColor = RGB(51, 51, 51);
    self.addressLabel.numberOfLines = 1;
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(-15);
    }];
    
    // 距离
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [UIFont systemFontOfSize:12];
    self.distanceLabel.textColor = RGB(102, 102, 102);
    [self addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(8);
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Actions
- (void)closeButtonTapped {
    if ([self.delegate respondsToSelector:@selector(locationCardViewDidTapClose:)]) {
        [self.delegate locationCardViewDidTapClose:self];
    }
}

- (void)cardTapped {
    if ([self.delegate respondsToSelector:@selector(locationCardViewDidTap:)]) {
        [self.delegate locationCardViewDidTap:self];
    }
}

#pragma mark - Public Methods
- (void)configureWithImageUrl:(NSString *)imageUrl
                        title:(NSString *)title
                      address:(NSString *)address
                     distance:(NSString *)distance {
    if (imageUrl.length > 0) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
    } else {
        self.coverImageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
    
    self.titleLabel.text = title;
    self.addressLabel.text = address;
    self.distanceLabel.text = distance;
}

@end
