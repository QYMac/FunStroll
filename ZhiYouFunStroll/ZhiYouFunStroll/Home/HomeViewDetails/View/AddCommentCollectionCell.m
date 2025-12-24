//
//  AddCommentCollectionCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import "AddCommentCollectionCell.h"
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>

@interface AddCommentCollectionCell ()<TZImagePickerControllerDelegate,LFImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableArray *addImgList;

@end

@implementation AddCommentCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        
        [self.contentView addSubview:self.commentImg];
        [self.commentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
        
        
        [self.contentView addSubview:self.addImgButton];
        [self.addImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        [self.contentView addSubview:self.removeImgBut];
        [self.removeImgBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

- (void)AddCommentIndexPath:(NSIndexPath *)indexPath imageList:(NSMutableArray *)imageList{
    
    self.addImgList = [NSMutableArray arrayWithArray:imageList];
    
    if (indexPath.row == 0) {
        self.commentImg.hidden = YES;
        self.removeImgBut.hidden = YES;
    }else{
        self.addImgButton.hidden = YES;
        UIImage *image = imageList[indexPath.row-1];
        self.commentImg.image = image;
        self.removeImgBut.tag = indexPath.row - 1;
    }
}

#pragma mark - 按钮点击

- (void)addImgButtonClick:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.addImgList.count >= 9) {
        [AlertWith showAlertWithMessageText:@"最多只能选择9张照片"];
        return;
    }
    
    
    // MaxImagesCount  可以选着的最大条目数
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = YES;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePicker.allowPickingImage = YES;
    //相册导航栏颜色
    imagePicker.naviBgColor = [UIColor whiteColor];
    imagePicker.barItemTextColor = [UIColor blackColor];
    imagePicker.naviTitleColor = [UIColor whiteColor];
    imagePicker.oKButtonTitleColorNormal = [UIColor blackColor];
    imagePicker.oKButtonTitleColorDisabled = [UIColor blackColor];
    // 设置 模态弹出模式。 iOS 13默认非全屏
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [[TabBarViewController takeCurrentVC] presentViewController:imagePicker animated:YES completion:nil];
     
    
//    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    imagePicker.allowTakePicture = NO; // 隐藏拍照按钮
//    //imagePicker.maxVideosCount = 1; // 解除混合选择- 要么1个视频，要么9个图片
//    //imagePicker.sortAscendingByCreateDate = NO;
//    imagePicker.supportAutorotate = YES; // 适配横屏
//    //imagePicker.imageCompressSize = 200; // 标清图压缩大小
//    //imagePicker.thumbnailCompressSize = 20; // 缩略图压缩大小
//    imagePicker.allowPickingType = LFPickingMediaTypePhoto | LFPickingMediaTypeGif;
//    //imagePicker.autoPlayLivePhoto = NO; // 自动播放live photo
//    //imagePicker.autoSelectCurrentImage = NO; // 关闭自动选中
//    //imagePicker.defaultAlbumName = @"动图"; // 指定默认显示相册
//    //imagePicker.displayImageFilename = YES; // 显示文件名称
//    //imagePicker.thumbnailCompressSize = 0.f; // 不需要缩略图
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
//        imagePicker.syncAlbum = YES; // 实时同步相册
//    }
//    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
//    [[TabBarViewController takeCurrentVC] presentViewController:imagePicker animated:YES completion:nil];
}

- (void)removeButClick:(UIButton *)sender{
    if (self.removeImgButBlcok) {
        [self.addImgList removeObjectAtIndex:sender.tag];
        self.removeImgButBlcok(self.addImgList);
    }
}

#pragma mark - TZImagePickerControllerDelegate
// 选择视频的回调
-(void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingVideo:(UIImage *)coverImage
                sourceAssets:(PHAsset *)asset{
    /*
    [MovEncodeToMpegTool convertMovToMp4FromPHAsset:asset
                      andAVAssetExportPresetQuality:ExportPresetMediumQuality
                  andMovEncodeToMpegToolResultBlock:^(NSURL *mp4FileUrl, NSData *mp4Data, NSError *error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //切回主线程
            
        }];
    }];
     */
}

// 选择照片的回调
-(void)imagePickerController:(TZImagePickerController *)picker
      didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                sourceAssets:(NSArray *)assets
       isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (int i = 0; i < photos.count; i++) {
        if (self.self.addImgList.count >= 9) {
            break;
        }
        [self.addImgList addObject:photos[i]];
    }
    
    PHAsset *assetsL = [assets objectAtIndex:0];
    // 检查是否有位置信息
    if (assetsL.location) {
        CLLocationCoordinate2D coordinate = assetsL.location.coordinate;
        NSLog(@"经度: %f, 纬度: %f", coordinate.longitude, coordinate.latitude);
        
    } else {
        NSLog(@"该图片没有位置信息");
    }
    
    
    
    
    
    if (self.addImgButtonBlcok) {
        self.addImgButtonBlcok(self.addImgList);
    }
    
    
}

// 方法1：从原始图片数据获取
- (NSDictionary *)getImageMetadataFromData:(NSData *)imageData {
    if (!imageData) return nil;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!source) return nil;
    
    CFDictionaryRef metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    NSDictionary *metadataDict = (__bridge_transfer NSDictionary *)metadata;
    
    CFRelease(source);
    
    return metadataDict;
}

