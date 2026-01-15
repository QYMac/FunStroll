//
//  RouteOptionCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "RouteOptionCell.h"

@interface RouteOptionCell ()

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIView *separator;

@end

@implementation RouteOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 标签（大众常选）
    self.tagLabel = [[UILabel alloc] init];
    self.tagLabel.font = [UIFont systemFontOfSize:11];
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.centerX.mas_equalTo(0);
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:17];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
    }];
    
    // 距离
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [UIFont systemFontOfSize:10];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(3);
        make.centerX.mas_equalTo(0);
    }];
    
    // 分隔线
    self.separator = [[UIView alloc] init];
    self.separator.backgroundColor = RGB(230, 230, 230);
    [self.contentView addSubview:self.separator];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(50);
    }];
}

- (void)configWithData:(NSDictionary *)data isSelected:(BOOL)isSelected {
    NSString *tag = data[@"tag"];
    NSString *time = data[@"time"];
    NSString *distance = data[@"distance"];
    
    self.tagLabel.text = tag;
    self.timeLabel.text = [NSString stringWithFormat:@"%@分钟", time];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@公里", distance];
    
    if (isSelected) {
        self.tagLabel.textColor = RGB(58, 175, 6);
        self.timeLabel.textColor = RGB(58, 175, 6);
        self.distanceLabel.textColor = RGB(58, 175, 6);
    } else {
        self.tagLabel.textColor = RGB(102, 102, 102);
        self.timeLabel.textColor = [UIColor blackColor];
        self.distanceLabel.textColor = RGB(102, 102, 102);
    }
}

@end
