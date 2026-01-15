//
//  ImageTableViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/4.
//

#import "ImageTableViewCell.h"

@interface ImageTableViewCell ()<DCCycleScrollViewDelegate,KYPhotoBrowserControllerDelegate>

@property (nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation ImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//去除cell的点击效果
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    self.severalBg.layer.cornerRadius = 10;
    self.severalBg.layer.masksToBounds = YES;
    [self.bgView insertSubview:self.severalBg atIndex:999];
    [self.severalBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];

    [self.severalBg addSubview:self.imageSeveralL];
    [self.imageSeveralL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.left.mas_equalTo(0);
    }];
    
    [self.bgView insertSubview:self.bannerView atIndex:0];
    
    [self.bgView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(25);
    }];
    
    [self.bgView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleL.mas_right).offset(0);
        make.left.mas_equalTo(self.titleL.mas_left).offset(0);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
    }];
    
    [self.bgView addSubview:self.topicL];
    [self.topicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleL.mas_right).offset(0);
        make.left.mas_equalTo(self.titleL.mas_left).offset(0);
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(5);
    }];
    
    [self.bgView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleL.mas_right).offset(0);
        make.left.mas_equalTo(self.titleL.mas_left).offset(0);
        make.top.mas_equalTo(self.topicL.mas_bottom).offset(10);
    }];
    
    [self.bgView addSubview:self.fgView];
    [self.fgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleL.mas_right).offset(0);
        make.left.mas_equalTo(self.titleL.mas_left).offset(0);
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.fgView.mas_bottom).offset(5);
    }];
}

- (void)setModel:(ResponseModel *)model{
    [self.imageArray removeAllObjects];
    for (ResourceModel *resourceModel in model.data.resources) {
        NSString *resourceUrl = [CheckTool replaceNullValue:resourceModel.resourceUrl];
        [self.imageArray addObject:resourceUrl];
    }
    
    self.bannerView.dataList = self.imageArray;
    if (self.imageArray.count != 0) {
        self.severalBg.hidden = NO;
        self.imageSeveralL.text = [NSString stringWithFormat:@"1/%ld",self.imageArray.count];
    } else {
        self.severalBg.hidden = YES;
    }
    self.titleL.text = [CheckTool replaceNullValue:model.data.title];
    
    // 使用 NSPredicate 过滤
    NSString *text = [CheckTool replaceNullValue:model.data.content];
    NSArray *hashtags = [[text componentsSeparatedByString:@" "]
                         filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] '#'"]];
    
    NSString *resultText = text;
    for (NSString *hashtag in hashtags) {
        resultText = [resultText stringByReplacingOccurrencesOfString:hashtag withString:@""];
    }
    self.contentL.text = resultText;
    [LabelSpacing setLineSpacing:5 label:self.contentL];
    
    NSString *topicLText = @"";
    for (NSString *str in hashtags) {
        if (topicLText.length == 0) {
            topicLText = [NSString stringWithFormat:@"%@",str];
        } else {
            topicLText = [NSString stringWithFormat:@"%@ %@",topicLText,str];
        }
    }
    self.topicL.text = topicLText;
    
    
    NSString *createTime = [CheckTool replaceNullValue:model.data.createTime];
    NSString *province = [[CheckTool replaceNullValue:model.data.province] stringByReplacingOccurrencesOfString:@"省" withString:@""];
    NSString *createTimeStr = [NSString stringWithFormat:@"编辑于%@  %@",[DateHelper formatDateString:createTime],province];
    self.timeL.text = [CheckTool replaceNullValue:createTimeStr];
    
}

#pragma mark - DCCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [KYPhotoBrowserController showPhotoBrowserWithImages:self.imageArray currentImageIndex:index delegate:self];
}

/**当图片手动滑动或自动切换时回调，返回当前页码，用于外部自定义pageControl时，切换当前页使用*/
- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView currentPageIndex:(NSInteger)index{
    self.imageSeveralL.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
}

#pragma mark - 懒加载

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (DCCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 435) shouldInfiniteLoop:YES imageGroups:@[]];
        _bannerView.autoScrollTimeInterval = 3;
        _bannerView.autoScroll = NO;
        _bannerView.isZoom = NO;
        _bannerView.imgCornerRadius = 0;
        _bannerView.itemWidth = kWidth;
        _bannerView.delegate = self;
        _bannerView.itemSpace = 0;
        _bannerView.pageControl.hidden = NO;
        _bannerView.pageControlY = 440;
        _bannerView.pageControlColor = RGB(227, 227, 227);
        _bannerView.pageControlSelectedColor = RGB(145, 233, 80);
    }
    return _bannerView;
}

- (UILabel *)imageSeveralL{
    if (!_imageSeveralL) {
        _imageSeveralL = [[UILabel alloc] init];
        _imageSeveralL.text = @"20/20";
        _imageSeveralL.textColor = [UIColor whiteColor];
        _imageSeveralL.font = [UIFont systemFontOfSize:12];
        _imageSeveralL.textAlignment = NSTextAlignmentCenter;
    }
    return _imageSeveralL;
}

- (UIView *)severalBg{
    if (!_severalBg) {
        _severalBg = [[UIView alloc] init];
        _severalBg.alpha = 0.5;
        _severalBg.backgroundColor = [UIColor blackColor];
    }
    return _severalBg;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"快来云南*六天花了1090，包吃住行门票";
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = [UIColor blackColor];
        _titleL.numberOfLines = 0;
    }
    return _titleL;
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.text = @"假期将至，趁着有时间 \n来云南晚上几天吧";
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.textColor = RGB(85, 85, 85);
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

- (UILabel *)topicL{
    if (!_topicL) {
        _topicL = [[UILabel alloc]init];
        _topicL.text = @"#攻略 #旅游";
        _topicL.font = [UIFont systemFontOfSize:14];
        _topicL.textColor = RGB(58, 175, 6);
        _topicL.numberOfLines = 0;
    }
    return _topicL;
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = RGB(182, 182, 182);
        _timeL.text = @"编辑于11-12 云南";
        _timeL.font = [UIFont systemFontOfSize:12];
    }
    return _timeL;
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc]init];
        _fgView.backgroundColor = RGB(229, 229, 229);
    }
    return _fgView;
}


- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

@end
