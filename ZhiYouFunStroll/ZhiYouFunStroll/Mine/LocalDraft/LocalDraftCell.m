//
//  LocalDraftCell.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/12.
//

#import "LocalDraftCell.h"
#import "FMDBManager.h"

@implementation LocalDraftCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 封面图（带边框）
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.coverImageView.mas_width).multipliedBy(1.2);
    }];
    
    
    // 标题
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    // 日期
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
    }];
    
    // 删除按钮
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.dateLabel);
        make.width.height.mas_equalTo(20);
    }];
}

#pragma mark - Public Methods
- (void)configureWithDraftDict:(NSDictionary *)draftDict {
    // 标题
    NSString *title = [CheckTool replaceNullValue:draftDict[@"title"]];
    self.titleLabel.text = title.length > 0 ? title : @"无标题";
    
    // 正文预览（如果没有标题，显示正文）
    if (title.length == 0) {
        NSString *content = [CheckTool replaceNullValue:draftDict[@"content"]];
        self.titleLabel.text = content.length > 0 ? content : @"无内容";
    }
    
    // 创建时间（格式化显示）
    NSString *createTime = [CheckTool replaceNullValue:draftDict[@"createTime"]];
    self.dateLabel.text = [self formatCreateTime:createTime];
    
    // 加载封面图（从文件名数组加载第一张）
    NSString *imagePathsJson = [CheckTool replaceNullValue:draftDict[@"imagePaths"]];
    self.coverImageView.image = [UIImage imageNamed:@"placeholder"]; // 默认占位图
    
    if (imagePathsJson.length > 0) {
        NSError *error;
        NSData *jsonData = [imagePathsJson dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *imageNames = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if (!error && [imageNames isKindOfClass:[NSArray class]] && imageNames.count > 0) {
            // 取第一张图片作为封面
            NSString *firstName = imageNames.firstObject;
            
            if ([firstName isKindOfClass:[NSString class]] && firstName.length > 0) {
                // 获取草稿图片目录
                NSString *draftImagesDir = [FMDBManager draftImagesDirectory];
                NSString *fullPath;
                
                // 判断是文件名还是完整路径（兼容旧数据）
                if ([firstName hasPrefix:@"/"]) {
                    // 旧数据：完整路径，提取文件名后重新拼接
                    fullPath = [draftImagesDir stringByAppendingPathComponent:[firstName lastPathComponent]];
                } else {
                    // 新数据：文件名，直接拼接
                    fullPath = [draftImagesDir stringByAppendingPathComponent:firstName];
                }
                
                // 检查文件是否存在
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:fullPath]) {
                    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
                    if (image) {
                        self.coverImageView.image = image;
                        NSLog(@"草稿封面图加载成功: %@", fullPath);
                    } else {
                        NSLog(@"草稿封面图加载失败，图片为nil: %@", fullPath);
                    }
                } else {
                    NSLog(@"草稿图片文件不存在: %@", fullPath);
                }
            }
        } else {
            NSLog(@"解析图片路径JSON失败: %@", error);
        }
    }
}

#pragma mark - Private Methods
/// 格式化创建时间：今年显示"M月d日 HH:mm"，非今年显示"yyyy年M月d日 HH:mm"
- (NSString *)formatCreateTime:(NSString *)createTime {
    if (createTime.length == 0) {
        return @"";
    }
    
    // 解析原始时间字符串 (yyyy-MM-dd HH:mm:ss)
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [inputFormatter dateFromString:createTime];
    
    if (!date) {
        return createTime; // 解析失败，返回原字符串
    }
    
    // 获取当前年份
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger dateYear = [calendar component:NSCalendarUnitYear fromDate:date];
    
    // 根据年份选择格式
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    if (dateYear == currentYear) {
        // 今年：显示 "M月d日 HH:mm"
        outputFormatter.dateFormat = @"M月d日 HH:mm";
    } else {
        // 非今年：显示 "yyyy年M月d日 HH:mm"
        outputFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
    }
    
    return [outputFormatter stringFromDate:date];
}

#pragma mark - Actions
- (void)deleteButtonClicked {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - Lazy Loading
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = RGB(240, 240, 240);
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = RGB(153, 153, 153);
    }
    return _dateLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"shanchu_m"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
