//
//  LFPhotoPreViewColletionCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/16.
//

#import "LFPhotoPreViewColletionCell.h"
#import "NSBundle+LFImagePicker.h"
#import "LFAssetManager.h"

#define bundleImageNamed(name) [NSBundle lf_imageNamed:name]

@implementation LFPhotoPreViewColletionCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self.contentView addSubview:self.selectedImg];
        [self.selectedImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (void)setSelectedModels:(NSMutableArray<LFAsset *> *)selectedModels indexPathdex:(NSIndexPath *) indexPathdex{
    LFAsset *model = selectedModels[indexPathdex.row];
    
    WeakSelf
    /*
    // 先获取缩略图
    [[LFAssetManager manager] getPhotoWithAsset:model.asset photoWidth:self.bounds.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        
        weakSelf.selectedImg.image = photo;
        
    }];
     */
    
    /*
    // 获取照片本身
    [[LFAssetManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        weakSelf.selectedImg.image = photo;
    }];
     */
    
    if (model.thumbnailImage) { /** 显示自定义图片 */
        self.selectedImg.image = (model.previewImage.images.count > 0 ? model.previewImage.images.firstObject : model.thumbnailImage);
    }  else {
        [[LFAssetManager manager] getPhotoWithAsset:model.asset photoWidth:self.frame.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (model.asset) {
                self.selectedImg.image = photo;
            } else {
                self.selectedImg.image = nil;
            }
            
        } progressHandler:nil networkAccessAllowed:NO];
    }
    
}

- (UIImageView *)selectedImg{
    if (!_selectedImg) {
        _selectedImg = [[UIImageView alloc]init];
        _selectedImg.layer.cornerRadius = 6;
        _selectedImg.layer.masksToBounds = YES;
        _selectedImg.backgroundColor = RGB(240, 240, 240);
        _selectedImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _selectedImg;
}

@end