// 获取位置信息
- (CLLocation *)getLocationFromImageMetadata:(NSDictionary *)metadata {
    if (!metadata) return nil;
    
    // 获取 GPS 信息
    NSDictionary *gpsInfo = metadata[(NSString *)kCGImagePropertyGPSDictionary];
    if (!gpsInfo) return nil;
    
    // 解析经纬度
    NSString *latitudeRef = gpsInfo[(NSString *)kCGImagePropertyGPSLatitudeRef];
    NSString *longitudeRef = gpsInfo[(NSString *)kCGImagePropertyGPSLongitudeRef];
    NSNumber *latitude = gpsInfo[(NSString *)kCGImagePropertyGPSLatitude];
    NSNumber *longitude = gpsInfo[(NSString *)kCGImagePropertyGPSLongitude];
    
    if (!latitude || !longitude) return nil;
    
    // 转换坐标
    CLLocationDegrees lat = latitude.doubleValue;
    CLLocationDegrees lng = longitude.doubleValue;
    
    if ([latitudeRef isEqualToString:@"S"]) lat = -lat;
    if ([longitudeRef isEqualToString:@"W"]) lng = -lng;
    
    return [[CLLocation alloc] initWithLatitude:lat longitude:lng];
}

#pragma mark - LFImagePickerControllerDelegate
- (void)lf_imagePickerController:(LFImagePickerController *)picker takePhotoHandler:(lf_takePhotoHandler)handler
{
    
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray <LFResultObject /* <LFResultImage/LFResultVideo> */*> *)results
{
    for (NSInteger i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            LFResultImage *resultImage = (LFResultImage *)result;
            [self.addImgList addObject:resultImage.originalImage];
        } else if ([result isKindOfClass:[LFResultVideo class]]) {
            //LFResultVideo *resultVideo = (LFResultVideo *)result;
            
        } else {
            /** 无法处理的数据 */
            NSLog(@"%@", result.error);
        }
    }
    
    if (self.addImgButtonBlcok) {
        self.addImgButtonBlcok(self.addImgList);
    }
}

- (void)lf_imagePickerControllerDidCancel:(LFImagePickerController *)picker
{
    
}

#pragma mark - 懒加载

- (UIImageView *)commentImg{
    if (!_commentImg) {
        _commentImg = [[UIImageView alloc]init];
        _commentImg.layer.cornerRadius = 6;
        _commentImg.layer.masksToBounds = YES;
        _commentImg.backgroundColor = RGB(240, 240, 240);
        _commentImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _commentImg;
}

- (UIButton *)addImgButton{
    if (!_addImgButton) {
        _addImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addImgButton.layer.cornerRadius = 5;
        _addImgButton.layer.masksToBounds = YES;
        UIImage * image = [[UIImage imageNamed:@"addImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_addImgButton setImage:image forState:UIControlStateNormal];
        [_addImgButton addTarget:self action:@selector(addImgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgButton;
}

- (UIButton *)removeImgBut{
    if (!_removeImgBut) {
        _removeImgBut = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [[UIImage imageNamed:@"removeImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_removeImgBut setImage:image forState:UIControlStateNormal];
        [_removeImgBut addTarget:self action:@selector(removeButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeImgBut;
}

- (NSMutableArray *)addImgList{
    if (!_addImgList) {
        _addImgList = [[NSMutableArray alloc] init];
    }
    return _addImgList;
}

@end
