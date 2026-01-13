//
//  AlbumListView.m
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import "AlbumListView.h"

@implementation AlbumModel

@end

#pragma mark - AlbumCell

@interface AlbumCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation AlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 封面图
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(60);
    }];
    
    // 相册名称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = RGB(51, 51, 51);
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 数量
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = RGB(153, 153, 153);
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 分割线
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
}

@end

#pragma mark - AlbumListView

@interface AlbumListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<AlbumModel *> *albums;
@property (nonatomic, assign) CGFloat containerHeight;

@end

@implementation AlbumListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.containerHeight = kHeight - bottomHeight;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    
    // 背景遮罩
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.backgroundView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.backgroundView addGestureRecognizer:tap];
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 容器（初始高度为0，从顶部开始）
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    // 列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 80;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomHeight, 0);
    [self.tableView registerClass:[AlbumCell class] forCellReuseIdentifier:@"AlbumCell"];
    [self.containerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)showWithAlbums:(NSArray<AlbumModel *> *)albums {
    self.albums = albums;
    [self.tableView reloadData];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
        // 展开：高度从0变为目标高度（下滑效果）
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.containerHeight);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
        // 收起：高度从目标高度变为0（上滑效果）
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    AlbumModel *album = self.albums[indexPath.row];
    cell.nameLabel.text = album.name;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)album.count];
    
    // 加载封面图
    if (album.coverAsset) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize targetSize = CGSizeMake(60 * scale, 60 * scale);
        
        [self.imageManager requestImageForAsset:album.coverAsset
                                     targetSize:targetSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
            cell.coverImageView.image = result;
        }];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumModel *album = self.albums[indexPath.row];
    
    if (self.didSelectAlbumBlock) {
        self.didSelectAlbumBlock(album);
    }
    
    [self hide];
}

@end
