//
//  AddCommentCollectionCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import "AddCommentCollectionCell.h"

@interface AddCommentCollectionCell ()<TZImagePickerControllerDelegate,LFImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableArray *addImgList;

@end

@implementation AddCommentCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        
        [self.contentView addSubview:self.commentImg];
        [self.commentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
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
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}

- (void)AddCommentIndexPath:(NSIndexPath *)indexPath imageList:(NSMutableArray *)imageList{
    
    self.addImgList = [NSMutableArray arrayWithArray:imageList];
    
    if (indexPath.row == imageList.count) {
        self.addImgButton.hidden = NO;
        self.commentImg.hidden = YES;
        self.removeImgBut.hidden = YES;
    }else{
        self.addImgButton.hidden = YES;
        self.commentImg.hidden = NO;
        self.removeImgBut.hidden = NO;
        UIImage *image = imageList[indexPath.row];
        self.commentImg.image = image;
        self.removeImgBut.tag = indexPath.row;
    }
}

#pragma mark - 按钮点击

- (void)addImgButtonClick:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (self.addButClickBlcok) {
        self.addButClickBlcok();
    }
    
    WeakSelf
    NSInteger maxCount = 2 - self.addImgList.count;
    if (maxCount <= 0) {
        [AlertWith showAlertWithMessageText:@"最多只能选择1张图片" completion:^{
            if (weakSelf.addImgButtonBlcok) {
                weakSelf.addImgButtonBlcok(weakSelf.addImgList);
            }
        }];
        return;
    }
    
    // 使用自定义图片选择器
    PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] init];
    picker.maxSelectCount = maxCount;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    picker.didFinishPickingBlock = ^(NSArray<UIImage *> *images, NSArray<PHAsset *> *assets) {
        [weakSelf.addImgList addObjectsFromArray:images];
        if (weakSelf.addImgButtonBlcok) {
            weakSelf.addImgButtonBlcok(weakSelf.addImgList);
        }
    };
    
    [[TabBarViewController takeCurrentVC] presentViewController:picker animated:YES completion:nil];
}

- (void)removeButClick:(UIButton *)sender{
    if (self.removeImgButBlcok) {
        [self.addImgList removeObjectAtIndex:sender.tag];
        self.removeImgButBlcok(self.addImgList);
    }
}

#pragma mark - 懒加载

- (UIImageView *)commentImg{
    if (!_commentImg) {
        _commentImg = [[UIImageView alloc]init];
        _commentImg.layer.cornerRadius = 6;
        _commentImg.layer.masksToBounds = YES;
        //_commentImg.backgroundColor = RGB(244, 244, 244);
        _commentImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _commentImg;
}

- (UIButton *)addImgButton{
    if (!_addImgButton) {
        _addImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addImgButton.layer.cornerRadius = 5;
        _addImgButton.layer.masksToBounds = YES;
        UIImage * image = [[UIImage imageNamed:@"hone_addImge"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_addImgButton setImage:image forState:UIControlStateNormal];
        [_addImgButton addTarget:self action:@selector(addImgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgButton;
}

- (UIButton *)removeImgBut{
    if (!_removeImgBut) {
        _removeImgBut = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [[UIImage imageNamed:@"home_shanchu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
