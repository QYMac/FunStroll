//
//  NearbyRecommendCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "NearbyRecommendCell.h"

@interface NearbyRecommendCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *walkTimeLabel;

@end

@implementation NearbyRecommendCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.masksToBounds = YES;
    
    // 封面图
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 4;
    self.coverImageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.coverImageView.backgroundColor = RGB(230, 235, 240);
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        // 高度由宽度的1.2比例计算
        make.height.mas_equalTo(self.coverImageView.mas_width).multipliedBy(1.2);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    // 位置图标
    self.locationIcon = [[UIImageView alloc] init];
    self.locationIcon.image = [UIImage imageNamed:@"route_location"];
    [self.contentView addSubview:self.locationIcon];
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(14);
    }];
    
    // 距离
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [UIFont systemFontOfSize:12];
    self.distanceLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationIcon.mas_right).offset(3);
        make.centerY.mas_equalTo(self.locationIcon);
    }];
    
    // 步行时间
    self.walkTimeLabel = [[UILabel alloc] init];
    self.walkTimeLabel.font = [UIFont systemFontOfSize:12];
    self.walkTimeLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.walkTimeLabel];
    [self.walkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.locationIcon);
    }];
}

- (void)configWithData:(NSDictionary *)data {
    NSString *imageUrl = data[@"image"];
    NSString *title = data[@"title"];
    NSString *distance = data[@"distance"];
    NSString *walkTime = data[@"walkTime"];
    
    if (imageUrl.length > 0) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    } else {
        self.coverImageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
    
    self.titleLabel.text = title;
    self.distanceLabel.text = [NSString stringWithFormat:@"距离%@", distance];
    self.walkTimeLabel.text = walkTime;
}

@end
