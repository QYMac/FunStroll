//
//  LFPhotoPreViewColletionCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/16.
//

#import <UIKit/UIKit.h>
#import "LFAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFPhotoPreViewColletionCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *selectedImg;

- (void)setSelectedModels:(NSMutableArray<LFAsset *> *)selectedModels indexPathdex:(NSIndexPath *) indexPathdex;

@end

NS_ASSUME_NONNULL_END
