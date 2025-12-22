//
//  PublishListViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishListViewCell : UITableViewCell

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *headL;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) TopLeftLabel *contentL;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,strong) UILabel *timeL1;
@property (nonatomic,strong) UILabel *timeL2;

- (void)publishListViewCellIndexPath:(NSIndexPath *)indexPath dict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
