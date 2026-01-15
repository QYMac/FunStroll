//
//  RouteOptionCell.h
//  ZhiYouFunStroll
//
//  Created on 2026/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouteOptionCell : UICollectionViewCell

- (void)configWithData:(NSDictionary *)data isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
