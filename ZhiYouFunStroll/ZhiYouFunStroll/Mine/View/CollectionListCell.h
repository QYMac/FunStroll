//
//  CollectionListCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionListCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImageView;   // 封面图
@property (nonatomic, strong) TopLeftLabel *titleLabel;           // 标题
@property (nonatomic, strong) UILabel *addressLabel; //地址
@end

NS_ASSUME_NONNULL_END
