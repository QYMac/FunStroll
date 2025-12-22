//
//  MapNavigationCollectionViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapNavigationCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *messageL;
@property (nonatomic,strong) UILabel *typeL;

- (void)collectionViewIndexPath:(NSIndexPath *)indexPath dataList:(NSArray *)dataList selectedIndex:(NSInteger)selectedIndex;

@end

NS_ASSUME_NONNULL_END
