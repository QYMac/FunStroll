//
//  GeneralWaterfallFlowLayout.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GeneralWaterfallFlowLayout;

@protocol GeneralWaterfallFlowLayoutDelegate <NSObject>
/**
 *  要求实现
 *
 *  @param waterflowLayout 哪个布局需要代理返回高度
 *  @param indexPath              对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param itemWidth              layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView;
/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView;
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  距离collectionView四周的间距, 默认{20, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(GeneralWaterfallFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;

@end

@interface GeneralWaterfallFlowLayout : UICollectionViewLayout

/** layout的代理 */
- (instancetype)initWithDelegate:(id<GeneralWaterfallFlowLayoutDelegate>)delegate;

+ (instancetype)flowLayoutWithDelegate:(id<GeneralWaterfallFlowLayoutDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
